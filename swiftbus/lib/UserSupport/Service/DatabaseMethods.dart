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

  Future<void> setNotificationAsRead(String lockId, String tolockId, String userId) async {
  try {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("TransferLocker")
        .where("lockid", isEqualTo: lockId)
        .where("userid", isEqualTo: userId)
        .where("tolockid", isEqualTo: tolockId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      await snapshot.docs.first.reference.update({
        "inprogress": true,
      });
      print("Transfer locker updated successfully.");
    } else {
      print("No transfer locker found with the provided lockId.$tolockId");
    }
  } catch (e) {
    print("Error updating transfer locker: $e");
  }
}
}