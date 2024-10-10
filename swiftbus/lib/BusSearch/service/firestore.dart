import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  // Reference to the buses collection in Firebase
  final CollectionReference buses =
      FirebaseFirestore.instance.collection('buses');

  // Function to search buses based on "from", "to", and "time"
  Future<List<Map<String, dynamic>>> searchBuses(
      String from, String to, String time) async {
    List<Map<String, dynamic>> matchingBuses = [];
    try {
      // Fetch all buses from Firebase
      QuerySnapshot busSnapshot = await buses.get();

      // Iterate over the buses
      for (var busDoc in busSnapshot.docs) {
        var busData = busDoc.data() as Map<String, dynamic>;

        // Get the trip points (array of locations and time) from the bus document
        List<dynamic> tripPoints = busData['tripPoints'] ?? [];

        // Variables to track if both from and to locations are found
        bool fromFound = false;
        bool toFound = false;

        // Iterate over the trip points to check if both "from" and "to" are present
        for (var point in tripPoints) {
          //i remove the time condition for testing purposes && point['time'] == time
          if (point['location'] == from) {
            fromFound = true;
          } else if (point['location'] == to) {
            toFound = true;
          }

          // If both are found, add the bus details to the matching buses list
          if (fromFound && toFound) {
            matchingBuses.add({
              'busName': busData['busName'],
              'busType': busData['busType'],
              'onboardTime': busData['onboardTime'],
              'startLocation': busData['startLocation'],
              'destination': busData['destination'],
              'busNo': busData['busNo'],
              'docId': busDoc.id // Add the document ID here
            });
            break;
          }
        }
      }
    } catch (e) {
      print('Error searching buses: $e');
    }
    return matchingBuses; // Return the list of matching buses
  }

  //get the bus details using the bus number
  // Function to get bus details using the bus document ID (docId)
  Future<Map<String, dynamic>?> getBusDetails(String docId) async {
    try {
      // Fetch the bus document from Firestore using the docId
      DocumentSnapshot busDoc = await buses.doc(docId).get();

      // if (busDoc.exists) {
      // If the document exists, return its data
      return busDoc.data() as Map<String, dynamic>;
      // } else {
      //   print('Bus document does not exist');
      //   return null;
      // }
    } catch (e) {
      print('Error fetching bus details: $e');
      return null;
    }
  }

// Function to fetch the trip points for a specific bus by its docId
  Future<Map<String, dynamic>?> getBusTripPoints(String docId) async {
    try {
      // Fetch the bus document using the provided docId
      DocumentSnapshot busSnapshot = await buses.doc(docId).get();

      if (busSnapshot.exists) {
        return busSnapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error getting bus trip points: $e');
    }
    return null;
  }

  // Function to calculate estimated travel time (ETT)
  Future<Map<String, dynamic>> calculateTravelTime(
      String docId, String from, String to) async {
    Map<String, dynamic>? busData = await getBusTripPoints(docId);

    if (busData == null) {
      return {
        'ett': 'N/A',
        'fromTime': 'N/A',
        'toTime': 'N/A',
      };
    }

    List<dynamic> tripPoints = busData['tripPoints'] ?? [];

    String? fromTime;
    String? toTime;

    // Loop through the trip points and find times for both 'from' and 'to'
    for (var point in tripPoints) {
      if (point['location'] == from) {
        fromTime = point['time'];
      } else if (point['location'] == to) {
        toTime = point['time'];
      }

      if (fromTime != null && toTime != null) {
        break;
      }
    }

    if (fromTime != null && toTime != null) {
      // Convert times to double (like 13.25 -> 13.25 hours)
      double fromTimeInHours = double.parse(fromTime);
      double toTimeInHours = double.parse(toTime);

      // Calculate the difference
      double ettInHours =
          (toTimeInHours - fromTimeInHours).abs(); // Travel time in hours

      return {
        'ett': ettInHours.toStringAsFixed(2), // Round to 2 decimal places
        'fromTime': fromTime,
        'toTime': toTime,
      };
    } else {
      return {
        'ett': 'N/A',
        'fromTime': fromTime ?? 'N/A',
        'toTime': toTime ?? 'N/A',
      };
    }
  }

//handling the paied users
  final CollectionReference bookedUsers =
      FirebaseFirestore.instance.collection('bookedUsers');

  // Function to save payment details in Firestore
  Future<void> savePaymentDetails({
    required List<int> seatNumbers,
    required String busNumber,
    required String to,
    required String from,
    required double totalPayment,
  }) async {
    try {
      // Get the current user
      User? currentUser = FirebaseAuth.instance.currentUser;

      // Ensure a user is logged in before proceeding
      // if (currentUser == null) {
      //   print('No user is logged in.');
      //   return;
      // }

      // Save the payment details in Firestore under the 'bookedUsers' collection
      await bookedUsers.add({
        'seatNumbers': seatNumbers,
        'busNumber': busNumber,
        'to': to,
        'from': from,
        'totalPayment': totalPayment,
        'userName': "samantha", //currentUser.displayName ?? currentUser.email,
        'userId': "samantha log wela na", // currentUser.uid,
        'timestamp':
            FieldValue.serverTimestamp(), // Optional: store booking time
      });

      print('Payment details saved successfully.');
    } catch (e) {
      print('Error saving payment details: $e');
    }
  }
}


// this is time with lower bound and upper bound 

// import 'package:intl/intl.dart'; // Import for date formatting and parsing

// class FirestoreService {
//   Future<List<Map<String, dynamic>>> searchBuses(
//       String from, String to, String time) async {
//     // Convert input time (from user) into a DateTime object
//     DateFormat dateFormat = DateFormat('HH.mm');
//     DateTime inputTime = dateFormat.parse(time);

//     // Calculate 2 hours before and after
//     DateTime timeLowerBound = inputTime.subtract(Duration(hours: 2));
//     DateTime timeUpperBound = inputTime.add(Duration(hours: 2));

//     List<Map<String, dynamic>> buses = [];
//     // Retrieve buses data from Firestore (this is just pseudocode; replace with your actual Firestore query)
//     var busCollection = await FirebaseFirestore.instance.collection('buses').get();

//     for (var busDoc in busCollection.docs) {
//       var busData = busDoc.data();
//       var tripPoints = busData['tripPoints'];

//       bool fromFound = false;
//       bool toFound = false;

//       for (var point in tripPoints) {
//         // Parse trip time (from Firestore) into DateTime
//         DateTime tripTime = dateFormat.parse(point['time']);

//         // Check if the trip point matches the user's from and to locations
//         if (point['location'] == from) {
//           fromFound = true;
//         } else if (point['location'] == to) {
//           toFound = true;
//         }

//         // Check if the trip time is within the 2-hour range
//         if (tripTime.isAfter(timeLowerBound) && tripTime.isBefore(timeUpperBound)) {
//           if (fromFound && toFound) {
//             // Add bus details to the list if both locations and time condition match
//             buses.add({
//               'busName': busData['busName'],
//               'busType': busData['busType'],
//               'onboardTime': point['time'],  // Use point's time for onboard time
//               'startLocation': from,
//               'destination': to,
//               'busNo': busData['busNo']
//             });
//             break; // Exit the loop once a valid trip is found
//           }
//         }
//       }
//     }

//     return buses;
//   }
// }
