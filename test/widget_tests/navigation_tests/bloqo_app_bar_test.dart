import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/navigation/bloqo_app_bar.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  bool notificationTapped = false;
  bool didPop = false;

  setUp(() {
    notificationTapped = false;
    didPop = false;
  });

  Widget buildTestWidget({required bool canPop, bool notificationsPresent = false}) {
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
                  body: Container(),
                  appBar: BloqoAppBar.get(
                    context: context,
                    title: "test",
                    canPop: canPop,
                    onPop: () { didPop = true; },
                    onNotificationIconPressed: notificationsPresent ? () { notificationTapped = true; } : () {}
                  ),
                );
              }
          )
      ),
    );
  }

  testWidgets('App bar present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(canPop: false));
    expect(find.text("test"), findsOneWidget);
  });

  testWidgets('Notification page can be opened from app bar', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(canPop: false, notificationsPresent: true));
    await tester.tap(find.byIcon(Icons.notifications));
    await tester.pumpAndSettle(); // Wait for animations and state changes
    expect(notificationTapped, isTrue);
  });

  testWidgets('App bar allows pop', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(canPop: true));
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle(); // Wait for animations and state changes
    expect(didPop, isTrue);
  });

}
