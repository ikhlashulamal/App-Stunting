import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:stunting/welcome_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreeen(),
    );
  }
}
