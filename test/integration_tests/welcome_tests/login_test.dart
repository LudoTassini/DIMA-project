import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2400, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    expect(find.text('test'), findsAtLeast(1));
  });

  testWidgets('Cannot login with wrong email test', (WidgetTester tester) async {
    await initTestApp(tester: tester);

    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.en');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOne);
  });

  testWidgets('Cannot login with wrong password test', (WidgetTester tester) async {
    await initTestApp(tester: tester);

    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test12!');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOne);
  });

  testWidgets('Cannot login with no credentials', (WidgetTester tester) async {
    await initTestApp(tester: tester);

    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOne);
  });

}