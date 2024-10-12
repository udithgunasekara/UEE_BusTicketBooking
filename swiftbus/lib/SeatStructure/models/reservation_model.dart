// lib/models/reservation_model.dart

class ReservationModel {
  final String name;
  final int seatNumber;
  final double amount;
  final String id;
  final String imageUrl;

  ReservationModel({
    required this.name,
    required this.seatNumber,
    required this.amount,
    required this.id,
    this.imageUrl = '', // Make imageUrl optional with a default value
  });

  factory ReservationModel.fromMap(Map<String, dynamic> map) {
    return ReservationModel(
      name: map['userName'] ?? '',
      seatNumber: (map['seatNumbers'] as List<dynamic>).first ?? 0,
      amount: (map['totalPayment'] as num).toDouble(),
      id: map['userId'] ??
          '', // Use an empty string as default if 'userId' is not present
      imageUrl: map['imageUrl'] ??
          '', // Use an empty string as default if 'imageUrl' is not present
    );
  }
}
