import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftbus/authentication/services/firebase_authservice.dart';

class Conducterhome extends StatefulWidget {
  final User? user;
  const Conducterhome({super.key,required this.user});

  @override
  State<Conducterhome> createState() => _ConducterhomeState();
}

class _ConducterhomeState extends State<Conducterhome> {
  Map<String, dynamic>? _userDetails ;
  final AuthService _auth = AuthService();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;

  @override
  void initState() {
    super.initState();
    _checkUserIdInPreferences;
  }

  Future<void> _checkUserIdInPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userID = prefs.getString('userID');
    if (userID == null) {
      // User ID is not set, redirect to login
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      // If user ID is set, fetch user details
      _fetchUserDetails(userID);
    }
  }
  

 Future<void> _fetchUserDetails(uid) async {
  DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
  final userdata =  doc.data() as Map<String, dynamic>?;
  setState(() {
    _userDetails = userdata;
    user = FirebaseAuth.instance.currentUser;
  });
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
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.orange,
        statusBarIconBrightness: Brightness.light));
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.black,
        elevation: 8,
        shadowColor: Colors.black,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
                Icons.person), // Notification icon
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout), // Logout icon
            onPressed: () => _signOut(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('buses').where('conducterId', isEqualTo: user!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final buses = snapshot.data?.docs ?? [];

                if (buses.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('No buses found. Please add a new bus.'),
                  );
                }

                return ListView.builder(
                  itemCount: buses.length,
                  itemBuilder: (context, index) {
                    final bus = buses[index].data() as Map<String, dynamic>;
                    final busNo = bus['busNo'] ?? '';
                    final busName = bus['busName'] ?? '';
                    final startLocation = bus['startLocation'] ?? '';
                    final destination = bus['destination'] ?? '';
                    final departureTime = bus['departureTime'] ?? '';
                    final departureDate = bus['departureDate'] ?? '';
                    // ignore: unused_local_variable
                    final price = bus['price'] ?? '';

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.green, width: 2),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('$busNo - $busName',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  Text('$startLocation - $destination'),
                                  Text('Departure: $departureDate at $departureTime'),
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: Colors.green),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.phone), label: 'Support'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notification'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/busregistration');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.orange,
      ),
    );
  }
}