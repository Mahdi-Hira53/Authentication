import 'package:authentication/pages/login_page.dart';
import 'package:authentication/pages/welcome_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Authentication",
      home: WelcomePage(),
    );
  }
}
