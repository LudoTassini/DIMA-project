import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/editor_course_app_state.dart';
import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_review_data.dart';
import 'package:bloqo/model/courses/bloqo_course_data.dart';
import 'package:bloqo/pages/from_any/qr_code_page.dart';
import 'package:bloqo/pages/from_editor/publish_course_page.dart';
import 'package:bloqo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_app_state.dart';
import '../../components/buttons/bloqo_text_button.dart';
import '../../components/complex/bloqo_course_created.dart';
import '../../components/containers/bloqo_main_container.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/published_courses/bloqo_published_course_data.dart';
import '../../model/user_courses/bloqo_user_course_created_data.dart';
import '../../model/user_courses/bloqo_user_course_enrolled_data.dart';
import '../../model/courses/bloqo_block_data.dart';
import '../../model/courses/bloqo_chapter_data.dart';
import '../../model/courses/bloqo_section_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/bloqo_qr_code_type.dart';
import '../../utils/localization.dart';
import '../from_editor/edit_course_page.dart';
import '../from_editor/view_statistics_page.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({
    super.key,
    required this.onPush,
    required this.onNavigateToPage
  });

  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<EditorPage> {

  late TabController tabController;
  late int inProgressCoursesDisplayed;
  late int publishedCoursesDisplayed;
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
    publishedCoursesDisplayed = Constants.coursesToShowAtFirst;

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

  void _checkHomePrivilege(BuildContext context) {
    if (getComingFromHomeEditorPrivilegeFromAppState(context: context)) {
      useComingFromHomeEditorPrivilegeFromAppState(context: context);
      BloqoCourseData? course = getEditorCourseFromAppState(context: context);
      if (course != null) {
        widget.onPush(EditCoursePage(onPush: widget.onPush));
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

    void loadMorePublishedCourses() {
      setState(() {
        publishedCoursesDisplayed += Constants.coursesToFurtherLoadAtRequest;
      });
    }

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Consumer<UserCoursesCreatedAppState>(
        builder: (context, userCoursesCreatedAppState, _) {
          List<BloqoUserCourseCreatedData> userCoursesCreated = getUserCoursesCreatedFromAppState(context: context) ?? [];
          List<BloqoUserCourseCreatedData> inProgressCourses = userCoursesCreated.where((course) => !course.published).toList();
          List<BloqoUserCourseCreatedData> publishedCourses = userCoursesCreated.where((course) => course.published).toList();
          inProgressCourses.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
          publishedCourses.sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));
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
                              color: theme.colors.highContrastColor,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        BloqoSeasaltContainer(
                          child: Consumer<EditorCourseAppState>(
                            builder: (context, editorCourseAppState, _){
                              return Column(
                                children: [
                                  if (inProgressCourses.isNotEmpty)
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: List.generate(
                                        inProgressCoursesDisplayed > inProgressCourses.length ? inProgressCourses.length : inProgressCoursesDisplayed,
                                            (index) {
                                          BloqoUserCourseCreatedData course = inProgressCourses[index];
                                          if(index != (inProgressCoursesDisplayed > inProgressCourses.length ? inProgressCourses.length : inProgressCoursesDisplayed) - 1) {
                                            return BloqoCourseCreated(
                                                course: course,
                                                onPressed: () async {
                                                  await _goToCoursePage(
                                                      context: context,
                                                      localizedText: localizedText,
                                                      userCourseCreated: course);
                                                },
                                                showEditOptions: true,
                                                onPublish: () => widget.onPush(PublishCoursePage(onPush: widget.onPush, courseId: course.courseId)),
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
                                                      userCourseCreated: course
                                                  );
                                                },
                                                showEditOptions: true,
                                                onPublish: () => widget.onPush(PublishCoursePage(onPush: widget.onPush, courseId: course.courseId,)),
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
                                            localizedText.editor_page_no_in_progress_courses,
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: theme.colors.primaryText,
                                              fontSize: 14,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                                            child: BloqoFilledButton(
                                              onPressed: () async {
                                                await _createNewCourse(context: context, localizedText: localizedText);
                                              },
                                              color: theme.colors.leadingColor,
                                              text: localizedText.take_me_there_button,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                ]
                              );
                            }
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
                              color: theme.colors.highContrastColor,
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
                                          BloqoUserCourseCreatedData course = publishedCourses[index];
                                          if(index != (publishedCoursesDisplayed > publishedCourses.length ? publishedCourses.length : publishedCoursesDisplayed) - 1) {
                                            return BloqoCourseCreated(
                                                course: course,
                                                onPressed: () async {
                                                  _goToCoursePage(
                                                      context: context,
                                                      localizedText: localizedText,
                                                      userCourseCreated: course);
                                                },
                                                showPublishedOptions: true,
                                                onViewStatistics: () async {
                                                  context.loaderOverlay.show();
                                                  try {
                                                    BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromCourseId(localizedText: localizedText, courseId: course.courseId);
                                                    List<BloqoReviewData> reviews = await getReviewsFromIds(localizedText: localizedText, reviewsIds: publishedCourse.reviews);
                                                    if (!context.mounted) return;
                                                    context.loaderOverlay.hide();
                                                    widget.onPush(ViewStatisticsPage(
                                                      publishedCourse: publishedCourse,
                                                      reviews: reviews,
                                                      onPush: widget.onPush,
                                                      onNavigateToPage: widget.onNavigateToPage,
                                                    ));
                                                  }
                                                  on BloqoException catch (e) {
                                                    if (!context.mounted) return;
                                                    context.loaderOverlay.hide();
                                                    showBloqoErrorAlert(
                                                      context: context,
                                                      title: localizedText.error_title,
                                                      description: e.message,
                                                    );
                                                  }
                                                },
                                                onDismiss: () async {
                                                  await showBloqoConfirmationAlert(
                                                      context: context,
                                                      title: localizedText.warning,
                                                      description: localizedText.course_dismiss_confirmation,
                                                      backgroundColor: theme.colors.error,
                                                      confirmationFunction: () async {
                                                        context.loaderOverlay.show();
                                                        try {
                                                          BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromCourseId(localizedText: localizedText, courseId: course.courseId);
                                                          if(!context.mounted) return;
                                                          await _tryDismissCourse(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            publishedCourseId: publishedCourse.publishedCourseId,
                                                            courseId: course.courseId
                                                          );
                                                          if (!context.mounted) return;
                                                          context.loaderOverlay.hide();
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
                                                            description: e.message,
                                                          );
                                                        }
                                                      }
                                                  );
                                                },
                                                onGetQrCode: () => widget.onPush(QrCodePage(
                                                    qrCodeTitle: course.courseName,
                                                    qrCodeContent: "${BloqoQrCodeType.course.name}_${course.courseId}")
                                                ),
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
                                                showPublishedOptions: true,
                                                onViewStatistics: () async {
                                                  context.loaderOverlay.show();
                                                  try {
                                                    BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromCourseId(localizedText: localizedText, courseId: course.courseId);
                                                    List<BloqoReviewData> reviews = await getReviewsFromIds(localizedText: localizedText, reviewsIds: publishedCourse.reviews);
                                                    if (!context.mounted) return;
                                                    context.loaderOverlay.hide();
                                                    widget.onPush(ViewStatisticsPage(
                                                      publishedCourse: publishedCourse,
                                                      reviews: reviews,
                                                      onPush: widget.onPush,
                                                      onNavigateToPage: widget.onNavigateToPage,
                                                    ));
                                                  }
                                                  on BloqoException catch (e) {
                                                    if (!context.mounted) return;
                                                    context.loaderOverlay.hide();
                                                    showBloqoErrorAlert(
                                                      context: context,
                                                      title: localizedText.error_title,
                                                      description: e.message,
                                                    );
                                                  }
                                                },
                                                onDismiss: () async {
                                                  await showBloqoConfirmationAlert(
                                                      context: context,
                                                      title: localizedText.warning,
                                                      description: localizedText.course_dismiss_confirmation,
                                                      backgroundColor: theme.colors.error,
                                                      confirmationFunction: () async {
                                                        context.loaderOverlay.show();
                                                        try {
                                                          BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromCourseId(localizedText: localizedText, courseId: course.courseId);
                                                          if(!context.mounted) return;
                                                          await _tryDismissCourse(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            publishedCourseId: publishedCourse.publishedCourseId,
                                                            courseId: course.courseId
                                                          );
                                                          if (!context.mounted) return;
                                                          context.loaderOverlay.hide();
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
                                                            description: e.message,
                                                          );
                                                        }
                                                      }
                                                  );
                                                },
                                                onGetQrCode: () async {
                                                  context.loaderOverlay.show();
                                                  try{
                                                    BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromCourseId(localizedText: localizedText, courseId: course.courseId);
                                                    if (!context.mounted) return;
                                                    context.loaderOverlay.hide();
                                                    widget.onPush(
                                                        QrCodePage(
                                                          qrCodeTitle: course.courseName,
                                                          qrCodeContent: "${BloqoQrCodeType.course.name}_${publishedCourse.publishedCourseId}"
                                                        )
                                                    );
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
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  if (publishedCoursesDisplayed < publishedCourses.length)
                                    BloqoTextButton(
                                        onPressed: loadMorePublishedCourses,
                                        text: localizedText.load_more,
                                        color: theme.colors.leadingColor
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
                  color: theme.colors.leadingColor,
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

      BloqoCourseData course = await saveNewCourse(
          localizedText: localizedText,
          authorId: getUserFromAppState(context: context)!.id
      );

      BloqoUserCourseCreatedData userCourseCreated = await saveNewUserCourseCreated(
          localizedText: localizedText,
          course: course
      );

      if(!context.mounted) return;

      addUserCourseCreatedToAppState(context: context, userCourseCreated: userCourseCreated);

      context.loaderOverlay.hide();

      saveEditorCourseToAppState(context: context, course: course, chapters: [], sections: {}, blocks: {});

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

  Future<void> _goToCoursePage({required BuildContext context, required var localizedText, required BloqoUserCourseCreatedData userCourseCreated}) async {
    context.loaderOverlay.show();
    try {
      BloqoCourseData? editorCourse = getEditorCourseFromAppState(context: context);
      if (editorCourse != null && editorCourse.id == userCourseCreated.courseId) {
        context.loaderOverlay.hide();
        widget.onPush(EditCoursePage(onPush: widget.onPush));
      } else {
        BloqoCourseData course = await getCourseFromId(
            localizedText: localizedText, courseId: userCourseCreated.courseId);
        List<BloqoChapterData> chapters = await getChaptersFromIds(localizedText: localizedText, chapterIds: course.chapters);
        Map<String, List<BloqoSectionData>> sections = {};
        Map<String, List<BloqoBlockData>> blocks = {};
        for(String chapterId in course.chapters) {
          List<BloqoSectionData> chapterSections = await getSectionsFromIds(
              localizedText: localizedText,
              sectionIds: chapters.where((chapter) => chapter.id == chapterId).first.sections);
          sections[chapterId] = chapterSections;
          for(BloqoSectionData section in chapterSections){
            List<BloqoBlockData> sectionBlocks = await getBlocksFromIds(
                localizedText: localizedText,
                blockIds: section.blocks
            );
            blocks[section.id] = sectionBlocks;
          }
        }
        if(!context.mounted) return;
        saveEditorCourseToAppState(context: context, course: course, chapters: chapters, sections: sections, blocks: blocks);
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

  Future<void> _tryDismissCourse({required BuildContext context, required var localizedText, required String publishedCourseId, required String courseId}) async {
    await deleteUserCoursesEnrolledForDismissedCourse(localizedText: localizedText, publishedCourseId: publishedCourseId);
    await deletePublishedCourse(localizedText: localizedText, publishedCourseId: publishedCourseId);
    await updateCourseStatus(localizedText: localizedText, courseId: courseId, published: false);

    if(!context.mounted) return;

    BloqoCourseData? currentEditorCourse = getEditorCourseFromAppState(context: context);
    if(currentEditorCourse != null && currentEditorCourse.id == courseId) {
      updateEditorCourseStatusInAppState(context: context, published: false);
    }
    updateUserCourseCreatedPublishedStatusInAppState(context: context, courseId: courseId, published: false);
    BloqoUserCourseCreatedData userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((ucc) => ucc.courseId == courseId).first;

    await saveUserCourseCreatedChanges(localizedText: localizedText, updatedUserCourseCreated: userCourseCreated);
  }

}