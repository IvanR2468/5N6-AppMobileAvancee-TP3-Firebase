import 'package:cloud_firestore/cloud_firestore.dart';
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
                DateTime deadline = DateTime.parse(deadlineController.text);
                CollectionReference tasksCollection =
                    FirebaseFirestore.instance.collection('tasks');
                tasksCollection.add({
                  'name': nameController.text,
                  'deadline': deadline,
                });
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
}
