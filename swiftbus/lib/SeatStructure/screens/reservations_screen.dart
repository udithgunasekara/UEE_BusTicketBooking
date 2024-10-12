import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bus_model.dart';
import '../models/reservation_model.dart';
import '../widgets/seat_layout.dart';
import '../widgets/legend.dart';
import '../widgets/trip_info.dart';
import 'reservation_details_screen.dart';

class ReservationsScreen extends StatefulWidget {
  final String busNo;
  final String from;
  final String to;
  final String date;
  final String time;

  ReservationsScreen({
    required this.busNo,
    required this.from,
    required this.to,
    required this.date,
    required this.time,
  });

  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  late Future<Map<String, dynamic>> _busDataFuture;
  late Future<List<ReservationModel>> _reservationsFuture;

  @override
  void initState() {
    super.initState();
    _busDataFuture = _fetchBusData();
    _reservationsFuture = _fetchReservations();
  }

  Future<Map<String, dynamic>> _fetchBusData() async {
    final busDoc = await FirebaseFirestore.instance
        .collection('buses')
        .where('busNo', isEqualTo: widget.busNo)
        .get();

    if (busDoc.docs.isNotEmpty) {
      return busDoc.docs.first.data();
    } else {
      throw Exception('Bus not found');
    }
  }

  Future<List<ReservationModel>> _fetchReservations() async {
    final reservationsSnapshot = await FirebaseFirestore.instance
        .collection('bookedUsers')
        .where('busNumber', isEqualTo: widget.busNo)
        .get();

    return reservationsSnapshot.docs.map((doc) {
      final data = doc.data();
      return ReservationModel.fromMap({...data, 'userId': doc.id});
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _busDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final busData = snapshot.data!;
            final busModel = BusModel(
              imageUrl: busData['imageUrl'] ?? '',
              id: busData['busNo'] ?? '',
              name: busData['busName'] ?? '',
              totalSeats: busData['totalSeats'] ?? 0,
              seatMap: List<List<int?>>.from(
                (busData['seatMap'] as List).map((row) => List<int?>.from(row)),
              ),
            );

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildAppBar(context),
                TripInfo(
                  from: widget.from,
                  to: widget.to,
                  date: widget.date,
                  time: widget.time,
                  availableSeats: busModel.totalSeats -
                      (busData['disabledSeats'] as List).length,
                ),
                Expanded(
                  child: FutureBuilder<List<ReservationModel>>(
                    future: _reservationsFuture,
                    builder: (context, reservationsSnapshot) {
                      if (reservationsSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (reservationsSnapshot.hasError) {
                        return Center(
                            child:
                                Text('Error: ${reservationsSnapshot.error}'));
                      }

                      final reservations = reservationsSnapshot.data!;
                      final reservedSeats = reservations
                          .map((reservation) => reservation.seatNumber)
                          .toSet();

                      return SeatLayout(
                        seatMap: busModel.seatMap,
                        disabledSeats:
                            Set.from(busData['disabledSeats'] as List),
                        onSeatTap: null,
                        reservedSeats: reservedSeats,
                        seatColor: (seatNumber) {
                          if (reservedSeats.contains(seatNumber)) {
                            return Colors.green;
                          } else if ((busData['disabledSeats'] as List)
                              .contains(seatNumber)) {
                            return Colors.blue;
                          } else {
                            return Colors.grey[300]!;
                          }
                        },
                        legendItems: [
                          LegendItem(color: Colors.green, label: 'Reserved'),
                          LegendItem(
                              color: Colors.grey[300]!, label: 'Available'),
                          LegendItem(color: Colors.blue, label: 'Disabled'),
                        ],
                      );
                    },
                  ),
                ),
                _buildDetailsButton(context),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.blue[700],
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          Expanded(
            child: Text(
              'Reservations',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildDetailsButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => FutureBuilder<List<ReservationModel>>(
                future: _reservationsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final reservations = snapshot.data!;
                  return ReservationDetailsScreen(
                    reservations: reservations,
                    totalAmount: reservations.fold(
                        0, (sum, reservation) => sum + reservation.amount),
                  );
                },
              ),
            ),
          );
        },
        child: Text(
          'Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
    );
  }
}
