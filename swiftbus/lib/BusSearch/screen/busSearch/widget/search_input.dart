import 'package:flutter/material.dart';

class SearchInput extends StatelessWidget {
  final String hintText;
  final IconData icon;

  const SearchInput({Key? key, required this.hintText, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
