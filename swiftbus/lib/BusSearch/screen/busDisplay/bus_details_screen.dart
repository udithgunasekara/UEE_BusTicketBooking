import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/screen/busDisplay/widget/booking_button.dart';
import 'package:swiftbus/BusSearch/screen/busDisplay/widget/bus_info_card.dart';
import 'package:swiftbus/BusSearch/screen/busDisplay/widget/bus_schedule_widget.dart';
import 'package:swiftbus/BusSearch/service/firestore.dart';

class BusDetailsScreen extends StatefulWidget {
  final String docId;
  final String to;
  final String from;

  const BusDetailsScreen({
    Key? key,
    required this.docId,
    required this.to,
    required this.from,
  }) : super(key: key);

  @override
  State<BusDetailsScreen> createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
  String fromTime = '';
  String toTime = '';
  String estimatedTravelTime = '';

  @override
  void initState() {
    super.initState();
    _getTravelTimes();
  }

  void _getTravelTimes() async {
    FirestoreService firestoreService = FirestoreService();
    var result = await firestoreService.calculateTravelTime(
        //getting info
        widget.docId,
        widget.from,
        widget.to);

    setState(() {
      fromTime = result['fromTime'];
      toTime = result['toTime'];
      estimatedTravelTime = result['ett'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bus Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BusInfoCard(docId: widget.docId),

            BusScheduleWidget(
              docId: widget.docId,
              from: widget.from,
              to: widget.to,
              fromTime: fromTime,
              toTime: toTime,
            ),
            const SizedBox(height: 8),
            BookingButton(
              ett: estimatedTravelTime,
              fromTime: fromTime,
              toTime: toTime,
              to: widget.to,
              from: widget.from,
              docId: widget.docId,
            ),
            // const SizedBox(height: 16), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}
