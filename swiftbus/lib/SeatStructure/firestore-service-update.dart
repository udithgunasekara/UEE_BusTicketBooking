import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference buses =
      FirebaseFirestore.instance.collection('buses');
  final CollectionReference bookedUsers =
      FirebaseFirestore.instance.collection('bookedUsers');

  // Function to search buses based on "from", "to", and "time"
  Future<List<Map<String, dynamic>>> searchBuses(
      String from, String to, String time) async {
    List<Map<String, dynamic>> matchingBuses = [];
    try {
      QuerySnapshot busSnapshot = await buses.get();

      for (var busDoc in busSnapshot.docs) {
        var busData = busDoc.data() as Map<String, dynamic>;
        List<dynamic> tripPoints = busData['tripPoints'] ?? [];

        bool fromFound = false;
        bool toFound = false;
        String fromTime = '';
        String toTime = '';

        for (var point in tripPoints) {
          if (point['location'] == from) {
            fromFound = true;
            fromTime = point['time'];
          } else if (point['location'] == to) {
            toFound = true;
            toTime = point['time'];
          }

          if (fromFound && toFound) {
            matchingBuses.add({
              'busName': busData['busName'],
              'busType': busData['busType'],
              'onboardTime': busData['onboardTime'],
              'startLocation': busData['startLocation'],
              'destination': busData['destination'],
              'busNo': busData['busNo'],
              'fromTime': fromTime,
              'toTime': toTime,
              'docId': busDoc.id
            });
            break;
          }
        }
      }
    } catch (e) {
      print('Error searching buses: $e');
    }
    return matchingBuses;
  }

  // Function to get bus details using the bus document ID (docId)
  Future<Map<String, dynamic>?> getBusDetails(String docId) async {
    try {
      DocumentSnapshot busDoc = await buses.doc(docId).get();
      return busDoc.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching bus details: $e');
      return null;
    }
  }

  // Function to save payment details in Firestore
  Future<void> savePaymentDetails({
    required List<int> seatNumbers,
    required String busNumber,
    required String to,
    required String from,
    required double totalPayment,
  }) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No user is logged in.');
        return;
      }

      await bookedUsers.add({
        'seatNumbers': seatNumbers,
        'busNumber': busNumber,
        'to': to,
        'from': from,
        'totalPayment': totalPayment,
        'userName': currentUser.displayName ?? currentUser.email,
        'userId': currentUser.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Payment details saved successfully.');
    } catch (e) {
      print('Error saving payment details: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getBookedBuses() async {
    List<Map<String, dynamic>> bookedBuses = [];
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No user is logged in.');
        return bookedBuses;
      }

      QuerySnapshot bookingsSnapshot =
          await bookedUsers.where('userId', isEqualTo: currentUser.uid).get();

      for (var bookingDoc in bookingsSnapshot.docs) {
        var bookingData = bookingDoc.data() as Map<String, dynamic>;
        String busNumber = bookingData['busNumber'];

        QuerySnapshot busSnapshot =
            await buses.where('busNo', isEqualTo: busNumber).limit(1).get();

        if (busSnapshot.docs.isNotEmpty) {
          var busData = busSnapshot.docs.first.data() as Map<String, dynamic>;
          bookedBuses.add({
            ...bookingData,
            ...busData,
            'bookingId': bookingDoc.id,
            'busId': busSnapshot.docs.first.id,
          });
        }
      }
    } catch (e) {
      print('Error fetching booked buses: $e');
    }
    return bookedBuses;
  }
}
