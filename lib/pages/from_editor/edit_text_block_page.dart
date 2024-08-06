import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:bloqo/model/bloqo_user_course_created.dart';
import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:bloqo/style/bloqo_style_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/editor_course_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
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

class EditTextBlockPage extends StatefulWidget {
  const EditTextBlockPage({
    super.key,
    required this.onPush,
    required this.chapterId,
    required this.sectionId,
    required this.block
  });

  final void Function(Widget) onPush;
  final String chapterId;
  final String sectionId;
  final BloqoBlock block;

  @override
  State<EditTextBlockPage> createState() => _EditTextBlockPageState();
}

class _EditTextBlockPageState extends State<EditTextBlockPage> with AutomaticKeepAliveClientMixin<EditTextBlockPage> {

  final formKeyText = GlobalKey<FormState>();
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
    textController.text = widget.block.content;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Consumer<EditorCourseAppState>(
        builder: (context, editorCourseAppState, _) {
          BloqoCourse course = getEditorCourseFromAppState(context: context)!;
          BloqoChapter chapter = getEditorCourseChapterFromAppState(context: context, chapterId: widget.chapterId)!;
          BloqoSection section = getEditorCourseSectionFromAppState(context: context, chapterId: widget.chapterId, sectionId: widget.sectionId)!;
          BloqoBlock block = getEditorCourseBlockFromAppState(context: context, sectionId: widget.sectionId, blockId: widget.block.id)!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BloqoBreadcrumbs(breadcrumbs: [
                course.name,
                chapter.name,
                section.name,
                block.name,
              ]),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      BloqoSeasaltContainer(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  localizedText.write_text_here,
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: BloqoColors.russianViolet,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            Form(
                              key: formKeyText,
                              child: BloqoTextField(
                                formKey: formKeyText,
                                controller: textController,
                                labelText: localizedText.text,
                                hintText: localizedText.write_text_here,
                                maxInputLength: Constants.maxBlockTextLength,
                                keyboardType: TextInputType.multiline,
                                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                                isTextArea: true,
                              ),
                            ),
                          ],
                        ),
                      ),
                      BloqoSeasaltContainer(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  localizedText.preview,
                                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                    color: BloqoColors.russianViolet,
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 20),
                              child: MarkdownBody(
                                data: textController.text,
                                styleSheet: BloqoMarkdownStyleSheet.get()
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
                        courseId: course.id,
                        sectionId: section.id,
                        block: block,
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
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _saveChanges({required BuildContext context, required String courseId, required String sectionId, required BloqoBlock block}) async {
    var localizedText = getAppLocalizations(context)!;

    block.content = textController.text;
    block.type = BloqoBlockType.text.toString();

    await saveBlockChanges(
      localizedText: localizedText,
      updatedBlock: block,
    );

    if (!context.mounted) return;
    BloqoUserCourseCreated userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((course) => course.courseId == courseId).first;
    updateEditorCourseBlockInAppState(context: context, sectionId: sectionId, block: block);

    await saveUserCourseCreatedChanges(localizedText: localizedText, updatedUserCourseCreated: userCourseCreated);
  }
}