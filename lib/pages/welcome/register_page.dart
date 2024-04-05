import 'package:bloqo/components/popups/bloqo_error_alert.dart';
import 'package:bloqo/model/bloqo_user.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/pages/welcome/welcome_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/buttons/bloqo_clickable_text.dart';
import '../../utils/constants.dart';
import '../../style/app_colors.dart';
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

  // state
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
                          validator: (String? value) { return _emailValidator(value); },
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
                          validator: (String? value) { return _passwordValidator(value); },
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
                          validator: (String? value) { return _usernameValidator(value); }
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
                          validator: (String? value) { return _fullNameValidator(value); }
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
                      const EdgeInsetsDirectional.fromSTEB(30, 0, 30, 15),
                      child: FilledButton(
                        style: Theme.of(context).filledButtonTheme.style?.copyWith(
                            backgroundColor: MaterialStateProperty.resolveWith((_) => AppColors.russianViolet)
                        ),
                        onPressed: () async {
                          String? error = await _tryRegister(email: emailController.text,
                              password: passwordController.text,
                              username: usernameController.text,
                              fullName: fullNameController.text,
                              isFullNameVisible: switchValue);
                          if(error == null) {
                            if(!context.mounted) return;
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                  HomePage(
                                    title: ("Welcome, ${usernameController.text}!")
                                  ),
                              )
                            );
                          }
                          else{
                            if(!context.mounted) return;
                            showErrorAlert(
                              context: context,
                              title: "Oops, an error occurred!",
                              description: error,
                            );
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                      child: BloqoClickableText(
                        text: "Already have an account? Log in!",
                        color: AppColors.russianViolet,
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
        ),
      ),
    );
  }
}

Future<String?> _tryRegister({required String email, required String password, required String username,
    required String fullName, required bool isFullNameVisible}) async {
  final user = BloqoUser(
      email: email,
      username: username,
      fullName: fullName,
      isFullNameVisible: isFullNameVisible
  );
  if(_emailValidator(user.email) == null && _passwordValidator(password) == null
      && _usernameValidator(user.username) == null && _fullNameValidator(user.fullName) == null) {
    if(await _isUsernameAlreadyTaken(user.username)){
      return "The username is already taken. Please choose another one.";
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      var ref = BloqoUser.getRef();
      await ref.doc().set(user);
      return null;
    } on FirebaseAuthException catch (e) {
        switch(e.code){
          case "email-already-in-use":
            return "There's already an account with the given email. Please login or try entering another one.";
          default:
            return "Oops, something went wrong. Please try again.";
        }
    }
  }
  else{
    return "All fields are required. Please complete them.";
  }
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

String? _emailValidator(String? email){
  return (email == null || !TextValidator.validateEmail(email)) ? 'Please enter a valid email address.' : null;
}

String? _passwordValidator(String? password){

  if(password == null){
    return "The password cannot be empty.";
  }
  List<bool> results = TextValidator.validatePassword(password);
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

}

String? _usernameValidator(String? username) {
  if (username == null || username.length < Constants.minUsernameLength) {
    return "The username must be at least ${Constants.minUsernameLength} characters long.";
  }
  if (!TextValidator.validateUsername(username)){
    return "The username must be alphanumeric.";
  }
  else{
    return null;
  }
}

String? _fullNameValidator(String? fullName){
  if (fullName == null){
    return "The full name must not be empty.";
  }
  if (!TextValidator.validateFullName(fullName)){
    return "The full name must be alphanumeric (spaces are allowed).";
  }
  else{
    return null;
  }
}

Future<bool> _isUsernameAlreadyTaken(String username) async{
  var ref = BloqoUser.getRef();
  var querySnapshot = await ref.where("username", isEqualTo: username).get();
  if(querySnapshot.docs.length != 0) {
    return true;
  }
  else{
    return false;
  }
}