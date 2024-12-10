import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit.dart';

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
    if (user == null) { return; }

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('tasks')
          .get();

      tasks = [];
      for (var doc in querySnapshot.docs) {
        final creationDate = (doc['creationDate'] as Timestamp).toDate();
        final deadline = (doc['deadline'] as Timestamp).toDate();
        final totalDuration = deadline.difference(creationDate);
        final elapsedTime = DateTime.now().difference(creationDate);

        final percentSpent = ((elapsedTime.inSeconds / totalDuration.inSeconds) * 100).clamp(0, 100);

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('tasks')
            .doc(doc.id)
            .update({'percentagetimespent': percentSpent});

        tasks.add({
          'name': doc['name'],
          'creationDate': creationDate,
          'deadline': deadline,
          'percentagedone': doc['percentagedone'],
          'percentagetimespent': percentSpent,
          'imageUrl': 'https://picsum.photos/150',
          'docId': doc.id,
        });
      }

      setState(() {});
    } catch (e) {
      print("Error fetching tasks: $e");
    }
  }

  // Delete a task from Firestore
  Future<void> _deleteTask(String taskId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('tasks')
          .doc(taskId)
          .delete();

      setState(() {
        tasks.removeWhere((task) => task['docId'] == taskId);
      });

      print("Task deleted successfully.");
    } catch (e) {
      print("Error deleting task: $e");
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
          ? const Center(child: Text('No task for the moment'))
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
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    // Navigate to Edit Task page and pass the task data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Edit(task: task),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteTask(task['docId']);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
