import 'package:bloqo/components/containers/bloqo_main_container.dart';
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
              body: BloqoMainContainer(
                child: Container()
              ),
            );
          }
      ),
    );
  }

  testWidgets('Main container present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoMainContainer), findsOneWidget);
  });
}