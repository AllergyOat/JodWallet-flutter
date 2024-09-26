import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/component/text_field.dart';
import 'package:project/component/button.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // sign in user
  void signIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // pop the loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // display error message
      displayMessage(e.code);
    }
  }

  // display a dialog message to user
  void displayMessage(String message) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // const Icon(Icons.account_circle, size: 100),
                const SizedBox(height: 10),
                Text(
                  'สวัสดี!',
                  style: GoogleFonts.notoSansThai(
                    textStyle: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Welcome back, nice to meet you",
                  style: GoogleFonts.outfit(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 30),

                // email text field
                MyTextField(
                  controller: emailTextController,
                  hintText: "Email",
                  obsecureText: false,
                ),
                const SizedBox(height: 11),

                // password text field
                MyTextField(
                  controller: passwordTextController,
                  hintText: "Password",
                  obsecureText: true,
                ),
                const SizedBox(height: 13),

                //sign in button
                MyButton(onTap: signIn, text: 'Sign in'),
                const SizedBox(height: 20),

                // register suggestion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: GoogleFonts.outfit(
                          textStyle: const TextStyle(color: Colors.black)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register here',
                          style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                  color: Colors.deepPurple,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
