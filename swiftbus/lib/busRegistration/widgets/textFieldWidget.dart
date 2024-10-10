import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String labelText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final TextEditingController? controller;

  const CustomTextFormField({
    Key? key,
    required this.labelText,
    this.validator,
    required this.onSaved,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '$labelText',
        labelStyle: const TextStyle(
            color: Color.fromARGB(169, 34, 116, 1),
            fontSize: 16,
            fontWeight: FontWeight.bold),
        floatingLabelStyle: const TextStyle(
            color: Color.fromARGB(255, 0, 0, 0),
            fontSize: 16,
            fontWeight: FontWeight.bold),
        fillColor: const Color.fromARGB(255, 255, 255, 255),
        filled: true,
        //border when the input is focsed
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.orange, width: 2.0),
        ),
        //default border style
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 33, 116, 1), width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color.fromARGB(
                255, 255, 38, 0), // Set custom color for the error underline
            width: 2.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.orange, // Custom color when focused with error
            width: 2.0,
          ),
        ),
        errorStyle: const TextStyle(
          color: Colors.red, // Custom error text color
          fontSize: 13, // Adjust the size of the error message
          fontWeight: FontWeight.bold, // Bold the error message if needed
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      controller: controller,
    );
  }
}
