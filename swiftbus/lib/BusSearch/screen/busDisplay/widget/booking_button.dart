//

import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/screen/paymentPage/show_bus_details_screen.dart';
import 'package:swiftbus/SeatStructure/screens/seat_selection_screen.dart';

class BookingButton extends StatelessWidget {
  final String ett;
  final String fromTime;
  final String toTime;
  final String to;
  final String from;
  final String docId;

  BookingButton(
      {required this.ett,
      required this.fromTime,
      required this.toTime,
      required this.to,
      required this.from,
      required this.docId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Estimated Travel Time
          Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 18),
            decoration: BoxDecoration(
              color: const Color(0xFFFD6905),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  'Estimated Travel Time',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                // SizedBox(height: 5),
                Text(
                  '$ett Hr',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20), // Space between widgets
          // Book a Seat Button

          ElevatedButton(
            onPressed: () {
              // Handle booking action
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        // SeatSelectionScreen(disabledSeats: {1, 2, 3})),
                        ShowBusDetailsScreen(
                          to: to,
                          from: from,
                          toTime: toTime,
                          fromTime: fromTime,
                          docId: docId,
                        )),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 40),
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Book a Seat',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
