import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftbus/UserSupport/Service/DatabaseMethods.dart';
import 'package:swiftbus/authentication/services/firebase_authservice.dart';
import 'package:swiftbus/common/NavBar.dart';
import 'package:swiftbus/UserSupport/Passenger/UserSupport.dart';
import 'package:swiftbus/common/ScanQr.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? busId;
  String? userId;
  Map<String, dynamic>? _userDetails;
  final AuthService _auth = AuthService();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _checkUserIdInPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userID');
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      await _fetchUserDetails(storedUserId);
      _fetchBusId();
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  Future<void> _fetchUserDetails(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    final userdata = doc.data() as Map<String, dynamic>?;
    setState(() {
      _userDetails = userdata;
    });
  }

  void _fetchBusId() {
    if (userId != null) {
      DatabaseMethods().getBusId(userId!).listen((snapshot) {
        if (snapshot.docs.isNotEmpty) {
          setState(() {
            busId = snapshot.docs.first['busid'];
          });
        } else {
          setState(() {
            busId = null;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserIdInPreferences();
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User signed out')),
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('userID');

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      debugPrint('Sign out failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the user's first name, if available
    String firstName = _userDetails?['firstname'] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFFD6905),
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hello, $firstName',
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
            IconButton(
              icon: const Icon(Icons.logout), // Logout icon
              onPressed: () => _signOut(context),
            ),
          ],
        ),
      ),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: () {
            if (busId == null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SacnQr(),
                ),
              );
            } else {
              showPopover(
                context: context,
                bodyBuilder: (context) => Popup(userId: userId!, busId: busId!),
                width: 250,
                height: 166,
                backgroundColor: Colors.transparent,
                direction: PopoverDirection.top,
              );
            }
          },
          tooltip: 'pop up box',
          backgroundColor: Color(0xFFFD6905),
          shape: const CircleBorder(),
          child: const Icon(Icons.support_agent),
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 0,),
    );
  }
}
