import 'package:flutter/material.dart';

class BusTimePicker extends StatefulWidget {
  @override
  _BusTimePickerState createState() => _BusTimePickerState();
}

class _BusTimePickerState extends State<BusTimePicker> {
  TimeOfDay selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 7.0,
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            icon: Icon(Icons.access_time, color: Colors.black),
            onPressed: () => _selectTime(context),
            label: Text(
              selectedTime.format(context),
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFF5F5F5), // Set the background color
              minimumSize: const Size(165, 45), // Set the width and height
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Set the radius
              ),
            ),
          ),
        ],
      ),
    );
  }
}
