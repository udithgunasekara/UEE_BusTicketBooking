//

import 'package:flutter/material.dart';

class BookingButton extends StatelessWidget {
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
            child: const Column(
              children: [
                Text(
                  'Estimated Travel Time',
                  style: TextStyle(color: Colors.white, fontSize: 11),
                ),
                // SizedBox(height: 5),
                Text(
                  '15 mins',
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
