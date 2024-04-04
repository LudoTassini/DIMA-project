import 'package:bloqo/data_structures/bloqo_user.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';
import '../../style/app_colors.dart';
import '../../utils/text_parser.dart';
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
            BloqoSeasaltContainer(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 15, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                        child: Text(
                            'Thank you for joining the bloQo community!',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                              color: AppColors.russianViolet,
                              fontSize: 25,
                            )
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                        child: Text(
                          'We want you to have the best experience.\nThat\'s why we are asking a few data about you.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: AppColors.russianViolet,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Form(
                        key: formKeyEmail,
                        child: BloqoTextField(
                          formKey: formKeyEmail,
                          controller: emailController,
                          labelText: "Email",
                          hintText: "e.g. bloqo@domain.com",
                          maxInputLength: Constants.maxEmailLength,
                          validator: (String? value) {
                            return (value == null || !TextParser.isEmail(value)) ? 'Please enter a valid email address.' : null;
                          },
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      Form(
                        key: formKeyPassword,
                        child: BloqoTextField(
                          formKey: formKeyPassword,
                          controller: passwordController,
                          labelText: "Password",
                          hintText: "type your password here",
                          maxInputLength: Constants.maxPasswordLength,
                          validator: (String? value) {
                            if(value == null){
                              return "The password cannot be empty.";
                            }
                            List<bool> results = TextParser.validatePassword(value);
                            int count = 0;
                            for (bool result in results){
                              if(result){
                                count++;
                              }
                            }
                            if(count==results.length){
                              return null;
                            }
                            else {
                              String errorMessage = _createPasswordErrorString(results);
                              return errorMessage;
                            }
                          },
                        ),
                      ),
                      Form(
                        key: formKeyUsername,
                        child: BloqoTextField(
                          formKey: formKeyUsername,
                          controller: usernameController,
                          labelText: "Nickname",
                          hintText: "e.g. iluvbloqo00",
                          maxInputLength: Constants.maxUsernameLength,
                          // FIXME: solo caratteri alfanumerici (gli spazi sono ok)
                          validator: (String? value) {
                            if (value == null || value.length < Constants.minUsernameLength) {
                              return "The username must be at least ${Constants.minUsernameLength} characters long.";
                            }
                            else{
                              return null;
                            }
                          }
                        ),
                      ),
                      Form(
                        key: formKeyFullName,
                        child: BloqoTextField(
                          formKey: formKeyFullName,
                          controller: fullNameController,
                          labelText: "Full name",
                          hintText: "e.g. Vanessa Visconti",
                          maxInputLength: Constants.maxFullNameLength,
                          // FIXME: solo caratteri alfanumerici (gli spazi sono ok)
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
                              'Full name visible to others',
                              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                color: AppColors.russianViolet,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 5, 0),
                                child: Switch.adaptive(
                                  value: switchValue,
                                  onChanged: (newValue) async {
                                    setState(() =>
                                      switchValue = newValue);
                                  },
                                  activeColor: AppColors.russianViolet,
                                  activeTrackColor: AppColors.russianViolet,
                                  inactiveTrackColor: AppColors.inactiveTracker,
                                  inactiveThumbColor: AppColors.seasalt,
                                ),
                              ),
                              Text(
                                switchValue ? 'Yes': 'No',
                                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                  color: AppColors.russianViolet,
                                  fontWeight: FontWeight.w500,
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
                        onPressed: () async {
                          try {
                            await _tryRegister(email: emailController.text,
                                password: passwordController.text,
                                username: usernameController.text,
                                fullName: fullNameController.text,
                                isFullNameVisible: switchValue);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    HomePage(
                                        title: ("Welcome, ${usernameController.text}!"
                                    )
                                ),
                              )
                            );
                          } on FirebaseAuthException catch (e) {
                            print('Error: $e');
                          } // TODO: messaggi più specifici per ogni tipo di errore
                        },
                        child: const Text('Register'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _tryRegister({required String email, required String password, required String username,
    required String fullName, required bool isFullNameVisible}) async {
  final user = BloqoUser(
      email: email,
      username: username,
      fullName: fullName,
      isFullNameVisible: isFullNameVisible
  );
  FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
  var ref = BloqoUser.getRef();
  await ref.doc().set(user);
}

String _createPasswordErrorString(List<bool> validationResults) {
  String messages = "";

  if (!validationResults[0]) {
    messages += 'Password must be at least ${Constants.minPasswordLength} characters long.\n';
  }
  if (!validationResults[1]) {
    messages+= 'Password must be at most ${Constants.maxPasswordLength} characters long.\n';
  }
  if (!validationResults[2]) {
    messages+= 'Password must contain at least one special character.\n';
  }
  if (!validationResults[3]) {
    messages+= 'Password must contain at least one number.\n';
  }
  if (!validationResults[4]) {
    messages+= 'Password must contain at least one uppercase letter.\n';
  }
  if (!validationResults[5]) {
    messages+= 'Password must contain at least one lowercase letter.\n';
  }
  return messages.trim();
}

