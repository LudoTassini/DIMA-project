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
          if (_didRemoveNotifications) {
            widget.onNotificationRemoved();
          }
        },
        canPop: true,
      ),
      body: BloqoMainContainer(
        alignment: const AlignmentDirectional(-1, -1),
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
                    style: theme.getThemeData().textTheme.displayMedium?.copyWith(
                      color: theme.colors.highContrastColor,
                    ),
                  ),
                );
              } else {
                return Padding(
                  padding: !isTablet ? const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40) :
                    (Constants.tabletPadding + const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 40)),
                  child: isTablet
                      ? LayoutBuilder(
                    builder: (BuildContext context, BoxConstraints constraints) {
                      double width = constraints.maxWidth / 2;
                      double height = width / 1.40;
                      double childAspectRatio = width / height;

                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: constraints.maxHeight, // Constrain GridView to the available height
                        ),
                        child: GridView.builder(
                          physics: const AlwaysScrollableScrollPhysics(), // Ensure GridView is scrollable
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: childAspectRatio,
                          ),
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            return _buildNotificationWidget(notifications[index]);
                          },
                        ),
                      );
                    },
                  )
                      : SingleChildScrollView(
                    child: Column(
                      children: [
                        ...List.generate(
                          notifications.length,
                              (index) => _buildNotificationWidget(notifications[index]),
                        ),
                      ],
                    ),
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
      ),
    );

  }

  // Helper method to build notification widget
  Widget _buildNotificationWidget(BloqoNotificationData notification) {
    if(notification.type == BloqoNotificationType.courseEnrollmentRequest.toString()) {
      return BloqoCourseEnrollmentRequestNotification(
        notification: notification,
        onNotificationHandled: () {
          setState(() {
            notifications.remove(notification);
            _didRemoveNotifications = true;
          });
        },
      );
    }
    else if (notification.type == BloqoNotificationType.courseEnrollmentAccepted.toString()) {
      return BloqoCourseEnrollmentAcceptedNotification(
        notification: notification,
        onNotificationHandled: () {
          setState(() {
            notifications.remove(notification);
            _didRemoveNotifications = true;
          });
        },
      );
    }
    else if (notification.type == BloqoNotificationType.newCourseFromFollowedUser.toString()) {
      return BloqoNewCoursePublishedNotification(
        notification: notification,
        onNotificationHandled: () {
          setState(() {
            notifications.remove(notification);
            _didRemoveNotifications = true;
          });
        },
      );
    } else {
      return Container(); // Return empty container if type doesn't match
    }
  }

  @override
  bool get wantKeepAlive => true;
}