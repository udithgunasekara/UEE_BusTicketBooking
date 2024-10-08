import 'package:flutter/material.dart';
import 'package:swiftbus/common/RouteIcon.dart';

class BusDetailCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Total Passenger', '2'),
          const SizedBox(height: 10),
          _buildDetailRow('Booked seats', '01, 13'),
          const SizedBox(height: 16),
          const Text('Destination',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          const Row(
            children: [
              Expanded(
                child: Text('Malabe',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              RouteIcon(width: 90),
              Expanded(
                child: Text('Panadura',
                    textAlign: TextAlign.right,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Departure Time',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
              Text('Arrival Time',
                  style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('9.20 AM',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('10.00 AM',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: TextStyle(fontSize: 18)),
      Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    ]);
  }
}
