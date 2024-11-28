import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:task_manager_firebase/pages/sign_in.dart';

import '../generated/l10n.dart';

class drawerWidget extends StatelessWidget {
  const drawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    String showUser(){
      User? user = FirebaseAuth.instance.currentUser;
      String? email = user?.email;
      String? username = user?.uid;
      if(email != null){
        return email;
      }
      else if (username != null){
        return username;
      }
      return 'No email or username';
    }

    return Drawer(
      child: ListView(
        children:  [
          DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.deepPurple[200]
              ),
              child: Text(showUser())
          ),
          // ListTile(
          //   leading: const Icon(Icons.home),
          //   title: Text(S.of(context).home),
          //   onTap: () {
          //     // Update the state of the app.
          //     Navigator.of(context).push(
          //         MaterialPageRoute(
          //             builder: (context) => const EcranAccueil()
          //         )
          //     );
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(Icons.add_task),
          //   title: Text(S.of(context).addTask),
          //   onTap: () {
          //     // Update the state of the app.
          //     Navigator.of(context).push(
          //         MaterialPageRoute(
          //             builder: (context) => const EcranCreation()
          //         )
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(S.of(context).signOut),
            onTap: () async {
              await GoogleSignIn().signOut();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>  const SignIn()
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}