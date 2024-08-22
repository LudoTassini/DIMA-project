import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/app_state/user_courses_enrolled_app_state.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/custom/bloqo_rating_bar.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_review_data.dart';
import 'package:bloqo/model/bloqo_user_data.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_enrolled_data.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/custom/bloqo_snack_bar.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/courses/published_courses/bloqo_published_course_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/constants.dart';
import '../../utils/localization.dart';
import '../../utils/uuid.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({
    super.key,
    required this.onPush,
    required this.courseToReview,
    required this.userReview
  });

  final void Function(Widget) onPush;
  final BloqoUserCourseEnrolledData courseToReview;
  final BloqoReviewData? userReview;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> with AutomaticKeepAliveClientMixin<ReviewPage> {
  late TextEditingController controllerTitle;
  late TextEditingController controllerReview;
  late bool isRated;
  int selectedRating = 0;

  @override
  void initState() {
    super.initState();
    controllerTitle = TextEditingController();
    controllerReview = TextEditingController();

    if (widget.userReview == null) {
      isRated = false;
    } else {
      isRated = true;
      controllerTitle.text = widget.userReview!.commentTitle;
      controllerReview.text = widget.userReview!.comment;
      selectedRating = widget.userReview!.rating;
    }
  }

  @override
  void dispose() {
    controllerTitle.dispose();
    controllerReview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);

    final formKeyAnswerTitle = GlobalKey<FormState>();
    final formKeyAnswerReview = GlobalKey<FormState>();

    return Consumer<UserCoursesEnrolledAppState>(
        builder: (context, userCoursesEnrolledAppState, _) {

      return BloqoMainContainer(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                      child: Text(
                        widget.courseToReview.courseName,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: theme.colors.highContrastColor,
                            fontSize: 30),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(20, 10, 20, 10),
                      child: Text(
                        !isRated ? localizedText.review_headliner_to_rate : localizedText.review_headliner_rated,
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                            color: theme.colors.highContrastColor,
                            fontSize: 20),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      child: Row(
                        children: [
                          BloqoRatingBar(
                            rating: selectedRating,  // Set the initial rating
                            onRatingChanged: isRated ? null : (rating) {
                              setState(() {
                                selectedRating = rating;
                              });
                            },
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
                      child: Form(
                        key: formKeyAnswerTitle,
                        child: BloqoTextField(
                          controller: controllerTitle, // Pre-populated text
                          formKey: formKeyAnswerTitle,
                          labelText: localizedText.title,
                          hintText: localizedText.review_title,
                          maxInputLength: Constants.maxReviewTitleLength,
                          isDisabled: isRated,  // Disable if already rated
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      child: Form(
                        key: formKeyAnswerReview,
                        child: BloqoTextField(
                          controller: controllerReview,  // Pre-populated text
                          formKey: formKeyAnswerReview,
                          labelText: localizedText.review,
                          hintText: localizedText.your_review,
                          maxInputLength: Constants.maxReviewLength,
                          isTextArea: true, // Allow multiline input
                          isDisabled: isRated,  // Disable if already rated
                        ),
                      ),
                    ),

                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 15),
                        child: isRated
                            ? Container()

                            : BloqoFilledButton(
                              onPressed: () async {
                                await _tryPublishReview(
                                  context: context,
                                  controllerTitle: controllerTitle,
                                  controllerReview: controllerReview,
                                  rating: selectedRating,
                                  userCourseEnrolled: widget.courseToReview
                                );
                              },
                              color: theme.colors.leadingColor,
                              text: localizedText.publish,
                              icon: Icons.comment
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

    }
    );
  }

  @override
  bool get wantKeepAlive => true;


  Future<void> _tryPublishReview({required BuildContext context, required TextEditingController controllerTitle, required TextEditingController controllerReview,
    required int rating, required BloqoUserCourseEnrolledData userCourseEnrolled}) async {

    BloqoUserData myself = getUserFromAppState(context: context)!;

    final localizedText = getAppLocalizations(context)!;
    final loaderOverlay = context.loaderOverlay;
    loaderOverlay.show();

    try {

      var firestore = getFirestoreFromAppState(context: context);

      BloqoReviewData reviewToPublish = BloqoReviewData(
        authorUsername: myself.username,
        authorId: myself.id,
        rating: rating,
        id: uuid(),
        commentTitle: controllerTitle.text,
        comment: controllerReview.text,
      );

      await publishReview(
          firestore: firestore,
          localizedText: localizedText,
          review: reviewToPublish
      );

      BloqoPublishedCourseData publishedCourse =
      await getPublishedCourseFromPublishedCourseId(
        firestore: firestore,
        localizedText: localizedText,
        publishedCourseId: widget.courseToReview.publishedCourseId,
      );

      List<dynamic> reviewsIds = publishedCourse.reviews;
      List<BloqoReviewData> reviews = [];
      double newRating = 0;

      if(reviewsIds.isNotEmpty) {
        reviews = await getReviewsFromIds(
            firestore: firestore,
            localizedText: localizedText,
            reviewsIds: reviewsIds
        );
        for (var review in reviews) {
          newRating += review.rating;
        }
      }

      newRating += rating;
      if (reviews.isNotEmpty) {
        newRating /= (reviews.length + 1);
      }

      if (!context.mounted) return;
      await addReviewToPublishedCourse(
        firestore: firestore,
        localizedText: localizedText,
        reviewId: reviewToPublish.id,
        publishedCourseId: widget.courseToReview.publishedCourseId,
        newRating: newRating,
      );

      if (!context.mounted) return;
      await updateUserCourseEnrolledRated(
          firestore: firestore,
          localizedText: localizedText,
          userId: myself.id,
          publishedCourseId: publishedCourse.publishedCourseId
      );

      if (!context.mounted) return;
      setState(() {
        isRated = true;
      });

      //FIXME: serve aggiornare UserCourseEnrolledAppState?
      userCourseEnrolled.isRated = true;
      if (!context.mounted) {
        return;
      } else {
      updateUserCoursesEnrolledToAppState(context: context, userCourseEnrolled: userCourseEnrolled); }

      if (!context.mounted) return;

      loaderOverlay.hide();

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
      );

    } on BloqoException catch (e) {
      if (!mounted) return;
      loaderOverlay.hide();
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    }
  }


}