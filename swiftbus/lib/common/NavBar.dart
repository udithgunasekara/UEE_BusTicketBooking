// File: lib/widgets/navbar.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftbus/UserSupport/Service/DatabaseMethods.dart';
import 'package:swiftbus/BusSearch/screen/busSearch/search_buses_screen.dart';
import 'package:swiftbus/UserSupport/Passenger/viewPreviousRequest.dart';
import 'package:swiftbus/common/Home.dart';
import 'package:swiftbus/common/inbox.dart';

class Navbar extends StatefulWidget {
  const Navbar({Key? key}) : super(key: key);

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  String? busId;
  String? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userID');

    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      _fetchBusId();
    } else {
      // Handle the case when userID is not found
      setState(() {
        isLoading = false;
      });
      // Optionally, navigate to a login screen or handle unauthenticated state
    }
  }

  void _fetchBusId() {
    if (userId != null) {
      DatabaseMethods().getBusId(userId!).listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            busId = snapshot.docs.first['busid'];
            isLoading = false;
          });
        } else {
          setState(() {
            busId = null;
            isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: StreamBuilder<QuerySnapshot>(
        stream: (busId != null && userId != null)
            ? DatabaseMethods().getaNotification(busId!, userId!)
            : null,
        builder: (context, snapshot) {
          bool hasUnread = false;

          if (snapshot.hasData && snapshot.data != null) {
            hasUnread = snapshot.data!.docs.any((doc) => doc['isread'] == false);
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildBottomNavigationBar(context, hasUnread);
          }

          if (snapshot.hasError) {
            return const Text("Error loading notifications");
          }

          return _buildBottomNavigationBar(context, hasUnread);
        },
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context, bool hasUnread) {
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
          icon: Icon(Icons.search),
          label: 'Bus Search',
        ),
        BottomNavigationBarItem(
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
          icon: Icon(Icons.support_agent),
          label: 'Requests',
        ),
      ],
      onTap: (int index) {
        _handleNavigation(context, index);
      },
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Home()),
          (Route<dynamic> route) => false,
        );
        break;
      case 1:
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchBusesScreen(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Inbox(),
          ),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewPreviousRequests(),
          ),
        );
        break;
    }
  }
}