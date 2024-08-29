import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/model/bloqo_notification_data.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_created_data.dart';
import 'package:bloqo/model/courses/tags/bloqo_modality_tag.dart';
import 'package:bloqo/model/courses/tags/bloqo_subject_tag.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/editor_course_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/forms/bloqo_dropdown.dart';
import '../../components/forms/bloqo_switch.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/published_courses/bloqo_published_course_data.dart';
import '../../model/bloqo_user_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../model/courses/tags/bloqo_course_tag.dart';
import '../../model/courses/tags/bloqo_difficulty_tag.dart';
import '../../model/courses/tags/bloqo_duration_tag.dart';
import '../../model/courses/tags/bloqo_language_tag.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/check_device.dart';
import '../../utils/constants.dart';
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
    bool isTablet = checkDevice(context);

    final List<DropdownMenuEntry<String>> languageTags = buildTagList(type: BloqoCourseTagType.language, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> subjectTags = buildTagList(type: BloqoCourseTagType.subject, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> durationTags = buildTagList(type: BloqoCourseTagType.duration, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> modalityTags = buildTagList(type: BloqoCourseTagType.modality, localizedText: localizedText);
    final List<DropdownMenuEntry<String>> difficultyTags = buildTagList(type: BloqoCourseTagType.difficulty, localizedText: localizedText);

    final BloqoUserCourseCreatedData userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((uc) => uc.courseId == widget.courseId).first;
    final BloqoUserData myself = getUserFromAppState(context: context)!;

    return Consumer<ApplicationSettingsAppState>(
        builder: (context, applicationSettingsAppState, _) {
          var theme = getAppThemeFromAppState(context: context);
          return BloqoMainContainer(
              alignment: const AlignmentDirectional(-1.0, -1.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Padding(
                          padding: !isTablet
                              ? const EdgeInsetsDirectional.all(0)
                              : Constants.tabletPadding,
                          child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 20, 0),
                                  child: Text(
                                    localizedText.publish_course_page_header_1,
                                    style: theme
                                        .getThemeData()
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                      color: theme.colors.highContrastColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 20, 0),
                                  child: Text(
                                      localizedText.publish_course_page_header_2,
                                      style: theme
                                          .getThemeData()
                                          .textTheme
                                          .displayMedium
                                          ?.copyWith(
                                        color: theme.colors.highContrastColor,
                                      )
                                  ),
                                ),
                                BloqoSeasaltContainer(
                                    padding: const EdgeInsetsDirectional.fromSTEB(
                                        20, 20, 20, 0),
                                    child: Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 15, 20, 20),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Text(
                                                  localizedText
                                                      .publish_course_page_public_private_header,
                                                  style: theme
                                                      .getThemeData()
                                                      .textTheme
                                                      .displayMedium
                                                      ?.copyWith(
                                                      fontWeight: FontWeight.bold,
                                                      color: theme.colors
                                                          .leadingColor
                                                  )
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Flexible(
                                                    child: Padding(
                                                      padding: const EdgeInsetsDirectional
                                                          .fromSTEB(0, 10, 0, 10),
                                                      child: Text(
                                                        localizedText
                                                            .publish_course_page_public_private_question,
                                                        style: theme
                                                            .getThemeData()
                                                            .textTheme
                                                            .displayMedium
                                                            ?.copyWith(
                                                            color: theme.colors
                                                                .leadingColor,
                                                            fontWeight: FontWeight
                                                                .w500
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  BloqoSwitch(
                                                    value: publicPrivateCoursesToggle,
                                                    padding: const EdgeInsetsDirectional
                                                        .fromSTEB(10, 0, 5, 0),
                                                  )
                                                ],
                                              ),
                                            ]
                                        )
                                    )
                                ),
                                BloqoSeasaltContainer(
                                    child: Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          20, 15, 20, 20),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                              localizedText
                                                  .publish_course_page_tag_header,
                                              style: theme
                                                  .getThemeData()
                                                  .textTheme
                                                  .displayMedium
                                                  ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: theme.colors.leadingColor
                                              )
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 20, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 15, 0),
                                                  child: Icon(
                                                    Icons.label,
                                                    color: Color(0xFFFF00FF),
                                                    size: 24,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: LayoutBuilder(
                                                        builder: (
                                                            BuildContext context,
                                                            BoxConstraints constraints) {
                                                          double availableWidth = constraints
                                                              .maxWidth;
                                                          return Row(
                                                              mainAxisSize: MainAxisSize
                                                                  .max,
                                                              children: [
                                                                BloqoDropdown(
                                                                    controller: languageTagController,
                                                                    dropdownMenuEntries: languageTags,
                                                                    initialSelection: languageTags[0]
                                                                        .value,
                                                                    label: localizedText
                                                                        .language_tag,
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
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 20, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 15, 0),
                                                  child: Icon(
                                                    Icons.label,
                                                    color: Color(0xFFFF0000),
                                                    size: 24,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: LayoutBuilder(
                                                        builder: (
                                                            BuildContext context,
                                                            BoxConstraints constraints) {
                                                          double availableWidth = constraints
                                                              .maxWidth;
                                                          return Row(
                                                              mainAxisSize: MainAxisSize
                                                                  .max,
                                                              children: [
                                                                BloqoDropdown(
                                                                    controller: subjectTagController,
                                                                    dropdownMenuEntries: subjectTags,
                                                                    initialSelection: subjectTags[0]
                                                                        .value,
                                                                    label: localizedText
                                                                        .subject_tag,
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
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 15, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 15, 0),
                                                  child: Icon(
                                                    Icons.label,
                                                    color: Color(0xFF0000FF),
                                                    size: 24,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: LayoutBuilder(
                                                        builder: (
                                                            BuildContext context,
                                                            BoxConstraints constraints) {
                                                          double availableWidth = constraints
                                                              .maxWidth;
                                                          return Row(
                                                              mainAxisSize: MainAxisSize
                                                                  .max,
                                                              children: [
                                                                BloqoDropdown(
                                                                    controller: durationTagController,
                                                                    dropdownMenuEntries: durationTags,
                                                                    initialSelection: durationTags[0]
                                                                        .value,
                                                                    label: localizedText
                                                                        .duration_tag,
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
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 15, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 15, 0),
                                                  child: Icon(
                                                    Icons.label,
                                                    color: Color(0xFF00FF00),
                                                    size: 24,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: LayoutBuilder(
                                                        builder: (
                                                            BuildContext context,
                                                            BoxConstraints constraints) {
                                                          double availableWidth = constraints
                                                              .maxWidth;
                                                          return Row(
                                                              mainAxisSize: MainAxisSize
                                                                  .max,
                                                              children: [
                                                                BloqoDropdown(
                                                                    controller: modalityTagController,
                                                                    dropdownMenuEntries: modalityTags,
                                                                    initialSelection: modalityTags[0]
                                                                        .value,
                                                                    label: localizedText
                                                                        .modality_tag,
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
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(0, 15, 0, 0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 15, 0),
                                                  child: Icon(
                                                    Icons.label,
                                                    color: Color(0xFFFFFF00),
                                                    size: 24,
                                                  ),
                                                ),
                                                Expanded(
                                                    child: LayoutBuilder(
                                                        builder: (
                                                            BuildContext context,
                                                            BoxConstraints constraints) {
                                                          double availableWidth = constraints
                                                              .maxWidth;
                                                          return Row(
                                                              mainAxisSize: MainAxisSize
                                                                  .max,
                                                              children: [
                                                                BloqoDropdown(
                                                                    controller: difficultyTagController,
                                                                    dropdownMenuEntries: difficultyTags,
                                                                    initialSelection: difficultyTags[0]
                                                                        .value,
                                                                    label: localizedText
                                                                        .difficulty_tag,
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
                    ),
                    Padding(
                      padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(
                          20, 10, 20, 10)
                          : Constants.tabletPaddingBloqoFilledButton,
                      child: BloqoFilledButton(
                        color: theme.colors.success,
                        fontSize: !isTablet
                            ? Constants.fontSizeNotTablet
                            : Constants.fontSizeTablet,
                        height: !isTablet ? Constants.heightNotTablet : Constants
                            .heightTablet,
                        onPressed: () async {
                          await showBloqoConfirmationAlert(
                              context: context,
                              title: localizedText.warning,
                              description: localizedText
                                  .course_publish_confirmation,
                              confirmationFunction: () async {
                                context.loaderOverlay.show();
                                await _tryPublishCourse(
                                    context: context,
                                    localizedText: localizedText,
                                    userCourseCreated: userCourseCreated,
                                    myself: myself
                                );
                              },
                              backgroundColor: theme.colors.leadingColor,
                              confirmationColor: theme.colors.success
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
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _tryPublishCourse({required BuildContext context, required var localizedText, required BloqoUserCourseCreatedData userCourseCreated, required BloqoUserData myself}) async {
    try {

      if (languageTagController.text == localizedText.none ||
          subjectTagController.text == localizedText.none ||
          durationTagController.text == localizedText.none ||
          modalityTagController.text == localizedText.none ||
          difficultyTagController.text == localizedText.none) {
        throw BloqoException(message: localizedText.missing_tag_error);
      }

      final List<DropdownMenuEntry<String>> languageTags = buildTagList(
          type: BloqoCourseTagType.language, localizedText: localizedText);
      final List<DropdownMenuEntry<String>> subjectTags = buildTagList(
          type: BloqoCourseTagType.subject, localizedText: localizedText);
      final List<DropdownMenuEntry<String>> durationTags = buildTagList(
          type: BloqoCourseTagType.duration, localizedText: localizedText);
      final List<DropdownMenuEntry<String>> modalityTags = buildTagList(
          type: BloqoCourseTagType.modality, localizedText: localizedText);
      final List<DropdownMenuEntry<String>> difficultyTags = buildTagList(
          type: BloqoCourseTagType.difficulty, localizedText: localizedText);

      String languageTag = languageTags
          .where((entry) => entry.label == languageTagController.text)
          .first
          .value;
      String subjectTag = subjectTags
          .where((entry) => entry.label == subjectTagController.text)
          .first
          .value;
      String durationTag = durationTags
          .where((entry) => entry.label == durationTagController.text)
          .first
          .value;
      String modalityTag = modalityTags
          .where((entry) => entry.label == modalityTagController.text)
          .first
          .value;
      String difficultyTag = difficultyTags
          .where((entry) => entry.label == difficultyTagController.text)
          .first
          .value;

      BloqoPublishedCourseData publishedCourse = BloqoPublishedCourseData(
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

      var firestore = getFirestoreFromAppState(context: context);

      await publishCourse(
          firestore: firestore,
          localizedText: localizedText,
          publishedCourse: publishedCourse
      );

      await updateCourseStatus(
          firestore: firestore,
          localizedText: localizedText,
          courseId: userCourseCreated.courseId,
          published: true
      );

      if (!context.mounted) return;

      BloqoCourseData? currentEditorCourse = getEditorCourseFromAppState(
          context: context);
      if (currentEditorCourse != null &&
          currentEditorCourse.id == userCourseCreated.courseId) {
        updateEditorCourseStatusInAppState(context: context, published: true);
      }

      updateUserCourseCreatedPublishedStatusInAppState(context: context,
          courseId: userCourseCreated.courseId,
          published: true);

      await saveUserCourseCreatedChanges(
          firestore: firestore,
          localizedText: localizedText,
          updatedUserCourseCreated: userCourseCreated
      );

      if (!context.mounted) return;
      List<dynamic> followerIds = getUserFromAppState(context: context)!.followers;
      for(String followerId in followerIds){
        BloqoNotificationData notification = BloqoNotificationData(
          id: uuid(),
          userId: followerId,
          type: BloqoNotificationType.newCourseFromFollowedUser.toString(),
          timestamp: Timestamp.now(),
          courseAuthorId: myself.id,
          courseName: userCourseCreated.courseName
        );
        await pushNotification(
            firestore: firestore,
            localizedText: localizedText,
            notification: notification
        );
      }

      if (!context.mounted) return;
      context.loaderOverlay.hide();
      Navigator.of(context).pop();
      showBloqoSnackBar(
          context: context,
          text: localizedText.done
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

  }

}