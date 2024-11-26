// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../ecran_accueil.dart';
// import '../ecran_creation.dart';
// import '../generated/l10n.dart';
// import '../main.dart';
// import '../service/singleton_dio.dart';
//
// class drawerWidget extends StatelessWidget {
//   const drawerWidget({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: ListView(
//         children:  [
//           DrawerHeader(
//               decoration: BoxDecoration(
//                   color: Colors.deepPurple[200]
//               ),
//               child: Text(SingletonDio.username)
//           ),
//           ListTile(
//             leading: const Icon(Icons.home),
//             title: Text(S.of(context).home),
//             onTap: () {
//               // Update the state of the app.
//               Navigator.of(context).push(
//                   MaterialPageRoute(
//                       builder: (context) => const EcranAccueil()
//                   )
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.add_task),
//             title: Text(S.of(context).addTask),
//             onTap: () {
//               // Update the state of the app.
//               Navigator.of(context).push(
//                   MaterialPageRoute(
//                       builder: (context) => const EcranCreation()
//                   )
//               );
//             },
//           ),
//           ListTile(
//             leading: const Icon(Icons.logout),
//             title: Text(S.of(context).signOut),
//             onTap: () async {
//               // Update the state of the app.
//               final prefs = await SharedPreferences.getInstance();
//               await prefs.remove("usernameSauveguard");
//               await prefs.remove("passwordSauveguard");
//               prefs.clear();
//               SingletonDio().signOut();
//               Navigator.of(context).push(
//                   MaterialPageRoute(
//                       builder: (context) =>  const EcranConnexion()
//                   )
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }