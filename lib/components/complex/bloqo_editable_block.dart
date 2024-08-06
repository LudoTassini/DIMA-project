import 'package:bloqo/app_state/editor_course_app_state.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../model/bloqo_user_course_created.dart';
import '../../model/courses/bloqo_block.dart';
import '../../model/courses/bloqo_chapter.dart';
import '../../model/courses/bloqo_course.dart';
import '../../model/courses/bloqo_section.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';
import '../custom/bloqo_snack_bar.dart';
import '../popups/bloqo_confirmation_alert.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoEditableBlock extends StatelessWidget {
  const BloqoEditableBlock({
    super.key,
    required this.course,
    required this.chapter,
    required this.section,
    required this.block,
    required this.onPressed,
    this.padding = const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
  });

  final BloqoCourse course;
  final BloqoChapter chapter;
  final BloqoSection section;
  final BloqoBlock block;
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
                            "${localizedText.block} ${block.number}",
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
                                  block.name,
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
                            onPressed: () {
                              showBloqoConfirmationAlert(
                                  context: context,
                                  title: localizedText.warning,
                                  description: localizedText.delete_block_confirmation,
                                  confirmationFunction: () async {
                                    await _tryDeleteBlock(
                                        context: context,
                                        localizedText: localizedText
                                    );
                                  },
                                  backgroundColor: BloqoColors.error
                              );
                            },
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

  Future<void> _tryDeleteBlock({required BuildContext context, required var localizedText}) async {
    context.loaderOverlay.show();
    try{
      await deleteBlock(localizedText: localizedText, blockId: block.id, courseId: course.id);
      await deleteBlockFromSection(localizedText: localizedText, sectionId: section.id, blockId: block.id);
      if (!context.mounted) return;
      BloqoUserCourseCreated updatedUserCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((c) => c.courseId == course.id).first;
      await saveUserCourseCreatedChanges(localizedText: localizedText, updatedUserCourseCreated: updatedUserCourseCreated);
      if(block.number < section.blocks.length){
        await reorderBlocks(localizedText: localizedText, blockIds: section.blocks);
      }
      if (!context.mounted) return;
      deleteBlockFromEditorCourseAppState(context: context, chapterId: chapter.id, sectionId: section.id, blockId: block.id);
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