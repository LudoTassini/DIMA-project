import 'package:bloqo/components/popups/bloqo_error_alert.dart';
import 'package:bloqo/model/bloqo_user.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/pages/welcome/welcome_page.dart';
import 'package:bloqo/utils/bloqo_exception.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:bloqo/utils/toggle.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../components/buttons/bloqo_text_button.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/forms/bloqo_switch.dart';
import '../../utils/auth.dart';
import '../../utils/constants.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/text_validator.dart';
import '../main/home_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKeyEmail = GlobalKey<FormState>();
  final formKeyPassword = GlobalKey<FormState>();
  final formKeyUsername = GlobalKey<FormState>();
  final formKeyFullName = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  late TextEditingController fullNameController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    fullNameController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BloqoSwitch visibilitySwitch = BloqoSwitch(value: Toggle(initialValue: true));
    final localizedText = getAppLocalizations(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BloqoMainContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                child: Text(
                  'bloQo',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    color: BloqoColors.seasalt,
                    fontSize: 60,
                  ),
                ),
              ),
              BloqoSeasaltContainer(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                          child: Text(
                              localizedText.register_thank_you,
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: BloqoColors.russianViolet,
                                fontSize: 25,
                              )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                          child: Text(
                            localizedText.register_explanation,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: BloqoColors.russianViolet,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Form(
                          key: formKeyEmail,
                          child: BloqoTextField(
                            formKey: formKeyEmail,
                            controller: emailController,
                            labelText: localizedText.email,
                            hintText: localizedText.email_hint,
                            maxInputLength: Constants.maxEmailLength,
                            validator: (String? value) { return emailValidator(email: value, localizedText: localizedText); },
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        Form(
                          key: formKeyPassword,
                          child: BloqoTextField(
                            formKey: formKeyPassword,
                            controller: passwordController,
                            labelText: localizedText.password,
                            hintText: localizedText.password_hint,
                            maxInputLength: Constants.maxPasswordLength,
                            validator: (String? value) { return passwordValidator(password: value, localizedText: localizedText); },
                          ),
                        ),
                        Form(
                          key: formKeyUsername,
                          child: BloqoTextField(
                            formKey: formKeyUsername,
                            controller: usernameController,
                            labelText: localizedText.username,
                            hintText: localizedText.username_hint,
                            maxInputLength: Constants.maxUsernameLength,
                            validator: (String? value) { return usernameValidator(username: value, localizedText: localizedText); }
                          ),
                        ),
                        Form(
                          key: formKeyFullName,
                          child: BloqoTextField(
                            formKey: formKeyFullName,
                            controller: fullNameController,
                            labelText: localizedText.full_name,
                            hintText: localizedText.full_name_hint,
                            maxInputLength: Constants.maxFullNameLength,
                            validator: (String? value) { return fullNameValidator(fullName: value, localizedText: localizedText); }
                          ),
                        ),
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                localizedText.full_name_visible,
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: BloqoColors.russianViolet,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            visibilitySwitch,
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 15),
                        child: BloqoFilledButton(
                          onPressed: () async {
                            context.loaderOverlay.show();
                            try {
                              await _tryRegister(localizedText: localizedText,
                                email: emailController.text,
                                password: passwordController.text,
                                username: usernameController.text,
                                fullName: fullNameController.text,
                                isFullNameVisible: visibilitySwitch.value.get());
                              BloqoUser user = await getUserFromEmail(localizedText: localizedText,
                                  email: emailController.text);
                              if(!context.mounted) return;
                              saveUserToAppState(context, user);
                              context.loaderOverlay.hide();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                )
                              );
                            } on BloqoException catch(e){
                              if(!context.mounted) return;
                              context.loaderOverlay.hide();
                              showBloqoErrorAlert(
                                context: context,
                                title: localizedText.error_title,
                                description: e.message,
                              );
                            }
                          },
                          color: BloqoColors.russianViolet,
                          text: localizedText.register,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                        child: BloqoTextButton(
                          text: localizedText.back_to_login,
                          color: BloqoColors.russianViolet,
                          onPressed: () {
                            if(!context.mounted) return;
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                    const WelcomePage(),
                                )
                            );
                          },
                        )
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}

Future<void> _tryRegister({required var localizedText, required String email, required String password, required String username,
    required String fullName, required bool isFullNameVisible}) async {
  final user = BloqoUser(
      email: email,
      username: username,
      fullName: fullName,
      isFullNameVisible: isFullNameVisible
  );
  if(emailValidator(email: user.email, localizedText: localizedText) == null &&
      passwordValidator(password: password, localizedText: localizedText) == null &&
      usernameValidator(username: user.username, localizedText: localizedText) == null &&
      fullNameValidator(fullName: user.fullName, localizedText: localizedText) == null) {
    if(await _isUsernameAlreadyTaken(localizedText: localizedText, username: user.username)){
      throw BloqoException(message: localizedText.username_already_taken);
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      var ref = BloqoUser.getRef();
      await ref.doc().set(user);
    } on FirebaseAuthException catch (e) {
        switch(e.code){
          case "email-already-in-use":
            throw BloqoException(message: localizedText.register_email_already_taken);
          case "network-request-failed":
            throw BloqoException(message: localizedText.register_network_error);
          default:
            throw BloqoException(message: localizedText.register_error);
        }
    }
  }
  else{
    throw BloqoException(message: localizedText.register_incomplete_error);
  }
}

Future<bool> _isUsernameAlreadyTaken({required var localizedText, required String username}) async {
  try {
    var ref = BloqoUser.getRef();
    var querySnapshot = await ref.where("username", isEqualTo: username).get();
    if (querySnapshot.docs.length != 0) {
      return true;
    }
    else {
      return false;
    }
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}