import 'dart:ui';

import 'package:bloqo/app_state/learn_course_app_state.dart';
import 'package:bloqo/components/containers/bloqo_main_container.dart';
import 'package:bloqo/model/bloqo_user_data.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_created_data.dart';
import 'package:bloqo/model/user_courses/bloqo_user_course_enrolled_data.dart';
import 'package:bloqo/pages/main/main_page.dart';
import 'package:bloqo/pages/welcome/welcome_page.dart';
import 'package:bloqo/style/themes/bloqo_theme.dart';
import 'package:bloqo/style/themes/purple_orchid_theme.dart';
import 'package:bloqo/utils/auth.dart';
import 'package:bloqo/utils/bloqo_external_services.dart';
import 'package:bloqo/utils/bloqo_startup_information.dart';
import 'package:bloqo/utils/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_state/application_settings_app_state.dart';
import 'app_state/editor_course_app_state.dart';
import 'app_state/user_app_state.dart';
import 'app_state/user_courses_created_app_state.dart';
import 'app_state/user_courses_enrolled_app_state.dart';
import 'utils/firebase_options.dart';

Future<void> main({BloqoExternalServices? externalServices}) async {
  // Ensure WidgetsFlutterBinding is initialized before changing some preferences
  WidgetsFlutterBinding.ensureInitialized();

  // Ensure that notification bar is shown also on iOS
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  // Prevent application from rotating in "landscape" mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  bool fromTest = false;

  // Initialize Firebase app only if no firestore instance is passed
  if (externalServices == null) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    externalServices = BloqoExternalServices(
        firestore: FirebaseFirestore.instance,
        auth: FirebaseAuth.instance,
        storage: FirebaseStorage.instance
    );
  }
  else{
    fromTest = true;
  }

  // Run app
  runApp(
    Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ApplicationSettingsAppState()),
          ChangeNotifierProvider(create: (_) => UserAppState()),
          ChangeNotifierProvider(create: (_) => LearnCourseAppState()),
          ChangeNotifierProvider(create: (_) => EditorCourseAppState()),
          ChangeNotifierProvider(create: (_) => UserCoursesEnrolledAppState()),
          ChangeNotifierProvider(create: (_) => UserCoursesCreatedAppState()),
        ],
        child: BloqoApp(fromTest: fromTest, externalServices: externalServices),
      ),
    )
  );
}

class BloqoApp extends StatefulWidget {
  const BloqoApp({
    super.key,
    required this.fromTest,
    required this.externalServices,
  });

  final bool fromTest;
  final BloqoExternalServices externalServices;

  @override
  State<BloqoApp> createState() => _BloqoAppState();
}

class _BloqoAppState extends State<BloqoApp> {
  BloqoStartupInformation? _startupInformation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {

    if(widget.fromTest) {
      updateFromTestInAppState(context: context);
    }
    updateFirestoreInAppState(context: context, firestore: widget.externalServices.firestore);
    updateAuthInAppState(context: context, auth: widget.externalServices.auth);
    updateStorageInAppState(context: context, storage: widget.externalServices.storage);

    final startupInfo = await _getStartupInformation(context: context);
    if (!mounted) return;

    setState(() {
      _startupInformation = startupInfo;
      _isLoading = false;
    });

    updateLanguageInAppState(context: context, newLanguageCode: startupInfo.locale.languageCode);
    updateAppThemeInAppState(context: context, newTheme: startupInfo.theme);

    if (startupInfo.isLoggedIn) {
      saveUserToAppState(context: context, user: startupInfo.user!);
      saveUserCoursesEnrolledToAppState(context: context, courses: startupInfo.userCoursesEnrolled!);
      saveUserCoursesCreatedToAppState(context: context, courses: startupInfo.userCoursesCreated!);
    }

  }

  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      useDefaultLoading: false,
      overlayWidgetBuilder: (_) {
        return Center(
          child: LoadingAnimationWidget.prograssiveDots(
            color: getAppThemeFromAppState(context: context).colors.leadingColor,
            size: 100,
          ),
        );
      },
      child: _buildAppContent(context),
    );
  }

  Widget _buildAppContent(BuildContext context) {
    return Consumer<ApplicationSettingsAppState>(
      builder: (context, applicationSettingsAppState, _) {
        if (_isLoading) {
          return _buildLoadingScreen();
        }

        if (_startupInformation!.isLoggedIn) {
          return _buildMainScreen();
        } else {
          return _buildWelcomeScreen();
        }
      },
    );
  }

  Widget _buildLoadingScreen() {
    return BloqoMainContainer(
      child: Center(
        child: LoadingAnimationWidget.prograssiveDots(
          color: const Color(0xFFF7F9F9),
          size: 100,
        ),
      ),
    );
  }

  Widget _buildWelcomeScreen() {
    return MaterialApp(
      title: 'bloQo',
      theme: getAppThemeFromAppState(context: context).getThemeData(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: getLanguageFromAppState(context: context),
      home: const WelcomePage(),
    );
  }

  Widget _buildMainScreen() {
    return MaterialApp(
      title: 'bloQo',
      theme: getAppThemeFromAppState(context: context).getThemeData(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: getLanguageFromAppState(context: context),
      home: const MainPage(),
    );
  }

  Future<BloqoStartupInformation> _getStartupInformation({required BuildContext context}) async {
    final bool isLoggedIn = await _checkIfUserIsLoggedIn();

    if(!context.mounted) {
      return BloqoStartupInformation(
        isLoggedIn: false,
        locale: const Locale('en'),
        theme: PurpleOrchidTheme()
      );
    }

    final Locale locale = await _getInitLanguage(context: context);

    if(!context.mounted) {
      return BloqoStartupInformation(
        isLoggedIn: false,
        locale: const Locale('en'),
        theme: PurpleOrchidTheme()
      );
    }

    final BloqoAppTheme theme = await _getInitTheme(context: context);

    if (isLoggedIn) {
      try {
        String userId = await getUserIdFromSharedPreferences();
        BloqoUserData user = await silentGetUserFromId(id: userId);
        List<BloqoUserCourseEnrolledData> userCoursesEnrolled = await silentGetUserCoursesEnrolled(user: user);
        List<BloqoUserCourseCreatedData> userCoursesCreated = await silentGetUserCoursesCreated(user: user);
        return BloqoStartupInformation(
          isLoggedIn: isLoggedIn,
          locale: locale,
          theme: theme,
          user: user,
          userCoursesCreated: userCoursesCreated,
          userCoursesEnrolled: userCoursesEnrolled,
        );
      } on Exception catch (_) {
        return BloqoStartupInformation(
          isLoggedIn: false,
          locale: locale,
          theme: theme,
        );
      }
    } else {
      return BloqoStartupInformation(
        isLoggedIn: false,
        locale: locale,
        theme: theme
      );
    }
  }

  Future<bool> _checkIfUserIsLoggedIn() async {
    if(widget.fromTest){
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(sharedLogged) ?? false) {
      try {
        await silentLogin(
          email: prefs.getString(sharedUserEmail)!,
          password: prefs.getString(sharedPassword)!,
        );
        return true;
      } catch (error) {
        return false;
      }
    }
    return false;
  }

  Future<Locale> _getInitLanguage({required BuildContext context}) async {
    if(widget.fromTest){
      return const Locale('en');
    }

    Locale? savedLocale = await readLanguageCode();
    if (savedLocale != null) {
      return savedLocale;
    }

    Locale deviceLocale = PlatformDispatcher.instance.locale;
    if (AppLocalizations.supportedLocales
        .map((locale) => locale.languageCode)
        .contains(deviceLocale.languageCode)) {
      return deviceLocale;
    }

    return const Locale('en');
  }

  Future<BloqoAppTheme> _getInitTheme({required BuildContext context}) async {
    if(widget.fromTest){
      return PurpleOrchidTheme();
    }
    String? savedTheme = await readAppTheme();
    if (savedTheme != null) {
      return getAppThemeBasedOnStringType(stringType: savedTheme);
    }
    else{
      return PurpleOrchidTheme();
    }
  }

}