import 'package:bloqo/app_state/application_settings_app_state.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

void main() {
  // Initializing BloqoTextField outside the testWidgets function
  final formKey = GlobalKey<FormState>();
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  Widget buildTestWidget({bool isDisabled = false}) {
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
                body: Form(
                  key: formKey,
                  child: BloqoTextField(
                    formKey: formKey,
                    controller: controller,
                    labelText: "test",
                    hintText: "test",
                    maxInputLength: 50,
                    isDisabled: isDisabled,
                  ),
                ),
              );
            },
          ),
        )
    );
  }

  testWidgets('Text form present', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    expect(find.byType(BloqoTextField), findsOneWidget);
  });

  testWidgets('Text form registers text', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget());
    const enteredText = "text";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();
    expect(find.text(enteredText), findsOneWidget);
    expect(controller.text, enteredText);
  });

  testWidgets('Text form does not register text if disabled', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestWidget(isDisabled: true));
    const enteredText = "text";
    final foundWidget = find.byType(BloqoTextField);
    expect(foundWidget, findsOneWidget);

    await tester.enterText(foundWidget, enteredText);
    await tester.pumpAndSettle();
    expect(find.text(enteredText), findsNothing);
    expect(controller.text, "");
  });
}