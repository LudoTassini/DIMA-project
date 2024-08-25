import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/components/navigation/bloqo_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../utils/routines.dart';


void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Register test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    var registerButton = find.byType(BloqoFilledButton, skipOffstage: false).at(1);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    var forms = find.byType(BloqoTextField);
    await tester.enterText(forms.at(0), 'register_test@bloqo.com');
    await tester.enterText(forms.at(1), 'RegisterTest123!');
    await tester.enterText(forms.at(2), 'RegisterTest');
    await tester.enterText(forms.at(3), 'Register Test');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    expect(find.byType(BloqoNavBar), findsAtLeastNWidgets(1));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Cannot register an user with an email that is already in use test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    var registerButton = find.byType(BloqoFilledButton, skipOffstage: false).at(1);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    var forms = find.byType(BloqoTextField);
    await tester.enterText(forms.at(0), 'test@bloqo.com');
    await tester.enterText(forms.at(1), 'RegisterTest123!');
    await tester.enterText(forms.at(2), 'RegisterTest');
    await tester.enterText(forms.at(3), 'Register Test');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Cannot register an user with unaccepted data', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    var registerButton = find.byType(BloqoFilledButton, skipOffstage: false).at(1);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    var forms = find.byType(BloqoTextField);
    await tester.enterText(forms.at(0), 'register_test@bloqo.com');
    await tester.enterText(forms.at(1), 'RegisterTest123!');
    await tester.enterText(forms.at(2), 'Register Test');
    await tester.enterText(forms.at(3), 'Register Test');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Cannot register an user with a username that is already in use test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    var registerButton = find.byType(BloqoFilledButton, skipOffstage: false).at(1);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    var forms = find.byType(BloqoTextField);
    await tester.enterText(forms.at(0), 'test@bloqo.com');
    await tester.enterText(forms.at(1), 'RegisterTest123!');
    await tester.enterText(forms.at(2), 'test');
    await tester.enterText(forms.at(3), 'Register Test');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOne);

    await binding.setSurfaceSize(null);
  });

}