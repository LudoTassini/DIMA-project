import 'package:bloqo/app_state/editor_course_app_state.dart';
import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/courses/bloqo_course.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_app_state.dart';
import '../../components/buttons/bloqo_text_button.dart';
import '../../components/complex/bloqo_course_created.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_user_course_created.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/localization.dart';
import '../from_editor/edit_course_page.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({
    super.key,
    required this.onPush,
  });

  final void Function(Widget) onPush;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin<EditorPage> {

  late TabController tabController;
  late int inProgressCoursesDisplayed;
  late int publishedCoursesDisplayed;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    )..addListener(() => setState(() {}));
    inProgressCoursesDisplayed = Constants.coursesToShowAtFirst;
    publishedCoursesDisplayed = Constants.coursesToShowAtFirst;

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
    if (getComingFromHomeEditorPrivilegeFromAppState(context: context)) {
      useComingFromHomeEditorPrivilegeFromAppState(context: context);
      BloqoCourse? course = getEditorCourseFromAppState(context: context);
      if (course != null) {
        widget.onPush(EditCoursePage(onPush: widget.onPush));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

    void loadMoreInProgressCourses() {
      setState(() {
        inProgressCoursesDisplayed += Constants.coursesToFurtherLoadAtRequest;
      });
    }

    void loadMorePublishedCourses() {
      setState(() {
        publishedCoursesDisplayed += Constants.coursesToFurtherLoadAtRequest;
      });
    }

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Consumer<UserCoursesCreatedAppState>(
        builder: (context, userCoursesCreatedAppState, _) {
          List<BloqoUserCourseCreated> userCoursesCreated = getUserCoursesCreatedFromAppState(context: context) ?? [];
          List<BloqoUserCourseCreated> inProgressCourses = userCoursesCreated.where((course) => !course.published).toList();
          List<BloqoUserCourseCreated> publishedCourses = userCoursesCreated.where((course) => course.published).toList();
          return Column(
            children: [
              TabBar(
                tabs: [
                  Tab(text: localizedText.in_progress),
                  Tab(text: localizedText.published),
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
                            localizedText.editor_page_header_1,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: BloqoColors.seasalt,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        BloqoSeasaltContainer(
                            child: Column(
                                children: [
                                  if (inProgressCourses.isNotEmpty)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                        inProgressCoursesDisplayed > inProgressCourses.length ? inProgressCourses.length : inProgressCoursesDisplayed,
                                            (index) {
                                          BloqoUserCourseCreated course = inProgressCourses[index];
                                          if(index != (inProgressCoursesDisplayed > inProgressCourses.length ? inProgressCourses.length : inProgressCoursesDisplayed) - 1) {
                                            return BloqoCourseCreated(
                                                course: course,
                                                onPressed: () async {
                                                  await _goToCoursePage(
                                                      context: context,
                                                      localizedText: localizedText,
                                                      userCourseCreated: course);
                                                },
                                                showEditOptions: true
                                            );
                                          }
                                          else{
                                            return BloqoCourseCreated(
                                                course: course,
                                                padding: const EdgeInsetsDirectional.all(15),
                                                onPressed: () async {
                                                  await _goToCoursePage(
                                                      context: context,
                                                      localizedText: localizedText,
                                                      userCourseCreated: course);
                                                },
                                                showEditOptions: true
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
                                            localizedText.editor_page_no_in_progress_courses,
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: BloqoColors.primaryText,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                                            child: BloqoFilledButton(
                                              onPressed: () async {
                                                await _createNewCourse(context: context, localizedText: localizedText);
                                              },
                                              color: BloqoColors.russianViolet,
                                              text: localizedText.take_me_there_button,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ]
                            )
                        )
                      ],
                    ),
                    ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
                          child: Text(
                            localizedText.editor_page_header_2,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: BloqoColors.seasalt,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        BloqoSeasaltContainer(
                            child: Column(
                                children: [
                                  if (publishedCourses.isNotEmpty)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                        publishedCoursesDisplayed > publishedCourses.length ? publishedCourses.length : publishedCoursesDisplayed,
                                            (index) {
                                          BloqoUserCourseCreated course = publishedCourses[index];
                                          if(index != (publishedCoursesDisplayed > publishedCourses.length ? publishedCourses.length : publishedCoursesDisplayed) - 1) {
                                            return BloqoCourseCreated(
                                                course: course,
                                                onPressed: () async {
                                                  _goToCoursePage(
                                                      context: context,
                                                      localizedText: localizedText,
                                                      userCourseCreated: course);
                                                },
                                                showPublishedOptions: true
                                            );
                                          }
                                          else{
                                            return BloqoCourseCreated(
                                                course: course,
                                                padding: const EdgeInsetsDirectional.all(15),
                                                onPressed: () async {
                                                  _goToCoursePage(
                                                      context: context,
                                                      localizedText: localizedText,
                                                      userCourseCreated: course);
                                                },
                                                showPublishedOptions: true
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  if (publishedCoursesDisplayed < publishedCourses.length)
                                    BloqoTextButton(
                                        onPressed: loadMorePublishedCourses,
                                        text: localizedText.load_more_courses,
                                        color: BloqoColors.russianViolet
                                    ),
                                  if (publishedCourses.isEmpty)
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            localizedText.editor_page_no_published_courses,
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
                                    )
                                ]
                            )
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                child: BloqoFilledButton(
                  color: BloqoColors.russianViolet,
                  onPressed: () async {
                    await _createNewCourse(context: context, localizedText: localizedText);
                  },
                  text: localizedText.new_course,
                  icon: Icons.add,
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

  Future<void> _createNewCourse({required BuildContext context, required var localizedText}) async {
    context.loaderOverlay.show();
    try {

      BloqoCourse course = await saveNewCourse(
          localizedText: localizedText,
          authorId: getUserFromAppState(context: context)!.id
      );

      BloqoUserCourseCreated userCourseCreated = await saveNewUserCourseCreated(
          localizedText: localizedText,
          course: course
      );

      if(!context.mounted) return;

      addUserCourseCreatedToAppState(context: context, userCourseCreated: userCourseCreated);

      context.loaderOverlay.hide();

      saveEditorCourseToAppState(context: context, course: course);

      widget.onPush(EditCoursePage(onPush: widget.onPush));

    } on BloqoException catch (e){

      context.loaderOverlay.hide();

      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );

    }
  }

  Future<void> _goToCoursePage({required BuildContext context, required var localizedText, required BloqoUserCourseCreated userCourseCreated}) async {
    context.loaderOverlay.show();
    try {
      BloqoCourse? editorCourse = getEditorCourseFromAppState(context: context);
      if (editorCourse != null && editorCourse.id == userCourseCreated.courseId) {
        context.loaderOverlay.hide();
        widget.onPush(EditCoursePage(onPush: widget.onPush));
      } else {
        BloqoCourse course = await getCourseFromId(
            localizedText: localizedText, courseId: userCourseCreated.courseId);
        if(!context.mounted) return;
        saveEditorCourseToAppState(context: context, course: course);
        context.loaderOverlay.hide();
        widget.onPush(EditCoursePage(onPush: widget.onPush));
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