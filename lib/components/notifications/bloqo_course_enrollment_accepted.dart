import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/model/bloqo_notification_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../model/bloqo_user.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/bloqo_exception.dart';
import '../popups/bloqo_error_alert.dart';

class BloqoCourseEnrollmentAccepted extends StatefulWidget {
  const BloqoCourseEnrollmentAccepted({
    super.key,
    required this.notification,
    required this.onNotificationHandled,
  });

  final BloqoNotificationData notification;
  final VoidCallback onNotificationHandled;

  @override
  State<BloqoCourseEnrollmentAccepted> createState() => _BloqoCourseEnrollmentRequestState();
}

class _BloqoCourseEnrollmentRequestState extends State<BloqoCourseEnrollmentAccepted> {

  @override
  Widget build(BuildContext context) {
    var localizedText = getAppLocalizations(context)!;
    return BloqoSeasaltContainer(
      child: FutureBuilder<BloqoUser?>(
        future: _getRequiredData(
          localizedText: localizedText,
          courseAuthorId: widget.notification.privateCourseAuthorId!
        ),
        builder: (BuildContext context, AsyncSnapshot<BloqoUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.prograssiveDots(
                color: BloqoColors.russianViolet,
                size: 100,
              ),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data == null) {
              return Center(
                child: Text(
                  "Error",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: BloqoColors.error,
                  ),
                ),
              );
            } else {
              BloqoUser courseAuthor = snapshot.data!;
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
                              image: courseAuthor.pictureUrl,
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
                                  courseAuthor.username,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  localizedText.has_granted_access,
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  widget.notification.privateCourseName!,
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
                                      color: BloqoColors.okay,
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

  Future<BloqoUser?> _getRequiredData({
    required var localizedText,
    required String courseAuthorId,
  }) async {
    try {
      BloqoUser courseAuthor = await getUserFromId(localizedText: localizedText, id: courseAuthorId);
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
      await deleteNotification(localizedText: localizedText, notificationId: widget.notification.id);
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

}