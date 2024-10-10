// import 'package:flutter/material.dart';
// import 'package:swiftbus/BusSearch/service/firestore.dart';
// import 'widget/search_input.dart';
// import 'widget/bus_list_item.dart';
// import 'widget/bus_time_picker.dart';

// class SearchBusesScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(30, 70, 30, 20),
//         child: Column(
//           children: [
//             //input fields
//             const SearchInput(hintText: 'Malabe', icon: Icons.circle_outlined),
//             const SearchInput(
//                 hintText: 'Panadura', icon: Icons.location_on_outlined),

//             //set timer
//             BusTimePicker(),
//             SizedBox(height: 15),

//             //search button
//             ElevatedButton(
//               onPressed: () async {
//                 // Get the entered values for from, to, and time
//                 String from =
//                     'waliweriya'; // Replace with actual user input value
//                 String to = 'pasyala'; // Replace with actual user input value
//                 String time = '12:45'; // Replace with actual user input value

//                 // Call the Firestore search function
//                 FirestoreService firestoreService = FirestoreService();
//                 await firestoreService.searchBuses(from, to, time);
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Color(0xFF129C38),
//                 minimumSize: Size(double.infinity, 40), // Set the width to full
//               ),
//               child: const Text(
//                 'Search Buses',
//                 style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 17,
//                     fontWeight: FontWeight.w500),
//               ),
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             const Divider(
//               thickness: 5,
//             ),
//             Expanded(
//               child: ListView(
//                 children: const [
//                   BusListItem(
//                     busName: 'D S Gunasena',
//                     busType: 'Semi Luxury',
//                     onboardTime: '7:00 AM',
//                     startLocation: 'Kurunegala',
//                     destination: 'Panadura',
//                     busNo: 'KD 8343',
//                   ),
//                   BusListItem(
//                     busName: 'D S Gunasena',
//                     busType: 'Semi Luxury',
//                     onboardTime: '7:00 AM',
//                     startLocation: 'Kurunegala',
//                     destination: 'Panadura',
//                     busNo: 'KD 8343',
//                   ),
//                   // More buses
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/service/firestore.dart';
import 'widget/search_input.dart';
import 'widget/bus_list_item.dart';
import 'widget/bus_time_picker.dart';

class SearchBusesScreen extends StatefulWidget {
  @override
  _SearchBusesScreenState createState() => _SearchBusesScreenState();
}

class _SearchBusesScreenState extends State<SearchBusesScreen> {
  // List to store the buses found
  List<Map<String, dynamic>> busList = [];
  String valFrom = '';
  String valTo = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 70, 30, 20),
        child: Column(
          children: [
            // Input field for 'from' location
            SearchInput(
                hintText: 'Malabe',
                icon: Icons.circle_outlined,
                onChanged: (value) {
                  setState(() {
                    valFrom = value; // Assigns the input value to 'valfrom'
                  });
                }), // from button
            // Input field for 'to' location
            SearchInput(
                hintText: 'Panadura',
                icon: Icons.location_on_outlined,
                onChanged: (value) {
                  setState(() {
                    valTo = value; // Assigns the input value to 'valto'
                  });
                }), // fr to button

            // Set timer
            BusTimePicker(),
            SizedBox(height: 15),

            // Search button
            ElevatedButton(
              onPressed: () async {
                // Debug: print the values captured from the inputs
                print('From: $valFrom');
                print('To: $valTo');

                String from = valFrom; // Replace with actual user input value
                String to = valTo; // Replace with actual user input value
                String time = '12:45'; // Replace with actual user input value

                // Call the Firestore search function
                FirestoreService firestoreService = FirestoreService();
                List<Map<String, dynamic>> results =
                    await firestoreService.searchBuses(from, to, time);

                // Update the state with the search results
                setState(() {
                  busList = results;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF129C38),
                minimumSize: Size(double.infinity, 40), // Set the width to full
              ),
              child: const Text(
                'Search Buses',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 5,
            ),

            // Bus list section
            Expanded(
              child: ListView.builder(
                itemCount: busList.length,
                itemBuilder: (context, index) {
                  final bus = busList[index];
                  return BusListItem(
                    busName: bus['busName'] ?? 'Unknown',
                    busType: bus['busType'] ?? 'Unknown',
                    onboardTime: bus['onboardTime'] ?? 'Unknown',
                    startLocation: bus['startLocation'] ?? 'Unknown',
                    destination: bus['destination'] ?? 'Unknown',
                    busNo: bus['busNo'] ?? 'Unknown',
                    docId: bus['docId'] ?? 'Unknown',
                    to: valTo,
                    from: valFrom,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
