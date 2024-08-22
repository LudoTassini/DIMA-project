import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/custom/bloqo_progress_bar.dart';
import 'package:bloqo/utils/localization.dart';
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
                return const Scaffold(
                  body: BloqoProgressBar(
                    percentage: 0.25,
                    width: 100
                  ),
                );
              }
          ),
        )
    );
  }

  testWidgets('Progress bar present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoProgressBar), findsOneWidget);
  });
}