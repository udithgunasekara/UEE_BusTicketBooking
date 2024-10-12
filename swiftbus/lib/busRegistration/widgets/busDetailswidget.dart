import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../SeatStructure/screens/reservations_screen.dart';

class Busdetailswidget extends StatelessWidget {
  final String? userId;
  const Busdetailswidget({super.key, this.userId});

  String _formatDate(String dateString) {
  try {
    final date = DateTime.parse(dateString);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  } catch (e) {
    return dateString; // Return the original string if parsing fails
  }
}

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
          return const Center(child: CircularProgressIndicator());
        }

        final buses = snapshot.data?.docs ?? [];

        if (buses.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
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
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFF129C38), width: 2),
              ),
              child: InkWell(
                // Wrap with InkWell for tap functionality
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReservationsScreen(
                        busNo: busNo,
                        from: startLocation,
                        to: destination,
                        date: departureDate,
                        time: departureTime,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(busName.isNotEmpty ? '$busNo - $busName' : busNo,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text('$startLocation - $destination'),
                            Text('Departure: ${_formatDate(departureDate)} at $departureTime'),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward, color: Colors.green),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
