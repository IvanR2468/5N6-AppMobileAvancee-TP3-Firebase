import 'package:cloud_firestore/cloud_firestore.dart';
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
    TextEditingController usernameController = TextEditingController();
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
              usernameController: usernameController,
              labelText: S.of(context).username,
            ),
            inputWidget(
              usernameController: passwordController,
              labelText: S.of(context).password,
            ),
            inputWidget(
              usernameController: confirmedPasswordController,
              labelText: S.of(context).confirmedPassword,
            ),
            OutlinedButton(
              child: Text(S.of(context).signUp),
              onPressed: () async {
                if (passwordController.text == confirmedPasswordController.text) {
                  CollectionReference usersCollection =
                  FirebaseFirestore.instance.collection('users');
                  usersCollection.add({
                    'username': usernameController.text,
                    'password': usernameController.text,
                  });
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>  const Home()
                      )
                  );
                } else {
                  final snackBar = SnackBar(
                    content: Text(S.of(context).passwordNotConfirmed),
                    action: SnackBarAction(
                        label: 'Ok',
                        onPressed: () {}
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }

              },
            ),
          ],
        ),
      ),
    );
  }
}
