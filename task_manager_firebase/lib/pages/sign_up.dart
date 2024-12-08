import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase/pages/home.dart';
import '../generated/l10n.dart';
import '../widgets/inputWidget.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _errorMessage = ''; // For displaying error messages
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmedPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(S.of(context).signUp),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputWidget(
              controller: emailController,
              labelText: S.of(context).email,
              obscureText: false,
            ),
            inputWidget(
              controller: passwordController,
              labelText: S.of(context).password,
              obscureText: true, // To hide the password input
            ),
            inputWidget(
              controller: confirmedPasswordController,
              labelText: S.of(context).confirmedPassword,
              obscureText: true, // To hide the password input
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            OutlinedButton(
              child: Text(S.of(context).signUp),
              onPressed: () async {
                // Validate inputs
                if (_validateInputs()) {
                  // Proceed with sign up
                  await _signUp();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // Validate email, password, and confirm password fields
  bool _validateInputs() {
    setState(() {
      _errorMessage = ''; // Clear previous error message
    });

    // Check if email is empty
    if (emailController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Email cannot be empty';
      });
      return false;
    }

    // Check if password is empty
    if (passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Password cannot be empty';
      });
      return false;
    }

    // Check if confirmed password is empty
    if (confirmedPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Confirmed password cannot be empty';
      });
      return false;
    }

    // Check if password and confirmed password match
    if (passwordController.text != confirmedPasswordController.text) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return false;
    }

    // Check if password length is sufficient
    if (passwordController.text.length < 6) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });
      return false;
    }

    return true;
  }

  // Create a new user with email and password
  _signUp() async {
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      print('User created: ${emailController.text}');

      // After successful sign-up, navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      // Handle Firebase exceptions
      setState(() {
        if (e.code == 'weak-password') {
          _errorMessage = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          _errorMessage = 'The account already exists for that email.';
        } else {
          _errorMessage = 'An error occurred: ${e.message}';
        }
      });
      print(_errorMessage);
    } catch (e) {
      setState(() {
        _errorMessage = 'An unknown error occurred: $e';
      });
      print(_errorMessage);
    }
  }
}
