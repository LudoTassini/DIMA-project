import 'package:bloqo/model/bloqo_user_course_enrolled.dart';
import 'package:flutter/material.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/learn_course_app_state.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/buttons/bloqo_text_button.dart';
import '../../components/complex/bloqo_course_enrolled.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/bloqo_course.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';
import '../from_learn/learn_course_page.dart';

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

class _LearnPageState extends State<LearnPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<LearnPage>{

  late TabController tabController;
  late int inProgressCoursesDisplayed;
  late int completedCoursesDisplayed;

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

    WidgetsBinding.instance.addPersistentFrameCallback((_) {
      _checkHomePrivilege(context);
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void _checkHomePrivilege(BuildContext context) {
    if (getComingFromHomeLearnPrivilegeFromAppState(context: context)) {
      useComingFromHomeLearnPrivilegeFromAppState(context: context);
      BloqoUserCourseEnrolled? course = getLearnCourseFromAppState(context: context);
      if (course != null) {
        widget.onPush(LearnCoursePage(onPush: widget.onPush, course: course));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

    List<BloqoUserCourseEnrolled> userCoursesEnrolled = Provider.of<UserCoursesEnrolledAppState>(context, listen: false).get() ?? [];

    List<BloqoUserCourseEnrolled> inProgressCourses = userCoursesEnrolled.where((course) => !course.isCompleted).toList();
    List<BloqoUserCourseEnrolled> completedCourses = userCoursesEnrolled.where((course) => course.isCompleted).toList();

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
      child: Consumer<UserCoursesCreatedAppState>(
        builder: (context, userCoursesCreatedAppState, _) {
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
                              color: BloqoColors.seasalt,
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
                                            BloqoUserCourseEnrolled course = inProgressCourses[index];
                                            if(index != (inProgressCoursesDisplayed > inProgressCourses.length ? inProgressCourses.length : inProgressCoursesDisplayed) - 1) {
                                              return BloqoCourseEnrolled(
                                                  course: course,
                                                  showInProgress: true,
                                                  onPressed: () {}/* TODO */
                                              );
                                            }
                                            else{
                                              return BloqoCourseEnrolled(
                                                  course: course,
                                                  showInProgress: true,
                                                  onPressed: () {}/* TODO */
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    if (inProgressCoursesDisplayed < inProgressCourses.length)
                                      BloqoTextButton(
                                          onPressed: loadMoreInProgressCourses,
                                          text: localizedText.load_more_courses,
                                          color: BloqoColors.russianViolet
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
                                                color: BloqoColors.primaryText,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                                              child: BloqoFilledButton(
                                                onPressed: () => widget.onNavigateToPage(2),
                                                color: BloqoColors.russianViolet,
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
                              color: BloqoColors.seasalt,
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
                                          BloqoUserCourseEnrolled course = completedCourses[index];
                                          if(index != (completedCoursesDisplayed > completedCourses.length ? completedCourses.length : completedCoursesDisplayed) - 1) {
                                            return BloqoCourseEnrolled(
                                                course: course,
                                                showCompleted: true,
                                                onPressed: () async {
                                                  //TODO
                                                },
                                            );
                                          }
                                          else{
                                            return BloqoCourseEnrolled(
                                                course: course,
                                                showCompleted: true,
                                                padding: const EdgeInsetsDirectional.all(15),
                                                onPressed: () async {
                                                  //TODO
                                                },
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  if (completedCoursesDisplayed < completedCourses.length)
                                    BloqoTextButton(
                                        onPressed: loadMoreCompletedCourses,
                                        text: localizedText.load_more_courses,
                                        color: BloqoColors.russianViolet
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
                                              color: BloqoColors.primaryText,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                                            child: BloqoFilledButton(
                                              onPressed: () => widget.onNavigateToPage(2),
                                              color: BloqoColors.russianViolet,
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
                                              color: BloqoColors.primaryText,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                                            child: BloqoFilledButton(
                                              onPressed: () { tabController.animateTo(0); },
                                              color: BloqoColors.russianViolet,
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

  Future<void> _goToCoursePage({required BuildContext context, required var localizedText, required BloqoUserCourseEnrolled userCourseEnrolled}) async {
    context.loaderOverlay.show();
    try {
      BloqoUserCourseEnrolled? learnCourse = getLearnCourseFromAppState(context: context);
      if (learnCourse != null && learnCourse.courseId == userCourseEnrolled.courseId) {
        widget.onPush(LearnCoursePage(onPush: widget.onPush, course: learnCourse));
      } else {
        BloqoUserCourseEnrolled course = await getUserCourseEnrolledFromId(
            localizedText: localizedText, courseId: userCourseEnrolled.courseId);
        if(!context.mounted) return;
        saveLearnCourseToAppState(context: context, course: course);
        context.loaderOverlay.hide();
        widget.onPush(LearnCoursePage(onPush: widget.onPush, course: course));
      }
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