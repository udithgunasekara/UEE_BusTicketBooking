import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftbus/UserSupport/Service/DatabaseMethods.dart';
import 'package:swiftbus/authentication/services/firebase_authservice.dart';
import 'package:swiftbus/common/NavBar.dart';

class Inbox extends StatefulWidget {
  const Inbox({super.key});

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
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
              'Notification',
              style: TextStyle(fontSize: 24, color: Colors.black),
            ),
            IconButton(
              icon: const Icon(Icons.logout), // Logout icon
              onPressed: () => _signOut(context),
            ),
          ],
        ),
      ),
      body: busId == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<QuerySnapshot>(
              stream: DatabaseMethods().getaNotification(busId!, userId!),
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

                // Sorting and displaying notifications
                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                docs.sort((a, b) {
                  bool isReadA = a['isread'] ?? false;
                  bool isReadB = b['isread'] ?? false;
                  return isReadA == isReadB ? 0 : (isReadA ? 1 : -1); // Unread first
                });

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var notification = docs[index];
                    bool isRead = notification['isread'] ?? false;
                    String title = isRead ? 'Old Message' : 'New Message';
                    String description = notification['message'];
                    String notificationId = notification.id;

                    return GestureDetector(
                      onTap: () async {
                        if (!isRead) {
                          await DatabaseMethods().markNotificationAsRead(notificationId);
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: isRead ? Colors.grey[300] : Colors.blue[100], // Blue for unread
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
                      ),
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: Navbar(context),
    );
  }
}