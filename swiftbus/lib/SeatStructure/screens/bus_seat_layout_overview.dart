import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore package
import '../models/bus_model.dart';
import '../widgets/seat_layout.dart';
import '../widgets/legend.dart';
import 'disable_seats_screen.dart';
import 'seat_selection_screen.dart';

class BusSeatLayoutOverview extends StatefulWidget {
  final Map<String, dynamic> busDetails;

  BusSeatLayoutOverview({required this.busDetails, required BusModel busModel});

  @override
  _BusSeatLayoutOverviewState createState() => _BusSeatLayoutOverviewState();
}

class _BusSeatLayoutOverviewState extends State<BusSeatLayoutOverview> {
  Set<int> disabledSeats = Set();
  late BusModel busModel;

  @override
  void initState() {
    super.initState();
    // Create a BusModel instance from the busDetails
    busModel = BusModel(
      id: widget.busDetails['busNo'],
      name: widget.busDetails['busName'] ?? 'Bus ${widget.busDetails['busNo']}',
      imageUrl: widget.busDetails['imageUrls']?.isNotEmpty == true
          ? widget.busDetails['imageUrls'][0]
          : '/api/placeholder/300/200', // Use the first image URL if available, otherwise use a placeholder
      seatMap: _createSeatMap(widget.busDetails['seatFormat']),
      totalSeats: _calculateTotalSeats(widget.busDetails['seatFormat']),
    );
  }

  List<List<int?>> _createSeatMap(String seatFormat) {
    int seatsPerRow = seatFormat == '4 seater' ? 4 : 5;
    int rows = 10; // Assuming 10 rows, adjust as needed
    return List.generate(rows, (row) {
      return List.generate(seatsPerRow + 1, (col) {
        if (col == 2) return null; // Add null for aisle
        int seatNumber = row * seatsPerRow + (col > 2 ? col - 1 : col) + 1;
        return seatNumber <= _calculateTotalSeats(seatFormat)
            ? seatNumber
            : null;
      });
    });
  }

  int _calculateTotalSeats(String seatFormat) {
    int seatsPerRow = seatFormat == '4 seater' ? 4 : 5;
    return seatsPerRow * 10; // Assuming 10 rows, adjust as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(busModel.name),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SeatLayout(
                seatMap: busModel.seatMap,
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
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _completeBooking, // Call the function here
                    child: Text(
                      'Complete',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
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

  // Function to navigate to disable seats screen
  void _goToDisableSeatsScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisableSeatsScreen(
          initialDisabledSeats: disabledSeats,
          busModel: busModel,
        ),
      ),
    );
    if (result != null) {
      setState(() {
        disabledSeats = result;
      });
    }
  }

  // Function to save bus details to Firebase
  Future<void> _completeBooking() async {
    try {
      await FirebaseFirestore.instance.collection('buses').add({
        'busNo': widget.busDetails['busNo'],
        'conducterId': widget.busDetails['conducterId'],
        'busName': widget.busDetails['busName'],
        'busType': widget.busDetails['busType'],
        'startLocation': widget.busDetails['startLocation'],
        'destination': widget.busDetails['destination'],
        'departureTime': widget.busDetails['departureTime'],
        'departureDate': widget.busDetails['departureDate'],
        'price': widget.busDetails['price'],
        'seatFormat': widget.busDetails['seatFormat'],
        'tripPoints': widget.busDetails['tripPoints'],
        'imageUrls': widget.busDetails['imageUrls'],
        'disabledSeats': disabledSeats.toList(), // Saving the disabled seats
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bus details saved successfully!')),
      );
      Navigator.pop(context); // Return to the previous screen
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving bus details: $e')),
      );
    }
  }
}
