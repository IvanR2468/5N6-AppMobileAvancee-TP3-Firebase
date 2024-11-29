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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _errorMessage = '';

  TextEditingController usernameController = TextEditingController();
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
              usernameController: usernameController,
              labelText: S.of(context).username,
            ),
            inputWidget(
              usernameController: passwordController,
              labelText: S.of(context).password,
            ),
            OutlinedButton(
              child: Text(S.of(context).signIn),
              onPressed: () async {
                signIn();
              },
            ),
            TextButton(
              child: Text(S.of(context).signUp),
              onPressed: () {
                Navigator.of(context).push(
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
                Navigator.push(
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

  signIn() async {
    try {
      // Query Firestore for the user with the matching username
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: usernameController.text)
          .where('password', isEqualTo: passwordController.text)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _errorMessage = 'User not found';
        });
        return;
      }

      // Get the user document
      final userDoc = snapshot.docs.first;
      final storedPassword = userDoc['password'];  // You should use hashed passwords in practice

      if (storedPassword == passwordController.text) {
        // If the passwords match, you can proceed (e.g., navigate to the home page)
        print("User signed in successfully: ${userDoc['username']}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        setState(() {
          _errorMessage = 'Incorrect password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
      });
    }
  }
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
    await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
