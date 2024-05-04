import 'package:bloqo/components/forms/bloqo_switch.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:bloqo/utils/toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  late BuildContext sharedContext1;
  late BuildContext sharedContext2;

  final testedWidget1 = MaterialApp(
    localizationsDelegates: getLocalizationDelegates(),
    supportedLocales: getSupportedLocales(),
    home: Builder(
      builder: (BuildContext context) {
        sharedContext1 = context;
        return Scaffold(
          body: BloqoSwitch(
            value: Toggle(initialValue: true),
          )
        );
      }
    )
  );

  final testedWidget2 = MaterialApp(
    localizationsDelegates: getLocalizationDelegates(),
    supportedLocales: getSupportedLocales(),
    home: Builder(
      builder: (BuildContext context) {
        sharedContext2 = context;
        return Scaffold(
          body: BloqoSwitch(
            value: Toggle(initialValue: false),
          )
        );
      }
    )
  );

  testWidgets('Switch form present (initial value: true)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget1);
    expect(find.byType(BloqoSwitch), findsOneWidget);
  });

  testWidgets('Switch form present (initial value: false)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget2);
    expect(find.byType(BloqoSwitch), findsOneWidget);
  });

  testWidgets('Switch form shows initial value "true"', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget1);
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(true, foundWidget.value.get());
  });

  testWidgets('Switch form shows initial value "false"', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget2);
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(false, foundWidget.value.get());
  });

  testWidgets('Switch form toggles (initial value: true)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget1);
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    foundWidget.value.toggle();
    expect(false, foundWidget.value.get());
  });

  testWidgets('Switch form toggles (initial value: false)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget2);
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    foundWidget.value.toggle();
    expect(true, foundWidget.value.get());
  });

  testWidgets('Switch form toggles twice (initial value: true)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget1);
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    foundWidget.value.toggle();
    expect(false, foundWidget.value.get());
    foundWidget.value.toggle();
    expect(true, foundWidget.value.get());
  });

  testWidgets('Switch form toggles twice (initial value: false)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget2);
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    foundWidget.value.toggle();
    expect(true, foundWidget.value.get());
    foundWidget.value.toggle();
    expect(false, foundWidget.value.get());
  });

  testWidgets('Switch form resets (initial value: true)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget1);
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    foundWidget.value.toggle();
    expect(false, foundWidget.value.get());
    foundWidget.value.reset();
    expect(true, foundWidget.value.get());
  });

  testWidgets('Switch form resets (initial value: false)', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget2);
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    foundWidget.value.toggle();
    expect(true, foundWidget.value.get());
    foundWidget.value.reset();
    expect(false, foundWidget.value.get());
  });

  testWidgets('Switch form shows "Yes" if value is true', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget1);
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(true, foundWidget.value.get());
    expect(find.descendant(of: find.byType(BloqoSwitch), matching: find.text(getAppLocalizations(sharedContext1)!.yes)), findsOneWidget);
  });

  testWidgets('Switch form shows "No" if value is false', (WidgetTester tester) async {
    await tester.pumpWidget(testedWidget2);
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(false, foundWidget.value.get());
    expect(find.descendant(of: find.byType(BloqoSwitch), matching: find.text(getAppLocalizations(sharedContext2)!.no)), findsOneWidget);
  });

}