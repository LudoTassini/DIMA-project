import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/editor_course_app_state.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../model/user_courses/bloqo_user_course_created_data.dart';
import '../../model/courses/bloqo_chapter_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';
import '../custom/bloqo_snack_bar.dart';
import '../popups/bloqo_confirmation_alert.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoEditableChapter extends StatelessWidget {
  const BloqoEditableChapter({
    super.key,
    required this.course,
    required this.chapter,
    required this.editable,
    required this.onPressed,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
  });

  final BloqoCourseData course;
  final BloqoChapterData chapter;
  final bool editable;
  final Function() onPressed;
  final EdgeInsetsDirectional padding;

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
                width: 2,
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
                          Text(
                            "${localizedText.chapter} ${chapter.number}",
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: theme.colors.secondaryText
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  chapter.name,
                                  style: Theme.of(context).textTheme.displayMedium,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        if(editable)
                          IconButton(
                            padding: const EdgeInsets.only(right: 5.0),
                            visualDensity: VisualDensity.compact,
                            icon: Icon(
                              Icons.delete_forever,
                              color: theme.colors.error,
                              size: 24,
                            ),
                            onPressed: () {
                              showBloqoConfirmationAlert(
                                context: context,
                                title: localizedText.warning,
                                description: localizedText.delete_chapter_confirmation,
                                confirmationFunction: () async {
                                  await _tryDeleteChapter(
                                      context: context,
                                      localizedText: localizedText
                                  );
                                },
                                backgroundColor: theme.colors.error
                              );
                            },
                          ),
                        Icon(
                          Icons.navigate_next,
                          color: theme.colors.leadingColor,
                          size: 24,
                        )
                      ]
                    ),
                  ],
                )
              ],
            ),
          ),
        )
    );
  }

  Future<void> _tryDeleteChapter({required BuildContext context, required var localizedText}) async {
    context.loaderOverlay.show();
    try{
      var firestore = getFirestoreFromAppState(context: context);
      var storage = getStorageFromAppState(context: context);

      await deleteChapter(
          firestore: firestore,
          storage: storage,
          localizedText: localizedText,
          chapter: chapter,
          courseId: course.id
      );
      await deleteChapterFromCourse(
          firestore: firestore,
          localizedText: localizedText,
          courseId: course.id,
          chapterId: chapter.id
      );
      await deleteChapterFromUserCourseCreated(
          firestore: firestore,
          localizedText: localizedText,
          courseId: course.id
      );
      if(chapter.number < course.chapters.length){
        await reorderChapters(
            firestore: firestore,
            localizedText: localizedText,
            chapterIds: course.chapters
        );
      }
      if (!context.mounted) return;
      deleteChapterFromEditorCourseAppState(context: context, chapterId: chapter.id);
      updateUserCourseCreatedChaptersNumberInAppState(context: context, courseId: course.id, newChaptersNum: course.chapters.length);
      updateUserCourseCreatedSectionsNumberInAppState(context: context, courseId: course.id, of: -chapter.sections.length);
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(
        BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
      );
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