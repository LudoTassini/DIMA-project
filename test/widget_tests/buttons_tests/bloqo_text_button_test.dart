import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/style/themes/purple_orchid_theme.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  bool tapped = false;

  final testedWidget = MaterialApp(
    localizationsDelegates: getLocalizationDelegates(),
    supportedLocales: getSupportedLocales(),
    home: Builder(
      builder: (BuildContext context) {
        return Scaffold(
          body: BloqoTextButton(
            color: PurpleOrchidTheme().colors.leadingColor,
            text: "Test",
            onPressed: () {
              tapped = true;
            },
          ),
        );
      },
    ),
  );

  setUp(() {
    tapped = false;
  });

  testWidgets('Text button present', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    expect(find.byType(BloqoTextButton), findsOneWidget);
  });

  testWidgets('Text button can be tapped', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget);
    await tester.tap(find.byType(BloqoTextButton));
    await tester.pump();
    expect(tapped, isTrue);
  });
}
