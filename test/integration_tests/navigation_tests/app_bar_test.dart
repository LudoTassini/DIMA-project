import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Users can navigate back thanks to the app bar', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1500, 1500));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    expect(find.byIcon(Icons.arrow_back), findsNothing);

    await goToStack(tester: tester, stack: "Search");

    expect(find.byIcon(Icons.arrow_back), findsNothing);

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back), findsOne);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back), findsNothing);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can view notifications and go back to the previous page', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(2388, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    expect(find.byIcon(Icons.arrow_back), findsNothing);

    await tester.tap(find.byType(Positioned).first);
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.notifications), findsNothing);
    expect(find.byIcon(Icons.arrow_back), findsOne);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.arrow_back), findsNothing);
    expect(find.byIcon(Icons.notifications), findsOne);

    await binding.setSurfaceSize(null);
  });

}