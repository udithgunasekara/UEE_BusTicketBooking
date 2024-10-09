import 'package:flutter/material.dart';
import 'widget/search_input.dart';
import 'widget/bus_list_item.dart';
import 'widget/bus_time_picker.dart';

class SearchBusesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 70, 30, 20),
        child: Column(
          children: [
            const SearchInput(hintText: 'Malabe', icon: Icons.circle_outlined),
            const SearchInput(
                hintText: 'Panadura', icon: Icons.location_on_outlined),
            BusTimePicker(),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: () {
                // Search bus logic
              },
              child: Text(
                'Search Buses',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF129C38),
                minimumSize: Size(double.infinity, 40), // Set the width to full
              ),
            ),
            SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 5,
            ),
            Expanded(
              child: ListView(
                children: const [
                  BusListItem(
                    busName: 'D S Gunasena',
                    type: 'Semi Luxury',
                    onboardTime: '7:00 AM',
                    to: 'Kurunegala',
                    from: 'Panadura',
                    busNumber: 'KD 8343',
                  ),
                  BusListItem(
                    busName: 'NLP',
                    type: 'A/C',
                    onboardTime: '7:10 AM',
                    to: 'Kurunegala',
                    from: 'Panadura',
                    busNumber: 'KD 8343',
                  ),
                  // More buses
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
