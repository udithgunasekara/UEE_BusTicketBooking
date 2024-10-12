import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference buses =
      FirebaseFirestore.instance.collection('buses');
  final CollectionReference bookedUsers =
      FirebaseFirestore.instance.collection('bookedUsers');

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

  Future<Map<String, dynamic>?> getBusDetails(String docId) async {
    try {
      DocumentSnapshot busDoc = await buses.doc(docId).get();
      return busDoc.data() as Map<String, dynamic>;
    } catch (e) {
      print('Error fetching bus details: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getBusTripPoints(String docId) async {
    try {
      DocumentSnapshot busSnapshot = await buses.doc(docId).get();
      if (busSnapshot.exists) {
        return busSnapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print('Error getting bus trip points: $e');
    }
    return null;
  }

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
      double fromTimeInHours = double.parse(fromTime);
      double toTimeInHours = double.parse(toTime);
      double ettInHours = (toTimeInHours - fromTimeInHours).abs();

      return {
        'ett': ettInHours.toStringAsFixed(2),
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

  Future<Map<String, dynamic>> fetchBusAndReservationData(String busNo) async {
    try {
      QuerySnapshot busSnapshot =
          await buses.where('busNo', isEqualTo: busNo).get();

      if (busSnapshot.docs.isEmpty) {
        throw Exception('Bus not found');
      }

      Map<String, dynamic> busData =
          busSnapshot.docs.first.data() as Map<String, dynamic>;

      QuerySnapshot reservationSnapshot =
          await bookedUsers.where('busNumber', isEqualTo: busNo).get();

      List<Map<String, dynamic>> reservations = reservationSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      return {
        'busData': busData,
        'reservations': reservations,
      };
    } catch (e) {
      print('Error fetching bus and reservation data: $e');
      rethrow;
    }
  }
}

Future<List<int>> getReservedSeats(String busNumber) async {
  List<int> reservedSeats = [];

  // Query the 'bookedUsers' collection to get the booked users for the bus
  QuerySnapshot bookedUsersSnapshot = await FirebaseFirestore.instance
      .collection('bookedUsers')
      .where('busNumber', isEqualTo: busNumber)
      .get();

  for (var doc in bookedUsersSnapshot.docs) {
    Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;
    List<int> seats = List<int>.from(userData['seatNumbers']);
    reservedSeats.addAll(seats);
  }

  return reservedSeats;
}
