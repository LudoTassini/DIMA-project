import 'package:bloqo/utils/bloqo_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> silentLogin({
  required String email,
  required String password,
}) async {
  final firebaseAuth = FirebaseAuth.instance;
  try {
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return true;
  } on Exception catch (_) {
    return false;
  }
}

Future<void> login({
  required var localizedText,
  required String email,
  required String password,
  required FirebaseAuth auth,
}) async {
  try {
    await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.login_network_error);
      default:
        throw BloqoException(
            message: localizedText.login_credentials_error);
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}

Future<void> logout({
  required var localizedText,
  required FirebaseAuth auth,
}) async {
  try {
    await auth.signOut();
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  } on Exception catch (_) {
    throw BloqoException(message: localizedText.generic_error);
  }
}