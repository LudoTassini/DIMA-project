import 'package:bloqo/app_state/editor_course_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../model/bloqo_user_course_created.dart';
import '../../model/courses/bloqo_course.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';
import '../popups/bloqo_confirmation_alert.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoCourseCreated extends StatelessWidget {
  const BloqoCourseCreated({
    super.key,
    required this.course,
    required this.onPressed,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
    this.showEditOptions = false,
    this.showPublishedOptions = false,
  });

  final BloqoUserCourseCreated course;
  final Function() onPressed;
  final EdgeInsetsDirectional padding;
  final bool showEditOptions;
  final bool showPublishedOptions;

  @override
  Widget build(BuildContext context) {
    final localizedText = getAppLocalizations(context)!;
    return Padding(
      padding: padding,
      child: ElevatedButton(
        style: ButtonStyle(
          padding: WidgetStateProperty.resolveWith((states) => const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8)),
          backgroundColor: WidgetStateProperty.resolveWith((states) => BloqoColors.seasalt),
          shape: WidgetStateProperty.resolveWith((states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(
              color: BloqoColors.russianViolet,
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
                            const Padding(
                              padding: EdgeInsets.only(right: 5),
                              child: Icon(
                                Icons.menu_book_rounded,
                                color: BloqoColors.russianViolet,
                                size: 24,
                              ),
                            ),
                            Flexible(
                              child: Text(
                                course.courseName,
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
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
                    color: BloqoColors.russianViolet,
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
                        color: BloqoColors.error,
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
                              backgroundColor: BloqoColors.error
                          );
                        },
                        text: localizedText.delete,
                        fontSize: 16,
                        height: 32,
                      ),
                      BloqoFilledButton(
                        color: BloqoColors.success,
                        onPressed: () {} /* TODO */,
                        text: localizedText.publish,
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
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      BloqoFilledButton(
                        color: BloqoColors.russianViolet,
                        onPressed: () {} /* TODO */,
                        text: localizedText.view_statistics,
                        fontSize: 16,
                        height: 32,
                      ),
                      BloqoFilledButton(
                        color: BloqoColors.error,
                        onPressed: () {} /* TODO */,
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
      BloqoCourse courseToDelete = await getCourseFromId(localizedText: localizedText, courseId: course.courseId);
      for(String chapterId in courseToDelete.chapters){
        await deleteChapter(localizedText: localizedText, chapterId: chapterId);
      }
      await deleteUserCourseCreated(localizedText: localizedText, courseId: course.courseId);
      await deleteCourse(localizedText: localizedText, courseId: course.courseId);
      if (!context.mounted) return;
      String? courseIdAppState = getEditorCourseFromAppState(context: context)?.id;
      if(courseIdAppState != null && course.courseId == courseIdAppState){
        deleteEditorCourseFromAppState(context: context);
      }
      deleteUserCourseCreatedFromAppState(context: context, userCourseCreated: course);
      context.loaderOverlay.hide();
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