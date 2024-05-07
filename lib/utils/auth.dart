import 'package:bloqo/utils/bloqo_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_state/user_app_state.dart';
import '../model/bloqo_user.dart';

const String sharedLogged = "USER_IS_LOGGED";
const String sharedUser = "USER";
const String sharedPassword = "PASSWORD";

Future<void> login({required String email, required String password}) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
}

Future<BloqoUser> getUserFromEmail({required var localizedText, required String email}) async {
  try {
    var ref = BloqoUser.getRef();
    var querySnapshot = await ref.where("email", isEqualTo: email).get();
    BloqoUser user = querySnapshot.docs.first.data();
    return user;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

void saveUserToAppState(BuildContext context, BloqoUser user){
  Provider.of<UserAppState>(context, listen: false).set(user);
}