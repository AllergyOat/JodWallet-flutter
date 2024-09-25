import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  // sign up user
  void signUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(child: CircularProgressIndicator()));

    if (passwordTextController.text != confirmPasswordTextController.text) {
      Navigator.pop(context);
      displayMessage('Password does not match');
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
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
                const Icon(Icons.account_circle, size: 100),
                const SizedBox(height: 20),
                const Text('Let create account'),
                const SizedBox(height: 20),

                // email text field
                MyTextField(
                  controller: emailTextController,
                  hintText: "Email",
                  obsecureText: false,
                ),
                const SizedBox(height: 10),

                // password text field
                MyTextField(
                  controller: passwordTextController,
                  hintText: "Password",
                  obsecureText: true,
                ),
                const SizedBox(height: 10),

                // confirm password text field
                MyTextField(
                  controller: confirmPasswordTextController,
                  hintText: "Confirm Password",
                  obsecureText: true,
                ),
                const SizedBox(height: 10),

                //sign Up button
                MyButton(onTap: signUp, text: 'Sign Up'),

                // register suggestion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account?'),
                    TextButton(
                      onPressed: () {},
                      child: GestureDetector(
                        onTap: widget.onTap,
                        child: const Text('Login here',
                            style: TextStyle(
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
