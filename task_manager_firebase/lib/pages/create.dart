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
User? user; // Define a class-level variable to store the current user

class _CreateState extends State<Create> {
  @override
  void initState() {
    super.initState();
    // Fetch the current user when the widget is initialized
    _fetchCurrentUser();
  }

  // Fetch the current user asynchronously
  Future<void> _fetchCurrentUser() async {
    try {
      user = await getCurrentUser();
      if (user != null) {
        print("Current user: ${user!.email}");
      } else {
        print("No user is logged in!");
      }
    } catch (e) {
      // Handle any errors that occur while fetching the user
      print("Error fetching current user: $e");
    }
    setState(() {}); // Trigger a rebuild to update the UI
  }

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
              obscureText: false,
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
                await addUser();
                await addTask();
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

// Fonction pour ajouter le user connecté à la collection de Users dans Firestore
  Future<void> addUser() async {
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('users');
    print('ICI: $usersCollection');
    DocumentReference userDoc = usersCollection
        .doc(user?.uid); // Replace 'userId' with the actual document ID

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
  Future<void> addTask() async {
    DateTime deadline = DateTime.parse(deadlineController.text);
    String name = nameController.text.trim();
    if (name.isEmpty) {
      showError();
      return;
    }
    if (await nameExist(user!, name)) {
      showError();
      return;
    }
    try {
      // Ajouter un document (une tâche) à la collection "tasks" pour un utilisateur spécifique
      await _firestore
          .collection('users')
          .doc(user!.uid) // Identifiant de l'utilisateur
          .collection('tasks') // Sous-collection "tasks"
          .add({
        'name': name,
        'deadline': deadline, // Date de création
      });
      print("Tâche ajoutée avec succès !");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      print("Erreur lors de l'ajout de la tâche : $e");
    }
  }

  void showError() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Dialog Title'),
          content: const Text('This is a simple dialog!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> nameExist(User user, String name) async {
    // Récupérer une tâche de l'utilisateur avec un nom spécifique
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .where('name', isEqualTo: name)
        .get();

    // Vérifier s'il y a des résultats
    if (querySnapshot.docs.isNotEmpty) {
      return true;
    } else {
      return true;
    }
  }
}
