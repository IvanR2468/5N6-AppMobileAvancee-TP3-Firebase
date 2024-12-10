import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_manager_firebase/firestore_service.dart';
import 'package:task_manager_firebase/pages/create.dart';

import 'home.dart';

class Edit extends StatefulWidget {
  final Map<String, dynamic> task;

  const Edit({super.key, required this.task});

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<Edit> {
  final TextEditingController _percentageDoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the current percentageDone
    _percentageDoneController.text = widget.task['percentagedone'].toString();
  }

  // Update only the percentageDone in Firestore
  Future<void> _updateTask() async {
    try {
      // Parse the percentage input as a number
      final double percentageDone = double.tryParse(_percentageDoneController.text) ?? -1.0;

      // If the percentage is invalid (less than 0 or greater than 100), show a validation message
      if (percentageDone < 0 || percentageDone > 100) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid percentage (0-100).')),
        );
        return;
      }

      // Debugging: Print the value of percentageDone to check if it's correct
      print("Updated Percentage Done: $percentageDone");

      // Debugging: Print the document path to check if it's correct
      final userId = FirestoreService.getUser()!.uid;
      final docId = widget.task['docId'];
      print("Updating task at path: users/$userId/tasks/$docId");

      // Update the task in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)  // The user ID for the task
          .collection('tasks')  // The tasks collection
          .doc(docId)  // Document ID for the specific task
          .update({'percentagedone': percentageDone});

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      print("Error updating task: $e");
      // Optionally show an error message if the update fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update task: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Task')),
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Percentage Done Input Field
              TextFormField(
                controller: _percentageDoneController,
                decoration: InputDecoration(
                  labelText: 'Percentage Done (%)',
                  hintText: 'Enter a number between 0 and 100',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Update Button
              ElevatedButton(
                onPressed: _updateTask,
                child: const Text('Update Percentage'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
