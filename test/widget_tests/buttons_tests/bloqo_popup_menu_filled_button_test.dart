import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_popup_menu_filled_button.dart';
import 'package:bloqo/style/themes/purple_orchid_theme.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  bool firstTapped = false;
  bool secondTapped = false;

  final testedWidget = MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
    ],
    child: MaterialApp(
      localizationsDelegates: getLocalizationDelegates(),
      supportedLocales: getSupportedLocales(),
      home: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: BloqoPopupMenuFilledButton(
                mainColor: PurpleOrchidTheme().colors.leadingColor,
                mainText: "Test",
                texts: const [
                  "First",
                  "Second"
                ],
                colors: const [
                  Colors.red,
                  Colors.blue
                ],
                onPressedList: [
                      () {
                    firstTapped = true;
                  },
                      () {
                    secondTapped = true;
                  }
                ]
            ),
          );
        },
      ),
    ),
  );

  setUp(() {
    firstTapped = false;
    secondTapped = false;
  });

  testWidgets('Popup menu filled button present', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    expect(find.byType(BloqoPopupMenuFilledButton), findsOneWidget);
  });

  testWidgets('Popup menu filled button opens menu when tapped', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    await tester.tap(find.byType(BloqoPopupMenuFilledButton));
    await tester.pumpAndSettle(); // Wait for the popup menu to appear

    expect(find.byType(PopupMenuItem<String>), findsWidgets);
  });

  testWidgets('Popup menu filled button\'s menu displays choices', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    await tester.tap(find.byType(BloqoPopupMenuFilledButton));
    await tester.pumpAndSettle(); // Wait for the popup menu to appear

    expect(find.text('First'), findsOneWidget);
    expect(find.text('Second'), findsOneWidget);
  });

  testWidgets('Popup menu filled button\'s menu choice can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    await tester.tap(find.byType(BloqoPopupMenuFilledButton));
    await tester.pumpAndSettle(); // Wait for the popup menu to appear

    await tester.tap(find.text("First"));
    await tester.pump(); // Wait for the tap to be processed

    expect(firstTapped, isTrue);
    expect(secondTapped, isFalse);
  });
}