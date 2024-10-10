import 'package:flutter/material.dart';
import 'package:swiftbus/main.dart';

// Function to create the popup box
Widget _popupBox() {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.all(20),
    content: const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 60,
        ),
        SizedBox(height: 20),
        Text(
          'Request Send Successfully!',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () {
          navigatorKey.currentState!.pop(); // Close the dialog using the global key
        },
        child: const Text('OK'),
      ),
    ],
  );
}

// Function to show the popup
void showPopup() {
  showDialog(
    context: navigatorKey.currentContext!, // Get context from the global key
    builder: (BuildContext context) {
      return _popupBox();
    },
  );
}