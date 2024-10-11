import 'package:flutter/material.dart';
import '../models/bus_model.dart';
import '../widgets/seat_layout.dart';
import '../widgets/legend.dart';

class DisableSeatsScreen extends StatefulWidget {
  final Set<int> initialDisabledSeats;
  final BusModel busModel;

  DisableSeatsScreen({
    required this.initialDisabledSeats,
    required this.busModel,
  });

  @override
  _DisableSeatsScreenState createState() => _DisableSeatsScreenState();
}

class _DisableSeatsScreenState extends State<DisableSeatsScreen> {
  late Set<int> disabledSeats;

  @override
  void initState() {
    super.initState();
    disabledSeats = Set.from(widget.initialDisabledSeats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Disable Seats'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SeatLayout(
                seatMap: widget.busModel.seatMap,
                disabledSeats: Set(), // Pass an empty set here
                onSeatTap: _toggleSeatDisabled,
                seatColor: (seatNumber) {
                  if (disabledSeats.contains(seatNumber)) {
                    return Color(0xFF12839C); // Color for disabled seats
                  }
                  return Colors.white; // Color for available seats
                },
                legendItems: [
                  LegendItem(color: Colors.white, label: 'Available'),
                  LegendItem(color: Color(0xFF12839C), label: 'Disabled'),
                ],
              ),
            ),
            _buildConfirmButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: ElevatedButton(
        onPressed: () => Navigator.pop(context, disabledSeats),
        child: Text(
          'Confirm Disabled Seats',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Color(0xFF12839C), // Updated to match the disabled seat color
          minimumSize: Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  void _toggleSeatDisabled(int seatNumber) {
    setState(() {
      if (disabledSeats.contains(seatNumber)) {
        disabledSeats.remove(seatNumber);
      } else {
        disabledSeats.add(seatNumber);
      }
    });
  }
}
