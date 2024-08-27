import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/model/bloqo_notification_data.dart';
import 'package:bloqo/model/courses/published_courses/bloqo_published_course_data.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_enrolled_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../model/bloqo_user_data.dart';
import '../../model/courses/bloqo_course_data.dart';
import '../../utils/bloqo_exception.dart';
import '../../utils/uuid.dart';
import '../custom/bloqo_snack_bar.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoCourseEnrollmentRequestNotification extends StatefulWidget {
  const BloqoCourseEnrollmentRequestNotification({
    super.key,
    required this.notification,
    required this.onNotificationHandled,
  });

  final BloqoNotificationData notification;
  final VoidCallback onNotificationHandled;

  @override
  State<BloqoCourseEnrollmentRequestNotification> createState() => _BloqoCourseEnrollmentRequestNotificationState();
}

class _BloqoCourseEnrollmentRequestNotificationState extends State<BloqoCourseEnrollmentRequestNotification> {

  @override
  Widget build(BuildContext context) {
    var localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    return BloqoSeasaltContainer(
      child: FutureBuilder<List<Object>>(
        future: _getRequiredData(
          context: context,
          localizedText: localizedText,
          applicantId: widget.notification.applicantId!,
          publishedCourseId: widget.notification.privatePublishedCourseId!,
        ),
        builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                color: theme.colors.leadingColor,
                size: 100,
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "Error",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: theme.colors.error,
                  ),
                ),
              );
            } else {
              BloqoUserData applicant = snapshot.data![0] as BloqoUserData;
              BloqoCourseData course = snapshot.data![1] as BloqoCourseData;
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
                            child: _getProfilePicture(context: context, url: applicant.pictureUrl)
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
                                      color: theme.colors.success,
                                      onPressed: () async {
                                        await showBloqoConfirmationAlert(
                                            context: context,
                                            title: localizedText.warning,
                                            description: localizedText.accept_enrollment_confirmation,
                                            confirmationFunction: () async {
                                              await _tryAccept(
                                                context: context,
                                                localizedText: localizedText,
                                                applicantId: applicant.id,
                                                originalCourse: course
                                              );
                                              if(!context.mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
                                              );
                                            },
                                            backgroundColor: theme.colors.leadingColor,
                                            confirmationColor: theme.colors.success
                                        );
                                      },
                                      text: localizedText.accept,
                                      fontSize: 16,
                                      height: 32,
                                    ),
                                    BloqoFilledButton(
                                      color: theme.colors.error,
                                      onPressed: () async {
                                        await showBloqoConfirmationAlert(
                                            context: context,
                                            title: localizedText.warning,
                                            description: localizedText.deny_enrollment_confirmation,
                                            confirmationFunction: () async {
                                              await _tryDeny(context: context, localizedText: localizedText);
                                              if(!context.mounted) return;
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                BloqoSnackBar.get(context: context, child: Text(localizedText.done)),
                                              );
                                            },
                                            backgroundColor: theme.colors.error
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
                  color: theme.colors.error,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<List<Object>> _getRequiredData({
    required BuildContext context,
    required var localizedText,
    required String applicantId,
    required String publishedCourseId,
  }) async {
    try {
      var firestore = getFirestoreFromAppState(context: context);
      BloqoUserData applicant = await getUserFromId(
          firestore: firestore,
          localizedText: localizedText,
          id: applicantId
      );
      BloqoPublishedCourseData publishedCourse = await getPublishedCourseFromPublishedCourseId(
          firestore: firestore,
          localizedText: localizedText,
          publishedCourseId: publishedCourseId
      );
      BloqoCourseData privateCourse = await getCourseFromId(
          firestore: firestore,
          localizedText: localizedText,
          courseId: publishedCourse.originalCourseId
      );
      return [applicant, privateCourse];
    } on Exception catch (_) {
      return [];
    }
  }

  Future<void> _tryAccept({
    required BuildContext context,
    required var localizedText,
    required String applicantId,
    required BloqoCourseData originalCourse
  }) async {
    context.loaderOverlay.show();
    try{
      var firestore = getFirestoreFromAppState(context: context);
      await saveNewUserCourseEnrolled(
          firestore: firestore,
          localizedText: localizedText,
          course: originalCourse,
          publishedCourseId: widget.notification.privatePublishedCourseId!,
          userId: applicantId
      );
      await deleteNotification(
          firestore: firestore,
          localizedText: localizedText,
          notificationId: widget.notification.id
      );
      BloqoUserData courseAuthor = await getUserFromId(
          firestore: firestore,
          localizedText: localizedText,
          id: originalCourse.authorId
      );
      BloqoNotificationData notification = BloqoNotificationData(
        id: uuid(),
        userId: applicantId,
        type: BloqoNotificationType.courseEnrollmentAccepted.toString(),
        timestamp: Timestamp.now(),
        privateCourseName: originalCourse.name,
        privateCourseAuthorId: courseAuthor.id
      );
      await pushNotification(
          firestore: firestore,
          localizedText: localizedText,
          notification: notification
      );
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      widget.onNotificationHandled();
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

  Future<void> _tryDeny({
    required BuildContext context,
    required var localizedText
  }) async {
    context.loaderOverlay.show();
    try{
      var firestore = getFirestoreFromAppState(context: context);
      await deleteNotification(
          firestore: firestore,
          localizedText: localizedText,
          notificationId: widget.notification.id
      );
      if (!context.mounted) return;
      context.loaderOverlay.hide();
      widget.onNotificationHandled();
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

  Widget _getProfilePicture({required BuildContext context, required String? url}){
    if(getFromTestFromAppState(context: context) && url == "assets/tests/test.png"){
      return Image.asset(
        "assets/tests/test.png",
        fit: BoxFit.cover,
      );
    }
    return url != null && url != "none"
        ? FadeInImage.assetNetwork(
      placeholder: "assets/images/portrait_placeholder.png",
      image: url,
      fit: BoxFit.cover,
      placeholderFit: BoxFit.cover,
    )
        : Image.asset(
      "assets/images/portrait_placeholder.png",
      fit: BoxFit.cover,
    );
  }

}