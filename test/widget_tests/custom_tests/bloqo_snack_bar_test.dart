import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/custom/bloqo_snack_bar.dart';
import 'package:bloqo/style/themes/purple_orchid_theme.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

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
                  showBloqoSnackBar(
                      context: context,
                      text: "test"
                  );
                },
              ),
            );
          },
        ),
      )
  );

  testWidgets('Snack bar present when triggered', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pump();
    expect(find.byType(SnackBar), findsOneWidget);
  });

}