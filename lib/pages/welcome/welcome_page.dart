import 'dart:async';

import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/pages/welcome/register_page.dart';
import 'package:bloqo/utils/auth.dart';
import 'package:bloqo/utils/bloqo_exception.dart';
import 'package:bloqo/utils/check_device.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../app_state/application_settings_app_state.dart';
import '../../app_state/user_app_state.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_user_data.dart';
import '../../model/user_courses/bloqo_user_course_created_data.dart';
import '../../model/user_courses/bloqo_user_course_enrolled_data.dart';
import '../../utils/constants.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/text_validator.dart';
import '../main/main_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
  });

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

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
    var theme = getAppThemeFromAppState(context: context);
    bool isTablet = checkDevice(context);

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

              Padding(
                padding: !isTablet ? const EdgeInsetsDirectional.all(0)
                : Constants.tabletPaddingWelcomePages,
                child: BloqoSeasaltContainer(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(15, 20, 15, 15),
                    child: Column(
                      children: [
                        Text(
                          localizedText.welcome,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: theme.colors.leadingColor,
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
                            validator: (String? value) { return emailValidator(email: value, localizedText: localizedText);},
                            keyboardType: TextInputType.emailAddress,
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
                            ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(30, 15, 30, 10),
                          child: BloqoFilledButton(
                            onPressed: () async {
                              await _tryLogin(
                                    context: context,
                                    localizedText: localizedText,
                                    email: emailController.text,
                                    password: passwordController.text);
                            },
                            color: theme.colors.leadingColor,
                            text: localizedText.login,
                          ),
                        ),
                      ]
                    ),
                  ),
                ),
              ),

              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    localizedText.new_here,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: theme.colors.highContrastColor,
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
                      color: theme.colors.leadingColor,
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

  Future<void> _tryLogin({required BuildContext context, required var localizedText, required String email, required String password}) async {
    context.loaderOverlay.show();
    try {

      var firestore = getFirestoreFromAppState(context: context);
      var auth = getAuthFromAppState(context: context);

      // logs in
      await login(
        localizedText: localizedText,
        email: email,
        password: password,
        auth: auth
      );

      // gets user data
      BloqoUserData user = await getUserFromEmail(
          firestore: firestore, localizedText: localizedText, email: email);

      // saves on the shared preferences that the user is logged in along with some data

      if (!context.mounted) return;
      if(!getFromTestFromAppState(context: context)) {
        addUserSharedPreferences(
            id: user.id,
            email: email,
            password: password
        );
      }

      List<BloqoUserCourseEnrolledData> userCoursesEnrolled = await getUserCoursesEnrolled(
          firestore: firestore, localizedText: localizedText, user: user);

      List<BloqoUserCourseCreatedData> userCoursesCreated = await getUserCoursesCreated(
          firestore: firestore, localizedText: localizedText, user: user);

      if (!context.mounted) return;

      saveUserToAppState(context: context, user: user);
      saveUserCoursesEnrolledToAppState(context: context, courses: userCoursesEnrolled);
      saveUserCoursesCreatedToAppState(context: context, courses: userCoursesCreated);

      context.loaderOverlay.hide();

      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: (context) => const MainPage()),
      );
    }
    on BloqoException catch (e) {
      if(!context.mounted) return;
      context.loaderOverlay.hide();
      showBloqoErrorAlert(
        context: context,
        title: localizedText.error_title,
        description: e.message,
      );
    }
  }

}