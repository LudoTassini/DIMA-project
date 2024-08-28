import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_created_data.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/style/bloqo_style_sheet.dart';
import 'package:bloqo/utils/check_device.dart';
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
import '../../model/courses/bloqo_block_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../model/courses/bloqo_section_data.dart';
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
  final BloqoBlockData block;

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
    bool isTablet = checkDevice(context);

    return Consumer<ApplicationSettingsAppState>(
        builder: (context, applicationSettingsAppState, _) {
          var theme = getAppThemeFromAppState(context: context);
          return BloqoMainContainer(
            alignment: const AlignmentDirectional(-1.0, -1.0),
            child: Consumer<EditorCourseAppState>(
              builder: (context, editorCourseAppState, _) {
                BloqoCourseData course = getEditorCourseFromAppState(
                    context: context)!;
                BloqoChapterData chapter = getEditorCourseChapterFromAppState(
                    context: context, chapterId: widget.chapterId)!;
                BloqoSectionData section = getEditorCourseSectionFromAppState(
                    context: context,
                    chapterId: widget.chapterId,
                    sectionId: widget.sectionId)!;
                BloqoBlockData block = getEditorCourseBlockFromAppState(
                    context: context,
                    sectionId: widget.sectionId,
                    blockId: widget.block.id)!;
                bool editable = !course.published;
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
                        child: Padding(
                            padding: !isTablet
                                ? const EdgeInsetsDirectional.all(0)
                                : Constants.tabletPadding,
                            child: Column(
                              children: [
                                BloqoSeasaltContainer(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 20, 20, 0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            localizedText.write_text_here,
                                            style: theme
                                                .getThemeData()
                                                .textTheme
                                                .displayLarge
                                                ?.copyWith(
                                              color: theme.colors.leadingColor,
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
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                                          isTextArea: true,
                                          isDisabled: !editable,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                BloqoSeasaltContainer(
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 20, 20, 0),
                                        child: Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            localizedText.preview,
                                            style: theme
                                                .getThemeData()
                                                .textTheme
                                                .displayLarge
                                                ?.copyWith(
                                              color: theme.colors.leadingColor,
                                              fontSize: 30,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 10, 20, 20),
                                        child: MarkdownBody(
                                            data: textController.text,
                                            styleSheet: BloqoMarkdownStyleSheet
                                                .get()
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                        ),
                      ),
                    ),
                    if(editable)
                      Padding(
                        padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(
                            20, 10, 20, 10)
                            : Constants.tabletPaddingBloqoFilledButton,
                        child: BloqoFilledButton(
                          color: theme.colors.leadingColor,
                          fontSize: !isTablet
                              ? Constants.fontSizeNotTablet
                              : Constants.fontSizeTablet,
                          height: !isTablet ? Constants.heightNotTablet : Constants
                              .heightTablet,
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
                              showBloqoSnackBar(
                                  context: context,
                                  text: localizedText.done
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
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _saveChanges({required BuildContext context, required String courseId, required String sectionId, required BloqoBlockData block}) async {
    var localizedText = getAppLocalizations(context)!;

    block.content = textController.text;
    block.type = BloqoBlockType.text.toString();

    var firestore = getFirestoreFromAppState(context: context);

    await saveBlockChanges(
      firestore: firestore,
      localizedText: localizedText,
      updatedBlock: block,
    );

    if (!context.mounted) return;
    BloqoUserCourseCreatedData userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((course) => course.courseId == courseId).first;
    updateEditorCourseBlockInAppState(context: context, sectionId: sectionId, block: block);

    await saveUserCourseCreatedChanges(
        firestore: firestore,
        localizedText: localizedText,
        updatedUserCourseCreated: userCourseCreated
    );
  }
}