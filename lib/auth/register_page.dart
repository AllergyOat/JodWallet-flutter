import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../component/button.dart';
import '../component/text_field.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();

  // Regular expression for email validation
  final RegExp emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+$');

  // Sign up user
  void signUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    // Validate email format
    if (!emailRegExp.hasMatch(emailTextController.text)) {
      Navigator.pop(context);
      displayMessage('อีเมลไม่ถูกต้อง');
      return;
    }

    // Validate password length
    if (passwordTextController.text.length < 6) {
      Navigator.pop(context);
      displayMessage('กรุณากรอกรหัสผ่านให้ครบ 6 ตัวอักษรขึ้นไป');
      return;
    }

    // Validate if passwords match
    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage('รหัสผ่านไม่ตรงกัน');
      return;
    }

    try {
      // Attempt to create user with email and password
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );

      // Pop the loading circle
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
      backgroundColor:  Color.fromARGB(255, 1, 30, 56),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle, size: 100, color: Colors.white),
                const SizedBox(height: 20),
                Text('มาสร้าง account กันเถอะ!',
                    style: GoogleFonts.notoSansThai(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 30,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                // Email text field
                MyTextField(
                  controller: emailTextController,
                  hintText: "Email",
                  obsecureText: false,
                ),
                const SizedBox(height: 10),

                // Password text field
                MyTextField(
                  controller: passwordTextController,
                  hintText: "Password  (6 characters minimum)",
                  obsecureText: true,
                ),
                const SizedBox(height: 10),

                // Confirm password text field
                MyTextField(
                  controller: confirmPasswordTextController,
                  hintText: "Confirm Password",
                  obsecureText: true,
                ),
                const SizedBox(height: 15),

                // Sign Up button
                MyButton(onTap: signUp, text: 'Sign Up'),
                const SizedBox(height: 20),

                // Register suggestion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',
                        style: GoogleFonts.outfit(color: const Color.fromARGB(255, 255, 255, 255))),
                    TextButton(
                      onPressed: () {},
                      child: GestureDetector(
                        onTap: widget.onTap,
                        child: Text('Login here',
                            style: GoogleFonts.outfit(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold)),
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
