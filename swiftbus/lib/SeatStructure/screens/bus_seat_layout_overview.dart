import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/bus_model.dart';
import '../widgets/seat_layout.dart';
import '../widgets/legend.dart';
import 'disable_seats_screen.dart';

class BusSeatLayoutOverview extends StatefulWidget {
  final Map<String, dynamic> busDetails;
  final BusModel busModel;

  const BusSeatLayoutOverview({
    Key? key,
    required this.busDetails,
    required this.busModel,
  }) : super(key: key);

  @override
  _BusSeatLayoutOverviewState createState() => _BusSeatLayoutOverviewState();
}

class _BusSeatLayoutOverviewState extends State<BusSeatLayoutOverview> {
  Set<int> disabledSeats = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.busModel.name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SeatLayout(
                reservedSeats: Set(),
                seatMap: widget.busModel.seatMap,
                disabledSeats: disabledSeats,
                onSeatTap: null,
                seatColor: (seatNumber) => disabledSeats.contains(seatNumber)
                    ? Color(0xFF12839C)
                    : Colors.white,
                legendItems: [
                  LegendItem(color: Colors.white, label: 'Available'),
                  LegendItem(color: Color(0xFF12839C), label: 'Disabled'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: _goToDisableSeatsScreen,
                    child: Text(
                      'Disable Seats',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _completeBooking,
                    child: Text(
                      'Complete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToDisableSeatsScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisableSeatsScreen(
          initialDisabledSeats: disabledSeats,
          busModel: widget.busModel,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        disabledSeats = result;
      });
    }
  }

  Future<void> _completeBooking() async {
    try {
      // Flatten the 2D seatMap to a 1D array
      final List<int?> flatSeatMap =
          widget.busModel.seatMap.expand((row) => row).toList();

      final Map<String, dynamic> finalBusDetails = {
        ...widget.busDetails,
        'disabledSeats': disabledSeats.toList(),
        'totalSeats': widget.busModel.totalSeats,
        'seatMap': flatSeatMap, // Store flattened seatMap
      };

      await FirebaseFirestore.instance.collection('buses').add(finalBusDetails);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bus details saved successfully!')),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving bus details: $e')),
      );
    }
  }
}
