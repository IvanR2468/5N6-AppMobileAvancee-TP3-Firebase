import 'package:flutter/material.dart';
import 'package:task_manager_firebase/firestore_service.dart';
import 'package:task_manager_firebase/pages/home.dart';
import '../generated/l10n.dart';
import '../widgets/drawerWidget.dart';
import '../widgets/inputWidget.dart';

class Create extends StatefulWidget {
  const Create({super.key});

  @override
  State<Create> createState() => _CreateState();
}

class _CreateState extends State<Create> {

  TextEditingController nameController = TextEditingController();
  TextEditingController deadlineController = TextEditingController();

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
          inputWidget(controller: nameController, labelText: S.of(context).task, obscureText: false),
          _buildDeadlineInput(),
          _buildCreateButton(),
          _buildHomeButton(),
        ],
      ),
    );
  }

  Widget _buildDeadlineInput() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
      child: TextField(
        controller: deadlineController,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: S.of(context).deadline,
          hintText: 'YYYY-MM-DD',
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDate,
          ),
        ),
        readOnly: true,
      ),
    );
  }

  Widget _buildCreateButton() {
    return OutlinedButton(
      child: Text(S.of(context).create),
      onPressed: _addTask,
    );
  }

  Widget _buildHomeButton() {
    return TextButton(
      child: Text(S.of(context).home),
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
      },
    );
  }

  // Date picker for deadline
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context, firstDate: DateTime(2000), lastDate: DateTime(2100));
    if (picked != null) deadlineController.text = picked.toIso8601String().split('T')[0];
  }

  // Add task to Firestore
  Future<void> _addTask() async {
    final name = nameController.text.trim();
    final deadline = DateTime.parse(deadlineController.text);

    if (name.isEmpty || await _taskExists(name)) {
      _showErrorDialog();
      return;
    }

    try {
      FirestoreService.addTask(name, deadline);

      nameController.clear();
      deadlineController.clear();
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Home()));
    } catch (e) {
      print("Error adding task: $e");
    }
  }

  // Check if task name already exists
  Future<bool> _taskExists(String name) async {
    return await FirestoreService.taskExists(name);
  }

  // Show error dialog
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: const Text('oopsie'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
