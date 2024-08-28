import 'dart:async';

import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_review_data.dart';
import 'package:bloqo/model/bloqo_user_data.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/model/courses/bloqo_course_data.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:bloqo/pages/from_search/course_search_page.dart';
import 'package:bloqo/pages/from_any/user_profile_page.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../components/containers/bloqo_main_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/published_courses/bloqo_published_course_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';

class QrCodeScanPage extends StatefulWidget {
  const QrCodeScanPage({
    super.key,
    required this.onPush,
    required this.onNavigateToPage,
  });

  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;

  @override
  State<QrCodeScanPage> createState() => _QrCodeScanPageState();
}

class _QrCodeScanPageState extends State<QrCodeScanPage> with AutomaticKeepAliveClientMixin<QrCodeScanPage>, WidgetsBindingObserver {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isProcessing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Register the observer
    Navigator.of(context).widget.observers.add(NavigationObserver(onPop: _onPop));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller?.resumeCamera();
    }
  }

  Future<void> _onPop() async {
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bool isTablet = checkDevice(context);

    return Consumer<ApplicationSettingsAppState>(
        builder: (context, applicationSettingsAppState, _) {
          return BloqoMainContainer(
            child: Padding(
              padding: !isTablet ? const EdgeInsetsDirectional.all(0)
                  : Constants.tabletPadding,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: (qrc) async {
                        await _onQRViewCreated(context: context, controller: qrc);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _onQRViewCreated({required BuildContext context, required QRViewController controller}) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return;

      isProcessing = true;
      final code = scanData.code;

      if(!context.mounted) return;
      if (code!.startsWith("course_")) {
        await _tryGoToCoursePage(
            context: context,
            publishedCourseId: code.substring("course_".length));
      } else if (code.startsWith("user_")) {
        await _tryGoToUserPage(
            context: context,
            userId: code.substring("user_".length));
      }

      isProcessing = false;
    });
  }

  Future<void> _tryGoToCoursePage(
      {required BuildContext context, required String publishedCourseId}) async {
    var localizedText = getAppLocalizations(context)!;
    context.loaderOverlay.show();
    try {
      controller?.pauseCamera();
      var firestore = getFirestoreFromAppState(context: context);
      BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromPublishedCourseId(
          firestore: firestore,
          localizedText: localizedText,
          publishedCourseId: publishedCourseId
      );
      BloqoCourseData course = await getCourseFromId(
          firestore: firestore,
          localizedText: localizedText,
          courseId: publishedCourse.originalCourseId
      );
      List<BloqoChapterData> chapters = await getChaptersFromIds(
          firestore: firestore,
          localizedText: localizedText,
          chapterIds: course.chapters
      );
      Map<String, List<BloqoSectionData>> sections = {};
      for (BloqoChapterData chapter in chapters) {
        List<BloqoSectionData> chapterSections = await getSectionsFromIds(
            firestore: firestore,
            localizedText: localizedText,
            sectionIds: chapter.sections
        );
        sections[chapter.id] = chapterSections;
      }
      BloqoUserData courseAuthor = await getUserFromId(firestore: firestore, localizedText: localizedText, id: publishedCourse.authorId);
      List<BloqoReviewData> reviews = await getReviewsFromIds(
          firestore: firestore,
          localizedText: localizedText,
          reviewsIds: publishedCourse.reviews
      );
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      widget.onPush(
          CourseSearchPage(
              onPush: widget.onPush,
              onNavigateToPage: widget.onNavigateToPage,
              course: course,
              publishedCourse: publishedCourse,
              chapters: chapters,
              sections: sections,
              courseAuthor: courseAuthor,
              rating: publishedCourse.rating,
              reviews: reviews
          )
      );
    } on BloqoException catch (e) {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    } finally {
      isProcessing = false;
    }
  }

  Future<void> _tryGoToUserPage(
      {required BuildContext context, required String userId}) async {
    var localizedText = getAppLocalizations(context)!;
    context.loaderOverlay.show();
    try {
      controller?.pauseCamera();
      var firestore = getFirestoreFromAppState(context: context);
      BloqoUserData user = await getUserFromId(
          firestore: firestore,
          localizedText: localizedText,
          id: userId
      );
      List<BloqoPublishedCourseData> publishedCourses = await getPublishedCoursesFromAuthorId(
          firestore: firestore,
          localizedText: localizedText,
          authorId: userId
      );
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      widget.onPush(
          UserProfilePage(
            onPush: widget.onPush,
            onNavigateToPage: widget.onNavigateToPage,
            author: user,
            publishedCourses: publishedCourses,
          )
      );
    } on BloqoException catch (e) {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    } finally {
      isProcessing = false;
    }
  }
}

class NavigationObserver extends NavigatorObserver {
  NavigationObserver({required this.onPop});

  final Function onPop;

  @override
  void didPop(Route route, Route? previousRoute) {
    onPop();
    super.didPop(route, previousRoute);
  }
}