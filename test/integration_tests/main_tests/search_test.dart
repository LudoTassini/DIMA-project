import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/complex/bloqo_search_result_course.dart';
import 'package:bloqo/components/complex/bloqo_user_details.dart';
import 'package:bloqo/components/forms/bloqo_dropdown.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/utils/bloqo_external_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:bloqo/main.dart' as app;
import 'package:qr_flutter/qr_flutter.dart';

import '../../mocks/mock_external_services.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Users can search courses test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can search courses and select one test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await tester.tap(find.byType(BloqoSearchResultCourse).first);
    await tester.pumpAndSettle();
    
    expect(find.byType(RatingBarIndicator), findsAtLeast(2));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can search courses, select one and view its QR code test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await tester.tap(find.byType(BloqoSearchResultCourse).first);
    await tester.pumpAndSettle();

    expect(find.byType(RatingBarIndicator), findsAtLeast(2));

    await tester.tap(find.byIcon(Icons.qr_code_2));
    await tester.pumpAndSettle();

    expect(find.byType(QrImageView), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can search courses, select one and enroll in it test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await tester.tap(find.byType(BloqoSearchResultCourse).first);
    await tester.pumpAndSettle();

    expect(find.byType(RatingBarIndicator), findsAtLeast(2));
    expect(find.text("Unsubscribe"), findsNothing);
    expect(find.text("Enroll in Course"), findsOne);

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    expect(find.text("Search"), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can search courses, select one and view the courses made by the same author test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await tester.tap(find.byType(BloqoSearchResultCourse).first);
    await tester.pumpAndSettle();

    expect(find.byType(RatingBarIndicator), findsAtLeast(2));

    await tester.tap(find.byType(BloqoTextButton).first);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoUserDetails), findsOne);
    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can search courses, select one in which they are enrolled and unsubscribe from it test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await tester.tap(find.text("test_enrolled"));
    await tester.pumpAndSettle();

    expect(find.byType(RatingBarIndicator), findsAtLeast(2));
    expect(find.text("Unsubscribe"), findsOne);
    expect(find.text("Enroll in Course"), findsNothing);

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text("OK"));
    await tester.pumpAndSettle();

    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can search courses, select a private one and ask for enrollment test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 2000));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(Switch).first);
    await tester.pump();

    await tester.tap(find.byType(Switch).last);
    await tester.pump();

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await tester.tap(find.text("private_test"));
    await tester.pumpAndSettle();

    expect(find.byType(RatingBarIndicator), findsAtLeast(2));
    expect(find.text("Unsubscribe"), findsNothing);
    expect(find.text("Enroll in Course"), findsNothing);
    expect(find.text("Request Access"), findsOne);

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    expect(find.text("Request Access"), findsOne);

    expect(find.byType(SnackBar), findsOne);

    await tester.runAsync(() async {
      await Future.delayed(const Duration(seconds: 3));
    });

    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);

    await tester.tap(find.byType(BloqoFilledButton));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOne);

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can apply filters and search specific courses test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1500, 1500));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(BloqoDropdown).at(4));
    await tester.pumpAndSettle();
    await tester.tap(find.text("For everyone").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).at(4));
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "For everyone");

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can select a date while editing filters test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1000, 1000));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(BloqoTextField).at(2));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.chevron_left).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text("21").last);
    await tester.pumpAndSettle();
    await tester.tap(find.text("OK").last);
    await tester.pumpAndSettle();

    final textField = tester.widget<BloqoTextField>(find.byType(BloqoTextField).at(2));
    final textFieldValue = textField.controller.text;
    expect(textFieldValue.contains("21"), isTrue);

    await tester.tap(find.byType(BloqoFilledButton).last);
    await tester.pumpAndSettle();

    expect(find.byType(BloqoSearchResultCourse), findsAtLeast(1));

    await binding.setSurfaceSize(null);
  });

  testWidgets('Users can apply filters and then reset them test', (WidgetTester tester) async {
    await binding.setSurfaceSize(const Size(1500, 1500));

    MockExternalServices mockExternalServices = MockExternalServices();
    await mockExternalServices.prepare();

    await app.main(externalServices: BloqoExternalServices(
        firestore: mockExternalServices.fakeFirestore,
        auth: mockExternalServices.mockFirebaseAuth,
        storage: mockExternalServices.mockFirebaseStorage
    ));
    await tester.pumpAndSettle();

    // Enter email and password
    await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
    await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
    await tester.pumpAndSettle();

    // Tap the login button
    await tester.tap(find.byType(BloqoFilledButton).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text("Search"));
    await tester.pump();

    await tester.tap(find.byType(BloqoDropdown).at(4));
    await tester.pumpAndSettle();
    await tester.tap(find.text("For everyone").last);
    await tester.pumpAndSettle();

    final dropdown = tester.widget<BloqoDropdown>(find.byType(BloqoDropdown).at(4));
    var dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "For everyone");

    await tester.tap(find.byType(BloqoTextButton).first);
    await tester.pumpAndSettle();

    dropdownValue = dropdown.controller.text;
    expect(dropdownValue, "None");

    await binding.setSurfaceSize(null);
  });

}