import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/bloqo_review.dart';
import 'package:bloqo/model/courses/bloqo_chapter.dart';
import 'package:bloqo/model/courses/bloqo_section.dart';
import 'package:bloqo/pages/from_search/user_courses_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../../app_state/learn_course_app_state.dart';
import '../../app_state/user_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/complex/bloqo_course_section.dart';
import '../../components/complex/bloqo_review_component.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/popups/bloqo_confirmation_alert.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_published_course.dart';
import '../../model/bloqo_user.dart';
import '../../model/bloqo_user_course_enrolled.dart';
import '../../model/courses/bloqo_course.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';

class CourseSearchPage extends StatefulWidget {

  const CourseSearchPage({
    super.key,
    required this.onPush,
    required this.onNavigateToPage,
    required this.course,
    required this.publishedCourse,
    required this.chapters,
    required this.sections,
    required this.courseAuthor,
    required this.rating,
    required this.reviews
  });

  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;
  final BloqoCourse course;
  final BloqoPublishedCourse publishedCourse;
  final List<BloqoChapter> chapters;
  final Map<String, List<BloqoSection>> sections;
  final BloqoUser courseAuthor;

  final double? rating;
  final List<BloqoReview>? reviews;

  @override
  State<CourseSearchPage> createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> with AutomaticKeepAliveClientMixin<CourseSearchPage> {

  bool isEnrolled = false;
  BloqoUserCourseEnrolled? enrolledCourse;

  final Map<String, bool> _showSectionsMap = {};
  bool isInitializedSectionMap = false;

  int _reviewsDisplayed = Constants.reviewsToShowAtFirst;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;

    void initializeSectionsToShowMap(List<BloqoChapter> chapters) {
      _showSectionsMap[chapters[0].id] = true;
      isInitializedSectionMap = true;
    }

    void showSections(String chapterId) {
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
      initializeSectionsToShowMap(widget.chapters);
    }

    void loadMoreReviews() {
      setState(() {
        _reviewsDisplayed += Constants.reviewsToFurtherLoadAtRequest;
      });
    }

    BloqoUser user = getUserFromAppState(context: context)!;

    return BloqoMainContainer(
      alignment: const AlignmentDirectional(-1.0, -1.0),
      child: Consumer<UserCoursesEnrolledAppState>(
        builder: (context, userCoursesEnrolledAppState, _) {
          List<BloqoUserCourseEnrolled> userCoursesEnrolled = getUserCoursesEnrolledFromAppState(context: context) ?? [];

          if(userCoursesEnrolled.any((enrolledCourse) => enrolledCourse.courseId == widget.course.id)) {
            isEnrolled = true;
            enrolledCourse = userCoursesEnrolled.firstWhere(
                (enrolledCourse) => enrolledCourse.courseId == widget.course.id);
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      widget.course.name,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: BloqoColors.seasalt,
                        fontSize: 36,
                      ),
                    ),
                  ),
                ),
              ),
          ],
              ),

              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 12),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Text(
                            localizedText.by,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: BloqoColors.seasalt,
                              fontSize: 16,
                            ),
                          ),
                          BloqoTextButton(
                            text: widget.courseAuthor.username,
                            color: BloqoColors.seasalt,
                            // TODO
                            onPressed: () async {
                              _goToUserCoursesPage(
                                  context: context,
                                  localizedText: localizedText,
                                  authorId: widget.course.authorId);
                              },
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ),
                    RatingBarIndicator(
                      rating: widget.rating?? 0,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: BloqoColors.tertiary,
                      ),
                      itemCount: 5,
                      itemSize: 24,
                      direction: Axis.horizontal,
                    ),
                  ],
                )
              ),

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
                            style: Theme.of(context).textTheme.displayLarge
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
                            child: widget.course.description != ''
                                ? Text(
                              widget.course.description!,
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
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 5, 20, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            localizedText.content,
                            style: Theme.of(context).textTheme.displayLarge
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
                                widget.chapters.length,
                                    (chapterIndex) {
                                  var chapter = widget.chapters[chapterIndex];

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
                                                  color: BloqoColors.secondaryText,
                                                  fontSize: 18,
                                                ),
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
                                                        color: BloqoColors.primaryText,
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
                                            widget.sections[chapter.id]!.length,
                                                (sectionIndex) {
                                              var section = widget.sections[chapter.id]![sectionIndex];
                                              return BloqoCourseSection(
                                                section: section,
                                                index: sectionIndex,
                                                isInLearnPage: false,
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
                                                        showSections(chapter.id);
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
                                padding: const EdgeInsetsDirectional.fromSTEB(20, 15, 20, 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        localizedText.reviews,
                                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                          color: BloqoColors.seasalt,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                    const Spacer(), // This will create space between the first Text and the rest of the Row
                                    Row(
                                      children: [

                                        widget.rating != null ?
                                          Text(
                                            widget.rating!.toDouble().toString(),
                                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                              color: BloqoColors.seasalt,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16,
                                            ),
                                          )
                                        : Text(
                                          '0',
                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                            color: BloqoColors.seasalt,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),

                                        Padding(
                                          padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                                          child: RatingBarIndicator(
                                            rating: widget.rating?? 0,
                                            itemBuilder: (context, index) => const Icon(
                                              Icons.star,
                                              color: BloqoColors.tertiary,
                                            ),
                                            itemCount: 5,
                                            itemSize: 24,
                                            direction: Axis.horizontal,
                                          ),
                                        ),
                                        Text(
                                          '(${widget.publishedCourse.reviews.length.toString()})',
                                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                            color: BloqoColors.seasalt,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              BloqoSeasaltContainer(
                                  child:
                                (widget.reviews!.isEmpty) ?
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                localizedText.no_reviews_yet,
                                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                                  color: BloqoColors.russianViolet,
                                                  fontSize: 15,
                                                  ),
                                                ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : _reviewsDisplayed >= widget.publishedCourse.reviews.length ?
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                                      child: Column(
                                        children:
                                          List.generate(
                                        _reviewsDisplayed > widget.publishedCourse.reviews.length ?
                                        widget.publishedCourse.reviews.length : _reviewsDisplayed,
                                            (index) {
                                          BloqoReview review = widget.reviews![index];
                                          return BloqoReviewComponent(
                                            review: review,
                                          );
                                        },
                                      ),
                                    ),
                                  )

                                    : Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                                        child: Column(
                                          children: [
                                            ...List.generate(
                                              _reviewsDisplayed > widget.publishedCourse.reviews.length ?
                                              widget.publishedCourse.reviews.length : _reviewsDisplayed,
                                                  (index) {
                                                BloqoReview review = widget.reviews![index];
                                                return BloqoReviewComponent(
                                                  review: review,
                                                );
                                              },
                                            ),

                                            BloqoTextButton(
                                                onPressed: loadMoreReviews,
                                                text: localizedText.load_more_reviews,
                                                color: BloqoColors.russianViolet
                                            ),
                                        ],
                                      ),
                                    ),

                              ),

                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 0, 20, 10),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child:
                                      isEnrolled ?
                                        Text(
                                          localizedText.enrolled_on +
                                              DateFormat('dd/MM/yyyy').format(enrolledCourse!.enrollmentDate.toDate()),
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .displaySmall
                                              ?.copyWith(
                                            color: BloqoColors.seasalt,
                                            fontSize: 16,
                                          ),
                                        )
                                      : Text(
                                        localizedText.published_on +
                                            DateFormat('dd/MM/yyyy').format(widget.course.publicationDate!.toDate()),
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                          color: BloqoColors.seasalt,
                                          fontSize: 16,
                                        ),
                                      )

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
                  !isEnrolled?
                      widget.course.authorId != getUserFromAppState(context: context)!.id?
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 10, 20, 10),
                          child: BloqoFilledButton(
                            onPressed: () async {
                              _goToLearnPage(context: context, localizedText: localizedText, course: widget.course,
                              chapters: widget.chapters, sections: widget.sections, publishedCourseId: widget.publishedCourse.publishedCourseId);
                            },
                            height: 60,
                            color: BloqoColors.russianViolet,
                            text: localizedText.enroll_in,
                            icon: Icons.add,
                            fontSize: 24,
                          ),
                        )
                      : Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20, 10, 20, 10),
                        child: BloqoFilledButton(
                          onPressed: () async {
                            showBloqoErrorAlert(
                                context: context,
                                title: localizedText.error_title,
                                description: localizedText.creator_cannot_subscribe);
                          },
                          height: 60,
                          color: BloqoColors.secondaryText,
                          text: localizedText.enroll_in,
                          icon: Icons.add,
                          fontSize: 24,
                        ),
                      )

                  : Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        20, 10, 20, 10),
                    child: BloqoFilledButton(
                      onPressed: () {
                            showBloqoConfirmationAlert(
                                context: context,
                                title: localizedText.warning,
                                description: localizedText.unsubscribe_confirmation,
                                confirmationFunction: () async {
                                  await _tryDeleteUserCourseEnrolled(
                                    context: context,
                                    localizedText: localizedText,
                                    courseId: widget.course.id,
                                    enrolledUserId: user.id
                                  );
                                },
                                backgroundColor: BloqoColors.error
                            );
                      },
                      height: 60,
                      color: BloqoColors.error,
                      text: localizedText.unsubscribe,
                      fontSize: 24,
                    ),
                  )
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

  Future<void> _goToLearnPage({required BuildContext context, required var localizedText, required BloqoCourse course,
    required List<BloqoChapter> chapters, required Map<String, List<BloqoSection>> sections,
    required String publishedCourseId}) async {
    context.loaderOverlay.show();
    try {
      BloqoUser? user = getUserFromAppState(context: context);
      BloqoPublishedCourse publishedCourseToUpdate = await getPublishedCourseFromCourseId(
          localizedText: localizedText, courseId: course.id);
        BloqoUserCourseEnrolled userCourseEnrolled = await saveNewUserCourseEnrolled(localizedText: localizedText,
            course: course, publishedCourseId: publishedCourseId, userId: user!.id);
        if(!context.mounted) return;
        saveLearnCourseToAppState(
            context: context,
            course: course,
            chapters: chapters,
            sections: sections,
            enrollmentDate: userCourseEnrolled.enrollmentDate,
            sectionsCompleted: [],
            chaptersCompleted: [],
            totNumSections: userCourseEnrolled.totNumSections,
            comingFromHome: true);
        List<BloqoUserCourseEnrolled>? enrolledCourses = getUserCoursesEnrolledFromAppState(context: context);
        if (enrolledCourses != null) {
          enrolledCourses.insert(0, userCourseEnrolled);
        } else {
          enrolledCourses = [userCourseEnrolled];
        }
        saveUserCoursesEnrolledToAppState(context: context, courses: enrolledCourses);
        publishedCourseToUpdate.numberOfEnrollments = publishedCourseToUpdate.numberOfEnrollments + 1;
        savePublishedCourseChanges(localizedText: localizedText, updatedPublishedCourse: publishedCourseToUpdate);
        context.loaderOverlay.hide();
        widget.onNavigateToPage(1);
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

  Future<void> _tryDeleteUserCourseEnrolled({required BuildContext context, required var localizedText, required String
    courseId, required String enrolledUserId}) async {
    context.loaderOverlay.show();
    try{
      List<BloqoUserCourseEnrolled>? courses = getUserCoursesEnrolledFromAppState(context: context);
      BloqoPublishedCourse publishedCourseToUpdate = await getPublishedCourseFromCourseId(
          localizedText: localizedText, courseId: courseId);
      BloqoUserCourseEnrolled courseToRemove = courses!.firstWhere((c) => c.courseId == courseId);
      await deleteUserCourseEnrolled(localizedText: localizedText, courseId: courseId, enrolledUserId: enrolledUserId);
      if (!context.mounted) return;
      deleteUserCourseEnrolledFromAppState(context: context, userCourseEnrolled: courseToRemove);
      publishedCourseToUpdate.numberOfEnrollments = publishedCourseToUpdate.numberOfEnrollments - 1;
      savePublishedCourseChanges(localizedText: localizedText, updatedPublishedCourse: publishedCourseToUpdate);
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

  Future<void> _goToUserCoursesPage({required BuildContext context, required var localizedText, required String authorId}) async {
    context.loaderOverlay.show();
    try {
      BloqoUser? courseAuthor = await getUserFromId(localizedText: localizedText, id: authorId);
      List<BloqoPublishedCourse> publishedCourses = await getPublishedCoursesFromAuthorId(localizedText: localizedText, authorId: authorId);
      if(!context.mounted) return;
      context.loaderOverlay.hide();
      widget.onPush(
        UserCoursesPage(
          onPush: widget.onPush,
          onNavigateToPage: widget.onNavigateToPage,
          author: courseAuthor,
          publishedCourses: publishedCourses,
        ));
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