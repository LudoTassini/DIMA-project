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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../../components/multimedia/bloqo_audio_player.dart';
import '../../components/multimedia/bloqo_video_player.dart';
import '../../components/multimedia/bloqo_youtube_player.dart';
import '../../components/navigation/bloqo_breadcrumbs.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../components/quiz/bloqo_multiple_choice_quiz.dart';
import '../../model/bloqo_user_data.dart';
import '../../model/courses/bloqo_course_data.dart';
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
    required this.chapter,
    required this.onSectionCompleted,
  });

  final void Function(Widget) onPush;
  final BloqoSectionData section;
  final List<BloqoBlockData> blocks;
  final String courseName;
  final BloqoChapterData chapter;
  final void Function() onSectionCompleted;

  @override
  State<SectionPage> createState() => _SectionPageState();
}

class _SectionPageState extends State<SectionPage> with AutomaticKeepAliveClientMixin<SectionPage> {

  int completedBlocks = 0;
  bool isSectionCompleted = false;
  late int numQuizBlocks;

  @override
  void initState() {
    super.initState();
    numQuizBlocks = _getNumQuizBlocks(blocks: widget.blocks);
    if(numQuizBlocks == completedBlocks){
      isSectionCompleted = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    bool isTablet = checkDevice(context);

    void markBlockAsCompleted() {
      completedBlocks = completedBlocks + 1;
      if(completedBlocks == numQuizBlocks) {
        setState(() {
          isSectionCompleted = true;
        });
      }
    }

    return Consumer<ApplicationSettingsAppState>(
        builder: (context, applicationSettingsAppState, _) {
          var theme = getAppThemeFromAppState(context: context);
          return Consumer<LearnCourseAppState>(
              builder: (context, learnCourseAppState, _) {
                List<dynamic> sectionsCompleted = getLearnCourseSectionsCompletedFromAppState(context: context)?? [];

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
                          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                                              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                              child: Column(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10), //20, 10, 20, 20
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize.max,
                                                      children: [
                                                        Expanded(
                                                            child: MarkdownBody(
                                                              data: block.content,
                                                              styleSheet: BloqoMarkdownStyleSheet.get(),
                                                            )
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
                                                  20, 20, 20, 0),
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
                                              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
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
                                                    20, 20, 20, 0),
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
                                            return BloqoOpenQuestionQuiz(
                                              block: block,
                                              isQuizCompleted: sectionsCompleted.contains(widget.section.id) ? true : false,
                                              onQuestionAnsweredCorrectly: () {
                                                markBlockAsCompleted();
                                              },
                                            );

                                          }

                                          if(block.type == BloqoBlockType.quizMultipleChoice.toString()) {
                                            return BloqoMultipleChoiceQuiz(
                                              block: block,
                                              isQuizCompleted: sectionsCompleted.contains(widget.section.id) ? true : false,
                                              onQuestionAnsweredCorrectly: () {
                                                markBlockAsCompleted();
                                              },
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
                                  padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20)
                                      : const EdgeInsetsDirectional.fromSTEB(65, 30, 65, 30),
                                  child: isSectionCompleted && !sectionsCompleted.contains(widget.section.id) ?

                                  BloqoFilledButton(
                                    onPressed: () async {
                                      await _updateEnrolledCourseStatus(
                                        context: context,
                                        localizedText: localizedText,
                                        section: widget.section,
                                      );
                                    },
                                    color: theme.colors.success,
                                    text: localizedText.learned,
                                    fontSize: !isTablet ? 24 : 32,
                                    height: !isTablet ? 65 : 75,
                                  )

                                      : !isSectionCompleted && !sectionsCompleted.contains(widget.section.id) ?
                                  BloqoFilledButton(
                                    onPressed: () async {
                                      showBloqoErrorAlert(
                                          context: context,
                                          title: localizedText.error_title,
                                          description: localizedText.section_is_not_completed);
                                    },
                                    color: theme.colors.inactive,
                                    text: localizedText.learned,
                                    fontSize: !isTablet ? 24 : 32,
                                    height: !isTablet ? 65 : 75,
                                  )

                                      : const SizedBox(height: 20,),

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
          );
        }
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _updateEnrolledCourseStatus({required BuildContext context, required var localizedText, required BloqoSectionData section,
  }) async {
    // Show loader before starting async operations
    context.loaderOverlay.show();

    try {
      // Fetch necessary data from the app state before any async operations
      final course = _getCourse(context);
      final user = _getUser(context);
      final chapters = _getChapters(context);
      final sectionsCompleted = _getSectionsCompleted(context);
      final courseEnrolled = _getCourseEnrolled(context, course);
      final firestore = getFirestoreFromAppState(context: context);
      final publishedCourse = await _getPublishedCourse(firestore, localizedText, course.id);

      // Update sections and chapters completion
      if (!context.mounted) return;
      await _updateSectionCompletion(context, localizedText, firestore, courseEnrolled, section, sectionsCompleted);

      if (!context.mounted) return;
      await _updateChapterCompletion(context, localizedText, firestore, courseEnrolled, section, chapters);

      // Check if course is completed, or update the next section to complete
      if (chapters.last.sections.lastOrNull == section.id) {
        if (!context.mounted) return;
        await _markCourseAsCompleted(context, localizedText, firestore, courseEnrolled, publishedCourse, course, user);
      }
      else {
        if (!context.mounted) return;
        await _setNextSectionToComplete(context, localizedText, firestore, courseEnrolled, chapters, section);
      }

      // Hide the loader when operations are complete
      if (!context.mounted) return;
      _hideLoader(context);
      Navigator.of(context).pop();
    } on BloqoException catch (e) {
      _handleError(context, localizedText, e);
    }
  }

// Method to fetch the current course from the app state
  BloqoCourseData _getCourse(BuildContext context) {
    return getLearnCourseFromAppState(context: context)!;
  }

// Method to fetch the current user from the app state
  BloqoUserData _getUser(BuildContext context) {
    return getUserFromAppState(context: context)!;
  }

// Method to fetch the course chapters from the app state
  List<BloqoChapterData> _getChapters(BuildContext context) {
    return getLearnCourseChaptersFromAppState(context: context)!;
  }

// Method to fetch completed sections from the app state
  List<dynamic> _getSectionsCompleted(BuildContext context) {
    return getLearnCourseSectionsCompletedFromAppState(context: context)!;
  }

// Method to fetch the course enrollment for the current user
  BloqoUserCourseEnrolledData _getCourseEnrolled(BuildContext context, BloqoCourseData course) {
    final userCoursesEnrolled = getUserCoursesEnrolledFromAppState(context: context)!;
    return userCoursesEnrolled.firstWhere((x) => x.courseId == course.id);
  }

// Method to fetch the published course data from Firestore
  Future<BloqoPublishedCourseData> _getPublishedCourse(var firestore, var localizedText, String courseId) async {
    return await getPublishedCourseFromCourseId(
      firestore: firestore,
      localizedText: localizedText,
      courseId: courseId,
    );
  }

// Method to update the completion status of a section
  Future<void> _updateSectionCompletion(BuildContext context, var localizedText, var firestore,
      BloqoUserCourseEnrolledData courseEnrolled, BloqoSectionData section, List<dynamic> sectionsCompleted,) async {
    if (!sectionsCompleted.contains(section.id)) {
      courseEnrolled.sectionsCompleted!.add(section.id);

      if (!context.mounted) return;

      await updateUserCourseEnrolledCompletedSections(
        firestore: firestore,
        localizedText: localizedText,
        courseId: courseEnrolled.courseId,
        enrolledUserId: courseEnrolled.enrolledUserId,
        sectionsCompleted: courseEnrolled.sectionsCompleted!,
      );

      if (!context.mounted) return;
      updateLearnCourseSectionsCompletedFromAppState(
          context: context, sectionsCompleted: courseEnrolled.sectionsCompleted!);
      updateUserCoursesEnrolledToAppState(context: context, userCourseEnrolled: courseEnrolled);
    }
  }

// Method to update the completion status of a chapter
  Future<void> _updateChapterCompletion(BuildContext context, var localizedText, var firestore,
      BloqoUserCourseEnrolledData courseEnrolled, BloqoSectionData section, List<BloqoChapterData> chapters,
      ) async {
    var chaptersCompleted = getLearnCourseChaptersCompletedFromAppState(context: context);

    if (widget.chapter.sections.lastOrNull == section.id) {
      if (!chaptersCompleted!.contains(widget.chapter.id)) {
        courseEnrolled.chaptersCompleted!.add(widget.chapter.id);

        await updateUserCourseEnrolledCompletedChapters(
          firestore: firestore,
          localizedText: localizedText,
          courseId: courseEnrolled.courseId,
          enrolledUserId: courseEnrolled.enrolledUserId,
          chaptersCompleted: courseEnrolled.chaptersCompleted!,
        );

        if (!context.mounted) return;

        updateLearnCourseChaptersCompletedFromAppState(
            context: context, chaptersCompleted: courseEnrolled.chaptersCompleted!);
        updateUserCoursesEnrolledToAppState(context: context, userCourseEnrolled: courseEnrolled);
      }
    }
  }

// Method to mark the course as completed
  Future<void> _markCourseAsCompleted(BuildContext context, var localizedText, var firestore,
      BloqoUserCourseEnrolledData courseEnrolled, BloqoPublishedCourseData publishedCourse, BloqoCourseData course,
      BloqoUserData user,) async {
    courseEnrolled.isCompleted = true;

    await updateUserCourseEnrolledStatusCompleted(
      firestore: firestore,
      localizedText: localizedText,
      courseId: course.id,
      enrolledUserId: user.id,
    );
    if (!context.mounted) return;

    updateUserCoursesEnrolledToAppState(context: context, userCourseEnrolled: courseEnrolled);

    publishedCourse.numberOfCompletions += 1;
    await savePublishedCourseChanges(
      firestore: firestore,
      localizedText: localizedText,
      updatedPublishedCourse: publishedCourse,
    );
  }

// Method to set the next section to be completed
  Future<void> _setNextSectionToComplete(BuildContext context, var localizedText, var firestore,
      BloqoUserCourseEnrolledData courseEnrolled, List<BloqoChapterData> chapters, BloqoSectionData section,) async {

    String? nextSectionToComplete = _getNextSectionId(chapters: chapters, chapter: widget.chapter, section: section);
    BloqoSectionData sectionToComplete = await getSectionFromId(
      firestore: firestore,
      localizedText: localizedText,
      sectionId: nextSectionToComplete!,
    );

    courseEnrolled.sectionToComplete = nextSectionToComplete;
    courseEnrolled.lastUpdated = Timestamp.now();

    await updateUserCourseEnrolledNewSectionToComplete(
      firestore: firestore,
      localizedText: localizedText,
      courseId: courseEnrolled.courseId,
      enrolledUserId: courseEnrolled.enrolledUserId,
      sectionToComplete: sectionToComplete,
    );

    if (!context.mounted) return;
    updateUserCoursesEnrolledToAppState(context: context, userCourseEnrolled: courseEnrolled);

    widget.onSectionCompleted();
  }

// Method to hide the loader overlay
  void _hideLoader(BuildContext context) {
    if (context.mounted) {
      context.loaderOverlay.hide();
    }
  }

// Method to handle errors
  void _handleError(BuildContext context, var localizedText, BloqoException e) {
    _hideLoader(context);
    if (context.mounted) {
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
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

  int _getNumQuizBlocks({required List<BloqoBlockData> blocks}) {
    int numBloqoQuizBlocks = 0;
    for(var block in blocks){
      if(block.type == BloqoBlockType.quizMultipleChoice.toString() || block.type == BloqoBlockType.quizOpenQuestion.toString()){
        numBloqoQuizBlocks = numBloqoQuizBlocks + 1;
      }
    }
    return numBloqoQuizBlocks;
  }

}