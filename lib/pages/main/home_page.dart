import 'package:bloqo/components/complex/bloqo_course_created.dart';
import 'package:bloqo/components/complex/bloqo_course_enrolled.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/style/bloqo_colors.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../../app_state/editor_course_app_state.dart';
import '../../app_state/learn_course_app_state.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/buttons/bloqo_text_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_user_course_created.dart';
import '../../model/bloqo_user_course_enrolled.dart';
import '../../model/courses/bloqo_course.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';

class HomePage extends StatefulWidget {

  const HomePage({
    super.key,
    required this.onPush,
    required this.onNavigateToPage
  });

  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin<HomePage> {

  int _coursesEnrolledInDisplayed = Constants.coursesToShowAtFirst;
  int _coursesCreatedDisplayed = Constants.coursesToShowAtFirst;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    List<BloqoUserCourseCreated> userCoursesCreated = Provider.of<UserCoursesCreatedAppState>(context, listen: false).get() ?? [];
    List<BloqoUserCourseEnrolled> userCoursesEnrolled = Provider.of<UserCoursesEnrolledAppState>(context, listen: false).get() ?? [];

    userCoursesEnrolled = userCoursesEnrolled.where((course) => !course.isCompleted).toList();
    userCoursesCreated = userCoursesCreated.where((course) => !course.published).toList();

    void loadMoreEnrolledCourses() {
      setState(() {
        _coursesEnrolledInDisplayed += Constants.coursesToFurtherLoadAtRequest;
      });
    }

    void loadMoreCreatedCourses() {
      setState(() {
        _coursesCreatedDisplayed += Constants.coursesToFurtherLoadAtRequest;
      });
    }

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: Text(
                localizedText.homepage_learning,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: BloqoColors.seasalt,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          BloqoSeasaltContainer(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (userCoursesEnrolled.isNotEmpty)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              localizedText.homepage_learning_quote,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: BloqoColors.primaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (userCoursesEnrolled.isNotEmpty)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        _coursesEnrolledInDisplayed > userCoursesEnrolled.length ? userCoursesEnrolled.length : _coursesEnrolledInDisplayed,
                        (index) {
                          BloqoUserCourseEnrolled course = userCoursesEnrolled[index];
                          return BloqoCourseEnrolled(
                              course: course,
                              showInProgress: true,
                              onPressed: () {}/* TODO */
                          );
                        },
                      ),
                    ),
                  if (_coursesEnrolledInDisplayed < userCoursesEnrolled.length)
                    Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                        child: BloqoTextButton(
                          onPressed: loadMoreEnrolledCourses,
                          text: localizedText.load_more_courses,
                          color: BloqoColors.russianViolet,
                        ),
                    ),
                  if (userCoursesEnrolled.isEmpty)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            localizedText.homepage_no_enrolled_courses,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: BloqoColors.primaryText,
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 5),
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
          Flexible(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: Text(
                localizedText.homepage_editing,
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: BloqoColors.seasalt,
                  fontSize: 30,
                ),
              ),
            ),
          ),
          BloqoSeasaltContainer(
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (userCoursesCreated.isNotEmpty)
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              localizedText.homepage_editing_quote,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: BloqoColors.primaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (userCoursesCreated.isNotEmpty)
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        userCoursesCreated.length,
                            (index) {
                          BloqoUserCourseCreated? course = userCoursesCreated[index];
                          return BloqoCourseCreated(
                            course: course,
                            onPressed: () async { await _goToEditorCoursePage(context: context, localizedText: localizedText, userCourseCreated: course); },
                          );
                        },
                      ),
                    ),

                    if (_coursesCreatedDisplayed < userCoursesCreated.length)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                        child: BloqoTextButton(
                            onPressed: loadMoreCreatedCourses,
                            text: localizedText.load_more_courses,
                            color: BloqoColors.russianViolet
                        ),
                      ),
                    if (userCoursesCreated.isEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              localizedText.homepage_no_created_courses,
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: BloqoColors.primaryText,
                              fontSize: 14,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 5),
                            child: BloqoFilledButton(
                              onPressed: () => widget.onNavigateToPage(3),
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
    ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _goToEditorCoursePage({required BuildContext context, required var localizedText, required BloqoUserCourseCreated userCourseCreated}) async {
    context.loaderOverlay.show();
    try {
      BloqoCourse? editorCourse = getEditorCourseFromAppState(context: context);
      if (editorCourse != null &&
          editorCourse.id == userCourseCreated.courseId) {
        setComingFromHomeEditorPrivilegeToAppState(context: context);
        context.loaderOverlay.hide();
        widget.onNavigateToPage(3);
      } else {
        BloqoCourse course = await getCourseFromId(
            localizedText: localizedText, courseId: userCourseCreated.courseId);
        if (!context.mounted) return;
        saveEditorCourseToAppState(context: context, course: course, comingFromHome: true);
        context.loaderOverlay.hide();
        widget.onNavigateToPage(3);
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

  Future<void> _goToLearnCoursePage({required BuildContext context, required var localizedText, required BloqoUserCourseEnrolled userCourseEnrolled}) async {
    context.loaderOverlay.show();
    try {
      BloqoCourse? learnCourse = getLearnCourseFromAppState(context: context);
      if (learnCourse != null &&
          learnCourse.id == userCourseEnrolled.courseId) {
        setComingFromHomeLearnPrivilegeToAppState(context: context);
        context.loaderOverlay.hide();
        widget.onNavigateToPage(1);
      } else {
        BloqoCourse course = await getCourseFromId(
            localizedText: localizedText, courseId: userCourseEnrolled.courseId);
        if (!context.mounted) return;
        saveLearnCourseToAppState(context: context, course: course, comingFromHome: true);
        context.loaderOverlay.hide();
        widget.onNavigateToPage(1);
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