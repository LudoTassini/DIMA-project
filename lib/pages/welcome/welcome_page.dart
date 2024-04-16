import 'dart:async';

import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/pages/welcome/register_page.dart';
import 'package:bloqo/utils/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_user.dart';
import '../../utils/constants.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/text_validator.dart';
import '../main/main_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  // state
  bool showLoginError = false;

  final formKeyEmail = GlobalKey<FormState>();
  final formKeyPassword = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BloqoMainContainer(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
                child: Image.asset(
                  "assets/images/bloqo_logo_partial.png",
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              BloqoSeasaltContainer(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 20, 15, 15),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcome,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: BloqoColors.russianViolet,
                        )
                      ),
                      Form(
                        key: formKeyEmail,
                        child:
                        BloqoTextField(
                          formKey: formKeyEmail,
                          controller: emailController,
                          labelText: AppLocalizations.of(context)!.email,
                          hintText: AppLocalizations.of(context)!.email_hint,
                          maxInputLength: Constants.maxEmailLength,
                          validator: (String? value) {return emailValidator(value);},
                          keyboardType: TextInputType.emailAddress,
                          onTap: () {
                            setState(() {
                              showLoginError = false;
                            });
                          },
                        ),
                      ),
                      Form(
                          key: formKeyPassword,
                          child:
                          BloqoTextField(
                            formKey: formKeyPassword,
                            controller: passwordController,
                            labelText: AppLocalizations.of(context)!.password,
                            hintText: AppLocalizations.of(context)!.password_hint,
                            maxInputLength: Constants.maxPasswordLength,
                            obscureText: true,
                            onTap: () {
                              setState(() {
                                showLoginError = false;
                              });
                            },
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 10),
                        child: BloqoFilledButton(
                          onPressed: () async {
                            context.loaderOverlay.show();
                            String? error = await _tryLogin(context: context, email: emailController.text, password: passwordController.text);
                            if(error==null){
                              BloqoUser user = await getUserFromEmail(email: emailController.text);
                              if(!context.mounted) return;
                              saveUserToAppState(context, user);
                              context.loaderOverlay.hide();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainPage()
                                ),
                              );
                            }
                            else{
                              if(!context.mounted) return;
                              context.loaderOverlay.hide();
                              showBloqoErrorAlert(
                                context: context,
                                title: AppLocalizations.of(context)!.error_title,
                                description: error,
                              );
                            }
                          },
                          color: BloqoColors.russianViolet,
                          text: AppLocalizations.of(context)!.login,
                        ),
                      ),
                      BloqoTextButton(
                        text: AppLocalizations.of(context)!.forgot_password,
                        color: BloqoColors.russianViolet,
                        onPressed: () {
                          //TODO
                        },
                      )
                    ]
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    AppLocalizations.of(context)!.new_here,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: BloqoColors.seasalt,
                      fontSize: 35,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                    child: BloqoFilledButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage()
                          )
                        );
                      },
                      color: BloqoColors.russianViolet,
                      text: AppLocalizations.of(context)!.register_now,
                      fontSize: 35,
                      height: 82,
                    ),
                  )
                ],
              ),
            ],
          ),
        )
      )
    );
  }

}

Future<String?> _tryLogin({required BuildContext context, required String email, required String password}) async {
  try {
    await login(email: email, password: password);
    //save on the shared preferences that the user is logged in
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(sharedLogged, true);
    await prefs.setString(sharedUser, email);
    await prefs.setString(sharedPassword, password);
    return null;
  } on FirebaseAuthException catch (e){
    switch(e.code){
      case "network-request-failed":
        if(!context.mounted) return "Error";
        return AppLocalizations.of(context)!.login_network_error;
      default:
        if(!context.mounted) return "Error";
        return AppLocalizations.of(context)!.login_credentials_error;
    }
  }
}