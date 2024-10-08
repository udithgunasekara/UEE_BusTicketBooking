import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/screen/paymentPage/widget/bus_detail_card.dart';
import 'package:swiftbus/BusSearch/screen/paymentPage/widget/payment_summary.dart';

class ShowBusDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Make Your Payment'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        // Ensures the UI is within safe areas like notches
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
              horizontal: 16, vertical: 8), // Adjust padding as needed
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BusDetailCard(),
              SizedBox(height: 24),
              PaymentSummary(),
            ],
          ),
        ),
      ),
    );
  }
}
