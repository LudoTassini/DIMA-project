import 'package:bloqo/app_state/editor_course_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/custom/bloqo_snack_bar.dart';
import 'package:bloqo/model/courses/bloqo_block_data.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../app_state/application_settings_app_state.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../model/user_courses/bloqo_user_course_created_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';
import '../popups/bloqo_confirmation_alert.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoCourseCreated extends StatelessWidget {
  const BloqoCourseCreated({
    super.key,
    required this.course,
    required this.onPressed,
    this.onPreview,
    this.onPublish,
    this.onViewStatistics,
    this.onDismiss,
    this.onGetQrCode,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
    this.showEditOptions = false,
    this.showPublishedOptions = false,
  });

  final BloqoUserCourseCreatedData course;
  final Function() onPressed;
  final Function()? onPreview;
  final Function()? onPublish;
  final Function()? onViewStatistics;
  final Function()? onDismiss;
  final Function()? onGetQrCode;
  final EdgeInsetsDirectional padding;
  final bool showEditOptions;
  final bool showPublishedOptions;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    return Padding(
      padding: padding,
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
          )),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.menu_book_rounded,
                                color: theme.colors.leadingColor,
                                size: 24,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                course.courseName,
                                style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                                  fontSize: 16,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            "${course.numChaptersCreated} ${localizedText.chapters}, ${course.numSectionsCreated} ${localizedText.sections}",
                            style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    showEditOptions ? Icons.edit_square : Icons.play_circle,
                    color: theme.colors.leadingColor,
                    size: 24,
                  ),
                ],
              ),
              showEditOptions
                  ? Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      BloqoFilledButton(
                        color: theme.colors.error,
                        onPressed: () {
                          showBloqoConfirmationAlert(
                              context: context,
                              title: localizedText.warning,
                              description: localizedText.delete_course_confirmation,
                              confirmationFunction: () async {
                                await _tryDeleteCourse(
                                    context: context,
                                    localizedText: localizedText
                                );
                              },
                              backgroundColor: theme.colors.error
                          );
                        },
                        text: localizedText.delete,
                        fontSize: 16,
                        height: 32,
                      ),
                      BloqoFilledButton(
                        color: theme.colors.success,
                        onPressed: onPublish ?? () {},
                        text: localizedText.publish,
                        fontSize: 16,
                        height: 32,
                      ),
                      BloqoFilledButton(
                        color: theme.colors.previewButton,
                        onPressed: onPreview ?? () {},
                        text: localizedText.preview,
                        fontSize: 16,
                        height: 32,
                      )
                    ]
                  ),
                ),
              )
                  : Container(),
              showPublishedOptions
                  ? Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                  child: Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 10,
                    runSpacing: 5,
                    children: [
                      BloqoFilledButton(
                        color: theme.colors.inBetweenColor,
                        text: localizedText.get_qr_code,
                        fontSize: 16,
                        height: 32,
                        icon: Icons.qr_code_2,
                        onPressed: onGetQrCode ?? () {}
                      ),
                      BloqoFilledButton(
                        color: theme.colors.leadingColor,
                        onPressed: onViewStatistics ?? () {},
                        text: localizedText.view_statistics,
                        fontSize: 16,
                        height: 32,
                      ),
                      BloqoFilledButton(
                        color: theme.colors.error,
                        onPressed: onDismiss ?? () {},
                        text: localizedText.dismiss,
                        fontSize: 16,
                        height: 32,
                      ),
                    ],
                  ),
                ),
              )
                  : Container(),
            ],
          ),
        ),
      )
    );
  }

  Future<void> _tryDeleteCourse({required BuildContext context, required var localizedText}) async {
    context.loaderOverlay.show();
    try{
      var firestore = getFirestoreFromAppState(context: context);
      var storage = getStorageFromAppState(context: context);

      BloqoCourseData courseToDelete = await getCourseFromId(
          firestore: firestore,
          localizedText: localizedText,
          courseId: course.courseId
      );
      await deleteUserCourseCreated(
          firestore: firestore,
          localizedText: localizedText,
          courseId: course.courseId
      );
      await deleteCourse(
          firestore: firestore,
          storage: storage,
          localizedText: localizedText,
          course: courseToDelete
      );
      if (!context.mounted) return;
      String? courseIdAppState = getEditorCourseFromAppState(context: context)?.id;
      if(courseIdAppState != null && course.courseId == courseIdAppState){
        deleteEditorCourseFromAppState(context: context);
      }
      deleteUserCourseCreatedFromAppState(context: context, userCourseCreated: course);
      context.loaderOverlay.hide();
      showBloqoSnackBar(context: context, text: localizedText.done);
    }
    on BloqoException catch (e) {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
          context: context,
          title: localizedText.error_title,
          description: e.message
      );
    }
  }

}