import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login register navigation test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    var registerButton = find.byType(BloqoFilledButton, skipOffstage: false).at(1);
    await tester.tap(registerButton);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoTextButton));
    await tester.pumpAndSettle();

    expect(find.byType(BloqoTextField), findsExactly(2));
    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await binding.setSurfaceSize(null);
  });
}