import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

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
            const SignInButton(
                Buttons.google,
                onPressed: signInWithGoogle,
                text: 'signin with Google'),
            OutlinedButton(onPressed: () async {
              // await signUp();
            },
                child: Text(S.of(context).signUp)
            ),
          ],
        ),
      ),
    );
  }


}
