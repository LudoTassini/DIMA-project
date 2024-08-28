import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_review_data.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class BloqoReview extends StatelessWidget{
  const BloqoReview({
    super.key,
    required this.review
  });

  final BloqoReviewData review;

  @override
  Widget build(BuildContext context) {

    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 15),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colors.highContrastColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: theme.colors.leadingColor,
            width: 3,
          ),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(
                    review.authorUsername,
                    textAlign: TextAlign.start,
                    style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                      fontSize: 14,
                      color: theme.colors.primaryText,
                    ),
                  ),
                  const Spacer(), // This will push the RatingBarIndicator to the right
                  RatingBarIndicator(
                    rating: review.rating.toDouble(),
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: theme.colors.tertiary,
                    ),
                    itemCount: 5,
                    itemSize: !isTablet ? 22 : 29,
                    direction: Axis.horizontal,
                  ),
                ],
              ),

              Row(
                children: [
                  Text(
                    review.commentTitle,
                    textAlign: TextAlign.start,
                    style: theme.getThemeData().textTheme
                        .displayMedium?.copyWith(
                      fontSize: 18,
                      color: theme.colors.primaryText,
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    review.comment,
                    textAlign: TextAlign.start,
                    style: theme.getThemeData().textTheme
                        .displayMedium?.copyWith(
                      fontSize: 14,
                      color: theme.colors.secondaryText,
                    ),
                  ),
                ),

              )
            ]
          )
        )
      )
    );
  }
}