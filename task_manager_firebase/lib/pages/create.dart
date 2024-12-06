import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase/pages/home.dart';

import '../generated/l10n.dart';
import '../widgets/drawerWidget.dart';
import '../widgets/inputWidget.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
TextEditingController nameController = TextEditingController();
TextEditingController deadlineController = TextEditingController();

class _CreateState extends State<Create> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(S.of(context).create),
        ),
        drawer: const drawerWidget(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            inputWidget(
              controller: nameController,
              labelText: S.of(context).task,
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
              child: TextField(
                controller: deadlineController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: S.of(context).deadline,
                  hintText: 'YYYY-MM-DD',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate();
                },
              ),
            ),
            OutlinedButton(
              child: Text(S.of(context).create),
              onPressed: () async {
                User? user = await getCurrentUser();
                await addUser(user);
                await addTask(user!.uid);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
            ),
            TextButton(
              child: Text(S.of(context).home),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Home()));
              },
            ),
          ],
        ));
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null) {
      deadlineController.text = picked.toString().split(" ")[0];
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      // Récupérer l'utilisateur actuel
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        print("Utilisateur connecté : ${user.email}");
        return user;
      } else {
        print("Aucun utilisateur connecté");
        return null;
      }
    } catch (e) {
      print("Erreur lors de la récupération de l'utilisateur : $e");
      return null;
    }
  }
}

// Fonction pour ajouter le user connecté à la collection de Users dans Firestore
Future<void> addUser(User? user) async {
  CollectionReference usersCollection = FirebaseFirestore.instance.collection('users');
  print('ICI: $usersCollection');
  DocumentReference userDoc = usersCollection.doc(user?.uid); // Replace 'userId' with the actual document ID

  try {
    // Update the document with the new field
    await userDoc.set({
      'email': user?.email, // Add the field you want to create
    });
    print('Field added/updated successfully!');
  } catch (e) {
    print('Error adding email: $e');
  }
}

// Fonction pour ajouter une tâche à la collection Firestore
Future<void> addTask(String userId) async {
  DateTime deadline = DateTime.parse(deadlineController.text);
  try {
    // Ajouter un document à la collection "tasks" pour un utilisateur spécifique
    await _firestore.collection('users')
        .doc(userId)  // Identifiant de l'utilisateur
        .collection('tasks')  // Sous-collection "tasks"
        .add({
      'name': nameController.text,
      'deadline': deadline, // Date de création
    });

    print("Tâche ajoutée avec succès !");
  } catch (e) {
    print("Erreur lors de l'ajout de la tâche : $e");
  }
}
