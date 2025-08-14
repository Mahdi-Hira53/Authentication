import 'package:authentication/auth/auth_services.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final authServices = AuthServices();
  void logout()async{
    await authServices.signOut();
  }
  @override
  Widget build(BuildContext context) {
    final currentEmail = authServices.getCurrentUserEmail();
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Page"),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(onPressed: logout, icon: Icon(Icons.logout_rounded)),
        ],
      ),
      body: Center(
        child: Text(currentEmail.toString()),
      ),

    );
  }
}
