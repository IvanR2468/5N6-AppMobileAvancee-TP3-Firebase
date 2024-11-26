import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class inputWidget extends StatelessWidget {
  const inputWidget({
    super.key,
    required this.usernameController,
    required this.labelText
  });

  final TextEditingController usernameController;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25,5,25,5),
      child: TextField(
        controller: usernameController,
        decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: labelText
        ),
      ),
    );
  }
}