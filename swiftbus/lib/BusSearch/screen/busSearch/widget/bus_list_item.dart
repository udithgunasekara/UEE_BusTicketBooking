import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/screen/busDisplay/bus_details_screen.dart';
import 'package:swiftbus/common/RouteIcon.dart';

class BusListItem extends StatelessWidget {
  final String busName;
  final String busType;
  final String onboardTime;
  final String startLocation;
  final String destination;
  final String busNo;
  final String docId;
  final String to;
  final String from;

  const BusListItem({
    Key? key,
    required this.busName,
    required this.busType,
    required this.onboardTime,
    required this.startLocation,
    required this.destination,
    required this.busNo,
    required this.docId,
    required this.to,
    required this.from,
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
                  busNo,
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
                  busType,
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
                    startLocation,
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
                    destination,
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BusDetailsScreen(docId: docId, to: to, from: from),
                      ),
                    );
                    // View more logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF129C38),
                    padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),

                  //HEre view more button to redirect to the bus details page
                  child: const Text(
                    'View More',
                    style: TextStyle(color: Colors.white, fontSize: 14),
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
