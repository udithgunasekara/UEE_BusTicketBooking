import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftbus/UserSupport/Service/DatabaseMethods.dart';
import 'package:swiftbus/authentication/services/firebase_authservice.dart';
import 'package:swiftbus/common/NavBar.dart';

class ViewUserRequest extends StatefulWidget {
  const ViewUserRequest({super.key});

  @override
  State<ViewUserRequest> createState() => _ViewUserRequestState();
}

class _ViewUserRequestState extends State<ViewUserRequest> {
  String? busId;
  String? userId;
  final AuthService _auth = AuthService();

  Future<void> _checkUserIdInPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userID');
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
      // Now that userId is set, you can fetch the busId
      _fetchBusId();
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
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
            const Text(
              'Requestes',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            IconButton(
              icon: const Icon(Icons.logout), // Logout icon
              onPressed: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseMethods().getaRequest(busId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Error retrieving notifications"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No notifications available"));
          }

          // Sorting by priority level: high, medium, low
          List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
          docs.sort((a, b) {
            String priorityA = a['priority'] ?? 'low';
            String priorityB = b['priority'] ?? 'low';

            List<String> priorityOrder = ['High', 'Medium', 'Low'];
            return priorityOrder.indexOf(priorityA).compareTo(priorityOrder.indexOf(priorityB));
          });

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              var notification = docs[index];
              String priority = notification['priority'] ?? 'low'; // Default to low if missing
              String title =  'Seat Number: ' + notification['seatnumber'];
              String description = notification['message'];

              // Set background color based on priority
              Color bgColor;
              if (priority == 'High') {
                bgColor = Colors.red[100]!;
              } else if (priority == 'Medium') {
                bgColor = Colors.orange[100]!;
              } else {
                bgColor = Colors.green[100]!;
              }

              return Container(
                margin: const EdgeInsets.all(8.0),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(15.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(description),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const Navbar(),
    );
  }
}