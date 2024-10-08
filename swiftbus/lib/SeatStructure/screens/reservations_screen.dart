import 'package:flutter/material.dart';
import '../widgets/seat_layout.dart';
import '../widgets/legend.dart';
import '../widgets/trip_info.dart';

class ReservationsScreen extends StatelessWidget {
  final String from;
  final String to;
  final String date;
  final String time;
  final List<int> reservedSeats;
  final List<int> disabledSeats;

  ReservationsScreen({
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.reservedSeats,
    required this.disabledSeats,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(context),
            TripInfo(
              from: from,
              to: to,
              date: date,
              time: time,
              availableSeats: 56 - disabledSeats.length - reservedSeats.length,
            ),
            Expanded(
              child: SeatLayout(
                disabledSeats: Set.from(disabledSeats),
                onSeatTap: null, // Seats are not tappable in reservation view
                seatColor: (seatNumber) {
                  if (reservedSeats.contains(seatNumber)) {
                    return Colors.green;
                  } else if (disabledSeats.contains(seatNumber)) {
                    return Colors.blue;
                  } else {
                    return Colors.grey[300]!;
                  }
                },
                legendItems: [
                  LegendItem(color: Colors.green, label: 'Reserved'),
                  LegendItem(color: Colors.grey[300]!, label: 'Not Reserved'),
                  LegendItem(color: Colors.blue, label: 'Disabled'),
                ],
              ),
            ),
            _buildDetailsButton(),
          ],
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
          SizedBox(width: 48), // Balance the layout
        ],
      ),
    );
  }

  Widget _buildDetailsButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement details action
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
