import 'package:flutter/material.dart';
import '../models/bus_model.dart';
import '../widgets/seat_layout.dart';
import '../widgets/legend.dart';
import '../widgets/trip_info.dart';
import '../firestore-service-update.dart';

class ReservationsScreen extends StatefulWidget {
  @override
  _ReservationsScreenState createState() => _ReservationsScreenState();
}

class _ReservationsScreenState extends State<ReservationsScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  List<Map<String, dynamic>> _bookedBuses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchBookedBuses();
  }

  Future<void> _fetchBookedBuses() async {
    setState(() => _isLoading = true);
    _bookedBuses = await _firestoreService.getBookedBuses();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Reservations'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _bookedBuses.isEmpty
              ? Center(child: Text('No reservations found.'))
              : ListView.builder(
                  itemCount: _bookedBuses.length,
                  itemBuilder: (context, index) {
                    final bus = _bookedBuses[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      child: ListTile(
                        title: Text('Bus ${bus['busName']}'),
                        subtitle: Text('From: ${bus['from']} To: ${bus['to']}'),
                        trailing:
                            Text('Seats: ${bus['seatNumbers'].join(', ')}'),
                        onTap: () => _showBusDetails(context, bus),
                      ),
                    );
                  },
                ),
    );
  }

  void _showBusDetails(BuildContext context, Map<String, dynamic> bus) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BusDetailsScreen(
          from: bus['from'],
          to: bus['to'],
          date: bus['timestamp'].toDate().toString(),
          time: bus['fromTime'],
          reservedSeats: List<int>.from(bus['seatNumbers']),
          disabledSeats: List<int>.from(bus['disabledSeats'] ?? []),
          busModel: BusModel(
            id: bus['busId'],
            name: bus['busName'],
            imageUrl: bus['imageUrl'] ?? '/api/placeholder/300/200',
            totalSeats: bus['totalSeats'],
            seatMap: List<List<int?>>.from(
                bus['seatMap'].map((row) => List<int?>.from(row))),
          ),
        ),
      ),
    );
  }
}

class BusDetailsScreen extends StatelessWidget {
  final String from;
  final String to;
  final String date;
  final String time;
  final List<int> reservedSeats;
  final List<int> disabledSeats;
  final BusModel busModel;

  BusDetailsScreen({
    required this.from,
    required this.to,
    required this.date,
    required this.time,
    required this.reservedSeats,
    required this.disabledSeats,
    required this.busModel,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bus Details')),
      body: Column(
        children: [
          TripInfo(
            from: from,
            to: to,
            date: date,
            time: time,
            availableSeats: busModel.totalSeats -
                disabledSeats.length -
                reservedSeats.length,
          ),
          Expanded(
            child: SeatLayout(
              seatMap: busModel.seatMap,
              disabledSeats: Set.from(disabledSeats),
              onSeatTap: null,
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
        ],
      ),
    );
  }
}
