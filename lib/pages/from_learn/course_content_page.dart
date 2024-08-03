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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1.0, -1.0),
        child: Consumer<UserCoursesEnrolledAppState>(
            builder: (context, userCoursesEnrolledAppState, _) {
              BloqoCourse course = getLearnCourseFromAppState(context: context)!;
              List<BloqoChapter> chapters = getLearnCourseChaptersFromAppState(context: context)?? [];
              Map<String, List<BloqoSection>> sections = getLearnCourseSectionsFromAppState(context: context)?? {};
              Timestamp enrollmentDate = getLearnCourseEnrollmentDateFromAppState(context: context)!;
              int numSectionsCompleted = getLearnCourseNumSectionsCompletedFromAppState(context: context)?? 0;
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
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 4, 20, 12),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                course.description ?? '',
                                //FIXME: forse sarebbe meglio rendere description required
                                style: Theme
                                    .of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: BloqoColors.seasalt,
                                  fontSize: 14,
                                ),
                              ),
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
                                              children: [
                                                Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    '${localizedText.chapter} ${chapterIndex+1}',
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
                                                //FIXME: aggiungere segnale se il capitolo è completato
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 20),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Flexible(
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Text(
                                                    chapter.description ?? '',
                                                    //FIXME: forse sarebbe meglio rendere description required
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .displaySmall
                                                        ?.copyWith(
                                                      color: BloqoColors.russianViolet,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                          ...List.generate(
                                            sections[chapter.id]!.length,
                                                (sectionIndex) {
                                              var section = sections[chapter.id]![sectionIndex];
                                              return BloqoCourseSection(
                                                section: section,
                                                index: sectionIndex,
                                                onPressed: () async {
                                                  // TODO
                                                },
                                              );
                                            },
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
                                    mainAxisSize: MainAxisSize.max,
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
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty
                                                .resolveWith((states) =>
                                            const EdgeInsetsDirectional.fromSTEB(
                                                24, 0, 24, 0)),
                                            backgroundColor: WidgetStateProperty
                                                .resolveWith((
                                                states) => BloqoColors.error),
                                            shape: WidgetStateProperty
                                                .resolveWith((states) =>
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius
                                                      .circular(15))),
                                          ),
                                          onPressed: () async {
                                            // TODO
                                          },
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              const Icon(
                                                Icons.close_sharp,
                                                size: 16,
                                                color: BloqoColors.seasalt,
                                              ),
                                              Flexible(
                                                child: Text(
                                                  localizedText.delete,
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .displayLarge
                                                      ?.copyWith(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    color: BloqoColors.seasalt,
                                                  ),
                                                ),
                                              ),
                                            ],
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
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          40, 0, 40, 0),
                      child: BloqoProgressBar(
                        percentage: numSectionsCompleted/totNumSections,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20, 0, 20, 0),
                      child: BloqoFilledButton(
                        onPressed: () =>
                            () async {
                          // TODO
                          //widget.onNavigateToPage(3),
                        },
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

