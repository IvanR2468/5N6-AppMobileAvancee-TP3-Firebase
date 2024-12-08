import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class inputWidget extends StatelessWidget {
  const inputWidget(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.obscureText});

  final TextEditingController controller;
  final String labelText;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(25, 5, 25, 5),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText,
        ),
      ),
    );
  }
}
