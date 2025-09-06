import 'package:authentication/pages/login_page.dart';
import 'package:authentication/pages/notes_page.dart';
import 'package:authentication/pages/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final session = snapshot.hasData ? snapshot.data!.session : null;

        if(session != null){
          return NotesPage();
        }else{
          return Login();
        }

      },
    );
  }
}
