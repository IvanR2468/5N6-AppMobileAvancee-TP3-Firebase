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
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
            inputWidget(controller: emailController, labelText: S.of(context).email, obscureText: false,),
            inputWidget(controller: passwordController, labelText: S.of(context).password, obscureText: true),
            _buildSignInButton(),
            TextButton(
              child: Text(S.of(context).signUp),
              onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUp())),
            ),
            if (_errorMessage.isNotEmpty) _buildErrorMessage(),
            const Divider(indent: 25, endIndent: 25),
            _buildGoogleSignInButton(),
          ],
        ),
      ),
    );
  }

  // Sign-in button for email/password login
  Widget _buildSignInButton() {
    return OutlinedButton(
      child: Text(S.of(context).signIn),
      onPressed: () async {
        if (_inputsAreValid()) {
          await signIn();
        }
      },
    );
  }

  // Google sign-in button
  Widget _buildGoogleSignInButton() {
    return SignInButton(
      Buttons.google,
      text: 'Continue with Google',
      onPressed: () async {
        await signInWithGoogle();
      },
    );
  }

  // Error message display
  Widget _buildErrorMessage() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Text(_errorMessage, style: const TextStyle(color: Colors.red)),
    );
  }

  // Validate email and password inputs
  bool _inputsAreValid() {
    setState(() => _errorMessage = '');

    if (emailController.text.isEmpty) {
      setState(() => _errorMessage = 'Email cannot be empty');
      return false;
    }

    if (passwordController.text.isEmpty) {
      setState(() => _errorMessage = 'Password cannot be empty');
      return false;
    }

    return true;
  }

  // Email/password sign-in
  Future<void> signIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.code == 'user-not-found'
            ? 'No user found for that email.'
            : e.code == 'wrong-password'
            ? 'Wrong password provided for that user.'
            : e.message ?? 'An error occurred. Please try again.';
      });
    }
  }

  // Google sign-in
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled sign-in

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final credentials =  await FirebaseAuth.instance.signInWithCredential(credential);
      // final User? user = credentials.user;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      setState(() => _errorMessage = 'Google sign-in failed: ${e.toString()}');
    }
  }
}
