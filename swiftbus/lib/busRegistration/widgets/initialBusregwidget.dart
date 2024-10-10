import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:swiftbus/busRegistration/intermediatebusreg.dart';
import 'package:swiftbus/busRegistration/widgets/textFieldWidget.dart';

class InitialBusDetailsPage extends StatefulWidget {
  final Function(Map<String, String>) onNext;

  const InitialBusDetailsPage({super.key, required this.onNext});

  @override
  // ignore: library_private_types_in_public_api
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
    return SingleChildScrollView(
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            padding: const EdgeInsets.all(20),
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
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    labelText: 'Bus Name',
                    onSaved: (value) => busName = value!,
                  ),
                  const SizedBox(height: 20),
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
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(169, 34, 116, 1),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      floatingLabelStyle: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      fillColor: const Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide:
                            const BorderSide(color: Colors.orange, width: 2.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromARGB(255, 33, 116, 1), width: 2.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
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
          ),
        ],
      ),
    ),
    );
  }
}
