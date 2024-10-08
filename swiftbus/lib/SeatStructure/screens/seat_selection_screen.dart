import 'package:flutter/material.dart';
import '../widgets/seat_layout.dart';
import '../widgets/legend.dart';
import 'reservations_screen.dart';
import '../widgets/trip_info.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Set<int> disabledSeats;

  SeatSelectionScreen({required this.disabledSeats});

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  Set<int> selectedSeats = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(),
            TripInfo(
              from: 'Panadura',
              to: 'Kandy',
              date: '08 Sep 2024',
              time: '03:30 AM',
              availableSeats: 56 - widget.disabledSeats.length,
            ),
            Expanded(
              child: SeatLayout(
                disabledSeats: widget.disabledSeats,
                onSeatTap: _toggleSeatSelection,
                seatColor: (seatNumber) {
                  if (widget.disabledSeats.contains(seatNumber)) {
                    return Colors.blue[700]!;
                  }
                  if (selectedSeats.contains(seatNumber))
                    return Colors.green[400]!;
                  return Colors.white;
                },
                legendItems: [
                  LegendItem(color: Colors.white, label: 'Available'),
                  LegendItem(color: Colors.blue[700]!, label: 'Disabled'),
                  LegendItem(color: Colors.green[400]!, label: 'Selected'),
                ],
              ),
            ),
            _buildBookingButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
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
              'Select Seats',
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

  Widget _buildBookingButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: selectedSeats.isNotEmpty ? _completeBooking : null,
        child: Text(
          'Book ${selectedSeats.length} ${selectedSeats.length == 1 ? 'Seat' : 'Seats'}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[400],
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  void _toggleSeatSelection(int seatNumber) {
    if (widget.disabledSeats.contains(seatNumber)) return;
    setState(() {
      if (selectedSeats.contains(seatNumber)) {
        selectedSeats.remove(seatNumber);
      } else {
        selectedSeats.add(seatNumber);
      }
    });
  }

  void _completeBooking() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReservationsScreen(
          from: 'Panadura',
          to: 'Kandy',
          date: '08 Sep 2024',
          time: '03:30 AM',
          reservedSeats: selectedSeats.toList(),
          disabledSeats: widget.disabledSeats.toList(),
        ),
      ),
    );
  }
}
