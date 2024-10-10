import 'package:flutter/material.dart';
import 'package:swiftbus/common/RouteIcon.dart';

class BusDetailCard extends StatelessWidget {
  final String to;
  final String from;
  final String toTime;
  final String fromTime;
  final List<int> seatNumbers; //temp data

  BusDetailCard(
      {required this.to,
      required this.from,
      required this.toTime,
      required this.fromTime,
      required this.seatNumbers});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Total Passenger',
              seatNumbers.length.toString()), // get length for total passengers
          const SizedBox(height: 10),
          _buildDetailRow(
              'Booked seats', seatNumbers.join(', ')), // added seates
          const SizedBox(height: 25),
          const Text('Your Destination',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(to,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              RouteIcon(width: 90),
              Expanded(
                child: Text(from,
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('OnBoard Time',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text('Arrival Time',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(toTime,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text(fromTime,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(fontSize: 18)),
      Text(value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ]);
  }
}
