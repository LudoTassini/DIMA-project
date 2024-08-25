import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/complex/bloqo_setting.dart';
import 'package:bloqo/components/complex/bloqo_user_details_short.dart';
import 'package:bloqo/components/forms/bloqo_dropdown.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../utils/routines.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Users can update their profile picture test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Account"));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.camera_alt).first);
    await tester.pumpAndSettle();

    expect(
      find.byWidgetPredicate(
            (Widget widget) =>
              widget is Image &&
              widget.image is AssetImage &&
              (widget.image as AssetImage).assetName == 'assets/tests/test.png',
      ),
      findsOneWidget,
    );

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can show their QR code test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Account"));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.qr_code_2).first);
    await tester.pumpAndSettle();

    expect(find.byType(QrImageView), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can update their account settings test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Account"));
    await tester.pump();

    await tester.tap(find.byType(BloqoSetting).first);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(BloqoTextField).first, 'A New Name');
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    expect(find.text("A New Name"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can update their application settings (language) test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Account"));
    await tester.pump();

    await tester.tap(find.byType(BloqoSetting).at(1));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoDropdown).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Italian").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).first);
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "Italian");

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    expect(find.text("Cerca"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can update their application settings (theme) test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Account"));
    await tester.pump();

    await tester.tap(find.byType(BloqoSetting).at(1));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoDropdown).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text("Ocean Cornflower").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).last);
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "Ocean Cornflower");

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BloqoSetting).at(1));
    await tester.pumpAndSettle();

    dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "Ocean Cornflower");

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can logout test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Account"));
    await tester.pump();

    await tester.tap(find.byType(BloqoSetting).last);
    await tester.pumpAndSettle();

    await tester.tap(find.text("OK").last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoFilledButton), findsExactly(2));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can see the users who follow them test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Account"));
    await tester.pump();

    await tester.tap(find.byType(BloqoTextButton).first);
    await tester.pumpAndSettle();

    expect(find.text("There are no users to show."), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can see the users who they are following test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    await initTestApp(tester: tester);

    await doLogin(tester: tester);

    await tester.tap(find.text("Account"));
    await tester.pump();

    await tester.tap(find.byType(BloqoTextButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoUserDetailsShort), findsAtLeast(1));

    await binding.setSurfaceSize(null);
  });

}