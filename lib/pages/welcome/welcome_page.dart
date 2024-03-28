import 'package:bloqo/components/bloqo_text_field.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';
import '../../style/app_colors.dart';
import '../../utils/regex_parser.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final formKey = GlobalKey<FormState>();

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
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.russianViolet,
              AppColors.fuchsiaRose
            ],
            stops: [0, 1],
            begin: AlignmentDirectional(0.87, -1),
            end: AlignmentDirectional(-0.87, 1),
          ),
        ),
        alignment: const AlignmentDirectional(0, 0),
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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.seasalt,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 20, 15, 20),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Welcome!',
                                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.russianViolet
                                )
                              ),
                              BloqoTextField(
                                formKey: formKey,
                                controller: emailController,
                                labelText: "Email",
                                hintText: "e.g. bloqo@domain.com",
                                maxInputLength: Constants.maxEmailLength,
                                validator: (String? value) {
                                  return (value == null || !RegexParser.isEmail(value)) ? 'Please enter a valid email address.' : null;
                                },
                                keyboardType: TextInputType.emailAddress,
                              ),
                              BloqoTextField(
                                formKey: formKey,
                                controller: passwordController,
                                labelText: "Password",
                                hintText: "type your password here",
                                maxInputLength: Constants.maxPasswordLength,
                                obscureText: true,
                              ),
                            ],
                          )
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 0),
                        child: FilledButton(
                          style: Theme.of(context).filledButtonTheme.style?.copyWith(
                            backgroundColor: MaterialStateProperty.resolveWith((_) => AppColors.russianViolet)
                          ),
                          onPressed: () {
                            tryLogin(email: emailController.text, password: passwordController.text);
                          },
                          child: const Text('Login'),
                        ),
                      )
                    ]
                  ),
                ),
              ),
            )
          ],
        ),
      )
    );
  }

  void tryLogin({required String email, required String password}){
    //TODO
  }

}