import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/custom/bloqo_progress_bar.dart';
import 'package:bloqo/model/courses/bloqo_block_data.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:bloqo/pages/from_learn/section_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../../app_state/learn_course_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/complex/bloqo_course_section.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/navigation/bloqo_breadcrumbs.dart';
import '../../components/popups/bloqo_confirmation_alert.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_user_data.dart';
import '../../model/courses/published_courses/bloqo_published_course_data.dart';
import '../../model/user_courses/bloqo_user_course_enrolled_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';
import 'package:intl/intl.dart';

class CourseContentPage extends StatefulWidget {

  const CourseContentPage({
    super.key,
    required this.onPush,
    required this.isCourseCompleted,
    this.sectionToComplete,
  });

  final void Function(Widget) onPush;
  final BloqoSectionData? sectionToComplete;
  final bool isCourseCompleted;


  @override
  State<CourseContentPage> createState() => _CourseContentPageState();
}

class _CourseContentPageState extends State<CourseContentPage> with AutomaticKeepAliveClientMixin<CourseContentPage> {

  final Map<String, bool> _showSectionsMap = {};
  bool isInitializedSectionMap = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

    // FIXME
    void initializeSectionsToShowMap(List<BloqoChapterData> chapters, List<dynamic> chaptersCompleted) {
      for (var chapter in chapters) {
        if (!chaptersCompleted.contains(chapter.id)) {
          _showSectionsMap[chapter.id] = true;
          break;
        }
      }
      isInitializedSectionMap = true;
    }

    void loadCompletedSections(String chapterId) {
      setState(() {
        _showSectionsMap[chapterId] = true;
      });
    }

    void hideSections(String chapterId) {
      setState(() {
        _showSectionsMap.remove(chapterId);
      });
    }

    if(!isInitializedSectionMap) {
      initializeSectionsToShowMap(getLearnCourseChaptersFromAppState(context: context)?? [],
          getLearnCourseChaptersCompletedFromAppState(context: context)?? []);
    }

    BloqoUserData user = getUserFromAppState(context: context)!;
    bool isClickable = false;

    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1.0, -1.0),
        child: Consumer<UserCoursesEnrolledAppState>(
            builder: (context, userCoursesEnrolledAppState, _) {

              return Consumer<LearnCourseAppState>(
                builder: (context, learnCourseAppState, _) {

                  BloqoCourseData course = getLearnCourseFromAppState(context: context)!;
                  List<BloqoChapterData> chapters = getLearnCourseChaptersFromAppState(context: context)?? [];
                  Map<String, List<BloqoSectionData>> sections = getLearnCourseSectionsFromAppState(context: context)?? {};
                  Timestamp enrollmentDate = getLearnCourseEnrollmentDateFromAppState(context: context)!;
                  List<dynamic> sectionsCompleted = getLearnCourseSectionsCompletedFromAppState(context: context)?? [];
                  List<dynamic> chaptersCompleted = getLearnCourseChaptersCompletedFromAppState(context: context)?? [];
                  int totNumSections = getLearnCourseTotNumSectionsFromAppState(context: context)!;

                  return Column(
                    children: [
                      BloqoBreadcrumbs(breadcrumbs: [
                        course.name,
                      ]),
                      Expanded(
                      child:SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 4, 0, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  localizedText.description,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                    color: BloqoColors.seasalt,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 12),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: course.description != ''
                                    ? Text(
                                  course.description!,
                                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: BloqoColors.seasalt,
                                    fontSize: 16,
                                  ),
                                )
                                    : const SizedBox.shrink(), // This will take up no space
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  localizedText.content,
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                    color: BloqoColors.seasalt,
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ...List.generate(
                                      chapters.length,
                                        (chapterIndex) {
                                          var chapter = chapters[chapterIndex];

                                          isClickable = false;
                                          if (chaptersCompleted.contains(chapter)){
                                            isClickable = true;
                                          }

                                        return BloqoSeasaltContainer(
                                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      '${localizedText.chapter} ${chapterIndex+1}',
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .displayMedium
                                                          ?.copyWith(
                                                        color: BloqoColors.secondaryText,
                                                        fontSize: 18,
                                                      ),
                                                    ),

                                                    chaptersCompleted.contains(chapter.id) ?
                                                      Row(
                                                        children: [
                                                          Align(
                                                            alignment: Alignment.topRight,
                                                            child: Text(
                                                              localizedText.completed,
                                                              textAlign: TextAlign.start,
                                                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                                fontSize: 14,
                                                                color: BloqoColors.success,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                          ),
                                                          const Padding(
                                                            padding: EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                            child: Icon(
                                                              Icons.check,
                                                              color: BloqoColors.success,
                                                              size: 24,
                                                            ),
                                                          ),
                                                        ],
                                                      )

                                                    : Row(
                                                      children: [
                                                        Align(
                                                          alignment: Alignment.topRight,
                                                          child: Text(
                                                            localizedText.not_completed,
                                                            textAlign: TextAlign.start,
                                                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                              fontSize: 14,
                                                              color: BloqoColors.secondaryText,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                  ],
                                                ),

                                              ),

                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 0),
                                                child: Row(
                                                  children: [
                                                    Align(
                                                      alignment: Alignment.topLeft,
                                                      child: Text(
                                                        chapter.name,
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .displayLarge
                                                            ?.copyWith(
                                                          color: BloqoColors.russianViolet,
                                                          fontSize: 24,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Padding(
                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                                                child: chapter.description != ''
                                                ? Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 10),
                                                  child: Row(
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
                                                    Flexible(
                                                      child: Align(
                                                        alignment: Alignment.topLeft,
                                                        child: Text(
                                                          chapter.description!,
                                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                            color: BloqoColors.primaryText,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                              : const SizedBox.shrink(), // This will take up no space
                                              ),

                                              ... (_showSectionsMap[chapter.id] == true
                                                  ? [
                                                    ...List.generate(
                                                      sections[chapter.id]!.length,
                                                          (sectionIndex) {
                                                        var section = sections[chapter.id]![sectionIndex];
                                                        if(widget.isCourseCompleted) {
                                                          isClickable = true;
                                                        } else {
                                                          if (widget.sectionToComplete!.id == section.id) {
                                                            isClickable = true;
                                                          }
                                                        }

                                                        return BloqoCourseSection(
                                                          section: section,
                                                          index: sectionIndex,
                                                          isClickable: isClickable,
                                                          isInLearnPage: true,
                                                          onPressed: () async {
                                                            _goToSectionPage(
                                                              context: context,
                                                              localizedText: localizedText,
                                                              section: section,
                                                              courseName: course.name,
                                                            );
                                                          },
                                                        );


                                                      },
                                                    ),
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 5),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Opacity(
                                                        opacity: 0.9,
                                                        child: Align(
                                                          alignment: const AlignmentDirectional(1, 0),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              hideSections(chapter.id);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  localizedText.collapse,
                                                                  style: const TextStyle(
                                                                    color: BloqoColors.secondaryText,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                const Icon(
                                                                  Icons.keyboard_arrow_up_sharp,
                                                                  color: BloqoColors.secondaryText,
                                                                  size: 25,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]
                                                  : [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 5),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Opacity(
                                                        opacity: 0.9,
                                                        child: Align(
                                                          alignment: const AlignmentDirectional(1, 0),
                                                          child: TextButton(
                                                            onPressed: () {
                                                              loadCompletedSections(chapter.id);
                                                            },
                                                            child: Row(
                                                              children: [
                                                                Text(
                                                                  localizedText.view_more,
                                                                  style: const TextStyle(
                                                                    color: BloqoColors.secondaryText,
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.w600,
                                                                  ),
                                                                ),
                                                                const Icon(
                                                                  Icons.keyboard_arrow_right_sharp,
                                                                  color: BloqoColors.secondaryText,
                                                                  size: 25,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]
                                            ),
                                          ],
                                          ),
                                        );
                                      },
                                    ),

                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          25, 15, 25, 10),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child: Text(
                                                  localizedText.enrolled_on,
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                    color: BloqoColors.seasalt,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ),
                                              Align(
                                                alignment: Alignment.topLeft,
                                                child:
                                                  Text(
                                                    DateFormat('dd/MM/yyyy').format(enrollmentDate.toDate()),
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .displaySmall
                                                        ?.copyWith(
                                                      color: BloqoColors.seasalt,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 20), // Add some space between the text and the button
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0), // Adjust padding if necessary
                                              child: BloqoFilledButton(
                                                color: BloqoColors.error,
                                                onPressed: () {
                                                  showBloqoConfirmationAlert(
                                                      context: context,
                                                      title: localizedText.warning,
                                                      description: localizedText.unsubscribe_confirmation,
                                                      confirmationFunction: () async {
                                                        await _tryDeleteUserCourseEnrolled(
                                                          context: context,
                                                          localizedText: localizedText,
                                                          courseId: course.id,
                                                          enrolledUserId: user.id
                                                        );
                                                      },
                                                      backgroundColor: BloqoColors.error
                                                  );
                                                },
                                                text: localizedText.unsubscribe,
                                                icon: Icons.close_sharp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),


                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    !widget.isCourseCompleted ?
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      direction: Axis.horizontal,
                      runAlignment: WrapAlignment.start,
                      verticalDirection: VerticalDirection.down,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(40, 10, 40, 0),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  double maxWidth = constraints.maxWidth-20;
                                  return BloqoProgressBar(
                                    percentage: sectionsCompleted.length / totNumSections,
                                    width: maxWidth,
                                    fontSize: 12,// Pass the maximum width to the progress bar
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 0, 20, 20),
                          child: BloqoFilledButton(
                            onPressed: () async {
                                  _goToSectionPage(
                                    context: context,
                                    localizedText: localizedText,
                                    section: widget.sectionToComplete!,
                                    courseName: course.name,
                                  );
                              },
                            height: 60,
                            color: BloqoColors.success,
                            text: sectionsCompleted.isEmpty ? localizedText.start_learning
                                : localizedText.continue_learning,
                            fontSize: 24,
                            icon: Icons.lightbulb,
                          ),
                        ),
                      ],
                    )
                    : Container(),
                  ],
                );
              }
            );
          }
        ),
    );

  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _tryDeleteUserCourseEnrolled({required BuildContext context, required var localizedText, required String
  courseId, required String enrolledUserId}) async {
    context.loaderOverlay.show();
    try{
      List<BloqoUserCourseEnrolledData>? courses = getUserCoursesEnrolledFromAppState(context: context);
      BloqoPublishedCourseData publishedCourseToUpdate = await getPublishedCourseFromCourseId(
          localizedText: localizedText, courseId: courseId);
      BloqoUserCourseEnrolledData courseToRemove = courses!.firstWhere((c) => c.courseId == courseId);
      await deleteUserCourseEnrolled(localizedText: localizedText, courseId: courseId, enrolledUserId: enrolledUserId);
      if (!context.mounted) return;
      deleteUserCourseEnrolledFromAppState(context: context, userCourseEnrolled: courseToRemove);
      publishedCourseToUpdate.numberOfEnrollments = publishedCourseToUpdate.numberOfEnrollments - 1;
      savePublishedCourseChanges(localizedText: localizedText, updatedPublishedCourse: publishedCourseToUpdate);
      context.loaderOverlay.hide();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
      );
    }
    on BloqoException catch (e) {
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
          context: context,
          title: localizedText.error_title,
          description: e.message
      );
    }
  }

  Future<void> _goToSectionPage({required BuildContext context, required var localizedText, required BloqoSectionData section,
    required String courseName}) async {
    context.loaderOverlay.show();
    try {

      List<BloqoBlockData> blocks = await getBlocksFromIds(localizedText: localizedText, blockIds: section.blocks);
      if(!context.mounted) return;

      context.loaderOverlay.hide();

      BloqoChapterData chapter = getLearnCourseChaptersFromAppState(context: context)!.where(
              (chapter) => chapter.sections.contains(section.id)).first;

      widget.onPush(
            SectionPage(
            onPush: widget.onPush,
            section: section,
            blocks: blocks,
            courseName: courseName,
            chapter: chapter,
        )
      );

    } on BloqoException catch (e) {
      if(!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    }
  }

}

