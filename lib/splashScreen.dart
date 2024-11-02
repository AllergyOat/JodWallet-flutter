import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project/auth/auth.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        children: [
          SizedBox(
            height: 300,
            width: 400,
            child: Center(
                child: Lottie.network(
                    'https://lottie.host/ed080334-9790-4a32-bf0f-f237354dce10/KzVtPdPElY.json')),
          ),
          const SizedBox(height: 20),
          Text("JodWallet",
              style: GoogleFonts.poppins(
                  textStyle: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white))),
        ],
      ),
      nextScreen: const AuthPage(),
      splashTransition: SplashTransition.fadeTransition,
      splashIconSize: 400,
      backgroundColor: const Color.fromARGB(255, 1, 30, 56),
    );
  }
}
