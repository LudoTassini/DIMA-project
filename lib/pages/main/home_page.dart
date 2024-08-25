import 'package:bloqo/components/complex/bloqo_course_created.dart';
import 'package:bloqo/components/complex/bloqo_course_enrolled.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../../app_state/application_settings_app_state.dart';
import '../../app_state/editor_course_app_state.dart';
import '../../app_state/learn_course_app_state.dart';
import '../../app_state/user_app_state.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/buttons/bloqo_text_button.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/user_courses/bloqo_user_course_created_data.dart';
import '../../model/user_courses/bloqo_user_course_enrolled_data.dart';
import '../../model/courses/bloqo_block_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../model/courses/bloqo_section_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/check_device.dart';
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
  int _coursesToFurtherLoadAtRequest = Constants.coursesToFurtherLoadAtRequest;
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

    if(isTablet && !_initialized){
      setState(() {
        _coursesEnrolledInDisplayed = Constants.coursesToShowAtFirstTabletHomepage;
        _coursesCreatedDisplayed = Constants.coursesToShowAtFirstTabletHomepage;
        _coursesToFurtherLoadAtRequest = Constants.coursesToFurtherLoadAtRequestTabletHomepage;
        _initialized = true;
        }
      );
    }

    void loadMoreEnrolledCourses() {
      setState(() {
        _coursesEnrolledInDisplayed += _coursesToFurtherLoadAtRequest;
      });
    }

    void loadMoreCreatedCourses() {
      setState(() {
        _coursesCreatedDisplayed += _coursesToFurtherLoadAtRequest;
      });
    }

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: SingleChildScrollView(
      child: Padding(
        padding: !isTablet ? const EdgeInsetsDirectional.all(0) : Constants.tabletPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    localizedText.homepage_learning,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: theme.colors.highContrastColor,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Consumer<UserCoursesEnrolledAppState>(
              builder: (context, userCoursesEnrolledAppState, _) {
                List<BloqoUserCourseEnrolledData> userCoursesEnrolled = getUserCoursesEnrolledFromAppState(context: context) ?? [];
                userCoursesEnrolled = userCoursesEnrolled.where((course) => !course.isCompleted).toList();
                return BloqoSeasaltContainer(
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
                                      color: theme.colors.primaryText,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (userCoursesEnrolled.isNotEmpty && !isTablet)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              _coursesEnrolledInDisplayed > userCoursesEnrolled.length ? userCoursesEnrolled.length : _coursesEnrolledInDisplayed,
                              (index) {
                                BloqoUserCourseEnrolledData course = userCoursesEnrolled[index];
                                return BloqoCourseEnrolled(
                                    course: course,
                                    showInProgress: true,
                                    onPressed: () async {
                                      await _goToLearnCoursePage(context: context, localizedText: localizedText, userCourseEnrolled: course);
                                    },
                                );
                              },
                            ),
                          ),

                        if (userCoursesEnrolled.isNotEmpty && isTablet)
                          GridView.builder(
                            key: ValueKey(_coursesEnrolledInDisplayed),
                            shrinkWrap: true, // This helps in unbounded height cases
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns in the grid
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 6/2,
                            ),
                            itemCount: _coursesEnrolledInDisplayed > userCoursesEnrolled.length
                                ? userCoursesEnrolled.length
                                : _coursesEnrolledInDisplayed,
                            itemBuilder: (context, index) {
                              BloqoUserCourseEnrolledData course = userCoursesEnrolled[index];
                              return BloqoCourseEnrolled(
                                course: course,
                                showInProgress: true,
                                onPressed: () async {
                                  await _goToLearnCoursePage(
                                    context: context,
                                    localizedText: localizedText,
                                    userCourseEnrolled: course,
                                  );
                                },
                              );
                            },
                          ),

                        if (_coursesEnrolledInDisplayed < userCoursesEnrolled.length)
                          Padding(
                            padding: !isTablet ? const EdgeInsetsDirectional.all(0)
                            : const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: BloqoTextButton(
                              onPressed: loadMoreEnrolledCourses,
                              text: localizedText.load_more,
                              color: theme.colors.leadingColor
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
                                    color: theme.colors.primaryText,
                                    fontSize: 14,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 5),
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
                );
              }
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                child: Align(
                  alignment: Alignment.topRight,
                  child:Text(
                    localizedText.homepage_editing,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: theme.colors.highContrastColor,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ),
            Consumer<UserCoursesCreatedAppState>(
              builder: (context, userCoursesCreatedAppState, _) {
                List<BloqoUserCourseCreatedData> userCoursesCreated = getUserCoursesCreatedFromAppState(context: context) ?? [];
                userCoursesCreated = userCoursesCreated.where((course) => !course.published).toList();
                return BloqoSeasaltContainer(
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
                                      color: theme.colors.primaryText,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        if (userCoursesCreated.isNotEmpty && !isTablet)
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              _coursesCreatedDisplayed > userCoursesCreated.length ? userCoursesCreated.length : _coursesCreatedDisplayed,
                                  (index) {
                                BloqoUserCourseCreatedData? course = userCoursesCreated[index];
                                return BloqoCourseCreated(
                                  course: course,
                                  onPressed: () async {
                                    await _goToEditorCoursePage(context: context, localizedText: localizedText,
                                        userCourseCreated: course); },
                                );
                              },
                            ),
                          ),

                        if (userCoursesCreated.isNotEmpty && isTablet)
                          GridView.builder(
                            key: ValueKey(_coursesCreatedDisplayed),
                            shrinkWrap: true, // This helps in unbounded height cases
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, // Number of columns in the grid
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                              childAspectRatio: 8/2,
                            ),
                            itemCount: _coursesCreatedDisplayed > userCoursesCreated.length
                                ? userCoursesCreated.length
                                : _coursesCreatedDisplayed,
                            itemBuilder: (context, index) {
                              BloqoUserCourseCreatedData course = userCoursesCreated[index];
                              return BloqoCourseCreated(
                                course: course,
                                onPressed: () async {
                                  await _goToEditorCoursePage(context: context, localizedText: localizedText,
                                      userCourseCreated: course); },
                              );
                            },
                          ),

                          if (_coursesCreatedDisplayed < userCoursesCreated.length)
                            Padding(
                              padding: !isTablet ? const EdgeInsetsDirectional.all(0)
                              : const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: BloqoTextButton(
                                  onPressed: loadMoreCreatedCourses,
                                  text: localizedText.load_more,
                                  color: theme.colors.primaryText
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
                                    color: theme.colors.primaryText,
                                    fontSize: 14,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 5),
                                  child: BloqoFilledButton(
                                    onPressed: () async { await _createNewCourse(context: context, localizedText: localizedText); },
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
                  );
                }
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _createNewCourse({required BuildContext context, required var localizedText}) async {
    context.loaderOverlay.show();
    try {
      var firestore = getFirestoreFromAppState(context: context);

      BloqoCourseData course = await saveNewCourse(
          firestore: firestore,
          localizedText: localizedText,
          authorId: getUserFromAppState(context: context)!.id
      );

      BloqoUserCourseCreatedData userCourseCreated = await saveNewUserCourseCreated(
          firestore: firestore,
          localizedText: localizedText,
          course: course
      );

      if (!context.mounted) return;

      addUserCourseCreatedToAppState(
          context: context, userCourseCreated: userCourseCreated);

      saveEditorCourseToAppState(context: context, course: course, chapters: [], sections: {}, blocks: {}, comingFromHome: true);

      context.loaderOverlay.hide();

      widget.onNavigateToPage(3);
    } on BloqoException catch (e) {
      context.loaderOverlay.hide();

      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    }
  }

  Future<void> _goToEditorCoursePage({required BuildContext context, required var localizedText, required BloqoUserCourseCreatedData userCourseCreated}) async {
    context.loaderOverlay.show();
    try {
      BloqoCourseData? editorCourse = getEditorCourseFromAppState(context: context);
      if (editorCourse != null &&
          editorCourse.id == userCourseCreated.courseId) {
        setComingFromHomeEditorPrivilegeToAppState(context: context);
        context.loaderOverlay.hide();
        widget.onNavigateToPage(3);
      } else {
        var firestore = getFirestoreFromAppState(context: context);
        BloqoCourseData course = await getCourseFromId(
            firestore: firestore,
            localizedText: localizedText,
            courseId: userCourseCreated.courseId
        );
        List<BloqoChapterData> chapters = await getChaptersFromIds(
            firestore: firestore,
            localizedText: localizedText,
            chapterIds: course.chapters
        );
        Map<String, List<BloqoSectionData>> sections = {};
        Map<String, List<BloqoBlockData>> blocks = {};
        for(String chapterId in course.chapters) {
          List<BloqoSectionData> chapterSections = await getSectionsFromIds(
              firestore: firestore,
              localizedText: localizedText,
              sectionIds: chapters.where((chapter) => chapter.id == chapterId).first.sections
          );
          sections[chapterId] = chapterSections;
          for(BloqoSectionData section in chapterSections){
            List<BloqoBlockData> sectionBlocks = await getBlocksFromIds(
                firestore: firestore,
                localizedText: localizedText,
                blockIds: section.blocks
            );
            blocks[section.id] = sectionBlocks;
          }
        }
        if (!context.mounted) return;
        saveEditorCourseToAppState(context: context, course: course, chapters: chapters, sections: sections, blocks: blocks, comingFromHome: true);
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

  Future<void> _goToLearnCoursePage({required BuildContext context, required var localizedText, required BloqoUserCourseEnrolledData userCourseEnrolled}) async {
    context.loaderOverlay.show();
    try {
      BloqoCourseData? learnCourse = getLearnCourseFromAppState(context: context);
      if (learnCourse != null &&
          learnCourse.id == userCourseEnrolled.courseId) {
        setComingFromHomeLearnPrivilegeToAppState(context: context);
        context.loaderOverlay.hide();
        widget.onNavigateToPage(1);
      } else {
        var firestore = getFirestoreFromAppState(context: context);
        BloqoCourseData course = await getCourseFromId(
          firestore: firestore,
          localizedText: localizedText,
          courseId: userCourseEnrolled.courseId
        );
        List<BloqoChapterData> chapters = await getChaptersFromIds(
          firestore: firestore,
          localizedText: localizedText,
          chapterIds: course.chapters
        );
        Map<String, List<BloqoSectionData>> sections = {};
        for(String chapterId in course.chapters) {
          List<BloqoSectionData> chapterSections = await getSectionsFromIds(
              firestore: firestore,
              localizedText: localizedText,
              sectionIds: chapters.where((chapter) => chapter.id == chapterId).first.sections
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
            totNumSections: userCourseEnrolled.totNumSections,
            chaptersCompleted: userCourseEnrolled.chaptersCompleted ?? [],
            comingFromHome: true);
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