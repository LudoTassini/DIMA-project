import 'package:bloqo/app_state/application_settings_app_state.dart';
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
import '../../utils/bloqo_exception.dart';
import '../../utils/bloqo_qr_code_type.dart';
import '../../utils/check_device.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import 'package:intl/intl.dart';

import '../from_any/qr_code_page.dart';

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

  final List<String> _showSectionsList = [];
  bool isInitializedSectionMap = false;

  void initializeSectionsToShowMap(List<BloqoChapterData> chapters, List<dynamic> chaptersCompleted) {
    for (var chapter in chapters) {
      if (!chaptersCompleted.contains(chapter.id)) {
        _showSectionsList.add(chapter.id);
        break;
      }
    }
    isInitializedSectionMap = true;
  }

  void loadSections(String chapterId) {
    setState(() {
      _showSectionsList.add(chapterId);
    });
  }

  void hideSections(String chapterId) {
    setState(() {
      _showSectionsList.remove(chapterId);
    });
  }

  void updateSectionsToShow({required BloqoChapterData chapterCurrentSection, required BloqoChapterData? chapterNextSection}) {
    if(chapterNextSection != null) {
      if (chapterCurrentSection.id != chapterNextSection.id) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          setState(() {
            _showSectionsList.clear();
            _showSectionsList.add(chapterNextSection.id);
          });
        });
      }
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _showSectionsList.clear();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

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

              List<BloqoUserCourseEnrolledData> userCoursesEnrolled = getUserCoursesEnrolledFromAppState(context: context)?? [];

              return Consumer<LearnCourseAppState>(
                builder: (context, learnCourseAppState, _) {

                  BloqoCourseData course = getLearnCourseFromAppState(context: context)!;
                  BloqoUserCourseEnrolledData? userCourseEnrolled = userCoursesEnrolled.where(
                          (courseEnrolled) => courseEnrolled.courseId == course.id).firstOrNull;
                  if(userCourseEnrolled == null){
                    return Row(
                      children: [
                        Column(
                          children: [
                            Expanded(
                              child: BloqoMainContainer(
                                child: Container(),
                              ),
                            ),
                          ])
                      ]);
                  }
                  List<BloqoChapterData> chapters = getLearnCourseChaptersFromAppState(context: context)?? [];
                  Map<String, List<BloqoSectionData>> sections = getLearnCourseSectionsFromAppState(context: context)?? {};
                  Timestamp enrollmentDate = getLearnCourseEnrollmentDateFromAppState(context: context)!;
                  List<dynamic> sectionsCompleted = getLearnCourseSectionsCompletedFromAppState(context: context)?? [];
                  List<dynamic> chaptersCompleted = getLearnCourseChaptersCompletedFromAppState(context: context)?? [];
                  int totNumSections = getLearnCourseTotNumSectionsFromAppState(context: context)!;
                  String? sectionToComplete = userCourseEnrolled.sectionToComplete;
                  bool isCourseCompleted = userCourseEnrolled.isCompleted;

                  return Column(
                    children: [
                      BloqoBreadcrumbs(breadcrumbs: [
                        course.name,
                      ]),
                      Expanded(
                      child:SingleChildScrollView(
                        child: Padding(
                          padding: !isTablet ? const EdgeInsetsDirectional.all(0)
                              : Constants.tabletPadding,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          20, 10, 0, 0),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          localizedText.description,
                                          style: Theme.of(context).textTheme.displayLarge
                                              ?.copyWith(
                                            color: theme.colors.highContrastColor,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 20, 10),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: theme.colors.inBetweenColor,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.qr_code_2,
                                            color: theme.colors.highContrastColor,
                                            size: 32,
                                          ),
                                          onPressed: () async {
                                            await _tryGoToCourseQrCodePage(context: context, localizedText: localizedText, course: course);
                                          }
                                        ),
                                      ),
                                    )
                                  ]
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
                                      color: theme.colors.highContrastColor,
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
                                      color: theme.colors.highContrastColor,
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
                                                          color: theme.colors.secondaryText,
                                                          fontSize: 18,
                                                        ),
                                                      ),

                                                      chaptersCompleted.contains(chapter.id) ?
                                                        Row(
                                                          children: [
                                                            Align(
                                                              alignment: Alignment.topRight,
                                                              child: Text(
                                                                localizedText.completed_section,
                                                                textAlign: TextAlign.start,
                                                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                                                  fontSize: 14,
                                                                  color: theme.colors.success,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                                              child: Icon(
                                                                Icons.check,
                                                                color: theme.colors.success,
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
                                                                color: theme.colors.secondaryText,
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
                                                            color: theme.colors.leadingColor,
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
                                                              color: theme.colors.primaryText,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                )
                                                : const SizedBox.shrink(), // This will take up no space
                                                ),

                                                ... _showSectionsList.contains(chapter.id)
                                                    ? [
                                                  if (!isTablet)
                                                      ...List.generate(
                                                        sections[chapter.id]!.length,
                                                            (sectionIndex) {
                                                          var section = sections[chapter.id]![sectionIndex];
                                                          if(isCourseCompleted) {
                                                            isClickable = true;
                                                          } else {
                                                            if (sectionToComplete! == section.id
                                                            || sectionsCompleted.contains(section.id)) {
                                                              isClickable = true;
                                                            }
                                                          }

                                                      return BloqoCourseSection(
                                                        section: section,
                                                        index: sectionIndex,
                                                        isClickable: isClickable,
                                                        isInLearnPage: true,
                                                        isCompleted: sectionsCompleted.contains(section.id),
                                                        onPressed: () async {
                                                          await _goToSectionPage(
                                                            context: context,
                                                            localizedText: localizedText,
                                                            sectionId: section.id,
                                                            courseName: course.name,
                                                          );
                                                        },
                                                      );
                                                    },
                                                  )
                                                  else Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: LayoutBuilder(
                                                      builder: (BuildContext context, BoxConstraints constraints) {
                                                        double width = constraints.maxWidth / 2;
                                                        double height = width / 2.3;
                                                        double childAspectRatio = width / height;

                                                        return GridView.builder(
                                                          shrinkWrap: true,
                                                          physics: const NeverScrollableScrollPhysics(),
                                                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 2,
                                                            crossAxisSpacing: 10.0,
                                                            mainAxisSpacing: 10.0,
                                                            childAspectRatio: childAspectRatio, // 5/2
                                                          ),
                                                          itemCount: sections[chapter.id]!.length,
                                                          itemBuilder: (context, sectionIndex) {
                                                            var section = sections[chapter.id]![sectionIndex];
                                                            bool isClickable = isCourseCompleted ||
                                                            (sectionToComplete! == section.id) ||
                                                            (sectionsCompleted.contains(section.id));

                                                              return Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: BloqoCourseSection(
                                                                  section: section,
                                                                  index: sectionIndex,
                                                                  isClickable: isClickable,
                                                                  isInLearnPage: true,
                                                                  isCompleted: sectionsCompleted.contains(section.id),
                                                                  onPressed: () async {
                                                                    await _goToSectionPage(
                                                                      context: context,
                                                                      localizedText: localizedText,
                                                                      sectionId: section.id,
                                                                      courseName: course.name,
                                                                    );
                                                                  },
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        }
                                                      ),
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
                                                                    style: TextStyle(
                                                                      color: theme.colors.secondaryText,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons.keyboard_arrow_up_sharp,
                                                                    color: theme.colors.secondaryText,
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
                                                                loadSections(chapter.id);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    localizedText.view_more,
                                                                    style: TextStyle(
                                                                      color: theme.colors.secondaryText,
                                                                      fontSize: 14,
                                                                      fontWeight: FontWeight.w600,
                                                                    ),
                                                                  ),
                                                                  Icon(
                                                                    Icons.keyboard_arrow_right_sharp,
                                                                    color: theme.colors.secondaryText,
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
                                              ],
                                            ),
                                          );
                                        },
                                      ),

                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(25, 50, 25, 10),
                                        child: isTablet
                                            ? Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Flexible(
                                              fit: FlexFit.loose,  // Adjust the fit
                                              child: Text(
                                                "${localizedText.enrolled_on} ${DateFormat('dd/MM/yyyy').format(enrollmentDate.toDate())}",
                                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                  color: theme.colors.highContrastColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            if(!isCourseCompleted)
                                              const Padding(
                                                  padding: EdgeInsetsDirectional.fromSTEB(45, 0, 45, 0),
                                              ),
                                            if(!isCourseCompleted)
                                              Flexible(
                                                fit: FlexFit.loose,
                                                child: BloqoFilledButton(
                                                  color: theme.colors.error,
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
                                                          enrolledUserId: user.id,
                                                        );
                                                      },
                                                      backgroundColor: theme.colors.error,
                                                    );
                                                  },
                                                  text: localizedText.unsubscribe,
                                                  icon: Icons.close_sharp,
                                                  fontSize: 30,
                                                  height: 70,
                                                ),
                                              ),
                                          ],
                                        )
                                        : Wrap(
                                          spacing: 10.0,
                                          runSpacing: 10.0,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "${localizedText.enrolled_on} ${DateFormat('dd/MM/yyyy').format(enrollmentDate.toDate())}",
                                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                  color: theme.colors.highContrastColor,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                            if(!isCourseCompleted)
                                              BloqoFilledButton(
                                                color: theme.colors.error,
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
                                                        enrolledUserId: user.id,
                                                      );
                                                    },
                                                    backgroundColor: theme.colors.error,
                                                  );
                                                },
                                                text: localizedText.unsubscribe,
                                                icon: Icons.close_sharp,
                                                fontSize: 20,
                                                height: 48,
                                              ),
                                          ],
                                        ),
                                      )

                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    if(!isCourseCompleted)
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
                                padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(40, 10, 40, 0)
                                  : const EdgeInsetsDirectional.fromSTEB(80, 10, 80, 0),
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

                          if(!isCourseCompleted)
                            Padding(
                              padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20)
                                  : Constants.tabletPaddingBloqoFilledButton,
                              child: BloqoFilledButton(
                                onPressed: () async {
                                  await _goToSectionPage(
                                    context: context,
                                    localizedText: localizedText,
                                    sectionId: sectionToComplete!,
                                    courseName: course.name,
                                  );
                                },
                                color: theme.colors.success,
                                text: sectionsCompleted.isEmpty
                                ? localizedText.start_learning
                                    : localizedText.continue_learning,
                                icon: Icons.lightbulb,
                                fontSize: !isTablet ? 24 : 34,
                                height: !isTablet ? 60 : 80,
                              ),
                            )
                          ],
                      ),

                      if(isCourseCompleted)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                          height: !isTablet ? 73 : 95,
                          child: Padding(
                          padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10)
                            : Constants.tabletPaddingBloqoFilledButton,
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colors.highContrastColor,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: theme.colors.success,
                                width: 3,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                              child: Text(
                                localizedText.course_completed,
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: theme.colors.success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: !isTablet ? 24 : 34,
                                ),
                              ),
                            ),
                          ),
                      ),
                        ),
                  ],
                  ),
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
      var firestore = getFirestoreFromAppState(context: context);
      BloqoPublishedCourseData publishedCourseToUpdate = await getPublishedCourseFromCourseId(
          firestore: firestore,
          localizedText: localizedText,
          courseId: courseId
      );
      BloqoUserCourseEnrolledData courseToRemove = courses!.firstWhere((c) => c.courseId == courseId);
      await deleteUserCourseEnrolled(
          firestore: firestore,
          localizedText: localizedText,
          courseId: courseId,
          enrolledUserId: enrolledUserId
      );
      if (!context.mounted) return;
      deleteUserCourseEnrolledFromAppState(context: context, userCourseEnrolled: courseToRemove);

      publishedCourseToUpdate.numberOfEnrollments = publishedCourseToUpdate.numberOfEnrollments - 1;
      await savePublishedCourseChanges(
          firestore: firestore,
          localizedText: localizedText,
          updatedPublishedCourse: publishedCourseToUpdate
      );
      if(!context.mounted) return;
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

  Future<void> _goToSectionPage({required BuildContext context, required var localizedText, required String sectionId,
    required String courseName}) async {
    context.loaderOverlay.show();
    try {
      var firestore = getFirestoreFromAppState(context: context);

      BloqoSectionData sectionToComplete = await getSectionFromId(
          firestore: firestore,
          localizedText: localizedText,
          sectionId: sectionId);

      List<BloqoBlockData> blocks = await getBlocksFromIds(
          firestore: firestore,
          localizedText: localizedText,
          blockIds: sectionToComplete.blocks
      );
      if(!context.mounted) return;

      context.loaderOverlay.hide();

      List<BloqoChapterData> chapters = getLearnCourseChaptersFromAppState(context: context)!;
      BloqoChapterData currentChapter = chapters.where(
              (chapter) => chapter.sections.contains(sectionId)).first;
      BloqoChapterData? nextChapter;
      String? nextChapterId = _getNextSectionChapterId(
          chapters: chapters,
          currentChapter: currentChapter,
          currentSection: sectionToComplete);

      if(nextChapterId != null){
        nextChapter = chapters.where((chapter) => chapter.id == nextChapterId).first;
      }

      widget.onPush(
        SectionPage(
          onPush: widget.onPush,
          section: sectionToComplete,
          blocks: blocks,
          courseName: courseName,
          chapter: currentChapter,
          onSectionCompleted: () {
            updateSectionsToShow(
              chapterCurrentSection: currentChapter,
              chapterNextSection: nextChapter,
            );
          },
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

  Future<void> _tryGoToCourseQrCodePage({required BuildContext context, required var localizedText, required BloqoCourseData course}) async {
    context.loaderOverlay.show();
    try{
      var firestore = getFirestoreFromAppState(context: context);
      BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromCourseId(firestore: firestore, localizedText: localizedText, courseId: course.id);
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      widget.onPush(
          QrCodePage(
              qrCodeTitle: course.name,
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

  String? _getNextSectionChapterId({required List<BloqoChapterData> chapters, required BloqoChapterData currentChapter,
    required BloqoSectionData currentSection,
  }) {
    final sectionIndex = currentChapter.sections.indexOf(currentSection.id);

    if (sectionIndex != -1 && sectionIndex < currentChapter.sections.length - 1) {
      return currentChapter.id;
    }

    final chapterIndex = chapters.indexOf(currentChapter);

    if (chapterIndex != -1 && chapterIndex < chapters.length - 1) {
      final nextChapter = chapters[chapterIndex + 1];

      if (nextChapter.sections.isNotEmpty) {
        return nextChapter.id;
      }
    }
    // Return null if there are no further sections or chapters to navigate to
    return null;
  }

}

