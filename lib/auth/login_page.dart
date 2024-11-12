import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/component/text_field.dart';
import 'package:project/component/button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // Regular expression for email validation
  final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  // Sign in user
  void signIn() async {
    // show loading circle
    showDialog(
      context: context,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    // Validate email format
    if (!emailRegExp.hasMatch(emailTextController.text)) {
      Navigator.pop(context); // Pop the loading indicator
      displayMessage('กรุณากรอกอีเมลให้ถูกต้อง');
      return;
    }

    // Validate password length
    if (passwordTextController.text.length < 6) {
      Navigator.pop(context); // Pop the loading indicator
      displayMessage('กรุณากรอกรหัสผ่านให้ถูกต้อง');
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // pop the loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // Display error message
      displayMessage(e.code);
    }
  }

  // Display a dialog message to user
  void displayMessage(String message) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 1, 30, 56),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Lottie.network(
                  'https://lottie.host/e757eae2-334f-42d2-9902-b2dcef307b9c/16eefh8HiB.json',
                  width: 250,
                  height: 250,
                  fit: BoxFit.fill,
                ),
                const SizedBox(height: 20),
                Text(
                  'สวัสดี!',
                  style: GoogleFonts.notoSansThai(
                      textStyle: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.bold),
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Welcome to meBudget\nExpense and Income Tracker App",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        textStyle: const TextStyle(fontSize: 20),
                        color: Colors.white,
                      ),
                    ),
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

                // sign in button
                MyButton(onTap: signIn, text: 'Sign in'),
                const SizedBox(height: 20),

                // register suggestion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: GoogleFonts.outfit(
                          textStyle: const TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255))),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: GestureDetector(
                        onTap: widget.onTap,
                        child: Text(
                          'Register here 555',
                          style: GoogleFonts.outfit(
                              textStyle: const TextStyle(
                                  color: Color.fromARGB(255, 49, 143, 231),
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
