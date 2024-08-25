import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/notifications/bloqo_new_course_published_notification.dart';
import 'package:bloqo/model/bloqo_notification_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  Widget buildTestWidget() {
    return MaterialApp(
        localizationsDelegates: getLocalizationDelegates(),
        supportedLocales: getSupportedLocales(),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
          ],
          child: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: BloqoNewCoursePublishedNotification(
                    onNotificationHandled: () {},
                    notification: BloqoNotificationData(
                        id: "test",
                        userId: "test",
                        type: BloqoNotificationType.courseEnrollmentAccepted.toString(),
                        timestamp: Timestamp.now(),
                        courseAuthorId: "test",
                        courseName: "test"
                    ),
                  ),
                );
              }
          ),
        )
    );
  }

  testWidgets('New course published notification present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoNewCoursePublishedNotification), findsOneWidget);
  });

}