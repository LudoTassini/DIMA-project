import 'package:bloqo/model/user_courses/bloqo_user_course_enrolled_data.dart';
import 'package:bloqo/pages/from_learn/course_content_page.dart';
import 'package:flutter/material.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:flutter/scheduler.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/application_settings_app_state.dart';
import '../../app_state/learn_course_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/buttons/bloqo_text_button.dart';
import '../../components/complex/bloqo_course_enrolled.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/bloqo_chapter_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../model/courses/bloqo_section_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';

class LearnPage extends StatefulWidget {

  const LearnPage({
    super.key,
    required this.onPush,
    required this.onNavigateToPage
  });

  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;

  @override
  State<LearnPage> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<LearnPage>{

  late TabController tabController;
  late int inProgressCoursesDisplayed;
  late int completedCoursesDisplayed;
  late Ticker _ticker;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    inProgressCoursesDisplayed = Constants.coursesToShowAtFirst;
    completedCoursesDisplayed = Constants.coursesToShowAtFirst;

    _ticker = createTicker((Duration elapsed) {
      _checkHomePrivilege(context);
    });

    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    tabController.dispose();
    super.dispose();
  }

  Future<void> _checkHomePrivilege(BuildContext context) async {
    if (getComingFromHomeLearnPrivilegeFromAppState(context: context)) {
      useComingFromHomeLearnPrivilegeFromAppState(context: context);
      BloqoCourseData? course = getLearnCourseFromAppState(context: context);
      List<BloqoUserCourseEnrolledData>? userCoursesEnrolled = getUserCoursesEnrolledFromAppState(context: context);
      BloqoUserCourseEnrolledData? userCourseEnrolled = userCoursesEnrolled?.firstWhere((x) => x.courseId == course?.id);
      String? sectionToCompleteId = userCourseEnrolled?.sectionToComplete;
      bool isCourseCompleted = userCourseEnrolled!.isCompleted;
      BloqoSectionData? sectionToComplete;
      var firestore = getFirestoreFromAppState(context: context);
      if(!isCourseCompleted) {
        sectionToComplete = await getSectionFromId(firestore: firestore, localizedText: getAppLocalizations(context)!, sectionId: sectionToCompleteId!);
      }
      if (course != null && !isCourseCompleted) {
        widget.onPush(
            CourseContentPage(
              onPush: widget.onPush,
              sectionToComplete: sectionToComplete!,
              isCourseCompleted: isCourseCompleted,
            ));
      }
      else {
        widget.onPush(
            CourseContentPage(
              onPush: widget.onPush,
              isCourseCompleted: isCourseCompleted,
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);

    void loadMoreInProgressCourses() {
      setState(() {
        inProgressCoursesDisplayed += Constants.coursesToFurtherLoadAtRequest;
      });
    }

    void loadMoreCompletedCourses() {
      setState(() {
        completedCoursesDisplayed += Constants.coursesToFurtherLoadAtRequest;
      });
    }

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Consumer<UserCoursesEnrolledAppState>(
        builder: (context, userCoursesEnrolledAppState, _) {
          List<BloqoUserCourseEnrolledData> userCoursesEnrolled = getUserCoursesEnrolledFromAppState(context: context) ?? [];
          List<BloqoUserCourseEnrolledData> inProgressCourses = userCoursesEnrolled.where((course) => !course.isCompleted).toList();
          List<BloqoUserCourseEnrolledData> completedCourses = userCoursesEnrolled.where((course) => course.isCompleted).toList();
          inProgressCourses.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
          completedCourses.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
          return Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: localizedText.enrollings),
                  Tab(text: localizedText.completed),
                ],
                controller: tabController,
                indicatorSize: TabBarIndicatorSize.tab,
              ),
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                          child: Text(
                            localizedText.learn_page_header_1,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: theme.colors.highContrastColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        BloqoSeasaltContainer(
                          child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                              child: Column(
                                  children: [
                                    if (inProgressCourses.isNotEmpty)
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          inProgressCoursesDisplayed > inProgressCourses.length ? inProgressCourses.length : inProgressCoursesDisplayed,
                                              (index) {
                                            BloqoUserCourseEnrolledData course = inProgressCourses[index];
                                            if(index != (inProgressCoursesDisplayed > inProgressCourses.length ? inProgressCourses.length : inProgressCoursesDisplayed) - 1) {
                                              return BloqoCourseEnrolled(
                                                  course: course,
                                                  showInProgress: true,
                                                  onPressed: () async {
                                                    await _goToCoursePage(context: context, localizedText: localizedText, userCourseEnrolled: course);
                                                  }
                                              );
                                            }
                                            else{
                                              return BloqoCourseEnrolled(
                                                  course: course,
                                                  showInProgress: true,
                                                  onPressed: () async {
                                                    await _goToCoursePage(context: context, localizedText: localizedText, userCourseEnrolled: course);
                                                  }
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    if (inProgressCoursesDisplayed < inProgressCourses.length)
                                      BloqoTextButton(
                                          onPressed: loadMoreInProgressCourses,
                                          text: localizedText.load_more,
                                          color: theme.colors.leadingColor
                                      ),
                                    if (inProgressCourses.isEmpty)
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              localizedText.learn_page_no_in_progress_courses,
                                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                color: theme.colors.primaryText,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 5),
                                              child: BloqoFilledButton(
                                                onPressed: () => widget.onNavigateToPage(2),
                                                color: theme.colors.leadingColor,
                                                text: localizedText.take_me_there_button,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                              ),
                          ),
                        ),
                      ],
                    ),
                    ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                          child: Text(
                            localizedText.learn_page_header_2,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: theme.colors.highContrastColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        BloqoSeasaltContainer(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                            child: Column(
                                children: [
                                  if (completedCourses.isNotEmpty)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                        completedCoursesDisplayed > completedCourses.length ? completedCourses.length : completedCoursesDisplayed,
                                            (index) {
                                          BloqoUserCourseEnrolledData course = completedCourses[index];
                                          if(index != (completedCoursesDisplayed > completedCourses.length ? completedCourses.length : completedCoursesDisplayed) - 1) {
                                            return BloqoCourseEnrolled(
                                                course: course,
                                                showCompleted: true,
                                                onPush: widget.onPush,
                                                onPressed: () async {
                                                  await _goToCoursePage(context: context, localizedText: localizedText, userCourseEnrolled: course);
                                                },
                                            );
                                          }
                                          else{
                                            return BloqoCourseEnrolled(
                                                course: course,
                                                showCompleted: true,
                                                onPush: widget.onPush,
                                                padding: const EdgeInsetsDirectional.all(15),
                                                onPressed: () async {
                                                  await _goToCoursePage(
                                                      context: context,
                                                      localizedText: localizedText,
                                                      userCourseEnrolled: course);
                                                },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  if (completedCoursesDisplayed < completedCourses.length)
                                    BloqoTextButton(
                                        onPressed: loadMoreCompletedCourses,
                                        text: localizedText.load_more,
                                        color: theme.colors.leadingColor
                                    ),
                                  if (completedCourses.isEmpty && inProgressCourses.isEmpty)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            localizedText.learn_page_no_in_progress_courses,
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: theme.colors.primaryText,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 5),
                                            child: BloqoFilledButton(
                                              onPressed: () => widget.onNavigateToPage(2),
                                              color: theme.colors.leadingColor,
                                              text: localizedText.take_me_there_button,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (completedCourses.isEmpty && inProgressCourses.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            localizedText.learn_page_no_completed_courses,
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: theme.colors.primaryText,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                                            child: BloqoFilledButton(
                                              onPressed: () { tabController.animateTo(0); },
                                              color: theme.colors.leadingColor,
                                              text: localizedText.take_me_there_button,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _goToCoursePage({ required BuildContext context, required var localizedText,
    required BloqoUserCourseEnrolledData userCourseEnrolled }) async {
    context.loaderOverlay.show();
    try {
      BloqoCourseData? learnCourse = getLearnCourseFromAppState(context: context);
      String? sectionToCompleteId = userCourseEnrolled.sectionToComplete;
      bool isCourseCompleted = userCourseEnrolled.isCompleted;
      BloqoSectionData? sectionToComplete;

      var firestore = getFirestoreFromAppState(context: context);

      // Fetch the sectionToComplete if the course is not completed
      if (!isCourseCompleted && sectionToCompleteId != null) {
        sectionToComplete = await getSectionFromId(
          firestore: firestore,
          localizedText: localizedText,
          sectionId: sectionToCompleteId,
        );
      }

      if (learnCourse != null && learnCourse.id == userCourseEnrolled.courseId) {
        widget.onPush(
          CourseContentPage(
            onPush: widget.onPush,
            isCourseCompleted: isCourseCompleted,
            sectionToComplete: sectionToComplete,
          ),
        );
      } else {
        BloqoCourseData course = await getCourseFromId(
          firestore: firestore,
          localizedText: localizedText,
          courseId: userCourseEnrolled.courseId,
        );
        List<BloqoChapterData> chapters = await getChaptersFromIds(
          firestore: firestore,
          localizedText: localizedText,
          chapterIds: course.chapters,
        );
        Map<String, List<BloqoSectionData>> sections = {};
        for (String chapterId in course.chapters) {
          List<BloqoSectionData> chapterSections = await getSectionsFromIds(
            firestore: firestore,
            localizedText: localizedText,
            sectionIds: chapters.firstWhere((chapter) => chapter.id == chapterId).sections,
          );
          sections[chapterId] = chapterSections;
        }

        if (!context.mounted) return;
        saveLearnCourseToAppState(
          context: context,
          course: course,
          chapters: chapters,
          sections: sections,
          enrollmentDate: userCourseEnrolled.enrollmentDate,
          sectionsCompleted: userCourseEnrolled.sectionsCompleted ?? [],
          chaptersCompleted: userCourseEnrolled.chaptersCompleted ?? [],
          totNumSections: userCourseEnrolled.totNumSections,
          comingFromHome: true,
        );
        context.loaderOverlay.hide();
        widget.onPush(
          CourseContentPage(
            onPush: widget.onPush,
            isCourseCompleted: isCourseCompleted,
            sectionToComplete: sectionToComplete,
          ),
        );
      }
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