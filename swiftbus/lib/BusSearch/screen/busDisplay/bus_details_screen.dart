import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/screen/busDisplay/widget/booking_button.dart';
import 'package:swiftbus/BusSearch/screen/busDisplay/widget/bus_info_card.dart';
import 'package:swiftbus/BusSearch/screen/busDisplay/widget/bus_schedule_widget.dart';

class BusDetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
                'https://lesscarmorelife.com/wp-content/uploads/2023/03/img_3728.jpg?w=900'), // Add your bus image here
            BusInfoCard(),
            BusScheduleWidget(),
            BookingButton(),
          ],
        ),
      ),
    );
  }
}
