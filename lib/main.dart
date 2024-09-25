import 'package:flutter/material.dart';
import 'package:project/auth/auth.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAjHL2AZSS6wsYLHcqh-0gVn1c5PVxn-po",
          appId: "1:8656224752:android:673a0f577686f968d59d35",
          messagingSenderId: "",
          projectId: "saving-app-3b5e8"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}
