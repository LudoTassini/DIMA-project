import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/multimedia/bloqo_youtube_player.dart';
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
                  body: BloqoYouTubePlayer(
                      url: "test"
                  ),
                );
              }
          ),
        )
    );
  }

  testWidgets('YouTube player present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoYouTubePlayer), findsOneWidget);
  });
}