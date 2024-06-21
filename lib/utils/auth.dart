import 'package:bloqo/utils/bloqo_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'connectivity.dart';

Future<void> login({required var localizedText, required String email, required String password}) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
  on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.login_network_error);
      default:
        throw BloqoException(
            message: localizedText.login_credentials_error);
    }
  }
}

Future<void> logout({required var localizedText}) async {
  await checkConnectivity(localizedText: localizedText);
  try {
    await FirebaseAuth.instance.signOut();
  }
  on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}