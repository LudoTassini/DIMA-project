import 'dart:io';
import 'dart:ui' as ui;

import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/custom/bloqo_progress_bar.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_published_course_data.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_review_data.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../app_state/application_settings_app_state.dart';
import '../../model/bloqo_user_data.dart';
import '../../model/user_courses/bloqo_user_course_enrolled_data.dart';
import '../../pages/from_learn/review_page.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';
import '../custom/bloqo_certificate.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoCourseEnrolled extends StatefulWidget {
  final BloqoUserCourseEnrolledData? course;
  final EdgeInsetsDirectional padding;
  final bool showCompleted;
  final bool showInProgress;
  final Function() onPressed;
  final void Function(Widget)? onPush;

  const BloqoCourseEnrolled({
    super.key,
    required this.course,
    this.onPush,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
    required this.onPressed,
    this.showCompleted = false,
    this.showInProgress = false,
  });

  @override
  State<BloqoCourseEnrolled> createState() => _BloqoCourseEnrolledState();
}

class _BloqoCourseEnrolledState extends State<BloqoCourseEnrolled> with AutomaticKeepAliveClientMixin<BloqoCourseEnrolled>{

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);

    return Padding(
        padding: widget.padding,
        child: ElevatedButton(
          style: ButtonStyle(
            padding: WidgetStateProperty.resolveWith((states) => const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8)),
            backgroundColor: WidgetStateProperty.resolveWith((states) => theme.colors.highContrastColor),
            shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                color: theme.colors.leadingColor,
                width: 3,
                ),
              )
            ),
          ),
          onPressed: widget.onPressed,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Align(
                      alignment: const AlignmentDirectional(-1, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:const EdgeInsetsDirectional
                                .fromSTEB(10, 10, 10, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional
                                      .fromSTEB(0,0,5,0),
                                  child: Icon(
                                    Icons.menu_book_rounded,
                                    color: theme.colors.leadingColor,
                                    size: 24,
                                  ),
                                ),
                                Flexible(
                                  child: Align(
                                    alignment:const AlignmentDirectional(-1, 0),
                                    child: Text(
                                      widget.course!.courseName,
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        fontSize: 16, ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsetsDirectional
                                .fromSTEB(10, 0, 10, 5),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional
                                      .fromSTEB(0,0,5,0),
                                  child: Icon(
                                    Icons.person,
                                    color: theme.colors.leadingColor,
                                    size: 24,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.course!.courseAuthor,
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if(widget.showInProgress)
                            Padding(
                              padding:
                              const EdgeInsetsDirectional
                                  .fromSTEB(10, 0, 10, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: const EdgeInsetsDirectional
                                        .fromSTEB(0,0,5,0),
                                    child: Icon(
                                      Icons.bookmark_outlined,
                                      color: theme.colors.leadingColor,
                                      size: 24,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      widget.course?.sectionName ?? '', // this is because completed courses do not have a section name, but text can't be of type String?
                                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                              ),
                          ),
                        ],
                      ),
                  ),
                ), Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional
                          .fromSTEB(0, 0, 10, 0),
                      child: Icon(
                        Icons.play_circle,
                        color: theme.colors.leadingColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if(widget.showInProgress)
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              // Get the maximum available width
                              double maxWidth = constraints.maxWidth-20;

                              return BloqoProgressBar(
                                percentage: widget.course!.isCompleted? 1 :
                                  (widget.course!.sectionsCompleted?.length ?? 0) / widget.course!.totNumSections,
                                width: maxWidth, // Pass the maximum width to the progress bar
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ],
                ),
              ),

              if(widget.showCompleted)
                Align(
                  alignment: AlignmentDirectional.bottomEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 10,
                        runSpacing: 5,
                        children: [
                          widget.course!.isRated ? BloqoFilledButton(
                            color: theme.colors.inactive,
                            onPressed: () async {
                                await _goToReviewPage(
                                  context: context,
                                  localizedText: localizedText,
                                  course: widget.course!,
                                );
                            },
                            text: localizedText.rated,
                            fontSize: 16,
                            height: 32,
                          )
                          :  BloqoFilledButton(
                              color: theme.colors.rate,
                              onPressed: () async {
                                await _goToReviewPage(
                                  context: context,
                                  localizedText: localizedText,
                                  course: widget.course!,
                                );
                              },
                              text: localizedText.rate,
                              fontSize: 16,
                              height: 32,
                            ),
                            BloqoFilledButton(
                              color: theme.colors.success,
                              onPressed: () async {
                                String myFullName = getUserFromAppState(context: context)!.fullName;
                                ui.Image certificateImage = await getCertificateImage(
                                  context: context,
                                  fullName: myFullName,
                                  courseName: widget.course!.courseName,
                                );
                                final byteData = await certificateImage.toByteData(format: ui.ImageByteFormat.png);
                                final pngBytes = byteData!.buffer.asUint8List();

                                final directory = (await getApplicationDocumentsDirectory()).path;
                                final imgFile = File('$directory/certificate.png');
                                imgFile.writeAsBytes(pngBytes);

                                if (!context.mounted) return;
                                RenderBox? box = context.findRenderObject() as RenderBox?;
                                Rect sharePositionOrigin = box!.localToGlobal(Offset.zero) & box.size;

                                Share.shareXFiles(
                                  [XFile('$directory/certificate.png')],
                                  sharePositionOrigin: sharePositionOrigin, // Set the share position origin
                                );
                              },
                              text: localizedText.get_certificate,
                              fontSize: 16,
                              height: 32,
                            ),
                        ],
                      ),
                  )
                ),
              ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _goToReviewPage({required BuildContext context, required var localizedText, required BloqoUserCourseEnrolledData course}) async {
    context.loaderOverlay.show();
    try {

      BloqoReviewData? userReview;
      BloqoUserData user = getUserFromAppState(context: context)!;

      if (course.isRated) {
        BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromPublishedCourseId(
            localizedText: localizedText, publishedCourseId: course.publishedCourseId);
        List reviewsIds = publishedCourse.reviews;
        List<BloqoReviewData> reviews = await getReviewsFromIds(localizedText: localizedText, reviewsIds: reviewsIds);

        userReview = reviews.where((review) => review.authorId == user.id).first; //error
      } else {
        userReview = null;
      }

      if(!context.mounted) return;
      context.loaderOverlay.hide();

      widget.onPush!(
          ReviewPage(
            courseToReview: course,
            onPush: widget.onPush!,
            userReview: userReview,
          )
      );

    } on BloqoException catch (e) {
      if(!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    }
  }

}