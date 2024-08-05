import 'dart:async';

import 'package:bloqo/components/buttons/bloqo_text_button.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/components/containers/bloqo_seasalt_container.dart';
import 'package:bloqo/components/forms/bloqo_text_field.dart';
import 'package:bloqo/pages/welcome/register_page.dart';
import 'package:bloqo/utils/auth.dart';
import 'package:bloqo/utils/bloqo_exception.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../app_state/user_app_state.dart';
import '../../app_state/user_courses_created_app_state.dart';
import '../../app_state/user_courses_enrolled_app_state.dart';
import '../../components/buttons/bloqo_filled_button.dart';
import '../../components/popups/bloqo_error_alert.dart';
import '../../model/bloqo_user.dart';
import '../../model/bloqo_user_course_created.dart';
import '../../model/bloqo_user_course_enrolled.dart';
import '../../utils/constants.dart';
import '../../style/bloqo_colors.dart';
import '../../utils/shared_preferences.dart';
import '../../utils/text_validator.dart';
import '../main/main_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

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

  Future<void> _tryLogin({required BuildContext context, required var localizedText, required String email, required String password}) async {
    context.loaderOverlay.show();
    try {

      // logs in
      await login(
        localizedText: localizedText,
        email: email,
        password: password);

      // gets user data
      BloqoUser user = await getUserFromEmail(
          localizedText: localizedText, email: email);

      // saves on the shared preferences that the user is logged in along with some data
      addSharedPreferences(
        id: user.id,
        email: email,
        password: password
      );

      List<BloqoUserCourseEnrolled> userCoursesEnrolled = await getUserCoursesEnrolled(
          localizedText: localizedText, user: user);
      List<BloqoUserCourseCreated> userCoursesCreated = await getUserCoursesCreated(
          localizedText: localizedText, user: user);

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