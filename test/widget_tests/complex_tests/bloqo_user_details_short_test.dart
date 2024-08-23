import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/app_state/user_app_state.dart';
import 'package:bloqo/components/complex/bloqo_user_details_short.dart';
import 'package:bloqo/model/bloqo_user_data.dart';
import 'package:bloqo/style/themes/purple_orchid_theme.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

void main() {

  Widget buildTestWidget({
    bool isFullNameVisible = true,
  }) {
    return GlobalLoaderOverlay(
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) {
          return Center(
            child: LoadingAnimationWidget.prograssiveDots(
              color: PurpleOrchidTheme().colors.leadingColor,
              size: 100,
            ),
          );
        },
        child: MaterialApp(
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
                  updateFirestoreInAppState(context: context, firestore: FakeFirebaseFirestore());
                  return Scaffold(
                    body: BloqoUserDetailsShort(
                      user: user,
                      onPush: (_) {},
                      onNavigateToPage: (_) {},
                    ),
                  );
                }
            ),
          )
        )
    );
  }

  testWidgets('User details short present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoUserDetailsShort), findsOneWidget);
  });

  testWidgets('User details can be expanded in new page if tapped', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.text("test"));
    expect(find.byType(GlobalLoaderOverlay), findsOneWidget);
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