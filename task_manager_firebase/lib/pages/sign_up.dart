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
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController confirmedPasswordController = TextEditingController();

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
            ),
            inputWidget(
              controller: passwordController,
              labelText: S.of(context).password,
            ),
            inputWidget(
              controller: confirmedPasswordController,
              labelText: S.of(context).confirmedPassword,
            ),
            OutlinedButton(
              child: Text(S.of(context).signUp),
              onPressed: () async {
                // if (passwordController.text == confirmedPasswordController.text) {
                //
                // } else {
                //   final snackBar = SnackBar(
                //     content: Text(S.of(context).passwordNotConfirmed),
                //     action: SnackBarAction(
                //         label: 'Ok',
                //         onPressed: () {}
                //     ),
                //   );
                //   ScaffoldMessenger.of(context).showSnackBar(snackBar);
                // }
                try {
                  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
                Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) =>  const Home()
                    )
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
