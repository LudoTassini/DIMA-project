// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC3YG0jSxyiv7Zn0Q-3aQsLrceoGshmwiU',
    appId: '1:736847386121:web:fd73a28af542e23137cad8',
    messagingSenderId: '736847386121',
    projectId: 'dima-project-91bba',
    authDomain: 'dima-project-91bba.firebaseapp.com',
    storageBucket: 'dima-project-91bba.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_guKaBDjSc1VlTfdIzp3HXsSsDP8J0_M',
    appId: '1:736847386121:android:c77590f1a2b58eaa37cad8',
    messagingSenderId: '736847386121',
    projectId: 'dima-project-91bba',
    storageBucket: 'dima-project-91bba.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCfQkJC39jxf52XC2P3PLZxo6bLRYrOggM',
    appId: '1:736847386121:ios:cd9501b503abde4337cad8',
    messagingSenderId: '736847386121',
    projectId: 'dima-project-91bba',
    storageBucket: 'dima-project-91bba.appspot.com',
    iosBundleId: 'com.example.bloqo',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCfQkJC39jxf52XC2P3PLZxo6bLRYrOggM',
    appId: '1:736847386121:ios:cc83b7c9d9aeb9d937cad8',
    messagingSenderId: '736847386121',
    projectId: 'dima-project-91bba',
    storageBucket: 'dima-project-91bba.appspot.com',
    iosBundleId: 'com.example.bloqo.RunnerTests',
  );
}
