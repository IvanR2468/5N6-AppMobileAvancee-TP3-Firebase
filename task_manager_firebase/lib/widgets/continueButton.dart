import 'package:flutter/material.dart';

import '../pages/sign_in.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the sign in screen using push
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent[100], // Background color
        foregroundColor: Colors.white, // Text color
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), // Button padding
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Text style
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min, // Prevents the row from taking up full width
        children: [
          Text('Continue'), // Button text
          SizedBox(width: 8), // Space between the text and the arrow
          Icon(Icons.arrow_forward), // Right arrow icon
        ],
      ),
    );
  }
}