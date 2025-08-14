import 'package:authentication/pages/login_page.dart';
import 'package:authentication/pages/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main()async{
  // supabase initialize
  await Supabase.initialize(
      url: "https://pfqkabnhgdbabxibzpnu.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmcWthYm5oZ2RiYWJ4aWJ6cG51Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUxMzI1NDUsImV4cCI6MjA3MDcwODU0NX0.L3MXvnyCNI7BbDfc1AhoOd_FOPiFf63QKoYSD_HHMUs");

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
