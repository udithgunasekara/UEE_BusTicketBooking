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
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.orange, width: 4.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
              color: Color.fromARGB(255, 33, 116, 1), width: 3.0),
        ),
      ),
      validator: validator,
      onSaved: onSaved,
      controller: controller,
    );
  }
}
