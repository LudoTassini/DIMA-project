import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/editor_course_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/complex/bloqo_editable_section.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/forms/bloqo_text_field.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/user_courses/bloqo_user_course_created_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../model/courses/bloqo_section_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import 'edit_section_page.dart';

class EditChapterPage extends StatefulWidget {
  const EditChapterPage({
    super.key,
    required this.onPush,
    required this.chapterId
  });

  final void Function(Widget) onPush;
  final String chapterId;

  @override
  State<EditChapterPage> createState() => _EditChapterPageState();
}

class _EditChapterPageState extends State<EditChapterPage> with AutomaticKeepAliveClientMixin<EditChapterPage> {

  bool firstBuild = true;

  final formKeyChapterName = GlobalKey<FormState>();
  final formKeyChapterDescription = GlobalKey<FormState>();

  late TextEditingController chapterNameController;
  late TextEditingController chapterDescriptionController;

  @override
  void initState() {
    super.initState();
    chapterNameController = TextEditingController();
    chapterDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    chapterNameController.dispose();
    chapterDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1.0, -1.0),
        child: Consumer<EditorCourseAppState>(
            builder: (context, editorCourseAppState, _){
              BloqoCourseData course = getEditorCourseFromAppState(context: context)!;
              BloqoChapterData chapter = getEditorCourseChapterFromAppState(context: context, chapterId: widget.chapterId)!;
              List<BloqoSectionData> sections = getEditorCourseChapterSectionsFromAppState(context: context, chapterId: widget.chapterId) ?? [];
              if(firstBuild) {
                chapterNameController.text = chapter.name;
                if (chapter.description != null) {
                  chapterDescriptionController.text = chapter.description!;
                }
                firstBuild = false;
              }
              bool editable = !course.published;
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BloqoBreadcrumbs(breadcrumbs: [
                      course.name,
                      chapter.name
                    ]),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Padding(
                              padding: !isTablet ? const EdgeInsetsDirectional.all(0) : Constants.tabletPadding,
                              child: Column(
                                children: [
                                  Form(
                                      key: formKeyChapterName,
                                      child: BloqoTextField(
                                        formKey: formKeyChapterName,
                                        controller: chapterNameController,
                                        labelText: localizedText.name,
                                        hintText: localizedText.editor_chapter_name_hint,
                                        maxInputLength: Constants.maxChapterNameLength,
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                      )
                                  ),
                                  Form(
                                      key: formKeyChapterDescription,
                                      child: BloqoTextField(
                                        formKey: formKeyChapterDescription,
                                        controller: chapterDescriptionController,
                                        labelText: localizedText.description,
                                        hintText: localizedText.editor_chapter_description_hint,
                                        maxInputLength: Constants.maxChapterDescriptionLength,
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                                        isTextArea: true,
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
                                                    localizedText.sections_header,
                                                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                                      color: theme.colors.leadingColor,
                                                      fontSize: 30,
                                                    ),
                                                  ),
                                                )
                                            ),
                                            if(sections.isEmpty)
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 15),
                                                child: Text(
                                                  localizedText.edit_chapter_page_no_sections,
                                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                    color: theme.colors.primaryText,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            if(sections.isNotEmpty)
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: List.generate(
                                                    sections.length,
                                                        (index) {
                                                      BloqoSectionData section = sections[index];
                                                      if (index < sections.length - 1) {
                                                        return BloqoEditableSection(
                                                            course: course,
                                                            chapter: chapter,
                                                            section: section,
                                                            editable: editable,
                                                            onPressed: () {
                                                              widget.onPush(EditSectionPage(onPush: widget.onPush, chapterId: chapter.id, sectionId: section.id,));
                                                            }
                                                        );
                                                      }
                                                      else{
                                                        return BloqoEditableSection(
                                                            course: course,
                                                            chapter: chapter,
                                                            section: section,
                                                            editable: editable,
                                                            padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                                            onPressed: () {
                                                              widget.onPush(EditSectionPage(onPush: widget.onPush, chapterId: chapter.id, sectionId: section.id,));
                                                            }
                                                        );
                                                      }
                                                    }
                                                ),
                                              ),
                                            if(editable)
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                                                child: BloqoFilledButton(
                                                  color: theme.colors.leadingColor,
                                                  onPressed: () async {
                                                  context.loaderOverlay.show();
                                                    try {
                                                      await _addSection(
                                                        context: context,
                                                        course: course,
                                                        chapter: chapter,
                                                        sections: sections
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
                                                  text: localizedText.add_section,
                                                  icon: Icons.add,
                                                ),
                                              )
                                          ]
                                      )
                                  )
                                ]
                            )
                          )
                        ),
                    ),
                    if(editable)
                      Padding(
                        padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10)
                            : Constants.tabletPaddingBloqoFilledButton,
                        child: BloqoFilledButton(
                          color: theme.colors.leadingColor,
                          fontSize: !isTablet ? Constants.fontSizeNotTablet : Constants.fontSizeTablet,
                          height: !isTablet ? Constants.heightNotTablet : Constants.heightTablet,
                          onPressed: () async {
                            context.loaderOverlay.show();
                            try {
                              await _saveChanges(
                                context: context,
                                course: course,
                                chapter: chapter,
                                sections: sections
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

  Future<void> _addSection({required BuildContext context, required BloqoCourseData course, required BloqoChapterData chapter, required List<BloqoSectionData> sections}) async {
    var localizedText = getAppLocalizations(context)!;

    var firestore = getFirestoreFromAppState(context: context);

    BloqoSectionData section = await saveNewSection(
        firestore: firestore,
        localizedText: localizedText,
        sectionNumber: chapter.sections.length + 1
    );

    if(!context.mounted) return;
    addSectionToEditorCourseAppState(context: context, chapterId: chapter.id, section: section);

    updateUserCourseCreatedSectionsNumberInAppState(context: context, courseId: course.id, of: 1);
    BloqoUserCourseCreatedData updatedUserCourseCreated = getUserCoursesCreatedFromAppState(context: context)
    !.firstWhere((userCourse) => userCourse.courseId == course.id);

    await saveUserCourseCreatedChanges(
        firestore: firestore,
        localizedText: localizedText,
        updatedUserCourseCreated: updatedUserCourseCreated
    );

    if(!context.mounted) return;
    _saveChanges(context: context, course: course, chapter: chapter, sections: sections);
  }

  Future<void> _saveChanges({required BuildContext context, required BloqoCourseData course, required BloqoChapterData chapter, required List<BloqoSectionData> sections}) async {
    var localizedText = getAppLocalizations(context)!;
    chapter.name = chapterNameController.text;
    if(chapter.name == ""){
      chapter.name = "${localizedText.chapter} ${chapter.number}";
    }
    chapter.description = chapterDescriptionController.text;

    var firestore = getFirestoreFromAppState(context: context);

    await saveChapterChanges(
        firestore: firestore,
        localizedText: localizedText,
        updatedChapter: chapter
    );

    if(!context.mounted) return;
    updateEditorCourseChapterNameInAppState(context: context, chapterId: chapter.id, newName: chapter.name);
  }

}
