import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/style/bloqo_colors.dart';
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
          body: BloqoFilledButton(
            color: BloqoColors.russianViolet,
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
