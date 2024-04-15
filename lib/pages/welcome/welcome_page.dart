import 'dart:async';

import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/pages/welcome/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app_state/user_app_state.dart';
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
                        'Welcome!',
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
                          labelText: "Email",
                          hintText: "e.g. bloqo@domain.com",
                          maxInputLength: Constants.maxEmailLength,
                          validator: (String? value) {return _emailValidator(value);},
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
                            labelText: "Password",
                            hintText: "type your password here",
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
                            String? error = await _tryLogin(email: emailController.text, password: passwordController.text);
                            if(error==null){
                              BloqoUser user = await _getUserFromEmail(email: emailController.text);
                              if(!context.mounted) return;
                              _saveUserToAppState(context, user);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MainPage()
                                ),
                              );
                            }
                            else{
                              if(!context.mounted) return;
                              showBloqoErrorAlert(
                                context: context,
                                title: "Oops, an error occurred!",
                                description: error,
                              );
                            }
                          },
                          color: BloqoColors.russianViolet,
                          text: 'Login',
                        ),
                      ),
                      BloqoTextButton(
                        text: "Forgot your password?",
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
                    'New here?',
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
                      text: 'Register now!',
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

Future<String?> _tryLogin({required String email, required String password}) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return null;
  } on FirebaseAuthException catch (e){
    switch(e.code){
      case "network-request-failed":
        return "Internet connection is required to login. Please check your connection status and try again.";
      default:
        return "Wrong credentials. Please check them and try again.";
    }
  }
}

String? _emailValidator(String? email){
  return (email == null || !TextValidator.validateEmail(email)) ? 'Please enter a valid email address.' : null;
}

Future<BloqoUser> _getUserFromEmail({required String email}) async {
  var ref = BloqoUser.getRef();
  var querySnapshot = await ref.where("email", isEqualTo: email).get();
  BloqoUser user = querySnapshot.docs.first.data();
  return user;
}

void _saveUserToAppState(BuildContext context, BloqoUser user){
  Provider.of<UserAppState>(context, listen: false).set(user);
}