import 'package:flutter/material.dart';
// import 'package:swiftbus/busRegistration/finalbusregpage.dart';
import 'package:swiftbus/busRegistration/widgets/customDatePicker.dart';
import 'package:swiftbus/busRegistration/widgets/textFieldWidget.dart';

class Intermediatebusreg extends StatefulWidget {
  final Map<String, dynamic> initialDetails;
  final Function(Map<String, dynamic>) onNext;
  const Intermediatebusreg({
    super.key,
    required this.initialDetails,
    required this.onNext,
  });

  @override
  State<Intermediatebusreg> createState() => _IntermediatebusregState();
}

class _IntermediatebusregState extends State<Intermediatebusreg> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  String departureTime = '';
  String estimatedArrival = '';
  String price = '';
  String seatFormat = '4 seater';
  List<Map<String, String>> tripPoints = [
    {'location': '', 'time': ''}
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        border:
            Border.all(width: 3, color: const Color.fromARGB(255, 71, 145, 2)),
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        color: Colors.green[200],
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 80, 80, 80).withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 20,
            offset: const Offset(0, 8), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomDatePickerField(
                    labelText: 'Departure Date *',
                    validator: (value) {
                      if (value == null) {
                        return 'Date is required';
                      }
                      return null;
                    },
                    onSaved: (value) => _selectedDate = value,
                  ),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: 'Departure Time*',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Departure Time is required';
                      }
                      return null;
                    },
                    onSaved: (value) => departureTime = value!,
                  ),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: 'Estimated Arrival Time*',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Estimated Arrival Time is required';
                      }
                      return null;
                    },
                    onSaved: (value) => estimatedArrival = value!,
                  ),
                  SizedBox(height: 15),
                  CustomTextFormField(
                    labelText: 'Price*',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Price is required';
                      }
                      return null;
                    },
                    onSaved: (value) => price = value!,
                  ),
                  SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: seatFormat,
                    items: ['4 seater', '5 seater']
                        .map((format) => DropdownMenuItem(
                              value: format,
                              child: Text(format),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => seatFormat = value!),
                    decoration: InputDecoration(
                      labelText: 'Seat Format',
                      // ... (keep the same decoration as in the original code)
                    ),
                  ),
                  SizedBox(height: 15),
                  ...tripPoints.asMap().entries.map((entry) {
                    int idx = entry.key;
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextFormField(
                                labelText: 'Location',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Location is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    tripPoints[idx]['location'] = value!,
                              ),
                            ),
                            SizedBox(width: 3,),
                            Expanded(
                              child: CustomTextFormField(
                                labelText: 'Time',
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Time is required';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    tripPoints[idx]['time'] = value!,
                              ),
                            ),
                            if (idx !=
                                0) // Don't show remove button for the first pair
                              IconButton(
                                icon: Icon(
                                  Icons.remove_circle,
                                  color: Colors.black,
                                  size: 22,
                                ),
                                onPressed: () {
                                  setState(() {
                                    tripPoints.removeAt(idx);
                                  });
                                },
                              ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    );
                  }).toList(),
                  SizedBox(height: 5),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        tripPoints.add({'location': '', 'time': ''});
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.orange,
                      padding: const EdgeInsets.symmetric(
                          horizontal:30, vertical:5),
                    ),
                    child: const Icon(
                      Icons.add, // This displays an arrow icon
                      size: 25, // You can adjust the size as needed
                      color: Colors.white, // Keeps the arrow white
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        Map<String, dynamic> allDetails = {
                          ...widget.initialDetails,
                          'departureDate': _selectedDate?.toIso8601String(),
                          'departureTime': departureTime,
                          'price': price,
                          'seatFormat': seatFormat,
                          'tripPoints': tripPoints,
                          'estimatedArrival': estimatedArrival,
                        };
                        widget.onNext(allDetails);
                  
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 27, 117, 30),
                      padding: const EdgeInsets.symmetric(
                          horizontal:20, vertical:20),
                    ),
                    child: const Icon(
                      Icons.arrow_forward, // This displays an arrow icon
                      size: 40, // You can adjust the size as needed
                      color: Colors.white, // Keeps the arrow white
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
