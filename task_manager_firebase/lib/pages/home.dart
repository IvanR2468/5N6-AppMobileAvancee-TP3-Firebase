import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/drawerWidget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  User? user = FirebaseAuth.instance.currentUser;
  List<Map<String, dynamic>> tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  // Fetch tasks from Firestore and calculate percent spent
  Future<void> _fetchTasks() async {
    if (user == null) { return; } // Check if the user is logged in

    try {
      // Fetch all tasks for the current user from Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('tasks')
          .get();

      if (querySnapshot.docs.isEmpty) {
        print("No tasks found.");
      }

      tasks = [];  // Clear the list before populating with new data

      // Iterate through each task document in the Firestore collection
      for (var doc in querySnapshot.docs) {
        print("Fetching task: ${doc.id}");

        // Convert the 'creationDate' and 'deadline' fields from Firestore to DateTime
        final creationDate = (doc['creationDate'] as Timestamp).toDate();
        final deadline = (doc['deadline'] as Timestamp).toDate();

        // Calculate the total duration (from creation to deadline)
        final totalDuration = deadline.difference(creationDate);
        // Calculate how much time has passed since creation
        final elapsedTime = DateTime.now().difference(creationDate);

        // Calculate percentage of time spent
        final percentSpent = ((elapsedTime.inSeconds / totalDuration.inSeconds) * 100).clamp(0, 100);

        // Update the task's 'percentagetimespent' field in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('tasks')
            .doc(doc.id)
            .update({'percentagetimespent': percentSpent});

        // Add the task data to the local list for UI display
        tasks.add({
          'name': doc['name'],
          'creationDate': creationDate,
          'deadline': deadline,
          'percentagedone': doc['percentagedone'],
          'percentagetimespent': percentSpent,
          'imageUrl': 'https://picsum.photos/150',  // Placeholder image
        });
      }

      // After all tasks have been fetched and updated, trigger a UI rebuild to display them
      setState(() {});
    } catch (e) {
      // If an error occurs, print it (you can log or show more specific error messages here)
      print("Error fetching tasks: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks List'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const drawerWidget(),
      body: tasks.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];
          return ListTile(
            contentPadding: const EdgeInsets.all(8.0),
            title: Text(task['name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Deadline: ${task['deadline'].toLocal()}'),
                // Display percentSpent as an integer
                Text('Time Spent: ${task['percentagetimespent'].toInt()}%'),
                Text('Completed: ${task['percentagedone']}%'),
              ],
            ),
            leading: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: NetworkImage(task['imageUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
