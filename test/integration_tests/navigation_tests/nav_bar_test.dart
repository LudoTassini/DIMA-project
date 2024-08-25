import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Users can navigate from and to main stacks test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Learn");

    expect(find.text("Learn"), findsExactly(2));

    await goToStack(tester: tester, stack: "Search");

    expect(find.text("Search"), findsExactly(3));

    await goToStack(tester: tester, stack: "Editor");

    expect(find.text("Editor"), findsExactly(2));

    await goToStack(tester: tester, stack: "Account");

    expect(find.text("Account"), findsExactly(1));

    await goToStack(tester: tester, stack: "Home");

    expect(find.text("Home"), findsExactly(1));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can go back to the origin of the main stack by clicking on the same icon test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1500, 1500));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await goToStack(tester: tester, stack: "Search");

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();
    expect(find.byType(BloqoFilledButton), findsNothing);

    await tester.tap(find.text("Search").last);
    await tester.pump();

    expect(find.text("Search"), findsExactly(3));

    await binding.setSurfaceSize(null);
  });

}