import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/forms/bloqo_switch.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:bloqo/utils/toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  Widget buildTestWidget(Toggle toggle) {
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
                  body: BloqoSwitch(
                    value: toggle,
                  ),
                );
              }
          ),
        )
    );
  }

  testWidgets('Switch form present (initial value: true)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(Toggle(initialValue: true)));
    expect(find.byType(BloqoSwitch), findsOneWidget);
  });

  testWidgets('Switch form present (initial value: false)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(Toggle(initialValue: false)));
    expect(find.byType(BloqoSwitch), findsOneWidget);
  });

  testWidgets('Switch form shows initial value "true"', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(Toggle(initialValue: true)));
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(foundWidget.value.get(), isTrue);
  });

  testWidgets('Switch form shows initial value "false"', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(Toggle(initialValue: false)));
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(foundWidget.value.get(), isFalse);
  });

  testWidgets('Switch form toggles (initial value: true)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(Toggle(initialValue: true)));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(foundWidget.value.get(), isFalse);
  });

  testWidgets('Switch form toggles (initial value: false)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(Toggle(initialValue: false)));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(foundWidget.value.get(), isTrue);
  });

  testWidgets('Switch form toggles twice (initial value: true)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(Toggle(initialValue: true)));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.byType(Switch));
    await tester.pump();
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(foundWidget.value.get(), isTrue);
  });

  testWidgets('Switch form toggles twice (initial value: false)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(Toggle(initialValue: false)));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    await tester.tap(find.byType(Switch));
    await tester.pump();
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(foundWidget.value.get(), isFalse);
  });

  testWidgets('Switch form resets (initial value: true)', (WidgetTester tester) async {
    final toggle = Toggle(initialValue: true);
    await tester.pumpWidget(buildTestWidget(toggle));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(toggle.get(), isFalse);
    toggle.reset();
    await tester.pump();
    expect(toggle.get(), isTrue);
  });

  testWidgets('Switch form resets (initial value: false)', (WidgetTester tester) async {
    final toggle = Toggle(initialValue: false);
    await tester.pumpWidget(buildTestWidget(toggle));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    expect(toggle.get(), isTrue);
    toggle.reset();
    await tester.pump();
    expect(toggle.get(), isFalse);
  });

  testWidgets('Switch form shows "Yes" if value is true', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(Toggle(initialValue: true)));
    expect(find.text(getAppLocalizations(tester.element(find.byType(BloqoSwitch)))!.yes), findsOneWidget);
  });

  testWidgets('Switch form shows "No" if value is false', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(Toggle(initialValue: false)));
    expect(find.text(getAppLocalizations(tester.element(find.byType(BloqoSwitch)))!.no), findsOneWidget);
  });
}