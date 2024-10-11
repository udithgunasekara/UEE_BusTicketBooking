import 'package:flutter/material.dart';
import '../models/bus_model.dart';
import 'bus_seat_layout_overview.dart';

class BusModelSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Bus Model'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        itemCount: busModels.length,
        itemBuilder: (context, index) {
          final model = busModels[index];
          return Card(
            elevation: 1,
            margin: EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              title: Text(
                model.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                '${model.totalSeats} seats available',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              trailing: Icon(Icons.arrow_forward_ios,
                  size: 16, color: Colors.grey[600]),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusSeatLayoutOverview(
                      busModel: model,
                      busDetails: {},
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
