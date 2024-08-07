import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/model/bloqo_user_course_created.dart';
import 'package:bloqo/model/courses/tags/bloqo_modality_tag.dart';
import 'package:bloqo/model/courses/tags/bloqo_subject_tag.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/forms/bloqo_dropdown.dart';
import '../../components/forms/bloqo_switch.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_published_course.dart';
import '../../model/bloqo_user.dart';
import '../../model/courses/bloqo_course.dart';
import '../../model/courses/tags/bloqo_course_tag.dart';
import '../../model/courses/tags/bloqo_difficulty_tag.dart';
import '../../model/courses/tags/bloqo_duration_tag.dart';
import '../../model/courses/tags/bloqo_language_tag.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/toggle.dart';
import '../../utils/uuid.dart';

class PublishCoursePage extends StatefulWidget {
  const PublishCoursePage({
    super.key,
    required this.onPush,
    required this.courseId,
  });

  final void Function(Widget) onPush;
  final String courseId;

  @override
  State<PublishCoursePage> createState() => _PublishCoursePageState();
}

class _PublishCoursePageState extends State<PublishCoursePage> with AutomaticKeepAliveClientMixin<PublishCoursePage> {

  late TextEditingController languageTagController;
  late TextEditingController subjectTagController;
  late TextEditingController durationTagController;
  late TextEditingController modalityTagController;
  late TextEditingController difficultyTagController;
  late TextEditingController sortByController;

  final Toggle publicPrivateCoursesToggle = Toggle(initialValue: true);

  @override
  void initState() {
    super.initState();
    languageTagController = TextEditingController();
    subjectTagController = TextEditingController();
    durationTagController = TextEditingController();
    modalityTagController = TextEditingController();
    difficultyTagController = TextEditingController();
    sortByController = TextEditingController();
  }

  @override
  void dispose() {
    languageTagController.dispose();
    subjectTagController.dispose();
    durationTagController.dispose();
    modalityTagController.dispose();
    difficultyTagController.dispose();
    sortByController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    var localizedText = getAppLocalizations(context)!;

    final List<DropdownMenuEntry<String>> languageTags = buildTagList(type: BloqoCourseTagType.language, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> subjectTags = buildTagList(type: BloqoCourseTagType.subject, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> durationTags = buildTagList(type: BloqoCourseTagType.duration, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> modalityTags = buildTagList(type: BloqoCourseTagType.modality, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> difficultyTags = buildTagList(type: BloqoCourseTagType.difficulty, localizedText: localizedText);

    final BloqoUserCourseCreated userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((uc) => uc.courseId == widget.courseId).first;
    final BloqoUser myself = getUserFromAppState(context: context)!;

    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1.0, -1.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: Text(
                          localizedText.publish_course_page_header_1,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: BloqoColors.seasalt,
                            fontSize: 30,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                        child: Text(
                            localizedText.publish_course_page_header_2,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: BloqoColors.seasalt,
                            )
                        ),
                      ),
                      BloqoSeasaltContainer(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 20),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        localizedText.publish_course_page_public_private_header,
                                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: BloqoColors.russianViolet
                                        )
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
                                            child: Text(
                                              localizedText.publish_course_page_public_private_question,
                                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                  color: BloqoColors.russianViolet,
                                                  fontWeight: FontWeight.w500
                                              ),
                                            ),
                                          ),
                                        ),
                                        BloqoSwitch(
                                          value: publicPrivateCoursesToggle,
                                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 5, 0),
                                        )
                                      ],
                                    ),
                                  ]
                              )
                          )
                      ),
                      BloqoSeasaltContainer(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 20),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    localizedText.publish_course_page_tag_header,
                                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: BloqoColors.russianViolet
                                    )
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                        child: Icon(
                                          Icons.label,
                                          color: Color(0xFFFF00FF),
                                          size: 24,
                                        ),
                                      ),
                                      Expanded(
                                          child: LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                double availableWidth = constraints.maxWidth;
                                                return Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children:[
                                                      BloqoDropdown(
                                                          controller: languageTagController,
                                                          dropdownMenuEntries: languageTags,
                                                          initialSelection: languageTags[0].value,
                                                          label: localizedText.language_tag,
                                                          width: availableWidth
                                                      ),
                                                    ]
                                                );
                                              }
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                        child: Icon(
                                          Icons.label,
                                          color: Color(0xFFFF0000),
                                          size: 24,
                                        ),
                                      ),
                                      Expanded(
                                          child: LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                double availableWidth = constraints.maxWidth;
                                                return Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children:[
                                                      BloqoDropdown(
                                                          controller: subjectTagController,
                                                          dropdownMenuEntries: subjectTags,
                                                          initialSelection: subjectTags[0].value,
                                                          label: localizedText.subject_tag,
                                                          width: availableWidth
                                                      ),
                                                    ]
                                                );
                                              }
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                        child: Icon(
                                          Icons.label,
                                          color: Color(0xFF0000FF),
                                          size: 24,
                                        ),
                                      ),
                                      Expanded(
                                          child: LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                double availableWidth = constraints.maxWidth;
                                                return Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children:[
                                                      BloqoDropdown(
                                                          controller: durationTagController,
                                                          dropdownMenuEntries: durationTags,
                                                          initialSelection: durationTags[0].value,
                                                          label: localizedText.duration_tag,
                                                          width: availableWidth
                                                      ),
                                                    ]
                                                );
                                              }
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                        child: Icon(
                                          Icons.label,
                                          color: Color(0xFF00FF00),
                                          size: 24,
                                        ),
                                      ),
                                      Expanded(
                                          child: LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                double availableWidth = constraints.maxWidth;
                                                return Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children:[
                                                      BloqoDropdown(
                                                          controller: modalityTagController,
                                                          dropdownMenuEntries: modalityTags,
                                                          initialSelection: modalityTags[0].value,
                                                          label: localizedText.modality_tag,
                                                          width: availableWidth
                                                      ),
                                                    ]
                                                );
                                              }
                                          )
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                                        child: Icon(
                                          Icons.label,
                                          color: Color(0xFFFFFF00),
                                          size: 24,
                                        ),
                                      ),
                                      Expanded(
                                          child: LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                double availableWidth = constraints.maxWidth;
                                                return Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    children:[
                                                      BloqoDropdown(
                                                          controller: difficultyTagController,
                                                          dropdownMenuEntries: difficultyTags,
                                                          initialSelection: difficultyTags[0].value,
                                                          label: localizedText.difficulty_tag,
                                                          width: availableWidth
                                                      ),
                                                    ]
                                                );
                                              }
                                          )
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                      ),
                    ]
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                child: BloqoFilledButton(
                  color: BloqoColors.success,
                  onPressed: () async {
                    await showBloqoConfirmationAlert(
                        context: context,
                        title: localizedText.warning,
                        description: localizedText.course_publish_confirmation,
                        confirmationFunction: () async {
                          context.loaderOverlay.show();
                          try {
                            await _tryPublishCourse(
                              context: context,
                              localizedText: localizedText,
                              userCourseCreated: userCourseCreated,
                              myself: myself
                            );
                            if (!context.mounted) return;
                            context.loaderOverlay.hide();
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
                            );
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
                        backgroundColor: BloqoColors.russianViolet,
                        confirmationColor: BloqoColors.success
                    );
                  },
                  text: localizedText.publish,
                  icon: Icons.upload,
                ),
              ),
            ]
        )
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _tryPublishCourse({required BuildContext context, required var localizedText, required BloqoUserCourseCreated userCourseCreated, required BloqoUser myself}) async {
    if(languageTagController.text == localizedText.none || subjectTagController.text == localizedText.none || durationTagController.text == localizedText.none ||
      modalityTagController.text == localizedText.none || difficultyTagController.text == localizedText.none){
      throw BloqoException(message: localizedText.missing_tag_error);
    }

    final List<DropdownMenuEntry<String>> languageTags = buildTagList(type: BloqoCourseTagType.language, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> subjectTags = buildTagList(type: BloqoCourseTagType.subject, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> durationTags = buildTagList(type: BloqoCourseTagType.duration, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> modalityTags = buildTagList(type: BloqoCourseTagType.modality, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> difficultyTags = buildTagList(type: BloqoCourseTagType.difficulty, localizedText: localizedText);

    String languageTag = languageTags.where((entry) => entry.label == languageTagController.text).first.value;
    String subjectTag = subjectTags.where((entry) => entry.label == subjectTagController.text).first.value;
    String durationTag = durationTags.where((entry) => entry.label == durationTagController.text).first.value;
    String modalityTag = modalityTags.where((entry) => entry.label == modalityTagController.text).first.value;
    String difficultyTag = difficultyTags.where((entry) => entry.label == difficultyTagController.text).first.value;

    BloqoPublishedCourse publishedCourse = BloqoPublishedCourse(
      publishedCourseId: uuid(),
      originalCourseId: userCourseCreated.courseId,
      courseName: userCourseCreated.courseName,
      authorUsername: myself.username,
      authorId: myself.id,
      isPublic: publicPrivateCoursesToggle.get(),
      publicationDate: Timestamp.now(),
      language: getLanguageTagFromString(tag: languageTag).toString(),
      modality: getModalityTagFromString(tag: modalityTag).toString(),
      subject: getSubjectTagFromString(tag: subjectTag).toString(),
      difficulty: getDifficultyTagFromString(tag: difficultyTag).toString(),
      duration: getDurationTagFromString(tag: durationTag).toString(),
      reviews: [],
      rating: 0
    );

    await publishCourse(localizedText: localizedText, publishedCourse: publishedCourse);

    await updateCourseStatus(localizedText: localizedText, courseId: userCourseCreated.courseId, published: true);

    if(!context.mounted) return;
    updateUserCourseCreatedPublishedStatusInAppState(context: context, courseId: userCourseCreated.courseId, published: true);

    await saveUserCourseCreatedChanges(localizedText: localizedText, updatedUserCourseCreated: userCourseCreated);
  }

}