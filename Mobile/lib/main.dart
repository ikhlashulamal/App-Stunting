import 'package:flutter/material.dart';
import 'package:stuntingapp/pages/home_page2.dart';
import 'package:stuntingapp/pages/splashscreen.dart';
import 'package:stuntingapp/widget_tree.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBvfDN_qz7EM_ittgyMN4S4Pw5vMls2tPE",
          appId: "1:538620452635:android:2eb0c7c992580e12767dbe",
          messagingSenderId: "538620452635",
          projectId: "fir-auth-777da"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: SplashScreen(),
      // home: HomePage2(),
    );
  }
}
