import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/custom/bloqo_progress_bar.dart';
import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:bloqo/model/courses/bloqo_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../app_state/learn_course_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/complex/bloqo_course_section.dart';
import '../../components/navigation/bloqo_breadcrumbs.dart';
import '../../model/courses/bloqo_course.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';
import 'package:intl/intl.dart';

class CourseContentPage extends StatefulWidget {

  const CourseContentPage({
    super.key,
    required this.onPush,
  });

  final void Function(Widget) onPush;

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
    void initializeSectionsToShowMap(List<BloqoChapter> chapters, List<dynamic> chaptersCompleted) {
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

    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1.0, -1.0),
        child: Consumer<UserCoursesEnrolledAppState>(
            builder: (context, userCoursesEnrolledAppState, _) {

              BloqoCourse course = getLearnCourseFromAppState(context: context)!;
              List<BloqoChapter> chapters = getLearnCourseChaptersFromAppState(context: context)?? [];
              Map<String, List<BloqoSection>> sections = getLearnCourseSectionsFromAppState(context: context)?? {};
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
                        Flexible(
                          child: Padding(
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

                                    return BloqoSeasaltContainer(
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
                                                    color: BloqoColors.russianViolet,
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
                                              padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 20),
                                              child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Flexible(
                                                  child: Align(
                                                    alignment: Alignment.topLeft,
                                                    child: Text(
                                                      chapter.description!,
                                                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                        color: BloqoColors.russianViolet,
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
                                                    return BloqoCourseSection(
                                                      section: section,
                                                      index: sectionIndex,
                                                      isInLearnPage: true,
                                                      onPressed: () async {
                                                        // TODO
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
                                      20, 0, 20, 10),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          localizedText.enrolled_on +
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

                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(30, 0, 0, 0), //24, 0, 24, 0
                                          child: BloqoFilledButton(
                                            color: BloqoColors.error,
                                            onPressed: () async {
                                            //TODO
                                            },
                                          text: localizedText.delete,
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
                        onPressed: () =>
                            () async {
                          // TODO
                          //widget.onNavigateToPage(3),
                        },
                        height: 60,
                        color: BloqoColors.success,
                        text: localizedText.continue_learning,
                        fontSize: 24,
                        icon: Icons.lightbulb,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

