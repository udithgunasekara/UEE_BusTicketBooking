import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/screen/paymentPage/widget/bus_detail_card.dart';
import 'package:swiftbus/BusSearch/screen/paymentPage/widget/payment_summary.dart';
import 'package:swiftbus/BusSearch/service/firestore.dart';
import 'package:swiftbus/common/NavBar.dart';

class ShowBusDetailsScreen extends StatefulWidget {
  final String to;
  final String from;
  final String toTime;
  final String fromTime;
  final String docId;
  final List<int> seatNumbers;

  //bus number
  //seat numbers
  //Tot payment
  //full price
  //user name

  ShowBusDetailsScreen({
    required this.to,
    required this.from,
    required this.toTime,
    required this.fromTime,
    required this.docId,
    required this.seatNumbers,
  }) {
    print('Here the bus id: $docId');
  }

  @override
  State<ShowBusDetailsScreen> createState() => _ShowBusDetailsScreenState();
}

class _ShowBusDetailsScreenState extends State<ShowBusDetailsScreen> {
  Map<String, dynamic>? busDetails;

  @override
  void initState() {
    super.initState();
    _fetchBusDetails();
  }

  // Function to fetch bus details using the docId
  void _fetchBusDetails() async {
    FirestoreService firestoreService = FirestoreService();
    Map<String, dynamic>? details =
        await firestoreService.getBusDetails(widget.docId);

    if (details != null) {
      setState(() {
        busDetails = details;
      });
    }
  }

  String get busNumber => busDetails?['busNo'] ?? 'Unknown';
  //props
  //final List<int> seatNumbers = seatNumbers;

  final double totalPayment = 150.0;
  // calculation
  String get fullPrice => busDetails?['price'] ?? 'Unknown Price';
  //props
  final String userName = 'John Doe';
  // google auth
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' Make Your Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        // Ensures the UI is within safe areas like notches
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // Adjust padding as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BusDetailCard(
                to: widget.to,
                from: widget.from,
                toTime: widget.toTime,
                fromTime: widget.fromTime,
                seatNumbers: widget.seatNumbers,
              ),
              const SizedBox(height: 24),
              PaymentSummary(
                  price: fullPrice,
                  seatNumbers: widget.seatNumbers,
                  to: widget.to,
                  from: widget.from,
                  busNo: busNumber),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const Navbar(selectedIndex: 1,),
    );
  }
}
