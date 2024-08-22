import 'package:bloqo/components/buttons/bloqo_filled_button.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/model/bloqo_user_data.dart';
import 'package:bloqo/utils/bloqo_external_services.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:bloqo/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final user = MockUser(
    isAnonymous: false,
    uid: 'test',
    email: 'test@bloqo.com',
    displayName: 'Test',
  );

  final fakeFirestore = FakeFirebaseFirestore();
  final mockFirebaseAuth = MockFirebaseAuth(mockUser: user);
  final mockFirebaseStorage = MockFirebaseStorage();

  testWidgets('Login test', (WidgetTester tester) async {
    // Configura i dati di Firestore
    BloqoUserData testUser = BloqoUserData(
        id: "test",
        email: "test@bloqo.com",
        username: "Test",
        fullName: "Test",
        isFullNameVisible: false,
        pictureUrl: "none",
        followers: [],
        following: []
    );

    await fakeFirestore.collection('users').doc('test').set(testUser.toFirestore());

    // Esegui il test
    await tester.runAsync(() async {
      await app.main(externalServices: BloqoExternalServices(
          firestore: fakeFirestore,
          auth: mockFirebaseAuth,
          storage: mockFirebaseStorage
      ));
      await tester.pumpAndSettle();

      // Inserisci le credenziali
      await tester.enterText(find.byType(BloqoTextField).first, 'test@bloqo.com');
      await tester.enterText(find.byType(BloqoTextField).last, 'Test123!');
      await tester.pumpAndSettle();

      // Tocca il pulsante di login
      await tester.tap(find.byType(BloqoFilledButton).first);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 5));

      // Verifica la pagina principale
      expect(find.text('Test'), findsOneWidget);
    });
  });
}