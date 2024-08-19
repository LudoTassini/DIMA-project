import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_published_course_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

import '../../components/buttons/bloqo_text_button.dart';
import '../../components/complex/bloqo_review.dart';
import '../../components/containers/bloqo_seasalt_container.dart';
import '../../model/courses/published_courses/bloqo_review_data.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/constants.dart';

class ViewStatisticsPage extends StatefulWidget {

  const ViewStatisticsPage({
    super.key,
    required this.publishedCourse,
    required this.reviews
  });

  final BloqoPublishedCourseData publishedCourse;
  final List<BloqoReviewData> reviews;

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
    return BloqoMainContainer(
        alignment: const AlignmentDirectional(-1, -1),
        child: SingleChildScrollView(
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
                            color: BloqoColors.seasalt,
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
                              color: BloqoColors.seasalt,
                              fontSize: 16,
                            ),
                          ),
                          BloqoTextButton(
                            text: widget.publishedCourse.authorUsername,
                            color: BloqoColors.seasalt,
                            onPressed: () async {
                              // TODO
                            },
                            fontSize: 16,
                          ),
                        ],
                      ),
                    ),
                    RatingBarIndicator(
                      rating: widget.publishedCourse.rating,
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
                                color: BloqoColors.russianViolet,
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
                              child: Text(
                                localizedText.users_enrolled
                              )
                            )
                          ]
                        ),
                        Row(
                          children: [
                            Text(
                              widget.publishedCourse.numberOfCompletions.toString(),
                              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Expanded(
                              child: Text(
                                localizedText.users_completed
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
                          color: BloqoColors.seasalt,
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
                            color: BloqoColors.seasalt,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: RatingBarIndicator(
                            rating: widget.publishedCourse.rating,
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
                              color: BloqoColors.primaryText,
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
                        child: Text(
                          localizedText.published_on +
                              DateFormat('dd/MM/yyyy').format(widget.publishedCourse.publicationDate.toDate()),
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
            ]
          )
        )
    );
  }

  @override
  bool get wantKeepAlive => true;

}