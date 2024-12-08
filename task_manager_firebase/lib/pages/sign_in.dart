import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:task_manager_firebase/pages/home.dart';
import 'package:task_manager_firebase/pages/sign_up.dart';

import '../generated/l10n.dart';
import '../widgets/inputWidget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  String _errorMessage = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(S.of(context).signIn),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            inputWidget(
              controller: emailController,
              labelText: S.of(context).email,
              obscureText: false,
            ),
            inputWidget(
              controller: passwordController,
              labelText: S.of(context).password,
              obscureText: true,
            ),
            OutlinedButton(
              child: Text(S.of(context).signIn),
              onPressed: () async {
                // First, validate input
                if (_inputsAreValid()) {
                  await signIn();
                }
              },
            ),
            TextButton(
              child: Text(S.of(context).signUp),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SignUp()));
              },
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const Divider(
              indent: 25,
              endIndent: 25,
            ),
            SignInButton(
              Buttons.google,
              text: 'Sign in with Google',
              onPressed: () async {
                await signInWithGoogle();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Validate email and password input
  bool _inputsAreValid() {
    setState(() {
      _errorMessage = ''; // Clear previous error message
    });

    if (emailController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Email cannot be empty';
      });
      return false;
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Password cannot be empty';
      });
      return false;
    }

    return true;
  }

  // Firebase Email/Password Sign-In
  signIn() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text
      );
      print('USER FOUND: ${emailController.text}');
      // After successful sign-in, navigate to the home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        if (e.code == 'user-not-found') {
          _errorMessage = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          _errorMessage = 'Wrong password provided for that user.';
        } else {
          _errorMessage = e.message ?? 'An error occurred. Please try again.';
        }
      });
      print(_errorMessage);
    }
  }

  // Firebase Google Sign-In
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User canceled Google sign-in
        return Future.error('Google sign-in canceled');
      }

      final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      setState(() {
        _errorMessage = 'Google sign-in failed: ${e.toString()}';
      });
      print(_errorMessage);
      return Future.error(e.toString());
    }
  }
}
