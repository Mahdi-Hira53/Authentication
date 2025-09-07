
import 'package:authentication/auth/auth_gate.dart';
import 'package:authentication/pages/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main()async{
  //supabase initialize
  await Supabase.initialize(
      url: "https://pfqkabnhgdbabxibzpnu.supabase.co",
      anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBmcWthYm5oZ2RiYWJ4aWJ6cG51Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTUxMzI1NDUsImV4cCI6MjA3MDcwODU0NX0.L3MXvnyCNI7BbDfc1AhoOd_FOPiFf63QKoYSD_HHMUs");

  //await runMigrations();
  runApp(MyApp());
}

  //final supabase = Supabase.instance.client;

  /*Future<void>runMigrations()async{
    final createTableSQL = """create table if not exists notes (
      id uuid primary key default uuid_generate_v4(),
      title text,
      content text,
      created_at timestamp with time zone default now()
    )""";
    final response = await supabase.rpc('exec_sql', params:{
      'query': createTableSQL,
    });

    if(response.error !=null){
      print("Migration error");
    }else{
      print("Notes table ready");
    }
  }*/

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Authentication",
      home: AuthGate(),
    );
  }
}
