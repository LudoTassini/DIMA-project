import 'dart:async';

import 'package:bloqo/model/bloqo_review.dart';
import 'package:bloqo/model/bloqo_user.dart';
import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:bloqo/model/courses/bloqo_course.dart';
import 'package:bloqo/model/courses/bloqo_section.dart';
import 'package:bloqo/pages/from_search/course_search_page.dart';
import 'package:bloqo/pages/from_search/user_courses_page.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../components/containers/bloqo_main_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_published_course.dart';
import '../../utils/bloqo_exception.dart';

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
    return BloqoMainContainer(
      child: Column(
        children: <Widget>[
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: (qrc) async {
                await _onQRViewCreated(qrc);
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _onQRViewCreated(QRViewController controller) async {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (isProcessing) return;

      isProcessing = true;
      final code = scanData.code;

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
      BloqoPublishedCourse publishedCourse = await getPublishedCourseFromPublishedCourseId(
          localizedText: localizedText, publishedCourseId: publishedCourseId);
      BloqoCourse course = await getCourseFromId(localizedText: localizedText,
          courseId: publishedCourse.originalCourseId);
      List<BloqoChapter> chapters = await getChaptersFromIds(localizedText: localizedText, chapterIds: course.chapters);
      Map<String, List<BloqoSection>> sections = {};
      for (BloqoChapter chapter in chapters) {
        List<BloqoSection> chapterSections = await getSectionsFromIds(localizedText: localizedText, sectionIds: chapter.sections);
        sections[chapter.id] = chapterSections;
      }
      BloqoUser courseAuthor = await getUserFromId(localizedText: localizedText, id: publishedCourse.authorId);
      List<BloqoReview> reviews = await getReviewsFromIds(localizedText: localizedText, reviewsIds: publishedCourse.reviews);
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
      BloqoUser user = await getUserFromId(localizedText: localizedText, id: userId);
      List<BloqoPublishedCourse> publishedCourses = await getPublishedCoursesFromAuthorId(localizedText: localizedText, authorId: userId);
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      widget.onPush(
          UserCoursesPage(
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