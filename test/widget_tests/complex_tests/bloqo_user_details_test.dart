import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/complex/bloqo_user_details.dart';
import 'package:bloqo/model/bloqo_user_data.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  bool tapped = false;

  Widget buildTestWidget({
    bool isFullNameVisible = true,
    bool showFollowingOptions = true,
    bool canReplacePicture = false
  }) {
    return MaterialApp(
        localizationsDelegates: getLocalizationDelegates(),
        supportedLocales: getSupportedLocales(),
        home: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
            ChangeNotifierProvider(create: (_) => UserAppState())
          ],
          child: Builder(
              builder: (BuildContext context) {
                BloqoUserData user = BloqoUserData(
                    id: "test",
                    email: "test@bloqo.com",
                    username: "test",
                    fullName: "Vanessa Visconti",
                    isFullNameVisible: isFullNameVisible,
                    pictureUrl: "none",
                    followers: [],
                    following: []
                );
                saveUserToAppState(context: context, user: user);
                return Scaffold(
                    body: BloqoUserDetails(
                      user: user,
                      isFullNameVisible: isFullNameVisible,
                      showFollowingOptions: showFollowingOptions,
                      onPush: (_) {
                        tapped = true;
                      },
                      onNavigateToPage: (_) {},
                      onReplacePicture: canReplacePicture ? () {
                        tapped = true;
                      } : null,
                    ),
                );
              }
          ),
        )
    );
  }

  setUp(() {
    tapped = false;
  });

  testWidgets('User details present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoUserDetails), findsOneWidget);
  });

  testWidgets('User can be followed (if following options are enabled)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoFilledButton), findsOneWidget);
  });

  testWidgets('User cannot be followed (if following options are disabled)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(showFollowingOptions: false));
    expect(find.byType(BloqoFilledButton), findsNothing);
  });

  testWidgets('User can see followers/following page', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.byType(BloqoTextButton).first);
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('User\'s QR code can be seen', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.byType(IconButton));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('User\'s image can be updated', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(canReplacePicture: true));
    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pump();
    expect(tapped, isTrue);
  });

  testWidgets('User\'s full name can be seen if it is allowed', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.text("Vanessa Visconti"), findsOneWidget);
  });

  testWidgets('User\'s full name can be seen if it is allowed', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(isFullNameVisible: false));
    expect(find.text("Vanessa Visconti"), findsNothing);
  });

}