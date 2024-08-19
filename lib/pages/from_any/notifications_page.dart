import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/notifications/bloqo_course_enrollment_request_notification.dart';
import 'package:bloqo/components/notifications/bloqo_new_course_published_notification.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../components/navigation/bloqo_app_bar.dart';
import '../../components/notifications/bloqo_course_enrollment_accepted_notification.dart';
import '../../model/bloqo_notification_data.dart';
import '../../model/bloqo_user.dart';
import '../../style/bloqo_colors.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with AutomaticKeepAliveClientMixin<NotificationsPage> {
  List<BloqoNotificationData> notifications = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BloqoUser user = getUserFromAppState(context: context)!;
    var localizedText = getAppLocalizations(context)!;
    return Scaffold(
      appBar: BloqoAppBar.get(
        context: context,
        title: localizedText.notifications,
        onPop: () => Navigator.of(context).pop(),
        canPop: true,
      ),
      body: BloqoMainContainer(
        child: FutureBuilder<List<BloqoNotificationData>>(
          future: getNotificationsFromUserId(localizedText: localizedText, userId: user.id),
          builder: (BuildContext context, AsyncSnapshot<List<BloqoNotificationData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  color: BloqoColors.seasalt,
                  size: 100,
                ),
              );
            } else if (snapshot.hasData) {
              notifications = snapshot.data!;
              if (notifications.isEmpty) {
                return Center(
                  child: Text(
                    localizedText.no_notifications,
                    style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: BloqoColors.seasalt,
                    ),
                  ),
                );
              } else {
                return Column(
                  children: List.generate(
                    notifications.length,
                        (index) {
                      BloqoNotificationData notification = notifications[index];
                      if(notification.type == BloqoNotificationType.courseEnrollmentRequest.toString()) {
                        return BloqoCourseEnrollmentRequestNotification(
                          notification: notification,
                          onNotificationHandled: () {
                            setState(() {
                              notifications.removeAt(index);
                            });
                          },
                        );
                      }
                      if(notification.type == BloqoNotificationType.courseEnrollmentAccepted.toString()) {
                        return BloqoCourseEnrollmentAcceptedNotification(
                          notification: notification,
                          onNotificationHandled: () {
                            setState(() {
                              notifications.removeAt(index);
                            });
                          },
                        );
                      }
                      if(notification.type == BloqoNotificationType.newCourseFromFollowedUser.toString()) {
                        return BloqoNewCoursePublishedNotification(
                          notification: notification,
                          onNotificationHandled: () {
                            setState(() {
                              notifications.removeAt(index);
                            });
                          },
                        );
                      }
                      return Container();
                    },
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}