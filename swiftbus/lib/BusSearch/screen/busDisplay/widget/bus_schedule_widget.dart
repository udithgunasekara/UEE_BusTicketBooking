// import 'package:flutter/material.dart';

// class BusScheduleWidget extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return const Card(
//       margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Padding(
//         padding: EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             ListTile(
//               title: Text('Departure Time: 7:00 AM'),
//               subtitle: Text('From: Kurunegala'),
//             ),
//             ListTile(
//               title: Text('Arrival Time: 10:00 AM'),
//               subtitle: Text('To: Panadura'),
//             ),
//             Divider(),
//             ListTile(
//               title: Text('Your Destination'),
//               subtitle: Text('From: Malabe - Departure Time: 9:20 AM'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:swiftbus/common/RouteIcon.dart';
// Ensure this import points to the correct file

class BusScheduleWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bus destination',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildRouteInfo('Kurunegala', 'Panadura', '7:00 AM', '10:00 AM'),
            SizedBox(height: 16),
            Text('Your destination',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            _buildRouteInfo('Malabe', 'Panadura', '9:20 AM', '10:00 AM'),
          ],
        ),
      ),
    );
  }

  Widget _buildRouteInfo(
      String from, String to, String departureTime, String arrivalTime) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(from,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            Expanded(
              child: Center(child: RouteIcon(width: 100)),
            ),
            Expanded(
              child: Text(to,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.right),
            ),
          ],
        ),
        SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Departure Time',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(departureTime, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Arrival Time',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(arrivalTime, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
