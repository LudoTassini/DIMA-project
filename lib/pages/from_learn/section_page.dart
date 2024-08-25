import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/learn_course_app_state.dart';
import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/app_state/user_courses_enrolled_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/quiz/bloqo_open_question_quiz.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_published_course_data.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../components/multimedia/bloqo_audio_player.dart';
import '../../components/multimedia/bloqo_video_player.dart';
import '../../components/multimedia/bloqo_youtube_player.dart';
import '../../components/navigation/bloqo_breadcrumbs.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../components/quiz/bloqo_multiple_choice_quiz.dart';
import '../../model/user_courses/bloqo_user_course_enrolled_data.dart';
import '../../model/courses/bloqo_block_data.dart';
import '../../style/bloqo_style_sheet.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';

class SectionPage extends StatefulWidget {

  const SectionPage({
    super.key,
    required this.onPush,
    required this.section,
    required this.blocks,
    required this.courseName,
    required this.chapter
  });

  final void Function(Widget) onPush;
  final BloqoSectionData section;
  final List<BloqoBlockData> blocks;
  final String courseName;
  final BloqoChapterData chapter;

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> with AutomaticKeepAliveClientMixin<SectionPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BloqoBreadcrumbs(
              disable: true,
              breadcrumbs: [
                widget.courseName,
                widget.chapter.name,
                widget.section.name
            ]),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: isTablet ? Constants.tabletPadding : const EdgeInsetsDirectional.all(0),
                      child: Column(
                        children: [
                        ...List.generate(
                      widget.blocks.length,
                      (blockIndex) {
                        var block = widget.blocks[blockIndex];

                        if (block.type == BloqoBlockType.text.toString()) {
                          return BloqoSeasaltContainer(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10), //20, 10, 20, 20
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      MarkdownBody(
                                        data: block.content,
                                        styleSheet: BloqoMarkdownStyleSheet.get(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        if(block.type == BloqoBlockType.multimediaAudio.toString()) {
                          return BloqoSeasaltContainer(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 20),
                            child: Column(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: BloqoAudioPlayer(
                                          url: block.content
                                      )
                                  ),
                                ]
                            ),
                          );
                      }

                      if(block.type == BloqoBlockType.multimediaImage.toString()) {
                        return BloqoSeasaltContainer(
                            padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                            child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Image.network(block.content),
                                    ),
                                ],
                            ),
                        );
                      }

                      if(block.type == BloqoBlockType.multimediaVideo.toString()) {
                        return BloqoSeasaltContainer(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 0, 20, 20),
                            child: block.content != "" ?
                              Column(
                                children: [
                                  !block.content.startsWith("yt:")
                                      ? BloqoVideoPlayer(
                                      url: block.content
                                  )
                                      : BloqoYouTubePlayer(
                                      url: block.content.substring(3)
                                  ),
                                ]
                            ) : Container()
                        );
                      }

                  if(block.type == BloqoBlockType.quizOpenQuestion.toString()) {
                    return BloqoSeasaltContainer(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                        child: Column(
                          children: [
                            BloqoOpenQuestionQuiz(
                              block: block
                            ),

                            ],
                          ),
                        );
                      }

                  if(block.type == BloqoBlockType.quizMultipleChoice.toString()) {
                    return BloqoSeasaltContainer(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                      child: Column(
                        children: [
                          BloqoMultipleChoiceQuiz(
                              block: block
                          ),

                            ],
                          ),
                        );
                      }
                      return const SizedBox();
                      }
                    ),
                  ],
                ),
              ),

                Align(
                  alignment: Alignment.center,
                  child:Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                    child: BloqoFilledButton(
                      onPressed: () async {
                        await _updateEnrolledCourseStatus(
                          context: context,
                          localizedText: localizedText,
                          section: widget.section,
                        );
                        if(!context.mounted) return;
                        Navigator.of(context).pop();
                      },
                      color: theme.colors.success,
                      text: localizedText.learned,
                      fontSize: !isTablet ? 24 : 32,
                      height: !isTablet ? 65 : 75,
                    ),
                  ),
                ),

                ],
              ),
            ),
          ),
      ],

      ),

    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _updateEnrolledCourseStatus({required BuildContext context, required var localizedText,
    required BloqoSectionData section}) async {
    // Show loader before starting async operations
    context.loaderOverlay.show();

    try {
      // Fetch necessary data from the app state before any async operations
      final course = getLearnCourseFromAppState(context: context)!;
      final user = getUserFromAppState(context: context)!;
      final chapters = getLearnCourseChaptersFromAppState(context: context)!;
      var sectionsCompleted = getLearnCourseSectionsCompletedFromAppState(context: context)!;
      final userCoursesEnrolled = getUserCoursesEnrolledFromAppState(context: context)!;
      final courseEnrolled = userCoursesEnrolled.firstWhere((x) => x.courseId == course.id);
      BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromCourseId(localizedText: localizedText, courseId: course.id);

      var firestore = getFirestoreFromAppState(context: context);

      // Update sections completed in both the course enrollment and app state
      if (!sectionsCompleted.contains(section.id)) { //FIXME: quando button learn sarà disabilitato, sarà da togliere

        courseEnrolled.sectionsCompleted!.add(section.id);
        updateLearnCourseSectionsCompletedFromAppState(context: context, sectionsCompleted: courseEnrolled.sectionsCompleted!);

        updateUserCoursesEnrolledToAppState(context: context, userCourseEnrolled: courseEnrolled);

        // Perform async operations and check if context is still mounted afterward
        await updateUserCourseEnrolledCompletedSections(
          firestore: firestore,
          localizedText: localizedText,
          courseId: course.id,
          enrolledUserId: user.id,
          sectionsCompleted: sectionsCompleted,
        );
        if (!context.mounted) return;
      }

      // Update chapters completed and course status
      var chaptersCompleted = getLearnCourseChaptersCompletedFromAppState(context: context);

        if (widget.chapter.sections.lastOrNull == section.id) {
          // If the section is the last in the chapter
          if (!chaptersCompleted!.contains(widget.chapter.id)) { //FIXME: quando button learn sarà disabilitato, sarà da togliere

            courseEnrolled.chaptersCompleted!.add(widget.chapter.id);
            updateLearnCourseChaptersCompletedFromAppState(context: context, chaptersCompleted: courseEnrolled.chaptersCompleted!);
            updateUserCoursesEnrolledToAppState(context: context, userCourseEnrolled: courseEnrolled);

            // Perform async operations and check if context is still mounted afterward
            await updateUserCourseEnrolledCompletedChapters(
              firestore: firestore,
              localizedText: localizedText,
              courseId: course.id,
              enrolledUserId: user.id,
              chaptersCompleted: chaptersCompleted,
            );
            if (!context.mounted) return;
          }
        }

      // If the last chapter is completed, mark the course as completed
      if (chapters.last.sections.lastOrNull == section.id) {
        courseEnrolled.isCompleted = true;
        updateUserCoursesEnrolledToAppState(context: context, userCourseEnrolled: courseEnrolled);
        await updateUserCourseEnrolledStatusCompleted(
          firestore: firestore,
          localizedText: localizedText,
          courseId: course.id,
          enrolledUserId: user.id,
        );

        publishedCourse.numberOfCompletions = publishedCourse.numberOfCompletions + 1;
        await savePublishedCourseChanges(localizedText: localizedText, updatedPublishedCourse: publishedCourse);

        if (!context.mounted) return;
      }
      // Otherwise set the new sectionToComplete
      else {
        String? nextSectionToComplete = _getNextSectionId(chapters: chapters, chapter: widget.chapter, section: section);
        BloqoSectionData sectionToComplete = await getSectionFromId(
            firestore: firestore,
            localizedText: localizedText,
            sectionId: nextSectionToComplete!
        );

        if (!context.mounted) return;

        updateUserCoursesEnrolledToAppState(context: context, userCourseEnrolled: courseEnrolled);
        await updateUserCourseEnrolledNewSectionToComplete(
          firestore: firestore,
          localizedText: localizedText,
          courseId: course.id,
          enrolledUserId: user.id,
          sectionToComplete: sectionToComplete,
        );

        if (!context.mounted) return;
      }
      context.loaderOverlay.hide();

    } on BloqoException catch (e) {
      context.loaderOverlay.hide();
      if (context.mounted) {
        showBloqoErrorAlert(
          context: context,
          title: localizedText.error_title,
          description: e.message,
        );
      }
    }
  }

  String? _getNextSectionId({required List<BloqoChapterData> chapters, required BloqoChapterData chapter, required BloqoSectionData section,
  }) {
    // Ensure the section exists within the chapter
    final sectionIndex = chapter.sections.indexOf(section.id);

    // If section is not the last one in the current chapter
    if (sectionIndex != -1 && sectionIndex < chapter.sections.length - 1) {
      // Return the next section ID in the current chapter
      return chapter.sections[sectionIndex + 1] as String;
    }

    // If the section is the last one in the current chapter, find the next chapter
    final chapterIndex = chapters.indexOf(chapter);

    // Ensure the current chapter is not the last one in the chapters list
    if (chapterIndex != -1 && chapterIndex < chapters.length - 1) {
      final nextChapter = chapters[chapterIndex + 1];

      // Return the first section ID in the next chapter
      if (nextChapter.sections.isNotEmpty) {
        return nextChapter.sections.first as String;
      }
    }
    // Return null if there are no further sections or chapters to navigate to
    return null;
  }

}