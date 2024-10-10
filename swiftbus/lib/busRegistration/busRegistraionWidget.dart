// import 'dart:ffi';
import 'dart:io';
// import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
// import 'package:intl/intl.dart';
import 'package:swiftbus/busRegistration/widgets/customDatePicker.dart';
import 'package:swiftbus/busRegistration/widgets/textFieldWidget.dart';

class Busregistraionwidget extends StatefulWidget {
  const Busregistraionwidget({super.key});
  

  @override
  State<Busregistraionwidget> createState() => _BusregistraionwidgetState();
}

class _BusregistraionwidgetState extends State<Busregistraionwidget> {
  User? user = FirebaseAuth.instance.currentUser;
  final _formkey = GlobalKey<FormState>();
  String busNo = '';
  String busName = '';
  String busType = 'Normal';
  String startLocation = '';
  String destination = '';
  DateTime? _selectedDate;
  String departureTime = '';
  String price = '';
  String seatFormat = '4 seater';
  List<Map<String, String>> tripPoints = [{'location': '', 'time': ''}];
  List<XFile> _images = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }


  Future <void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    setState(() {
      // ignore: unnecessary_null_comparison
      if(pickedFiles != null && pickedFiles.isNotEmpty) {
        _images.addAll(pickedFiles);
      } 
    });
  }

  void _addTripPoint() {
    setState(() {
      tripPoints.add({'location': '', 'time': ''});
    });
  }

   // Function to remove selected image
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _uploadImagesAndSubmitForm() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      /* if (_images.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select images')),
        );
        return;
      } */
      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      List<String> uploadedUrls = [];

      try {
        for (int i = 0; i < _images.length; i++) {
          XFile image = _images[i];
          String filename = path.basename(image.path);
          String fileExtension = path.extension(filename);

          final ref = FirebaseStorage.instance
              .ref()
              .child('bus_images')
              .child('$busNo${DateTime.now().millisecondsSinceEpoch}$fileExtension');

          UploadTask uploadTask = ref.putFile(File(image.path));

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            setState(() {
              _uploadProgress = (i + (snapshot.bytesTransferred / snapshot.totalBytes)) / _images.length;
            });
          });

          await uploadTask;
          String downloadUrl = await ref.getDownloadURL();
          uploadedUrls.add(downloadUrl);
        }

        // Now that images are uploaded, submit the form data
        await FirebaseFirestore.instance.collection('buses').add({
          'busNo': busNo,
          'conducterId': user!.uid,
          'busName': busName,
          'busType': busType,
          'startLocation': startLocation,
          'destination': destination,
          'departureTime': departureTime,
          'departureDate': _selectedDate?.toIso8601String(),
          'price': price,
          'seatFormat': seatFormat,
          'tripPoints': tripPoints,
          'imageUrls': uploadedUrls,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bus added successfully')),
        );

        // Clear the form and selected images
        _formkey.currentState!.reset();
        setState(() {
          _images.clear();
        });

      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error registering bus: $e')),
        );
      } finally {
        setState(() {
          _isUploading = false;
          _uploadProgress = 0.0;
        });
      }
    }
    }


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
            key: _formkey,
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
                  onSaved: (value) => busNo = value!
                ), 
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                  labelText: 'Bus Name',
                  onSaved: (value) => busName = value!
                ),
                const SizedBox(
                  height: 10,
                ),
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
                      borderSide: const BorderSide(color: Colors.orange, width: 4.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 33, 116, 1), width: 3.0),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                CustomTextFormField(
                  labelText: 'Start Location*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Start Location is required';
                    }
                    return null;
                  },
                  onSaved: (value) => startLocation = value!
                ), 

                const SizedBox(height: 10),

                CustomTextFormField(
                  labelText: 'Destination*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Destination is required';
                    }
                    return null;
                  },
                  onSaved: (value) => destination = value!
                ), 

                const SizedBox(height: 10),
                //datepoicker section
                CustomDatePickerField(
                  labelText: 'Departure Date *',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Date is required';
                    }
                    return null;
                  },
                  onSaved: (value) => _selectedDate = value!,
                ),

                const SizedBox(height: 10),

                CustomTextFormField(
                  labelText: 'Departure Time*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Departure Time is required';
                    }
                    return null;
                  },
                  onSaved: (value) => departureTime = value!
                ), 

                const SizedBox(height: 10),

                CustomTextFormField(
                  labelText: 'Price*',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required';
                    }
                    return null;
                  },
                  onSaved: (value) => price = value!
                ), 
                const SizedBox(
                  height: 10,
                ),                
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
                      borderSide: const BorderSide(color: Colors.orange, width: 4.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromARGB(255, 33, 116, 1), width: 3.0),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 10,
                ),

                ...tripPoints.asMap().entries.map((entry) {
                  int idx = entry.key;
                  return Row(
                    children: [
                      Expanded(child: CustomTextFormField(
                          labelText: 'Location',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Location is required';
                            }
                            return null;
                          },
                          onSaved: (value) => tripPoints[idx]['location'] = value!
                        ),
                      ),
                      Expanded(child: CustomTextFormField(
                          labelText: 'Time',
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Time is required';
                            }
                            return null;
                          },
                          onSaved: (value) => tripPoints[idx]['time'] = value!
                        ),
                      ),                      
                    ],
                  );
                }).toList(),

                ElevatedButton(
                  onPressed: _addTripPoint,
                  child: const Icon(Icons.add),
                ),
                ElevatedButton(
                  onPressed: _isUploading ? null : _pickImage,
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.orange,
                    ),
                  child: const Text('Select Images',
                  style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                  ),
                ),
                if (_images.isNotEmpty) ...[
                  const SizedBox(height: 10),

                  Text('${_images.length} images selected'),

                  const SizedBox(height: 10),
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: _images.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Image.file(
                            File(_images[index].path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              onPressed: () => _removeImage(index),
                              icon: const Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
                if (_isUploading) ...[
                  SizedBox(height: 10),
                  LinearProgressIndicator(value: _uploadProgress),
                  SizedBox(height: 10),
                  Text('Uploading: ${(_uploadProgress * 100).toStringAsFixed(2)}%'),
                ],
                ElevatedButton(
                  onPressed: _isUploading ? null : _uploadImagesAndSubmitForm,
                  child: Text('Submit',
                  style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.green,
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