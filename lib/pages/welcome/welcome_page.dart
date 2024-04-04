import 'dart:async';

import 'package:bloqo/components/buttons/bloqo_clickable_text.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/errors/bloqo_error_text.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/pages/main/home_page.dart';
import 'package:bloqo/pages/welcome/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../data_structures/bloqo_user.dart';
import '../../utils/constants.dart';
import '../../style/app_colors.dart';
import '../../utils/text_parser.dart';

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
      body: BloqoMainContainer(
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
            BloqoSeasaltContainer(child:
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 20, 15, 20),
                child: Column(
                  children: [
                    Form(
                      key: formKeyEmail,
                      child:
                      BloqoTextField(
                        formKey: formKeyEmail,
                        controller: emailController,
                        labelText: "Email",
                        hintText: "e.g. bloqo@domain.com",
                        maxInputLength: Constants.maxEmailLength,
                        validator: (String? value) {
                          return (value == null || !TextParser.isEmail(value)) ? 'Please enter a valid email address.' : null;
                        },
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
                      child: FilledButton(
                        style: Theme.of(context).filledButtonTheme.style?.copyWith(
                          backgroundColor: MaterialStateProperty.resolveWith((_) => AppColors.russianViolet)
                        ),
                        onPressed: () async {
                          setState(() {
                            showLoginError = false;
                          });
                          try {
                            await _tryLogin(email: emailController.text,
                              password: passwordController.text).then((value) => {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => HomePage(
                                      title: ("Welcome, $value!")
                                    )
                                  ),
                                )
                              }
                            );
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              showLoginError = true;
                            });
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                    showLoginError ? const Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
                      child: BloqoErrorText(text: "Wrong credentials. Please check them and try again."))
                    : Container(),
                    BloqoClickableText(
                      text: "Forgot your password?",
                      color: AppColors.russianViolet,
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
                    color: AppColors.seasalt,
                    fontSize: 35,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(30, 10, 30, 20),
                  child: FilledButton(
                    style: Theme.of(context).filledButtonTheme.style?.copyWith(
                    textStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      )),
                      backgroundColor: MaterialStateProperty.resolveWith((_) => AppColors.russianViolet),
                      fixedSize: MaterialStateProperty.resolveWith((_) => const Size(double.infinity, double.infinity)),
                      padding: MaterialStateProperty.resolveWith((_) => const EdgeInsetsDirectional.fromSTEB(30, 16, 30, 16)),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage()
                        )
                      );
                    },
                    child: const Text('Register now!'),
                  ),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

}

Future<String> _tryLogin({required String email, required String password}) async {
  await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: email,
    password: password,
  );
  var ref = BloqoUser.getRef();
  var querySnapshot = await ref.where("email", isEqualTo: email).get();
  BloqoUser user = querySnapshot.docs.first.data();
  return user.username;
}