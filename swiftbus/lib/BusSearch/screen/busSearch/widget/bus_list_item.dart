import 'package:flutter/material.dart';
import 'package:swiftbus/common/RouteIcon.dart';

class BusListItem extends StatelessWidget {
  final String busName;
  final String type;
  final String onboardTime;
  final String to;
  final String from;
  final String busNumber; // Added for the bus number (e.g., KD 8343)

  const BusListItem({
    Key? key,
    required this.busName,
    required this.type,
    required this.onboardTime,
    required this.to,
    required this.from,
    required this.busNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  busName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text(
                  busNumber,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 30, // Adjust the height as needed
              width: 100, // Adjust the width as needed
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: const Color(0xFFFD6905),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  type,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    to,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                // Container(
                //   height: 2,
                //   width: 50,
                //   color: Color(0xFF129C38),
                // ),

                const RouteIcon(width: 90),

                Expanded(
                  child: Text(
                    from,
                    textAlign: TextAlign.right,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'OnBoard: $onboardTime',
                  style: TextStyle(fontSize: 14),
                ),
                ElevatedButton(
                  onPressed: () {
                    // View more logic
                  },
                  child: Text(
                    'View More',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF129C38),
                    padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
