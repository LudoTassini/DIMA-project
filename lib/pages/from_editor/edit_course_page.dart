import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/navigation/bloqo_breadcrumbs.dart';
import 'package:bloqo/model/bloqo_user_course_created.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/editor_course_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/forms/bloqo_text_field.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/bloqo_course.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';

class EditCoursePage extends StatefulWidget {
  const EditCoursePage({
    super.key,
    required this.onPush
  });

  final void Function(Widget) onPush;

  @override
  State<EditCoursePage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditCoursePage> with AutomaticKeepAliveClientMixin<EditCoursePage> {

  final formKeyCourseName = GlobalKey<FormState>();
  final formKeyCourseDescription = GlobalKey<FormState>();

  late TextEditingController courseNameController;
  late TextEditingController courseDescriptionController;

  @override
  void initState() {
    super.initState();
    courseNameController = TextEditingController();
    courseDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    courseNameController.dispose();
    courseDescriptionController.dispose();
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
              courseNameController.text = course.name;
              if(course.description != null) {
                courseDescriptionController.text = course.description!;
              }
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BloqoBreadcrumbs(breadcrumbs: [
                      course.name
                    ]),
                    Expanded(
                        child: SingleChildScrollView(
                            child: Column(
                                children: [
                                  Form(
                                      key: formKeyCourseName,
                                      child: BloqoTextField(
                                        formKey: formKeyCourseName,
                                        controller: courseNameController,
                                        labelText: localizedText.name,
                                        hintText: localizedText.editor_course_name_hint,
                                        maxInputLength: Constants.maxCourseTitleLength,
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                      )
                                  ),
                                  Form(
                                      key: formKeyCourseDescription,
                                      child: BloqoTextField(
                                        formKey: formKeyCourseDescription,
                                        controller: courseDescriptionController,
                                        labelText: localizedText.description,
                                        hintText: localizedText.editor_course_description_hint,
                                        maxInputLength: Constants.maxCourseDescriptionLength,
                                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                                        isTextArea: true,
                                      )
                                  ),
                                  Padding(
                                    padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 0),
                                    child: Text(
                                      localizedText.chapters_header,
                                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                        color: BloqoColors.seasalt,
                                        fontSize: 30,
                                      ),
                                    ),
                                  ),
                                  BloqoSeasaltContainer(
                                      child: Column(
                                          children: [
                                            if(course.chapters.isEmpty)
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                                                child: Text(
                                                  localizedText.edit_course_page_no_chapters,
                                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                    color: BloqoColors.primaryText,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            if(course.chapters.isNotEmpty)
                                              Container(),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                                              child: BloqoFilledButton(
                                                color: BloqoColors.russianViolet,
                                                onPressed: () async {
                                                  // TODO
                                                },
                                                text: localizedText.add_chapter,
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
                          context.loaderOverlay.show();
                          WidgetsBinding.instance.addPostFrameCallback((_) async {
                            try {
                              await _saveChanges(
                                context: context,
                                course: course,
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
                          });
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

  Future<void> _saveChanges({required BuildContext context, required BloqoCourse course}) async {
    var localizedText = getAppLocalizations(context);
    course.name = courseNameController.text;
    course.description = courseDescriptionController.text;

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
    saveEditorCourseToAppState(context: context, course: course);
  }

}
