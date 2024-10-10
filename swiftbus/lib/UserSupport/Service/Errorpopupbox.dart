import 'package:flutter/material.dart';
import 'package:swiftbus/main.dart';

// Function to create the popup box
Widget _errorPopupBox() {
  return AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    contentPadding: const EdgeInsets.all(20),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Circular container for the close icon
        Container(
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red, // Background color
          ),
          padding: const EdgeInsets.all(15), // Padding around the icon
          child: const Icon(
            Icons.close, // Close icon
            color: Colors.white, // Icon color
            size: 30, // Size of the icon
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Error sending Request!', // Error message
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
void showErrorPopup() {
  showDialog(
    context: navigatorKey.currentContext!, // Get context from the global key
    builder: (BuildContext context) {
      return _errorPopupBox();
    },
  );
}