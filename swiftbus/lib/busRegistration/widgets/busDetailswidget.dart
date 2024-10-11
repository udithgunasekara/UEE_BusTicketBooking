import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Busdetailswidget extends StatelessWidget {
  final String? userId;
  const Busdetailswidget({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('buses')
          .where('conducterId', isEqualTo: userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
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
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
    );
  }
}