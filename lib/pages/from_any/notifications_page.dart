import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/notifications/bloqo_course_enrollment_request_notification.dart';
import 'package:bloqo/components/notifications/bloqo_new_course_published_notification.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../components/navigation/bloqo_app_bar.dart';
import '../../components/notifications/bloqo_course_enrollment_accepted_notification.dart';
import '../../model/bloqo_notification_data.dart';
import '../../model/bloqo_user_data.dart';
import '../../utils/constants.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    super.key,
    required this.onNotificationRemoved
  });

  final void Function() onNotificationRemoved;

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> with AutomaticKeepAliveClientMixin<NotificationsPage> {
  List<BloqoNotificationData> notifications = [];

  bool _didRemoveNotifications = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    BloqoUserData user = getUserFromAppState(context: context)!;
    var localizedText = getAppLocalizations(context)!;
    var theme = getAppThemeFromAppState(context: context);
    var firestore = getFirestoreFromAppState(context: context);
    bool isTablet = checkDevice(context);

    return Scaffold(
      appBar: BloqoAppBar.get(
        context: context,
        title: localizedText.notifications,
        onPop: () {
          Navigator.of(context).pop();
          if(_didRemoveNotifications) {
            widget.onNotificationRemoved();
          }
        },
        canPop: true,
      ),
      body: BloqoMainContainer(
        child: FutureBuilder<List<BloqoNotificationData>>(
          future: getNotificationsFromUserId(firestore: firestore, localizedText: localizedText, userId: user.id),
          builder: (BuildContext context, AsyncSnapshot<List<BloqoNotificationData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.prograssiveDots(
                  color: theme.colors.highContrastColor,
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
                      color: theme.colors.highContrastColor,
                    ),
                  ),
                );
              } else {
                return Padding(
                    padding: !isTablet ? const EdgeInsetsDirectional.all(0)
                : Constants.tabletPadding,
                  child: Column(
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
                                _didRemoveNotifications = true;
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
                                _didRemoveNotifications = true;
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
                                _didRemoveNotifications = true;
                              });
                            },
                          );
                        }
                        return Container();
                      },
                    ),
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
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}