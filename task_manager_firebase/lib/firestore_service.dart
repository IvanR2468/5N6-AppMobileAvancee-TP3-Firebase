import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {

  static User? getUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }
  static CollectionReference getUserTasks() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(getUser()!.uid)
        .collection('tasks');
  }

  static Future<bool> taskExists(String name) async {
    final querySnapshot = await FirestoreService
        .getUserTasks()
        .where('name', isEqualTo: name).get();
    return querySnapshot.docs.isNotEmpty;
  }

  static addTask(String name, DateTime deadline) async {
    final now = DateTime.now();
    await FirestoreService.getUserTasks()
        .add({
      'name': name,
      'deadline': deadline,
      'creationDate': now,// Store deadline as a Timestamp
      'percentagetimespent': 0,
      'percentagedone': 0,
    });
  }

}