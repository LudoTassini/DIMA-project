import 'package:bloqo/components/buttons/bloqo_clickable_text.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../style/app_colors.dart';
import '../../utils/regex_parser.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController usernameController;
  late TextEditingController fullNameController;

  late bool switchValue;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    usernameController = TextEditingController();
    fullNameController = TextEditingController();
    switchValue = true;
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
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
              child: Text(
                'bloQo',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.seasalt,
                  fontSize: 60,
                ),
              ),
            ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                child: BloqoSeasaltContainer(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                          child: Text(
                              'Thank you for joining the bloQo community!',
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                  color: AppColors.russianViolet
                              )
                          ),
                        ),
                        Text(
                          'We want you to have the best experience. That\'s why we are asking a few data about you.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppColors.russianViolet
                          ),
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
                        BloqoTextField(
                          formKey: formKey,
                          controller: usernameController,
                          labelText: "Nickname",
                          hintText: "e.g. iluvbloqo00",
                          maxInputLength: Constants.maxUsernameLength,
                        ),
                        BloqoTextField(
                          formKey: formKey,
                          controller: fullNameController,
                          labelText: "Full name",
                          hintText: "e.g. Ludovica Tassini",
                          maxInputLength: Constants.maxFullNameLength,
                        ),
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(20, 0, 20, 20),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                'Full name visible to others',
                                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                    color: AppColors.russianViolet
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 0, 5, 0),
                                  child: Switch.adaptive(
                                    value: switchValue,
                                    onChanged: (newValue) async {
                                      setState(() =>
                                        switchValue = newValue);
                                    },
                                    activeColor: AppColors.russianViolet,
                                    activeTrackColor: AppColors.russianViolet,
                                    inactiveTrackColor: Colors.grey,
                                    inactiveThumbColor: Colors.grey
                                  ),
                                ),
                                Text(
                                  'Yes',
                                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                                      color: AppColors.russianViolet
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                        const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 20),
                        child: FilledButton(
                          style: Theme.of(context).filledButtonTheme.style?.copyWith(
                              backgroundColor: MaterialStateProperty.resolveWith((_) => AppColors.russianViolet)
                          ),
                          onPressed: () {
                            tryRegister(email: emailController.text, password: passwordController.text,
                              username: usernameController.text, fullName: fullNameController.text);
                          },
                          child: const Text('Register'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> tryRegister({required String email, required String password, required String username,
    required String fullName}) async {
  // TODO
}