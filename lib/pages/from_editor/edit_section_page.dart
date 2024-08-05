import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:bloqo/model/bloqo_user_course_created.dart';
import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:bloqo/pages/from_editor/edit_multimedia_block_page.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/editor_course_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/buttons/bloqo_popup_menu_filled_button.dart';
import '../../components/complex/bloqo_editable_block.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/forms/bloqo_text_field.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/bloqo_block.dart';
import '../../model/courses/bloqo_course.dart';
import '../../model/courses/bloqo_section.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import 'edit_text_block_page.dart';

class EditSectionPage extends StatefulWidget {
  const EditSectionPage({
    super.key,
    required this.onPush,
    required this.chapterId,
    required this.sectionId
  });

  final void Function(Widget) onPush;
  final String chapterId;
  final String sectionId;

  @override
  State<EditSectionPage> createState() => _EditSectionPageState();
}

class _EditSectionPageState extends State<EditSectionPage> with AutomaticKeepAliveClientMixin<EditSectionPage> {

  final formKeyChapterName = GlobalKey<FormState>();

  late TextEditingController sectionNameController;

  @override
  void initState() {
    super.initState();
    sectionNameController = TextEditingController();
  }

  @override
  void dispose() {
    sectionNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1.0, -1.0),
        child: Consumer<EditorCourseAppState>(
            builder: (context, editorCourseAppState, _){
              BloqoCourse course = getEditorCourseFromAppState(context: context)!;
              BloqoChapter chapter = getEditorCourseChapterFromAppState(context: context, chapterId: widget.chapterId)!;
              BloqoSection section = getEditorCourseSectionFromAppState(context: context, chapterId: widget.chapterId, sectionId: widget.sectionId)!;
              List<BloqoBlock> blocks = getEditorCourseSectionBlocksFromAppState(context: context, sectionId: widget.sectionId)!;
              sectionNameController.text = section.name;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BloqoBreadcrumbs(breadcrumbs: [
                      course.name,
                      chapter.name,
                      section.name
                    ]),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                                children: [
                                  Form(
                                      key: formKeyChapterName,
                                      child: BloqoTextField(
                                        formKey: formKeyChapterName,
                                        controller: sectionNameController,
                                        labelText: localizedText.name,
                                        hintText: localizedText.editor_section_name_hint,
                                        maxInputLength: Constants.maxChapterNameLength,
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                                      )
                                  ),
                                  BloqoSeasaltContainer(
                                      child: Column(
                                          children: [
                                            Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    localizedText.blocks_header,
                                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                                      color: BloqoColors.russianViolet,
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                )
                                            ),
                                            if(blocks.isEmpty)
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
                                                child: Text(
                                                  localizedText.edit_section_page_no_blocks,
                                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                    color: BloqoColors.primaryText,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            if(blocks.isNotEmpty)
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: List.generate(
                                                    blocks.length,
                                                        (index) {
                                                      BloqoBlock block = blocks[index];
                                                      if (index < blocks.length - 1) {
                                                        return BloqoEditableBlock(
                                                            course: course,
                                                            chapter: chapter,
                                                            section: section,
                                                            block: block,
                                                            onPressed: () {
                                                              _goToEditBlockPage(
                                                                  blockSuperType: BloqoBlockSuperTypeExtension.fromString(block.superType)!,
                                                                  courseId: course.id,
                                                                  chapterId: chapter.id,
                                                                  sectionId: section.id,
                                                                  block: block
                                                              );
                                                            }
                                                        );
                                                      }
                                                      else{
                                                        return BloqoEditableBlock(
                                                            course: course,
                                                            chapter: chapter,
                                                            section: section,
                                                            block: block,
                                                            padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                                            onPressed: () {
                                                              _goToEditBlockPage(
                                                                blockSuperType: BloqoBlockSuperTypeExtension.fromString(block.superType)!,
                                                                courseId: course.id,
                                                                chapterId: chapter.id,
                                                                sectionId: section.id,
                                                                block: block
                                                              );
                                                            }
                                                        );
                                                      }
                                                    }
                                                ),
                                              ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                                              child: BloqoPopupMenuFilledButton(
                                                mainColor: BloqoColors.russianViolet,
                                                colors: const [
                                                  BloqoColors.textBlockButton,
                                                  BloqoColors.multimediaBlockButton,
                                                  BloqoColors.quizBlockButton
                                                ],
                                                texts: [
                                                  localizedText.text_block,
                                                  localizedText.multimedia_block,
                                                  localizedText.quiz_block
                                                ],
                                                icons: const [
                                                  Icons.text_fields,
                                                  Icons.perm_media,
                                                  Icons.quiz
                                                ],
                                                onPressedList: [
                                                  () async {
                                                    context.loaderOverlay.show();
                                                    try {
                                                      await _addBlock(
                                                        context: context,
                                                        course: course,
                                                        chapter: chapter,
                                                        section: section,
                                                        blockSuperType: BloqoBlockSuperType.text
                                                      );
                                                      if (!context.mounted) return;
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
                                                      );
                                                      context.loaderOverlay.hide();
                                                    } on BloqoException catch (e) {
                                                      if (!context.mounted) return;
                                                      context.loaderOverlay.hide();
                                                      showBloqoErrorAlert(
                                                        context: context,
                                                        title: localizedText.error_title,
                                                        description: e.message,
                                                      );
                                                    }
                                                  },
                                                      () async {
                                                    context.loaderOverlay.show();
                                                    try {
                                                      await _addBlock(
                                                          context: context,
                                                          course: course,
                                                          chapter: chapter,
                                                          section: section,
                                                          blockSuperType: BloqoBlockSuperType.multimedia
                                                      );
                                                      if (!context.mounted) return;
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
                                                      );
                                                      context.loaderOverlay.hide();
                                                    } on BloqoException catch (e) {
                                                      if (!context.mounted) return;
                                                      context.loaderOverlay.hide();
                                                      showBloqoErrorAlert(
                                                        context: context,
                                                        title: localizedText.error_title,
                                                        description: e.message,
                                                      );
                                                    }
                                                  },
                                                      () async {
                                                    context.loaderOverlay.show();
                                                    try {
                                                      await _addBlock(
                                                          context: context,
                                                          course: course,
                                                          chapter: chapter,
                                                          section: section,
                                                          blockSuperType: BloqoBlockSuperType.quiz
                                                      );
                                                      if (!context.mounted) return;
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
                                                      );
                                                      context.loaderOverlay.hide();
                                                    } on BloqoException catch (e) {
                                                      if (!context.mounted) return;
                                                      context.loaderOverlay.hide();
                                                      showBloqoErrorAlert(
                                                        context: context,
                                                        title: localizedText.error_title,
                                                        description: e.message,
                                                      );
                                                    }
                                                  },
                                                ],
                                                mainText: localizedText.add_block,
                                                mainIcon: Icons.add,
                                              ),
                                            )
                                          ]
                                      )
                                  )
                                ]
                            )
                        )
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                      child: BloqoFilledButton(
                        color: BloqoColors.russianViolet,
                        onPressed: () async {
                          context.loaderOverlay.show();
                          try {
                            await _saveChanges(
                              context: context,
                              course: course,
                              chapter: chapter,
                              section: section,
                            );
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
                            );
                            context.loaderOverlay.hide();
                          } on BloqoException catch (e) {
                            if (!context.mounted) return;
                            context.loaderOverlay.hide();
                            showBloqoErrorAlert(
                              context: context,
                              title: localizedText.error_title,
                              description: e.message,
                            );
                          }
                        },
                        text: localizedText.save_changes,
                        icon: Icons.edit,
                      ),
                    ),
                  ]
              );
            }
        )
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _addBlock({required BuildContext context, required BloqoCourse course, required BloqoChapter chapter, required BloqoSection section, required BloqoBlockSuperType blockSuperType}) async {
    var localizedText = getAppLocalizations(context)!;

    BloqoBlock block = await saveNewBlock(localizedText: localizedText, blockSuperType: blockSuperType, blockNumber: section.blocks.length + 1);

    if(!context.mounted) return;
    addBlockToEditorCourseAppState(context: context, chapterId: chapter.id, sectionId: section.id, block: block);

    BloqoUserCourseCreated updatedUserCourseCreated = getUserCoursesCreatedFromAppState(context: context)
    !.firstWhere((userCourse) => userCourse.courseId == course.id);

    await saveUserCourseCreatedChanges(
        localizedText: localizedText,
        updatedUserCourseCreated: updatedUserCourseCreated
    );

    if(!context.mounted) return;
    _saveChanges(context: context, course: course, chapter: chapter, section: section);
  }

  Future<void> _saveChanges({required BuildContext context, required BloqoCourse course, required BloqoChapter chapter, required BloqoSection section}) async {
    var localizedText = getAppLocalizations(context)!;

    section.name = sectionNameController.text;
    if(section.name == ""){
      section.name = "${localizedText.section} ${section.number}";
    }

    await saveSectionChanges(
        localizedText: localizedText,
        updatedSection: section
    );

    if(!context.mounted) return;
    updateEditorCourseSectionNameInAppState(context: context, chapterId: chapter.id, sectionId: section.id, newName: section.name);
  }

  void _goToEditBlockPage({required BloqoBlockSuperType blockSuperType, required String courseId, required String chapterId, required String sectionId, required BloqoBlock block}){
    switch(blockSuperType){
      case BloqoBlockSuperType.text:
        widget.onPush(EditTextBlockPage(onPush: widget.onPush, chapterId: chapterId, sectionId: sectionId, block: block));
        break;
      case BloqoBlockSuperType.multimedia:
        widget.onPush(EditMultimediaBlockPage(onPush: widget.onPush, courseId: courseId, chapterId: chapterId, sectionId: sectionId, block: block));
        break;
      case BloqoBlockSuperType.quiz:
        // TODO
        break;
    }
  }

}
