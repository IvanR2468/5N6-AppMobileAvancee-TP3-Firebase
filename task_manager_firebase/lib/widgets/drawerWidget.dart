import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_manager_firebase/pages/create.dart';
import 'package:task_manager_firebase/pages/home.dart';
import 'package:task_manager_firebase/pages/sign_in.dart';

import '../generated/l10n.dart';

class drawerWidget extends StatelessWidget {
  const drawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email;

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple[200]),
              child: (email == null) ? const Text('') : Text(email)),
          ListTile(
            leading: const Icon(Icons.home),
            title: Text(S.of(context).home),
            onTap: () {
              // Update the state of the app.
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => const Home()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_task),
            title: Text(S.of(context).addTask),
            onTap: () {
              // Update the state of the app.
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Create()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(S.of(context).signOut),
            onTap: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              print("Déconnexion réussie");
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignIn()));
            },
          ),
        ],
      ),
    );
  }
}
