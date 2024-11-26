import 'package:flutter/material.dart';
import 'package:task_manager_firebase/pages/sign_up.dart';

import '../generated/l10n.dart';
import '../widgets/inputWidget.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {

    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

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
            OutlinedButton(onPressed: () async {
              // Sign in logic
            }, child: Text(S.of(context).signIn)),
            TextButton(onPressed: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const SignUp()
                  )
              );
            },
                child: Text(S.of(context).signUp)
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () { },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


