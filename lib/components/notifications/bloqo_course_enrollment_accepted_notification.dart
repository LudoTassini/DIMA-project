import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/bloqo_notification_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../model/bloqo_user_data.dart';
import '../../utils/bloqo_exception.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoCourseEnrollmentAcceptedNotification extends StatefulWidget {
  const BloqoCourseEnrollmentAcceptedNotification({
    super.key,
    required this.notification,
    required this.onNotificationHandled,
  });

  final BloqoNotificationData notification;
  final VoidCallback onNotificationHandled;

  @override
  State<BloqoCourseEnrollmentAcceptedNotification> createState() => _BloqoCourseEnrollmentRequestState();
}

class _BloqoCourseEnrollmentRequestState extends State<BloqoCourseEnrollmentAcceptedNotification> {

  @override
  Widget build(BuildContext context) {
    var localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    return BloqoSeasaltContainer(
      child: FutureBuilder<BloqoUserData?>(
        future: _getRequiredData(
          context: context,
          localizedText: localizedText,
          courseAuthorId: widget.notification.privateCourseAuthorId!
        ),
        builder: (BuildContext context, AsyncSnapshot<BloqoUserData?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                color: theme.colors.leadingColor,
                size: 100,
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  "Error",
                  style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                    color: theme.colors.error,
                  ),
                ),
              );
            } else {
              BloqoUserData courseAuthor = snapshot.data!;
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
                            child: _getProfilePicture(context: context, url: courseAuthor.pictureUrl)
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
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: courseAuthor.username,
                                    style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: localizedText.has_granted_access,
                                    style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                                      fontSize: 18,
                                    ),
                                  ),
                                  TextSpan(
                                    text: widget.notification.privateCourseName!,
                                    style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
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
                                      color: theme.colors.okay,
                                      onPressed: () async {
                                        await _tryDeleteNotification(
                                          context: context,
                                          localizedText: localizedText
                                        );
                                      },
                                      text: localizedText.okay,
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
                style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                  color: theme.colors.error,
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Future<BloqoUserData?> _getRequiredData({
    required BuildContext context,
    required var localizedText,
    required String courseAuthorId,
  }) async {
    try {
      var firestore = getFirestoreFromAppState(context: context);
      BloqoUserData courseAuthor = await getUserFromId(
          firestore: firestore,
          localizedText: localizedText,
          id: courseAuthorId
      );
      return courseAuthor;
    } on Exception catch (_) {
      return null;
    }
  }

  Future<void> _tryDeleteNotification({
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