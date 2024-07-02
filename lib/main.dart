import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/pages/main/main_page.dart';
import 'package:bloqo/pages/welcome/welcome_page.dart';
import 'package:bloqo/style/bloqo_colors.dart';
import 'package:bloqo/style/bloqo_theme.dart';
import 'package:bloqo/utils/auth.dart';
import 'package:bloqo/utils/localization.dart';
import 'package:bloqo/utils/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_state/editor_course_app_state.dart';
import 'app_state/user_app_state.dart';
import 'app_state/user_courses_created_app_state.dart';
import 'app_state/user_courses_enrolled_app_state.dart';
import 'utils/firebase_options.dart';

Future<void> main() async {
  // Ensure WidgetsFlutterBinding is initialized before changing some preferences
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure that notification bar is shown also on iOS
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  // Prevent application from rotating in "landscape" mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final bool userIsLoggedIn = await _checkIfUserIsLoggedIn();

  // Run app
  runApp(
    Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserAppState()),
          ChangeNotifierProvider(create: (_) => EditorCourseAppState()),
          ChangeNotifierProvider(create: (_) => UserCoursesEnrolledAppState()),
          ChangeNotifierProvider(create: (_) => UserCoursesCreatedAppState()),
        ],
        child: MyApp(
          userIsLoggedIn: userIsLoggedIn,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.userIsLoggedIn,
  });

  final bool userIsLoggedIn;

  @override
  Widget build(BuildContext context) {
    var localizedText = getAppLocalizations(context);
    return MaterialApp(
      title: 'bloQo',
      theme: BloqoTheme.get(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidgetBuilder: (_) {
          return Center(
            child: LoadingAnimationWidget.prograssiveDots(
              color: BloqoColors.russianViolet,
              size: 100,
            ),
          );
        },
        child: FutureBuilder<bool>(
          future: _checkIfUserIsLoggedIn(localizedText: localizedText),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return BloqoMainContainer(child:
                Center(
                  child: LoadingAnimationWidget.prograssiveDots(
                    color: BloqoColors.seasalt,
                    size: 100,
                  ),
                )
              );
            } else if (snapshot.hasData && snapshot.data == true) {
              return const MainPage();
            } else {
              return const WelcomePage();
            }
          },
        ),
      ),
    );
  }
}

Future<bool> _checkIfUserIsLoggedIn({AppLocalizations? localizedText}) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getBool(sharedLogged) ?? false) {
    try {
      await login(
        email: prefs.getString(sharedUserEmail)!,
        password: prefs.getString(sharedPassword)!,
        localizedText: localizedText!,
      );
      return true;
    } catch (error) {
      return false;
    }
  }
  return false;
}