import 'package:flutter/material.dart';

Widget Navbar() {
  return Container(
    decoration: const BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    child: BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support),
          label: 'Support',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notification',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    ),
  );
}