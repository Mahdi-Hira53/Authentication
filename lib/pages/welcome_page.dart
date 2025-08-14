import 'package:authentication/auth/auth_gate.dart';
import 'package:authentication/pages/login_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset("images/bg_image1.png", fit: BoxFit.cover),
          ),

          Center(
            child: Column(
              children: [
                SizedBox(height: height * 0.35),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: height * 0.010),
                Text(
                  "Enter your details",
                  style: TextStyle(
                    color: Colors.white,
                      fontSize: 20, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: height * .45),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0x00dab1da),
                    foregroundColor: Colors.black,
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AuthGate()));
                  },
                  child: Text("Next", style: TextStyle(
                    fontSize: 20,
                    color: Colors.white
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
