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
import 'package:swiftbus/BusSearch/service/firestore.dart';
import 'package:swiftbus/common/RouteIcon.dart';

class BusScheduleWidget extends StatefulWidget {
  final String docId;
  final String from;
  final String to;
  final String fromTime;
  final String toTime;

  BusScheduleWidget(
      {required this.docId,
      required this.from,
      required this.to,
      required this.fromTime,
      required this.toTime}) {
    print('Here the the bus getter in schedule: $docId, $from, $to');
  }

  @override
  State<BusScheduleWidget> createState() => _BusScheduleWidgetState();
}

class _BusScheduleWidgetState extends State<BusScheduleWidget> {
  Map<String, dynamic>? busDetails;

  @override
  void initState() {
    super.initState();
    _fetchBusDetails();
  }

  // Function to fetch bus details using the docId
  void _fetchBusDetails() async {
    FirestoreService firestoreService = FirestoreService();
    Map<String, dynamic>? details =
        await firestoreService.getBusDetails(widget.docId);

    if (details != null) {
      setState(() {
        busDetails = details;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bus destination',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            // const SizedBox(height: 8),
            _buildRouteInfo(
                busDetails!['startLocation'],
                busDetails!['destination'],
                busDetails!['departureTime'],
                '10:00 AM'),
            // const SizedBox(height: 16),
            const Text('Your destination',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildRouteInfo(
                widget.from, widget.to, widget.toTime, widget.fromTime),
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
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            const Expanded(
              child: Center(child: RouteIcon(width: 100)),
            ),
            Expanded(
              child: Text(to,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                  textAlign: TextAlign.right),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Departure Time',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(departureTime, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Arrival Time',
                      style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Text(arrivalTime, style: const TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
