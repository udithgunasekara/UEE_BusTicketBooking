import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReservationsScreen extends StatelessWidget {
  final String busNumber;
  final Map<String, dynamic> busDetails;

  const ReservationsScreen({
    Key? key,
    required this.busNumber,
    required this.busDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reservations for Bus $busNumber'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBusDetails(),
              const SizedBox(height: 20),
              _buildReservationsList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBusDetails() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${busDetails['busName']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('From: ${busDetails['startLocation']}'),
            Text('To: ${busDetails['destination']}'),
            Text(
                'Departure: ${busDetails['departureDate']} at ${busDetails['departureTime']}'),
          ],
        ),
      ),
    );
  }

  Widget _buildReservationsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookedUsers')
          .where('busNumber', isEqualTo: busNumber)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final reservations = snapshot.data?.docs ?? [];

        if (reservations.isEmpty) {
          return const Text('No reservations for this bus yet.');
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reservations.length,
          itemBuilder: (context, index) {
            final reservation =
                reservations[index].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(reservation['userName'] ?? 'Unknown User'),
                subtitle:
                    Text('Seats: ${reservation['seatNumbers'].join(', ')}'),
                trailing: Text('Paid: \$${reservation['totalPayment']}'),
              ),
            );
          },
        );
      },
    );
  }
}
