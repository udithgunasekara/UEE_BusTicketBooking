import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:swiftbus/busRegistration/intermediatebusreg.dart';
import 'package:swiftbus/busRegistration/widgets/textFieldWidget.dart';

class InitialBusDetailsPage extends StatefulWidget {
  final Function(Map<String, String>) onNext;

  const InitialBusDetailsPage({required this.onNext});

  @override
  _InitialBusDetailsPageState createState() => _InitialBusDetailsPageState();
}

class _InitialBusDetailsPageState extends State<InitialBusDetailsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  String busNo = '';
  String busName = '';
  String busType = 'Normal';
  String startLocation = '';
  String destination = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(width: 3, color: const Color.fromARGB(255, 71, 145, 2)),
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
          padding:  EdgeInsets.all(16),
          child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextFormField(
                labelText: 'Bus No*',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bus No is required';
                  }
                  return null;
                },
                onSaved: (value) => busNo = value!,
              ),
              const SizedBox(height: 10),
              CustomTextFormField(
                labelText: 'Bus Name',
                onSaved: (value) => busName = value!,
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: busType,
                items: ['Normal', 'Semi-Luxary', 'A/C']
                    .map((format) => DropdownMenuItem(
                          value: format,
                          child: Text(format),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => busType = value!),
                decoration: InputDecoration(
                  labelText: 'Bus Type',
                  // ... (keep the same decoration as in the original code)
                ),
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                labelText: 'Start Location*',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Start Location is required';
                  }
                  return null;
                },
                onSaved: (value) => startLocation = value!,
              ),
              SizedBox(height: 10),
              CustomTextFormField(
                labelText: 'Destination*',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Destination is required';
                  }
                  return null;
                },
                onSaved: (value) => destination = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    widget.onNext({
                          'busNo': busNo,
                          'busName': busName,
                          'busType': busType,
                          'startLocation': startLocation,
                          'destination': destination,
                          'conducterId': user!.uid,
                    });
                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Intermediatebusreg(
                          initialDetails: {
                            'busNo': busNo,
                            'busName': busName,
                            'busType': busType,
                            'startLocation': startLocation,
                            'destination': destination,
                            'conducterId': user!.uid,
                          },
                        ),
                      ),
                    ); */
                  }
                },
                child: Text('Next'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
              ),
            ],
          ),
        ),
        ),
        ],
      ),
    );
}
}