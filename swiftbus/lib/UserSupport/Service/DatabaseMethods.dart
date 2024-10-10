import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swiftbus/UserSupport/Service/Donepopupbox.dart';
import 'package:swiftbus/UserSupport/Service/Errorpopupbox.dart';

class DatabaseMethods {
  Future<void> createRequest(String userId, String message, String priority, String seatNumber, String busId) async {
    try {
      await FirebaseFirestore.instance.collection("UserSupport").doc().set({
        'priority': priority,
        'message': message,
        'sender': userId,
        'seatnumber': seatNumber,
        'busid': busId
      });
      
      print("UserSupport created successfully.");
      showPopup();
    } catch (e) {
      print("Error creating UserSupport: $e");
      showErrorPopup();
    }
  }

  Stream<QuerySnapshot> getaRequest(String? busid) {
    return FirebaseFirestore.instance
        .collection("UserSupport")
        .where('busid', isEqualTo: busid)
        .snapshots();
  }

  Stream<QuerySnapshot> getaRequestByUserId(String? userId) {
    return FirebaseFirestore.instance
        .collection("UserSupport")
        .where('sender', isEqualTo: userId)
        .snapshots();
  }

  Future<void> createNotification(String senderid, String message, String busId) async {
    try {
      await FirebaseFirestore.instance.collection("Notification").doc().set({
        'message': message,
        'sender': senderid,
        'busid': busId, 
        'isread': false
      });
      
      print("Notification created successfully.");
    } catch (e) {
      print("Error creating Notification: $e");
    }
  }

  Stream<QuerySnapshot> getaNotification(String busId) {
    return FirebaseFirestore.instance
        .collection("Notification")
        .where('busid', isEqualTo: busId)
        .snapshots();
  }

  Stream<QuerySnapshot> getBusId(String userId) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('uid', isEqualTo: userId)
        .snapshots();
  }

  Future<void> updateUsersWithBusId(String busId) async {
    try {
      Stream<QuerySnapshot> snapshotStream = getUserId(busId);

      snapshotStream.listen((QuerySnapshot snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            String userId = doc["uid"];
            await setBusNo(userId, busId);
          }
        } else {
          print("No users found for the bus with busId: $busId");
        }
      });
    } catch (e) {
      print("Error retrieving user IDs: $e");
    }
  }


  Stream<QuerySnapshot> getUserId(String busId) {
    return FirebaseFirestore.instance
        .collection("bookedUsers")
        .where('busid', isEqualTo: busId)
        .snapshots();
  }

  Future<void> setBusNo(String userId, String busId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("uid", isEqualTo: userId)
          .get();

      if (snapshot.docs.isNotEmpty) {
        await snapshot.docs.first.reference.update({
          "busid": busId,
        });
        print("user updated successfully.");
      } else {
        print("No user found with the provided uid.");
      }
    } catch (e) {
      print("Error updating user: $e");
    }
  }
}