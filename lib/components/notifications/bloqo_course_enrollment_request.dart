import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/model/bloqo_notification_data.dart';
import 'package:bloqo/model/bloqo_published_course.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../model/bloqo_user.dart';
import '../../model/courses/bloqo_course.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoCourseEnrollmentRequest extends StatefulWidget {
  const BloqoCourseEnrollmentRequest({
    super.key,
    required this.notification,
    required this.onActionSuccessful
  });

  final BloqoNotificationData notification;
  final void Function() onActionSuccessful;

  @override
  State<BloqoCourseEnrollmentRequest> createState() => _BloqoCourseEnrollmentRequestState();
}

class _BloqoCourseEnrollmentRequestState extends State<BloqoCourseEnrollmentRequest> {

  @override
  Widget build(BuildContext context) {
    var localizedText = getAppLocalizations(context)!;
    return BloqoSeasaltContainer(
      child: FutureBuilder<List<Object>>(
        future: _getRequiredData(
          localizedText: localizedText,
          applicantId: widget.notification.applicantId!,
          publishedCourseId: widget.notification.privatePublishedCourseId!,
        ),
        builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                color: BloqoColors.russianViolet,
                size: 100,
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "Error",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: BloqoColors.error,
                  ),
                ),
              );
            } else {
              BloqoUser applicant = snapshot.data![0] as BloqoUser;
              BloqoCourse course = snapshot.data![1] as BloqoCourse;
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align items to the top
                  children: [
                    Expanded(
                      flex: 2,
                      child: AspectRatio(
                        aspectRatio: 1.0,
                        child: Align(
                          alignment: Alignment.topCenter, // Align image to the top center
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: FadeInImage.assetNetwork(
                              placeholder: "assets/images/portrait_placeholder.png",
                              image: applicant.pictureUrl,
                              fit: BoxFit.cover,
                              placeholderFit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Wrap(
                              spacing: 5,
                              runSpacing: 5,
                              children: [
                                Text(
                                  applicant.username,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  localizedText.has_requested_access,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  course.name,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    BloqoFilledButton(
                                      color: BloqoColors.success,
                                      onPressed: () {}, // TODO
                                      text: localizedText.accept,
                                      fontSize: 16,
                                      height: 32,
                                    ),
                                    BloqoFilledButton(
                                      color: BloqoColors.error,
                                      onPressed: () async {
                                        await showBloqoConfirmationAlert(
                                            context: context,
                                            title: localizedText.warning,
                                            description: localizedText.deny_enrollment_confirmation,
                                            confirmationFunction: () async {
                                              await _tryDeny(context: context, localizedText: localizedText);
                                              widget.onActionSuccessful;
                                            },
                                            backgroundColor: BloqoColors.error
                                        );
                                      },
                                      text: localizedText.deny,
                                      fontSize: 16,
                                      height: 32,
                                    ),
                                  ],
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
          } else {
            return Center(
              child: Text(
                "Error",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: BloqoColors.error,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Object>> _getRequiredData({
    required var localizedText,
    required String applicantId,
    required String publishedCourseId,
  }) async {
    try {
      BloqoUser applicant = await getUserFromId(localizedText: localizedText, id: applicantId);
      BloqoPublishedCourse publishedCourse = await getPublishedCourseFromPublishedCourseId(localizedText: localizedText, publishedCourseId: publishedCourseId);
      BloqoCourse privateCourse = await getCourseFromId(localizedText: localizedText, courseId: publishedCourse.originalCourseId);
      return [applicant, privateCourse];
    } on Exception catch (_) {
      return [];
    }
  }

  Future<void> _tryDeny({
    required BuildContext context,
    required var localizedText
  }) async {
    context.loaderOverlay.show();
    try{
      await deleteNotification(localizedText: localizedText, notificationId: widget.notification.id);
      if (!context.mounted) return;
      context.loaderOverlay.hide();
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