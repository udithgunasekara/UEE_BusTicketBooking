import 'package:flutter/material.dart';

class BusInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('D S Gunasena',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Bus Condition', style: TextStyle(fontSize: 18)),
                Text('Semi Luxury',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
              ],
            ),
            // SizedBox(height: 8),
            // Text('Bus Destination: Kurunegala to Panadura'),
          ],
        ),
      ),
    );
  }
}
