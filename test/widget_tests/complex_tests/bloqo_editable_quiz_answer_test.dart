import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/complex/bloqo_editable_quiz_answer.dart';
import 'package:bloqo/components/forms/bloqo_switch.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/components/popups/bloqo_confirmation_alert.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:bloqo/utils/toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {

  late TextEditingController controller;
  Toggle toggle = Toggle(initialValue: false);

  Widget buildTestWidget({
    required bool editable
  }) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
        ],
        child: MaterialApp(
          localizationsDelegates: getLocalizationDelegates(),
          supportedLocales: getSupportedLocales(),
          home: Builder(
              builder: (BuildContext context) {
                return Scaffold(
                  body: BloqoEditableQuizAnswer(
                    controller: controller,
                    toggle: toggle,
                    answerNumber: 1,
                    editable: editable,
                    onDelete: () {}
                  )
                );
              }
          ),
        )
    );
  }

  setUp(() {
    controller = TextEditingController();
    toggle.reset();
  });

  testWidgets('Editable quiz answer present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: true));
    expect(find.byType(BloqoEditableQuizAnswer), findsOneWidget);
  });

  testWidgets('Editable quiz answer\'s text can be modified (if editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: true));
    const enteredText = "text";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);
    expect(controller.text, "");

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();
    expect(controller.text, enteredText);
  });

  testWidgets('Editable quiz answer cannot be modified (if not editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: false));
    const enteredText = "text";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);
    expect(controller.text, "");

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();
    expect(controller.text, "");
  });

  testWidgets('Editable quiz answer can be deleted (if editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: true));
    await tester.tap(find.byIcon(Icons.delete_forever));
    await tester.pumpAndSettle();

    expect(find.byType(BloqoConfirmationAlert), findsOneWidget);
  });

  testWidgets('Editable quiz answer cannot be deleted (if not editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: false));

    expect(find.byIcon(Icons.delete_forever), findsNothing);
  });

  testWidgets('Editable quiz answer can change its status (if editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: true));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(foundWidget.value.get(), isTrue);
  });

  testWidgets('Editable quiz answer cannot change its status (if not editable)', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(editable: false));
    await tester.tap(find.byType(Switch));
    await tester.pump();
    final foundWidget = tester.firstWidget<BloqoSwitch>(find.byType(BloqoSwitch));
    expect(foundWidget.value.get(), isFalse);
  });

}