import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/complex/bloqo_setting.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  bool tapped = false;

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
                  body: BloqoSetting(
                    onPressed: () {
                      tapped = true;
                    },
                    settingDescription: "test",
                    settingIcon: Icons.settings,
                    settingTitle: "test",
                  )
                );
              }
          ),
        )
    );
  }

  setUp(() {
    tapped = false;
  });

  testWidgets('Setting present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoSetting), findsOneWidget);
  });

  testWidgets('Setting can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    await tester.tap(find.byType(BloqoSetting));
    await tester.pump();
    expect(tapped, isTrue);
  });

}