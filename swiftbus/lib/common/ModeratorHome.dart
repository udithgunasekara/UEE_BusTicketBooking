import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftbus/UserSupport/Service/DatabaseMethods.dart';
import 'package:swiftbus/authentication/services/firebase_authservice.dart';
import 'package:swiftbus/busRegistration/widgets/busDetailswidget.dart';
import 'package:swiftbus/common/NavBar.dart';

class ConductorHome extends StatefulWidget {
  const ConductorHome({super.key});

  @override
  State<ConductorHome> createState() => _ConductorHomeState();
}

class _ConductorHomeState extends State<ConductorHome> {
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
    String lastname = _userDetails?['lastname'] ?? 'User';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.orange,
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
              'Hello, $lastname',
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
            IconButton(
              icon: const Icon(Icons.logout), // Logout icon
              onPressed: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: Busdetailswidget(userId: userId),
      bottomNavigationBar: Navbar(context),
    );
  }
}