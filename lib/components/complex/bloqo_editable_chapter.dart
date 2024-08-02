import 'package:bloqo/app_state/editor_course_app_state.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../model/bloqo_user_course_created.dart';
import '../../model/courses/bloqo_chapter.dart';
import '../../model/courses/bloqo_course.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';
import '../custom/bloqo_snack_bar.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoEditableChapter extends StatelessWidget {
  const BloqoEditableChapter({
    super.key,
    required this.course,
    required this.chapter,
    required this.onPressed,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
  });

  final BloqoCourse course;
  final BloqoChapter chapter;
  final Function() onPressed;
  final EdgeInsetsDirectional padding;

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
                              color: BloqoColors.secondaryText
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
                        IconButton(
                          padding: const EdgeInsets.only(right: 5.0),
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(
                            Icons.delete_forever,
                            color: BloqoColors.error,
                            size: 24,
                          ),
                          onPressed: () async {
                            _tryDeleteChapter(context: context, localizedText: localizedText);
                          }
                        ),
                        const Icon(
                          Icons.navigate_next,
                          color: BloqoColors.russianViolet,
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
      await deleteChapter(localizedText: localizedText, chapterId: chapter.id);
      await deleteChapterFromCourse(localizedText: localizedText, courseId: course.id, chapterId: chapter.id);
      await deleteChapterFromUserCourseCreated(localizedText: localizedText, courseId: course.id);
      if(chapter.number < course.chapters.length){
        await reorderChapters(localizedText: localizedText, chapterIds: course.chapters);
      }
      if (!context.mounted) return;
      deleteChapterFromEditorCourseAppState(context: context, chapterId: chapter.id);
      updateUserCourseCreatedChaptersNumberInAppState(context: context, courseId: course.id, newChaptersNum: course.chapters.length);
      context.loaderOverlay.hide();
      ScaffoldMessenger.of(context).showSnackBar(
        BloqoSnackBar.get(child: Text(localizedText.done)),
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