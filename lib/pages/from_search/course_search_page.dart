import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/bloqo_notification_data.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_review_data.dart';
import 'package:bloqo/model/courses/bloqo_chapter_data.dart';
import 'package:bloqo/model/courses/bloqo_section_data.dart';
import 'package:bloqo/pages/from_any/user_profile_page.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../../app_state/application_settings_app_state.dart';
import '../../app_state/learn_course_app_state.dart';
import '../../app_state/user_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/complex/bloqo_course_section.dart';
import '../../components/complex/bloqo_review.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/popups/bloqo_confirmation_alert.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/published_courses/bloqo_published_course_data.dart';
import '../../model/bloqo_user_data.dart';
import '../../model/user_courses/bloqo_user_course_enrolled_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/bloqo_qr_code_type.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../../utils/uuid.dart';
import '../from_any/qr_code_page.dart';

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
    required this.reviews,
    this.enrollmentAlreadyRequested = false
  });

  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;
  final BloqoCourseData course;
  final BloqoPublishedCourseData publishedCourse;
  final List<BloqoChapterData> chapters;
  final Map<String, List<BloqoSectionData>> sections;
  final BloqoUserData courseAuthor;

  final double? rating;
  final List<BloqoReviewData>? reviews;

  final bool enrollmentAlreadyRequested;

  @override
  State<CourseSearchPage> createState() => _CourseSearchPageState();
}

class _CourseSearchPageState extends State<CourseSearchPage> with AutomaticKeepAliveClientMixin<CourseSearchPage> {

  bool isEnrolled = false;
  BloqoUserCourseEnrolledData? enrolledCourse;
  late bool buttonEnabled;

  final Map<String, bool> _showSectionsMap = {};
  bool isInitializedSectionMap = false;

  int _reviewsDisplayed = Constants.reviewsToShowAtFirst;

  @override
  void initState() {
    super.initState();
    buttonEnabled = !widget.enrollmentAlreadyRequested;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    bool isTablet = checkDevice(context);

    void initializeSectionsToShowMap(List<BloqoChapterData> chapters) {
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

    BloqoUserData myself = getUserFromAppState(context: context)!;

    bool isCoursePublic = widget.publishedCourse.isPublic;

    return Consumer<ApplicationSettingsAppState>(
        builder: (context, applicationSettingsAppState, _) {
          var theme = getAppThemeFromAppState(context: context);
          return BloqoMainContainer(
            alignment: const AlignmentDirectional(-1.0, -1.0),
            child: Consumer<UserCoursesEnrolledAppState>(
              builder: (context, userCoursesEnrolledAppState, _) {
                List<
                    BloqoUserCourseEnrolledData> userCoursesEnrolled = getUserCoursesEnrolledFromAppState(
                    context: context) ?? [];

                if (userCoursesEnrolled.any((enrolledCourse) =>
                enrolledCourse.courseId == widget.course.id)) {
                  isEnrolled = true;
                  enrolledCourse = userCoursesEnrolled.firstWhere(
                          (enrolledCourse) =>
                      enrolledCourse.courseId == widget.course.id);
                }

                return Padding(
                  padding: !isTablet ? const EdgeInsetsDirectional.all(0)
                      : Constants.tabletPadding,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  20, 4, 20, 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  widget.course.name,
                                  style: theme
                                      .getThemeData()
                                      .textTheme
                                      .displayLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colors.highContrastColor,
                                    fontSize: 36,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              20, 4, 20, 12),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    Text(
                                      localizedText.by,
                                      style: theme
                                          .getThemeData()
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                        color: theme.colors.highContrastColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    BloqoTextButton(
                                      text: widget.courseAuthor.username,
                                      color: theme.colors.highContrastColor,
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
                                rating: widget.rating ?? 0,
                                itemBuilder: (context, index) =>
                                    Icon(
                                      Icons.star,
                                      color: theme.colors.tertiary,
                                    ),
                                itemCount: 5,
                                itemSize: !isTablet ? 24 : 35,
                                direction: Axis.horizontal,
                              ),
                            ],
                          )
                      ),

                      Expanded(
                        child: SingleChildScrollView(
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
                                          style: theme
                                              .getThemeData()
                                              .textTheme
                                              .displayLarge
                                              ?.copyWith(
                                            color: theme.colors.highContrastColor,
                                            fontSize: 24,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 20, 10),
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
                                          onPressed: () {
                                            widget.onPush(
                                                QrCodePage(
                                                    qrCodeTitle: widget
                                                        .publishedCourse.courseName,
                                                    qrCodeContent: "${BloqoQrCodeType
                                                        .course.name}_${widget
                                                        .publishedCourse
                                                        .publishedCourseId}"
                                                )
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ]
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      20, 4, 20, 12),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: widget.course.description != null &&
                                        widget.course.description != ''
                                        ? Text(
                                      widget.course.description!,
                                      style: theme
                                          .getThemeData()
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                        fontWeight: FontWeight.w400,
                                        color: theme.colors.highContrastColor,
                                        fontSize: 16,
                                      ),
                                    )
                                        : const SizedBox
                                        .shrink(), // This will take up no space
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    20, 5, 20, 0),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    localizedText.content,
                                    style: theme
                                        .getThemeData()
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
                                        widget.chapters.length,
                                            (chapterIndex) {
                                          var chapter = widget
                                              .chapters[chapterIndex];

                                          return BloqoSeasaltContainer(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(15, 15, 15, 0),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.max,
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      Text(
                                                        '${localizedText
                                                            .chapter} ${chapterIndex +
                                                            1}',
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .displayMedium
                                                            ?.copyWith(
                                                          color: theme.colors
                                                              .secondaryText,
                                                          fontSize: 18,
                                                        ),
                                                      ),

                                                    ],
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(15, 5, 15, 0),
                                                  child: Row(
                                                    children: [
                                                      Align(
                                                        alignment: Alignment
                                                            .topLeft,
                                                        child: Text(
                                                          chapter.name,
                                                          style: Theme
                                                              .of(context)
                                                              .textTheme
                                                              .displayLarge
                                                              ?.copyWith(
                                                            color: theme.colors
                                                                .leadingColor,
                                                            fontSize: 24,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(0, 0, 0, 10),
                                                  child: chapter.description !=
                                                      null &&
                                                      chapter.description != ''
                                                      ? Padding(
                                                    padding: const EdgeInsetsDirectional
                                                        .fromSTEB(15, 5, 15, 10),
                                                    child: Row(
                                                      mainAxisSize: MainAxisSize
                                                          .max,
                                                      children: [
                                                        Flexible(
                                                          child: Align(
                                                            alignment: Alignment
                                                                .topLeft,
                                                            child: Text(
                                                              chapter.description!,
                                                              style: theme
                                                                  .getThemeData()
                                                                  .textTheme
                                                                  .displaySmall
                                                                  ?.copyWith(
                                                                color: theme.colors
                                                                    .primaryText,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                      : const SizedBox
                                                      .shrink(), // This will take up no space
                                                ),

                                          ... _showSectionsMap[chapter.id] == true
                                        ? [
                                          if (!isTablet)
                                            ...List.generate(
                                              widget.sections[chapter.id]!.length,
                                              (sectionIndex) {
                                                var section = widget.sections[chapter.id]![sectionIndex];
                                                return BloqoCourseSection(
                                                  section: section,
                                                  index: sectionIndex,
                                                  isClickable: false,
                                                  isInLearnPage: false,
                                                  isCompleted: false,
                                                  onPressed: () {},
                                                );
                                              },
                                            )
                                          else
                                            Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: LayoutBuilder(
                                              builder: (BuildContext context, BoxConstraints constraints) {
                                                double width = constraints.maxWidth / 2;
                                                double height = width / 3.25;
                                                double childAspectRatio = width / height;

                                                return GridView.builder(
                                                  shrinkWrap: true,
                                                  physics: const NeverScrollableScrollPhysics(),
                                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount: 2,
                                                    crossAxisSpacing: 10.0,
                                                    mainAxisSpacing: 10.0,
                                                    childAspectRatio: childAspectRatio,
                                                  ),
                                                  itemCount: widget.sections[chapter.id]!.length,
                                                  itemBuilder: (context, sectionIndex) {
                                                  var section = widget.sections[chapter.id]![sectionIndex];

                                                  return Padding(
                                                    padding: const EdgeInsets.all(5.0),
                                                    child: BloqoCourseSection(
                                                      section: section,
                                                      index: sectionIndex,
                                                      isClickable: false,
                                                      isInLearnPage: false,
                                                      isCompleted: false,
                                                      onPressed: () {},
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),

                                        // Collapse/Hide sections button
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
                                                            showSections(chapter.id);
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
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(20, 15, 20, 12),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                localizedText.reviews,
                                                style: theme
                                                    .getThemeData()
                                                    .textTheme
                                                    .displayLarge
                                                    ?.copyWith(
                                                  color: theme.colors
                                                      .highContrastColor,
                                                  fontSize: 24,
                                                ),
                                              ),
                                            ),
                                            const Spacer(),
                                            // This will create space between the first Text and the rest of the Row
                                            Row(
                                              children: [

                                                widget.rating != null ?
                                                Text(
                                                  widget.rating!
                                                      .toDouble()
                                                      .toString(),
                                                  style: theme
                                                      .getThemeData()
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                    color: theme.colors
                                                        .highContrastColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                )
                                                    : Text(
                                                  '0',
                                                  style: theme
                                                      .getThemeData()
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                    color: theme.colors
                                                        .highContrastColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 16,
                                                  ),
                                                ),

                                                Padding(
                                                  padding: const EdgeInsetsDirectional
                                                      .fromSTEB(8, 0, 8, 0),
                                                  child: RatingBarIndicator(
                                                    rating: widget.rating ?? 0,
                                                    itemBuilder: (context, index) =>
                                                        Icon(
                                                          Icons.star,
                                                          color: theme.colors
                                                              .tertiary,
                                                        ),
                                                    itemCount: 5,
                                                    itemSize: !isTablet ? 22 : 29,
                                                    direction: Axis.horizontal,
                                                  ),
                                                ),
                                                Text(
                                                  '(${widget.publishedCourse.reviews
                                                      .length.toString()})',
                                                  style: theme
                                                      .getThemeData()
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                    color: theme.colors
                                                        .highContrastColor,
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
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 15, 0, 15),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    localizedText.no_reviews_yet,
                                                    style: theme
                                                        .getThemeData()
                                                        .textTheme
                                                        .displaySmall
                                                        ?.copyWith(
                                                      color: theme.colors
                                                          .primaryText,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                            : _reviewsDisplayed >=
                                            widget.publishedCourse.reviews.length ?
                                        Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 15, 0, 0),
                                          child: Column(
                                            children:
                                            List.generate(
                                              _reviewsDisplayed >
                                                  widget.publishedCourse.reviews
                                                      .length
                                                  ?
                                              widget.publishedCourse.reviews.length
                                                  : _reviewsDisplayed,
                                                  (index) {
                                                BloqoReviewData review = widget
                                                    .reviews![index];
                                                return BloqoReview(
                                                  review: review,
                                                );
                                              },
                                            ),
                                          ),
                                        )

                                            : Padding(
                                          padding: const EdgeInsetsDirectional
                                              .fromSTEB(0, 15, 0, 15),
                                          child: Column(
                                            children: [
                                              ...List.generate(
                                                _reviewsDisplayed >
                                                    widget.publishedCourse.reviews
                                                        .length ?
                                                widget.publishedCourse.reviews
                                                    .length : _reviewsDisplayed,
                                                    (index) {
                                                  BloqoReviewData review = widget
                                                      .reviews![index];
                                                  return BloqoReview(
                                                    review: review,
                                                  );
                                                },
                                              ),

                                              BloqoTextButton(
                                                  onPressed: loadMoreReviews,
                                                  text: localizedText.load_more,
                                                  color: theme.colors.leadingColor
                                              ),
                                            ],
                                          ),
                                        ),

                                      ),

                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(
                                            20, 0, 20, 10),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Flexible(
                                                child:
                                                isEnrolled ?
                                                Text(
                                                  "${localizedText
                                                      .enrolled_on} ${DateFormat(
                                                      'dd/MM/yyyy').format(
                                                      enrolledCourse!.enrollmentDate
                                                          .toDate())}",
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                    color: theme.colors
                                                        .highContrastColor,
                                                    fontSize: 16,
                                                  ),
                                                )
                                                    : Text(
                                                  localizedText.published_on +
                                                      DateFormat('dd/MM/yyyy')
                                                          .format(widget.course
                                                          .publicationDate!
                                                          .toDate()),
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .displaySmall
                                                      ?.copyWith(
                                                    color: theme.colors
                                                        .highContrastColor,
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
                          !isEnrolled && !isCoursePublic &&
                              widget.course.authorId !=
                                  getUserFromAppState(context: context)!.id ?
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 10, 20, 10),
                            child: BloqoFilledButton(
                              onPressed: () async {
                                await _tryRequestAccessToPrivateCourse(
                                    context: context,
                                    localizedText: localizedText,
                                    publishedCourseId: widget.publishedCourse
                                        .publishedCourseId,
                                    applicantId: myself.id,
                                    courseAuthorId: widget.publishedCourse.authorId
                                );
                              },
                              height: 60,
                              color: buttonEnabled ? theme.colors.warning : theme
                                  .colors.secondaryText,
                              text: localizedText.request_access,
                              icon: Icons.front_hand,
                              fontSize: 24,
                            ),
                          )
                              : (!isCoursePublic && widget.course.authorId ==
                              getUserFromAppState(context: context)!.id ?
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 10, 20, 10),
                            child: BloqoFilledButton(
                              onPressed: () async {
                                showBloqoErrorAlert(
                                    context: context,
                                    title: localizedText.error_title,
                                    description: localizedText
                                        .creator_cannot_subscribe);
                              },
                              height: 60,
                              color: theme.colors.secondaryText,
                              text: localizedText.request_access,
                              icon: Icons.front_hand,
                              fontSize: 24,
                            ),
                          )
                              : (!isEnrolled ?
                          widget.course.authorId !=
                              getUserFromAppState(context: context)!.id ?
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                20, 10, 20, 10),
                            child: BloqoFilledButton(
                              onPressed: () async {
                                _goToLearnPage(context: context,
                                    localizedText: localizedText,
                                    course: widget.course,
                                    chapters: widget.chapters,
                                    sections: widget.sections,
                                    publishedCourseId: widget.publishedCourse
                                        .publishedCourseId);
                              },
                              height: 60,
                              color: theme.colors.leadingColor,
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
                                    description: localizedText
                                        .creator_cannot_subscribe);
                              },
                              color: theme.colors.secondaryText,
                              text: localizedText.enroll_in,
                              icon: Icons.add,
                              fontSize: !isTablet ? 24 : 26,
                              height: !isTablet ? 60 : 64,
                            ),
                          )

                    : Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20, 10, 20, 10),
                      child: BloqoFilledButton(
                        onPressed: () {
                          isEnrolled && enrolledCourse != null && enrolledCourse?.isCompleted == true ?
                            showBloqoErrorAlert(
                              context: context,
                              title: localizedText.error_title,
                              description: localizedText.cannot_unsubscribe_course_completed,
                            ) :

                            showBloqoConfirmationAlert(
                              context: context,
                              title: localizedText.warning,
                              description: localizedText.unsubscribe_confirmation,
                              confirmationFunction: () async {
                                await _tryDeleteUserCourseEnrolled(
                                    context: context,
                                    localizedText: localizedText,
                                    courseId: widget.course.id,
                                    enrolledUserId: myself.id
                                );
                              },
                              backgroundColor: theme.colors.error
                            );

                        },
                        color: isEnrolled && enrolledCourse != null && enrolledCourse?.isCompleted == true ?
                          theme.colors.inactive : theme.colors.leadingColor,
                        text: localizedText.unsubscribe,
                        icon: Icons.close_sharp,
                        fontSize: !isTablet ? 24 : 26,
                        height: !isTablet ? 60 : 64,
                      ),
                    )))
                  ],
                ),
              ],
            ),
          );

        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _goToLearnPage({required BuildContext context, required var localizedText, required BloqoCourseData course,
    required List<BloqoChapterData> chapters, required Map<String, List<BloqoSectionData>> sections,
    required String publishedCourseId}) async {
    context.loaderOverlay.show();
    try {
      BloqoUserData? user = getUserFromAppState(context: context);
      var firestore = getFirestoreFromAppState(context: context);
      BloqoPublishedCourseData publishedCourseToUpdate = await getPublishedCourseFromCourseId(
          firestore: firestore,
          localizedText: localizedText,
          courseId: course.id
      );
        BloqoUserCourseEnrolledData userCourseEnrolled = await saveNewUserCourseEnrolled(
            firestore: firestore,
            localizedText: localizedText,
            course: course,
            publishedCourseId: publishedCourseId,
            userId: user!.id
        );
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
        List<BloqoUserCourseEnrolledData>? enrolledCourses = getUserCoursesEnrolledFromAppState(context: context);
        if (enrolledCourses != null) {
          enrolledCourses.insert(0, userCourseEnrolled);
        } else {
          enrolledCourses = [userCourseEnrolled];
        }
        saveUserCoursesEnrolledToAppState(context: context, courses: enrolledCourses);
        publishedCourseToUpdate.numberOfEnrollments = publishedCourseToUpdate.numberOfEnrollments + 1;
        await savePublishedCourseChanges(
            firestore: firestore,
            localizedText: localizedText,
            updatedPublishedCourse: publishedCourseToUpdate
        );
        if(!context.mounted) return;
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

  Future<void> _tryDeleteUserCourseEnrolled({required BuildContext context, required var localizedText,
    required String courseId, required String enrolledUserId}) async {
    context.loaderOverlay.show();
    try {
      List<
          BloqoUserCourseEnrolledData>? courses = getUserCoursesEnrolledFromAppState(
          context: context);
      var firestore = getFirestoreFromAppState(context: context);
      BloqoPublishedCourseData publishedCourseToUpdate = await getPublishedCourseFromCourseId(
          firestore: firestore,
          localizedText: localizedText,
          courseId: courseId
      );
      BloqoUserCourseEnrolledData courseToRemove = courses!.firstWhere((c) =>
      c.courseId == courseId);

      if (courseToRemove.isCompleted) {
        if (!context.mounted) return;
        context.loaderOverlay.hide();
        showBloqoErrorAlert(
          context: context,
          title: localizedText.error_title,
          description: localizedText.cannot_unsubscribe_course_completed,
        );
      } else {
        await deleteUserCourseEnrolled(
            firestore: firestore,
            localizedText: localizedText,
            courseId: courseId,
            enrolledUserId: enrolledUserId
        );
        if (!context.mounted) return;
        deleteUserCourseEnrolledFromAppState(
            context: context, userCourseEnrolled: courseToRemove);
        publishedCourseToUpdate.numberOfEnrollments =
            publishedCourseToUpdate.numberOfEnrollments - 1;
        await savePublishedCourseChanges(
            firestore: firestore,
            localizedText: localizedText,
            updatedPublishedCourse: publishedCourseToUpdate
        );
        if (!context.mounted) return;
        context.loaderOverlay.hide();
        Navigator.of(context).pop();
        showBloqoSnackBar(
            context: context,
            text: localizedText.done
        );
      }
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

  Future<void> _goToUserCoursesPage({required BuildContext context, required var localizedText, required String authorId}) async {
    context.loaderOverlay.show();
    try {
      var firestore = getFirestoreFromAppState(context: context);
      BloqoUserData? courseAuthor = await getUserFromId(firestore: firestore, localizedText: localizedText, id: authorId);
      List<BloqoPublishedCourseData> publishedCourses = await getPublishedCoursesFromAuthorId(
          firestore: firestore,
          localizedText: localizedText,
          authorId: authorId
      );
      if(!context.mounted) return;
      context.loaderOverlay.hide();
      widget.onPush(
        UserProfilePage(
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

  Future<void> _tryRequestAccessToPrivateCourse({
    required BuildContext context,
    required var localizedText,
    required String publishedCourseId,
    required String applicantId,
    required String courseAuthorId,
  }) async {
    context.loaderOverlay.show();
    try {
      var firestore = getFirestoreFromAppState(context: context);
      BloqoNotificationData? oldNotification = await getNotificationFromPublishedCourseIdAndApplicantId(
          firestore: firestore,
          localizedText: localizedText,
          publishedCourseId: publishedCourseId,
          applicantId: applicantId
      );
      if(oldNotification == null){
        BloqoNotificationData newNotification = BloqoNotificationData(
          id: uuid(),
          userId: courseAuthorId,
          type: BloqoNotificationType.courseEnrollmentRequest.toString(),
          timestamp: Timestamp.now(),
          privatePublishedCourseId: publishedCourseId,
          applicantId: applicantId
        );
        await pushNotification(
            firestore: firestore,
            localizedText: localizedText,
            notification: newNotification
        );
        if(!context.mounted) return;
        context.loaderOverlay.hide();
        showBloqoSnackBar(
            context: context,
            text: localizedText.done
        );
        setState(() {
          buttonEnabled = false;
        });
      }
      else{
        if(!context.mounted) return;
        context.loaderOverlay.hide();
        showBloqoErrorAlert(
          context: context,
          title: localizedText.error_title,
          description: localizedText.already_requested_access_error,
        );
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