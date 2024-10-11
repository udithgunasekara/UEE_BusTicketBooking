// File: lib/widgets/navbar.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftbus/UserSupport/Service/DatabaseMethods.dart';
import 'package:swiftbus/BusSearch/screen/busSearch/search_buses_screen.dart';
import 'package:swiftbus/UserSupport/Passenger/viewPreviousRequest.dart';
import 'package:swiftbus/common/Home.dart';
import 'package:swiftbus/common/inbox.dart';

// File: lib/widgets/navbar.dart
class Navbar extends StatefulWidget {
  final int selectedIndex;  // Pass the selectedIndex from each screen

  const Navbar({Key? key, required this.selectedIndex}) : super(key: key);

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
      setState(() {
        isLoading = false;
      });
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
        color: Color(0xFF129C38),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: _buildBottomNavigationBar(context),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.transparent,
      elevation: 0,
      selectedItemColor: Color(0xFFFD6905),
      unselectedItemColor: Colors.black,
      currentIndex: widget.selectedIndex,  // Use the passed selectedIndex
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Bus Search',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.support_agent),
          label: 'Requests',
        ),
      ],
      onTap: (index) {
        _handleNavigation(context, index);
      },
    );
  }

  void _handleNavigation(BuildContext context, int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Home()),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SearchBusesScreen(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Inbox(),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewPreviousRequests(),
          ),
        );
        break;
    }
  }
}