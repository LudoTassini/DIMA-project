import 'package:bloqo/model/bloqo_review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/localization.dart';

class BloqoReviewComponent extends StatelessWidget{
  const BloqoReviewComponent({
    super.key,
    required this.review
  });

  final BloqoReview review;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 15),
      child: Container(
        decoration: BoxDecoration(
          color: BloqoColors.seasalt,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: BloqoColors.russianViolet,
            width: 3,
          ),
        ),
        //padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 8, 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
              child: Row(
                children: [
                  Text(
                    review.authorUsername,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      fontSize: 14,
                      color: BloqoColors.primaryText,
                    ),
                  ),
                  const Spacer(), // This will push the RatingBarIndicator to the right
                  RatingBarIndicator(
                    rating: review.rating.toDouble(),
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

            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
              child: Row(
                children: [
                  Text(
                    review.commentTitle,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme
                        .displayMedium?.copyWith(
                      fontSize: 18,
                      color: BloqoColors.primaryText,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 4, 10, 10),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  review.comment,
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme
                      .displayMedium?.copyWith(
                    fontSize: 14,
                    color: BloqoColors.secondaryText,
                  ),
                ),
              ),

            ),

          ],
        ),
      ),
    );
  }
}