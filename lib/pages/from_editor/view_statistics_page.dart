import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/model/bloqo_user_data.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_published_course_data.dart';
import 'package:bloqo/pages/from_any/user_profile_page.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../components/buttons/bloqo_text_button.dart';
import '../../components/complex/bloqo_review.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/published_courses/bloqo_review_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';

class ViewStatisticsPage extends StatefulWidget {

  const ViewStatisticsPage({
    super.key,
    required this.publishedCourse,
    required this.reviews,
    required this.onPush,
    required this.onNavigateToPage
  });

  final BloqoPublishedCourseData publishedCourse;
  final List<BloqoReviewData> reviews;
  final void Function(Widget) onPush;
  final void Function(int) onNavigateToPage;

  @override
  State<ViewStatisticsPage> createState() => _ViewStatisticsPageState();

}

class _ViewStatisticsPageState extends State<ViewStatisticsPage> with AutomaticKeepAliveClientMixin<ViewStatisticsPage> {

  int _reviewsDisplayed = Constants.reviewsToShowAtFirst;

  void loadMoreReviews() {
    setState(() {
      _reviewsDisplayed += Constants.reviewsToFurtherLoadAtRequest;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    var localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1, -1),
        child: SingleChildScrollView(
          child: Padding(
            padding: !isTablet ? const EdgeInsetsDirectional.all(0) : Constants.tabletPadding,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 4, 20, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            widget.publishedCourse.courseName,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: theme.colors.highContrastColor,
                              fontSize: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]
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
                                color: theme.colors.highContrastColor,
                                fontSize: 16,
                              ),
                            ),
                            BloqoTextButton(
                              text: widget.publishedCourse.authorUsername,
                              color: theme.colors.highContrastColor,
                              onPressed: () async {
                                await _tryGoToProfilePage(context: context, localizedText: localizedText);
                              },
                              fontSize: 16,
                            ),
                          ],
                        ),
                      ),
                      RatingBarIndicator(
                        rating: widget.publishedCourse.rating,
                        itemBuilder: (context, index) => Icon(
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
                BloqoSeasaltContainer(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                localizedText.statistics,
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: theme.colors.leadingColor,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                widget.publishedCourse.numberOfEnrollments.toString(),
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                  child: Text(
                                    localizedText.users_enrolled
                                  )
                                )
                              )
                            ]
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(0, 2, 0, 0),
                                child: Text(
                                  widget.publishedCourse.numberOfCompletions.toString(),
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                                  child: Text(
                                    localizedText.users_completed,
                                  )
                                )
                              )
                            ]
                          ),
                        ]
                    )
                  )
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
                            color: theme.colors.highContrastColor,
                            fontSize: 24,
                          ),
                        ),
                      ),
                      const Spacer(), // This will create space between the first Text and the rest of the Row
                      Row(
                        children: [
                          Text(
                            widget.publishedCourse.rating.toDouble().toString(),
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: theme.colors.highContrastColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                            child: RatingBarIndicator(
                              rating: widget.publishedCourse.rating,
                              itemBuilder: (context, index) => Icon(
                                Icons.star,
                                color: theme.colors.tertiary,
                              ),
                              itemCount: 5,
                              itemSize: !isTablet ? 22 : 29,
                              direction: Axis.horizontal,
                            ),
                          ),
                          Text(
                            '(${widget.publishedCourse.reviews.length.toString()})',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: theme.colors.highContrastColor,
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
                  (widget.reviews.isEmpty) ?
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
                                color: theme.colors.primaryText,
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
                          BloqoReviewData review = widget.reviews[index];
                          return BloqoReview(
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
                            BloqoReviewData review = widget.reviews[index];
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
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      20, 0, 20, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                          child: Text(
                            localizedText.published_on +
                                DateFormat('dd/MM/yyyy').format(widget.publishedCourse.publicationDate.toDate()),
                            style: Theme
                                .of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                              color: theme.colors.highContrastColor,
                              fontSize: 16,
                            ),
                          )

                      ),

                    ],
                  ),
                ),
              ]
            )
          )
        ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _tryGoToProfilePage({required BuildContext context, required var localizedText}) async {
    context.loaderOverlay.show();
    try{
      var firestore = getFirestoreFromAppState(context: context);

      BloqoUserData author = await getUserFromId(
          firestore: firestore,
          localizedText: localizedText,
          id: widget.publishedCourse.authorId
      );
      List<BloqoPublishedCourseData> publishedCourses = await getPublishedCoursesFromAuthorId(
          firestore: firestore,
          localizedText: localizedText,
          authorId: author.id
      );
      if(!context.mounted) return;
      context.loaderOverlay.hide();
      widget.onPush(
          UserProfilePage(
              onPush: widget.onPush,
              onNavigateToPage: widget.onNavigateToPage,
              author: author,
              publishedCourses: publishedCourses
          )
      );
    }
    on BloqoException catch(e) {
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