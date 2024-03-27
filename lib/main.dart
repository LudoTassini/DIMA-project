import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'pages/all.dart';

void main() {

  //ensures that notification bar is shown also on iOS
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top], );

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
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(title: 'bloQo Home Page'),
    );
  }
}
