import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/complex/bloqo_editable_chapter.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:bloqo/model/bloqo_user_course_created.dart';
import 'package:bloqo/model/courses/bloqo_chapter.dart';
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
import '../../model/courses/bloqo_course.dart';
import '../../model/courses/bloqo_section.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';

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
    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1.0, -1.0),
        child: Consumer<EditorCourseAppState>(
            builder: (context, editorCourseAppState, _){
              BloqoCourse course = getEditorCourseFromAppState(context: context)!;
              BloqoChapter chapter = getEditorCourseChapterFromAppState(context: context, chapterId: widget.chapterId)!;
              List<BloqoSection> sections = getEditorCourseChapterSectionsFromAppState(context: context, chapterId: widget.chapterId) ?? [];
              chapterNameController.text = chapter.name;
              if(chapter.description != null) {
                chapterDescriptionController.text = chapter.description!;
              }
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BloqoBreadcrumbs(breadcrumbs: [
                      course.name,
                      chapter.name
                    ]),
                    Expanded(
                        child: SingleChildScrollView(
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
                                                      color: BloqoColors.russianViolet,
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
                                                    color: BloqoColors.primaryText,
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
                                                      BloqoSection section = sections[index];
                                                      if (index < sections.length - 1) {
                                                        return BloqoEditableSection(
                                                            course: course,
                                                            section: section,
                                                            onPressed: () async {
                                                              // TODO
                                                            }
                                                        );
                                                      }
                                                      else{
                                                        return BloqoEditableSection(
                                                            course: course,
                                                            section: section,
                                                            padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                                            onPressed: () async {
                                                              // TODO
                                                            }
                                                        );
                                                      }
                                                    }
                                                ),
                                              ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                                              child: BloqoFilledButton(
                                                color: BloqoColors.russianViolet,
                                                onPressed: () async {
                                                  /*context.loaderOverlay.show();
                                                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                                                    try {
                                                      await _addChapter(
                                                          context: context,
                                                          course: course,
                                                          chapters: chapters
                                                      );
                                                      if (!context.mounted) return;
                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                        BloqoSnackBar.get(child: Text(localizedText.done)),
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
                                                  });*/
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
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                      child: BloqoFilledButton(
                        color: BloqoColors.russianViolet,
                        onPressed: () async {
                          /*context.loaderOverlay.show();
                          WidgetsBinding.instance.addPostFrameCallback((_) async {
                            try {
                              await _saveChanges(
                                  context: context,
                                  course: course,
                                  chapters: chapters
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                BloqoSnackBar.get(child: Text(localizedText.done)),
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
                          });*/
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

  /*Future<void> _addChapter({required BuildContext context, required BloqoCourse course, required List<BloqoChapter> chapters}) async {
    var localizedText = getAppLocalizations(context)!;

    BloqoChapter chapter = await saveNewChapter(localizedText: localizedText, chapterNumber: course.chapters.length + 1);

    course.chapters.add(chapter.id);
    chapters.add(chapter);

    if(!context.mounted) return;
    updateUserCourseCreatedChaptersNumberInAppState(context: context, courseId: course.id, newChaptersNum: course.chapters.length);
    _saveChanges(context: context, course: course, chapters: chapters);
  }

  Future<void> _saveChanges({required BuildContext context, required BloqoCourse course, required List<BloqoChapter> chapters}) async {
    var localizedText = getAppLocalizations(context);
    course.name = chapterNameController.text;
    course.description = chapterDescriptionController.text;

    BloqoUserCourseCreated updatedUserCourseCreated = getUserCoursesCreatedFromAppState(context: context)
    !.firstWhere((userCourse) => userCourse.courseId == course.id);

    updatedUserCourseCreated.courseName = course.name;

    await saveCourseChanges(
        localizedText: localizedText,
        updatedCourse: course
    );

    await saveUserCourseCreatedChanges(
        localizedText: localizedText,
        updatedUserCourseCreated: updatedUserCourseCreated
    );

    if(!context.mounted) return;
    updateUserCourseCreatedNameInAppState(context: context, courseId: course.id, newName: course.name);
    saveEditorCourseToAppState(context: context, course: course, chapters: chapters);
  }*/

}
