import 'dart:async';

import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/pages/welcome/register_page.dart';
import 'package:bloqo/utils/auth.dart';
import 'package:bloqo/utils/bloqo_exception.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_state/user_courses_created_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_user.dart';
import '../../model/bloqo_user_course_created.dart';
import '../../model/bloqo_user_course_enrolled.dart';
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
    final localizedText = getAppLocalizations(context)!;
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
                          localizedText.welcome,
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
                          labelText: localizedText.email,
                          hintText: localizedText.email_hint,
                          maxInputLength: Constants.maxEmailLength,
                          validator: (String? value) {return emailValidator(email: value, localizedText: localizedText);},
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
                            labelText: localizedText.password,
                            hintText: localizedText.password_hint,
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
                            try {
                              await _tryLogin(localizedText: localizedText, email: emailController.text, password: passwordController.text);
                              BloqoUser user = await getUserFromEmail(localizedText: localizedText, email: emailController.text);
                              List<BloqoUserCourseEnrolled> userCoursesEnrolled = await _getUserCoursesEnrolled(
                                  localizedText: localizedText, user: user);
                              List<BloqoUserCourseCreated> userCoursesCreated = await _getUserCoursesCreated(
                                  localizedText: localizedText, user: user);
                              if(!context.mounted) return;
                              saveUserToAppState(context, user);
                              saveUserCoursesToAppState(context: context, userCoursesEnrolled: userCoursesEnrolled,
                                  userCoursesCreated: userCoursesCreated);
                              context.loaderOverlay.hide();
                              Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => const MainPage()),
                              );
                            } on BloqoException catch (e) {
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
                          text: localizedText.login,
                        ),
                      ),
                      BloqoTextButton(
                        text: localizedText.forgot_password,
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
                    localizedText.new_here,
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
                      text: localizedText.register_now,
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

Future<void> _tryLogin({required var localizedText, required String email, required String password}) async {
  try {
    await login(email: email, password: password);
    //save on the shared preferences that the user is logged in
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(sharedLogged, true);
    await prefs.setString(sharedUser, email);
    await prefs.setString(sharedPassword, password);
  } on FirebaseAuthException catch (e){
    switch(e.code){
      case "network-request-failed":
        throw BloqoException(message: localizedText.login_network_error);
      default:
        throw BloqoException(message: localizedText.login_credentials_error);
    }
  }
}


// FIXME: limitare a tre corsi e che siano i più recenti (guardare the latest update)
Future<List<BloqoUserCourseEnrolled>> _getUserCoursesEnrolled({required var localizedText, required BloqoUser user}) async {
  try {
    var ref = BloqoUserCourseEnrolled.getRef();
    var querySnapshot = await ref.where("user_email", isEqualTo: user.email).get();
    List<BloqoUserCourseEnrolled> userCourses = [];
    for(var doc in querySnapshot.docs) {
        userCourses.add(doc.data());
      }
    return userCourses;
  } on FirebaseAuthException catch(e){
    switch(e.code){
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

/*
Future<List<BloqoUserCourseEnrolled>> _getUserCoursesEnrolled({ required var localizedText,
  required BloqoUser user, DocumentSnapshot? lastDocument,
}) async {
  int limit = 3;
  try {
    var ref = BloqoUserCourseEnrolled.getRef();
    var query = ref.where("userEmail", isEqualTo: user.email).orderBy("lastUpdated", descending: true).limit(limit);
    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }
    var querySnapshot = await query.get();
    List<BloqoUserCourseEnrolled> userCourses = [];
    for (var doc in querySnapshot.docs) {
      userCourses.add(doc.data());
    }
    return userCourses;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
} */


// FIXME: limitare a tre corsi e che siano i più recenti (guardare the latest update)
Future<List<BloqoUserCourseCreated>> _getUserCoursesCreated({required var localizedText, required BloqoUser user}) async {
  try {
    var ref = BloqoUserCourseCreated.getRef();
    var querySnapshot = await ref.where("user_email", isEqualTo: user.email).get();
    List<BloqoUserCourseCreated> userCourses = [];
    for(var doc in querySnapshot.docs) {
      userCourses.add(doc.data());
    }
    return userCourses;
  } on FirebaseAuthException catch(e){
    switch(e.code){
      case "network-request-failed":
        throw BloqoException(message: localizedText.network_error);
      default:
        throw BloqoException(message: localizedText.generic_error);
    }
  }
}

void saveUserCoursesToAppState({required BuildContext context, required List<BloqoUserCourseEnrolled> userCoursesEnrolled,
  required List<BloqoUserCourseCreated> userCoursesCreated}){
  Provider.of<UserCoursesEnrolledAppState>(context, listen: false).set(userCoursesEnrolled);
  Provider.of<UserCoursesCreatedAppState>(context, listen: false).set(userCoursesCreated);
}