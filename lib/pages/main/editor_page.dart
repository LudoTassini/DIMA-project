import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/editor_course_app_state.dart';
import 'package:bloqo/app_state/user_courses_created_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_review_data.dart';
import 'package:bloqo/model/courses/bloqo_course_data.dart';
import 'package:bloqo/pages/from_any/qr_code_page.dart';
import 'package:bloqo/pages/from_editor/course_content_preview_page.dart';
import 'package:bloqo/pages/from_editor/publish_course_page.dart';
import 'package:bloqo/utils/check_device.dart';
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
  late int coursesToFurtherLoadAtRequest;
  late bool initialized;
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
    coursesToFurtherLoadAtRequest = Constants.coursesToFurtherLoadAtRequest;
    initialized = false;

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
    bool isTablet = checkDevice(context);

    if(isTablet && !initialized){
      setState(() {
        inProgressCoursesDisplayed = Constants.coursesToShowAtFirstTablet;
        publishedCoursesDisplayed = Constants.coursesToShowAtFirstTablet;
        coursesToFurtherLoadAtRequest = Constants.coursesToFurtherLoadAtRequestTablet;
        initialized = true;
      }
      );
    }

    void loadMoreInProgressCourses() {
      setState(() {
        inProgressCoursesDisplayed += coursesToFurtherLoadAtRequest;
      });
    }

    void loadMorePublishedCourses() {
      setState(() {
        publishedCoursesDisplayed += coursesToFurtherLoadAtRequest;
      });
    }

    return Consumer<ApplicationSettingsAppState>(
        builder: (context, applicationSettingsAppState, _) {
          var theme = getAppThemeFromAppState(context: context);
          return BloqoMainContainer(
            alignment: const AlignmentDirectional(-1.0, -1.0),
            child: Consumer<UserCoursesCreatedAppState>(
              builder: (context, userCoursesCreatedAppState, _) {
                List<BloqoUserCourseCreatedData> userCoursesCreated = getUserCoursesCreatedFromAppState(
                    context: context) ?? [];
                List<BloqoUserCourseCreatedData> inProgressCourses = userCoursesCreated
                    .where((course) => !course.published).toList();
                List<BloqoUserCourseCreatedData> publishedCourses = userCoursesCreated
                    .where((course) => course.published).toList();
                inProgressCourses.sort((a, b) =>
                    b.lastUpdated.compareTo(a.lastUpdated));
                publishedCourses.sort((a, b) =>
                    b.lastUpdated.compareTo(a.lastUpdated));
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
                          Padding(
                            padding: !isTablet
                                ? const EdgeInsetsDirectional.all(0)
                                : Constants.tabletPadding,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 20, 0),
                                  child: Text(
                                    localizedText.editor_page_header_1,
                                    style: theme
                                        .getThemeData()
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                      color: theme.colors.highContrastColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                BloqoSeasaltContainer(
                                  child: Consumer<EditorCourseAppState>(
                                      builder: (context, editorCourseAppState, _) {
                                        return Column(
                                          children: [

                                            if (inProgressCourses.isNotEmpty &&
                                                !isTablet)
                                              Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  ...List.generate(
                                                    inProgressCoursesDisplayed >
                                                        inProgressCourses.length
                                                        ? inProgressCourses.length
                                                        : inProgressCoursesDisplayed,
                                                        (index) {
                                                      BloqoUserCourseCreatedData course = inProgressCourses[index];
                                                      if (index !=
                                                          (inProgressCoursesDisplayed >
                                                              inProgressCourses
                                                                  .length
                                                              ? inProgressCourses
                                                              .length
                                                              : inProgressCoursesDisplayed) -
                                                              1) {
                                                        return BloqoCourseCreated(
                                                          course: course,
                                                          onPressed: () async {
                                                            await _goToCoursePage(
                                                                context: context,
                                                                localizedText: localizedText,
                                                                userCourseCreated: course);
                                                          },
                                                          showEditOptions: true,
                                                          onPublish: () =>
                                                              widget.onPush(
                                                                  PublishCoursePage(
                                                                      onPush: widget.onPush,
                                                                      courseId: course.courseId
                                                                  )
                                                              ),
                                                          onPreview: () async {
                                                            await _tryShowCoursePreview(
                                                              context: context,
                                                              localizedText: localizedText,
                                                              userCourseCreated: course
                                                            );
                                                          },
                                                        );
                                                      }
                                                      else {
                                                        return BloqoCourseCreated(
                                                          course: course,
                                                          padding: const EdgeInsetsDirectional
                                                              .fromSTEB(
                                                              15, 15, 15, 0),
                                                          onPressed: () async {
                                                            await _goToCoursePage(
                                                                context: context,
                                                                localizedText: localizedText,
                                                                userCourseCreated: course
                                                            );
                                                          },
                                                          showEditOptions: true,
                                                          onPublish: () =>
                                                              widget.onPush(
                                                                  PublishCoursePage(
                                                                    onPush: widget
                                                                        .onPush,
                                                                    courseId: course
                                                                        .courseId,)
                                                              ),
                                                          onPreview: () async {
                                                            await _tryShowCoursePreview(
                                                                context: context,
                                                                localizedText: localizedText,
                                                                userCourseCreated: course
                                                            );
                                                          },
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  Padding(
                                                    padding: !(inProgressCoursesDisplayed <
                                                        inProgressCourses.length)
                                                        ?
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 0, 0, 15)
                                                        : const EdgeInsetsDirectional
                                                        .all(0),
                                                  ),
                                                ],
                                              ),

                                            if (inProgressCourses.isNotEmpty &&
                                                isTablet)
                                              LayoutBuilder(
                                                  builder: (BuildContext context,
                                                      BoxConstraints constraints) {
                                                    double width = constraints
                                                        .maxWidth / 2;
                                                    double height = width / 1.45;
                                                    double childAspectRatio = width /
                                                        height;

                                                    return Padding(
                                                      padding: const EdgeInsetsDirectional
                                                          .fromSTEB(5, 0, 5, 15),
                                                      // Padding around the entire GridView
                                                      child: GridView.builder(
                                                        shrinkWrap: true,
                                                        physics: const NeverScrollableScrollPhysics(),
                                                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 2,
                                                          crossAxisSpacing: 10.0,
                                                          mainAxisSpacing: 10.0,
                                                          childAspectRatio: childAspectRatio,
                                                        ),
                                                        itemCount: inProgressCoursesDisplayed >
                                                            inProgressCourses.length
                                                            ? inProgressCourses
                                                            .length
                                                            : inProgressCoursesDisplayed,
                                                        itemBuilder: (context,
                                                            index) {
                                                          BloqoUserCourseCreatedData course = inProgressCourses[index];
                                                          return BloqoCourseCreated(
                                                            course: course,
                                                            onPressed: () async {
                                                              await _goToCoursePage(
                                                                context: context,
                                                                localizedText: localizedText,
                                                                userCourseCreated: course,
                                                              );
                                                            },
                                                            showEditOptions: true,
                                                            onPreview: () async {
                                                              await _tryShowCoursePreview(
                                                                  context: context,
                                                                  localizedText: localizedText,
                                                                  userCourseCreated: course
                                                              );
                                                            },
                                                            onPublish: () =>
                                                                widget.onPush(
                                                                  PublishCoursePage(
                                                                      onPush: widget
                                                                          .onPush,
                                                                      courseId: course
                                                                          .courseId),
                                                                ),
                                                          );
                                                        },
                                                      ),
                                                    );
                                                  }
                                              ),


                                            if (inProgressCoursesDisplayed <
                                                inProgressCourses.length)
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(0, 10, 0, 10),
                                                child: BloqoTextButton(
                                                    onPressed: loadMoreInProgressCourses,
                                                    text: localizedText.load_more,
                                                    color: theme.colors.leadingColor
                                                ),
                                              ),
                                            if (inProgressCourses.isEmpty)
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(15, 15, 15, 0),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      localizedText
                                                          .editor_page_no_in_progress_courses,
                                                      style: theme
                                                          .getThemeData()
                                                          .textTheme
                                                          .displaySmall
                                                          ?.copyWith(
                                                        color: theme.colors
                                                            .primaryText,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsetsDirectional
                                                          .fromSTEB(30, 10, 30, 20),
                                                      child: BloqoFilledButton(
                                                        onPressed: () async {
                                                          await _createNewCourse(
                                                              context: context,
                                                              localizedText: localizedText);
                                                        },
                                                        color: theme.colors
                                                            .leadingColor,
                                                        text: localizedText
                                                            .take_me_there_button,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                          ],
                                        );
                                      }
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: !isTablet
                                ? const EdgeInsetsDirectional.all(0)
                                : Constants.tabletPadding,
                            child: ListView(
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 20, 20, 0),
                                  child: Text(
                                    localizedText.editor_page_header_2,
                                    textAlign: TextAlign.end,
                                    style: theme
                                        .getThemeData()
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                      color: theme.colors.highContrastColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                BloqoSeasaltContainer(
                                  child: Column(
                                    children: [

                                      if (publishedCourses.isNotEmpty && !isTablet)
                                        Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ...List.generate(
                                              publishedCoursesDisplayed >
                                                  publishedCourses.length
                                                  ? publishedCourses.length
                                                  : publishedCoursesDisplayed,
                                                  (index) {
                                                BloqoUserCourseCreatedData course = publishedCourses[index];
                                                if (index !=
                                                    (publishedCoursesDisplayed >
                                                        publishedCourses.length
                                                        ? publishedCourses.length
                                                        : publishedCoursesDisplayed) -
                                                        1) {
                                                  return BloqoCourseCreated(
                                                      course: course,
                                                      onPressed: () async {
                                                        await _tryShowCoursePreview(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            userCourseCreated: course
                                                        );
                                                      },
                                                      showPublishedOptions: true,
                                                      onViewStatistics: () async {
                                                        await _tryViewStatistics(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            course: course);
                                                      },
                                                      onDismiss: () async {
                                                        await _askConfirmationAndDismissCourse(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            course: course);
                                                      },
                                                      onGetQrCode: () async {
                                                        await _tryGoToQrCodePage(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            course: course);
                                                      }
                                                  );
                                                }
                                                else {
                                                  return BloqoCourseCreated(
                                                      course: course,
                                                      padding: const EdgeInsetsDirectional.all(15),
                                                      onPressed: () async {
                                                        await _tryShowCoursePreview(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            userCourseCreated: course
                                                        );
                                                      },
                                                      showPublishedOptions: true,
                                                      onViewStatistics: () async {
                                                        await _tryViewStatistics(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            course: course);
                                                      },
                                                      onDismiss: () async {
                                                        await _askConfirmationAndDismissCourse(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            course: course);
                                                      },
                                                      onGetQrCode: () async {
                                                        await _tryGoToQrCodePage(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            course: course);
                                                      }
                                                  );
                                                }
                                              },
                                            ),
                                          ],
                                        ),

                                      if (publishedCourses.isNotEmpty && isTablet)
                                        LayoutBuilder(
                                            builder: (BuildContext context,
                                                BoxConstraints constraints) {
                                              double width = constraints.maxWidth /
                                                  2;
                                              double height = width / 1.20;
                                              double childAspectRatio = width /
                                                  height;

                                              return Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(5, 0, 5, 15),
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 10.0,
                                                    mainAxisSpacing: 10.0,
                                                    childAspectRatio: childAspectRatio,
                                                  ),
                                                  itemCount: publishedCoursesDisplayed >
                                                      publishedCourses.length
                                                      ?
                                                  publishedCourses.length
                                                      : publishedCoursesDisplayed,
                                                  itemBuilder: (context, index) {
                                                    BloqoUserCourseCreatedData course = publishedCourses[index];
                                                    return BloqoCourseCreated(
                                                      course: course,
                                                      onPressed: () async {
                                                        await _tryShowCoursePreview(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            userCourseCreated: course
                                                        );
                                                      },
                                                      showPublishedOptions: true,
                                                      onViewStatistics: () async {
                                                        await _tryViewStatistics(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            course: course);
                                                      },
                                                      onDismiss: () async {
                                                        await _askConfirmationAndDismissCourse(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            course: course);
                                                      },
                                                      onGetQrCode: () async {
                                                        await _tryGoToQrCodePage(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            course: course);
                                                      },
                                                    );
                                                  },
                                                ),
                                              );
                                            }
                                        ),


                                      if (publishedCoursesDisplayed <
                                          publishedCourses.length)
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 10, 0, 10),
                                          child: BloqoTextButton(
                                              onPressed: loadMorePublishedCourses,
                                              text: localizedText.load_more,
                                              color: theme.colors.leadingColor
                                          ),
                                        ),

                                      if (publishedCourses.isEmpty)
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(15, 15, 15, 0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                localizedText.editor_page_no_published_courses,
                                                style: theme.getThemeData().textTheme.displaySmall?.copyWith(
                                                  color: theme.colors.primaryText,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsetsDirectional
                                                    .fromSTEB(30, 10, 30, 20),
                                                child: BloqoFilledButton(
                                                  onPressed: () {
                                                    tabController.animateTo(0);
                                                  },
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
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(
                          20, 10, 20, 10)
                          : Constants.tabletPaddingBloqoFilledButton,
                      child: BloqoFilledButton(
                        color: theme.colors.leadingColor,
                        onPressed: () async {
                          await _createNewCourse(
                              context: context, localizedText: localizedText);
                        },
                        text: localizedText.new_course,
                        icon: Icons.add,
                        fontSize: !isTablet
                            ? Constants.fontSizeNotTablet
                            : Constants.fontSizeTablet,
                        height: !isTablet ? Constants.heightNotTablet : Constants
                            .heightTablet,
                      ),
                    ),
                  ],
                );
              },
            ),
          );
        }
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

    var firestore = getFirestoreFromAppState(context: context);

    await deleteUserCoursesEnrolledForDismissedCourse(firestore: firestore, localizedText: localizedText, publishedCourseId: publishedCourseId);
    await deletePublishedCourse(firestore: firestore, localizedText: localizedText, publishedCourseId: publishedCourseId);
    await updateCourseStatus(firestore: firestore, localizedText: localizedText, courseId: courseId, published: false);

    if(!context.mounted) return;

    BloqoCourseData? currentEditorCourse = getEditorCourseFromAppState(context: context);
    if(currentEditorCourse != null && currentEditorCourse.id == courseId) {
      updateEditorCourseStatusInAppState(context: context, published: false);
    }
    updateUserCourseCreatedPublishedStatusInAppState(context: context, courseId: courseId, published: false);
    BloqoUserCourseCreatedData userCourseCreated = getUserCoursesCreatedFromAppState(context: context)!.where((ucc) => ucc.courseId == courseId).first;

    await saveUserCourseCreatedChanges(firestore: firestore, localizedText: localizedText, updatedUserCourseCreated: userCourseCreated);
  }

  Future<void> _tryViewStatistics({required BuildContext context, required var localizedText, required BloqoUserCourseCreatedData course}) async {
    context.loaderOverlay.show();
    try {
      var firestore = getFirestoreFromAppState(context: context);
      BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromCourseId(firestore: firestore, localizedText: localizedText, courseId: course.courseId);
      List<BloqoReviewData> reviews = await getReviewsFromIds(firestore: firestore, localizedText: localizedText, reviewsIds: publishedCourse.reviews);
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
  }

  Future<void> _askConfirmationAndDismissCourse({required BuildContext context, required var localizedText, required BloqoUserCourseCreatedData course}) async {
    var theme = getAppThemeFromAppState(context: context);
    await showBloqoConfirmationAlert(
        context: context,
        title: localizedText.warning,
        description: localizedText.course_dismiss_confirmation,
        backgroundColor: theme.colors.error,
        confirmationFunction: () async {
          context.loaderOverlay.show();
          try {
            var firestore = getFirestoreFromAppState(context: context);
            BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromCourseId(firestore: firestore, localizedText: localizedText, courseId: course.courseId);
            if(!context.mounted) return;
            await _tryDismissCourse(
                context: context,
                localizedText: localizedText,
                publishedCourseId: publishedCourse.publishedCourseId,
                courseId: course.courseId
            );
            if (!context.mounted) return;
            context.loaderOverlay.hide();
            showBloqoSnackBar(context: context, text: localizedText.done);
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
  }

  Future<void> _tryGoToQrCodePage({required BuildContext context, required var localizedText, required BloqoUserCourseCreatedData course}) async {
    context.loaderOverlay.show();
    try{
      var firestore = getFirestoreFromAppState(context: context);
      BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromCourseId(firestore: firestore, localizedText: localizedText, courseId: course.courseId);
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

  Future<void> _tryShowCoursePreview({required BuildContext context, required var localizedText, required BloqoUserCourseCreatedData userCourseCreated}) async {
    context.loaderOverlay.show();
    try{
      var editorCourse = getEditorCourseFromAppState(context: context);
      if(editorCourse != null && editorCourse.id == userCourseCreated.courseId){
        context.loaderOverlay.hide();
        widget.onPush(
          CourseContentPreviewPage(onPush: widget.onPush)
        );
      }
      else{
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
        for(BloqoChapterData chapter in chapters){
          List<BloqoSectionData> chapterSections = await getSectionsFromIds(
              firestore: firestore,
              localizedText: localizedText,
              sectionIds: chapter.sections
          );
          sections[chapter.id] = chapterSections;
        }

        Map<String, List<BloqoBlockData>> blocks = {};
        for(BloqoChapterData chapter in chapters) {
          for (BloqoSectionData section in sections[chapter.id]!) {
            List<BloqoBlockData> sectionBlocks = await getBlocksFromIds(
                firestore: firestore,
                localizedText: localizedText,
                blockIds: section.blocks
            );
            blocks[section.id] = sectionBlocks;
          }
        }

        if(!context.mounted) return;
        saveEditorCourseToAppState(context: context, course: course, chapters: chapters, sections: sections, blocks: blocks);

        context.loaderOverlay.hide();
        widget.onPush(
            CourseContentPreviewPage(onPush: widget.onPush)
        );
      }
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

}