import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/style/themes/purple_orchid_theme.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  bool tapped = false;

  final testedWidget = MaterialApp(
    localizationsDelegates: getLocalizationDelegates(),
    supportedLocales: getSupportedLocales(),
    home: MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
      ],
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            body: BloqoFilledButton(
              color: PurpleOrchidTheme().colors.leadingColor,
              text: "Test",
              onPressed: () {
                tapped = true;
              },
            ),
          );
        },
      ),
    )
  );

  setUp(() {
    tapped = false;
  });

  testWidgets('Filled button present', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    expect(find.byType(BloqoFilledButton), findsOneWidget);
  });

  testWidgets('Filled button can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
