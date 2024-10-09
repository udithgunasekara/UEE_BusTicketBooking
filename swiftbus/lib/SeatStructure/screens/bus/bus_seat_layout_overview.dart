import 'package:flutter/material.dart';
import '../../models/bus_model.dart';
import '../../widgets/seat_layout.dart';
import '../../widgets/legend.dart';
import 'disable_seats_screen.dart';
import 'seat_selection_screen.dart';

class BusSeatLayoutOverview extends StatefulWidget {
  final BusModel busModel;

  BusSeatLayoutOverview({required this.busModel});

  @override
  _BusSeatLayoutOverviewState createState() => _BusSeatLayoutOverviewState();
}

class _BusSeatLayoutOverviewState extends State<BusSeatLayoutOverview> {
  Set<int> disabledSeats = Set();

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
                    onPressed: _goToSeatSelectionScreen,
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

  void _goToSeatSelectionScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatSelectionScreen(
          disabledSeats: disabledSeats,
          busModel: widget.busModel,
        ),
      ),
    );
  }
}
