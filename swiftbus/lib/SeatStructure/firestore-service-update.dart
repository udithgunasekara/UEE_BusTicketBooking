import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final CollectionReference buses =
      FirebaseFirestore.instance.collection('buses');
  final CollectionReference bookedUsers =
      FirebaseFirestore.instance.collection('bookedUsers');

  // ... (previous methods remain the same)

  Future<List<Map<String, dynamic>>> getBookedBuses() async {
    List<Map<String, dynamic>> bookedBuses = [];
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        print('No user is logged in.');
        return bookedBuses;
      }

      QuerySnapshot bookingsSnapshot = await bookedUsers
          .where('userId', isEqualTo: currentUser.uid)
          .get();

      for (var bookingDoc in bookingsSnapshot.docs) {
        var bookingData = bookingDoc.data() as Map<String, dynamic>;
        String busNumber = bookingData['busNumber'];

        // Fetch the corresponding bus details
        QuerySnapshot busSnapshot = await buses
            .where('busNo', isEqualTo: busNumber)
            .limit(1)
            .get();

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
