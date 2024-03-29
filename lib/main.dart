import 'package:flutter/foundation.dart';

import 'pages/all.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // it's here just to signal I should have installed it (authentication)


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Initialize Firestore instance
  FirebaseFirestore db = FirebaseFirestore.instance;

  await db.collection("DIMA-project").get().then((event) {
    for (var doc in event.docs) {
      print("${doc.id} => ${doc.data()}");
    }
  });

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
