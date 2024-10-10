import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swiftbus/UserSupport/Conductor/ViewUserRequest.dart';
import 'package:swiftbus/UserSupport/Passenger/viewPreviousRequest.dart';
import 'package:swiftbus/UserSupport/Service/DatabaseMethods.dart';
import 'package:swiftbus/common/Home.dart';
import 'package:swiftbus/common/inbox.dart';

Widget Navbar(BuildContext context) {
  String busId = 'B001';
  return Container(
    decoration: const BoxDecoration(
      color: Colors.green,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.0),
        topRight: Radius.circular(20.0),
      ),
    ),
    child: StreamBuilder<QuerySnapshot>(
      stream: DatabaseMethods().getaNotification(busId),
      builder: (context, snapshot) {
        bool hasUnread = false;

        if (snapshot.hasData) {
          // Check if any message is unread
          hasUnread = snapshot.data!.docs.any((doc) => doc['isread'] == false);
        }

        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.support),
              label: 'Support',
            ),
            BottomNavigationBarItem(
              // Change icon if there are unread messages
              icon: Stack(
                children: [
                  const Icon(Icons.notifications),
                  if (hasUnread)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 9,
                          minHeight: 9,
                        ),
                      ),
                    ),
                ],
              ),
              label: 'Notification',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Bus Search',
            ),
          ],
          onTap: (int index) {
            switch (index) {
              case 0:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ViewPreviousRequests(),
                  ),
                );
                break;
              case 2:
                // Navigate to Notification screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Inbox(),
                  ),
                );
                break;
              case 3:
                // Handle Profile navigation
                // Navigate to Notification screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchBusesScreen(),
                  ),
                );
                break;
            }
          },
        );
      },
    ),
  );
}
