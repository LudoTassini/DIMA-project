import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  Widget buildTestWidget() {
    return MaterialApp(
      localizationsDelegates: getLocalizationDelegates(),
      supportedLocales: getSupportedLocales(),
      home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: BloqoSeasaltContainer(
                  child: Container()
              ),
            );
          }
      ),
    );
  }

  testWidgets('Seasalt container present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoSeasaltContainer), findsOneWidget);
  });
}