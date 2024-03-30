import 'package:bloqo/pages/welcome/welcome_page.dart';
import 'package:bloqo/style/bloqo_theme.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // it's here just to signal I should have installed it (authentication)


Future<void> main() async {

  //ensures WidgetsFlutterBinding is initialized before changing some preferences
  WidgetsFlutterBinding.ensureInitialized();

  //ensures that notification bar is shown also on iOS
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top], );

  //prevents application from rotating in "landscape" mode
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //runs app
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'bloQo',
      theme: BloqoTheme.get(),
      home: const WelcomePage(),
    );
  }
}
