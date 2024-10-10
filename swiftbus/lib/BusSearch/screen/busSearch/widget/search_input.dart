import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final Function(String) onChanged;

  const SearchInput({
    Key? key,
    required this.hintText,
    required this.icon,
    required this.onChanged, // Accept onChanged callback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        onChanged: onChanged,
        cursorColor: Color(0xFF129C38),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 255, 255, 255),
          prefixIcon: Icon(
            icon,
            color: icon == Icons.location_on_outlined
                ? const Color(0xFFFD6905)
                : Colors.black,
            size: 28.0,
          ),
          // Add the desired icon size here
          hintText: hintText,
          suffixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFFD6905), width: 2.0),
          ),
        ),
      ),
    );
  }
}
