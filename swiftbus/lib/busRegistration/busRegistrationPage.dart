import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import '../SeatStructure/models/bus_model.dart';
import '../SeatStructure/screens/bus_seat_layout_overview.dart';

class Finalbusregpage extends StatefulWidget {
  final Map<String, dynamic> busDetails;
  final Function(Map<String, dynamic>) onNext;

  const Finalbusregpage({
    Key? key,
    required this.busDetails,
    required this.onNext,
  }) : super(key: key);

  @override
  State<Finalbusregpage> createState() => _FinalbusregpageState();
}

class _FinalbusregpageState extends State<Finalbusregpage> {
  List<XFile> _images = [];
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    setState(() {
      _images.addAll(pickedFiles);
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _uploadImages() async {
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
        final ref = FirebaseStorage.instance.ref().child('bus_images').child(
            '${widget.busDetails['busNo']}_${DateTime.now().millisecondsSinceEpoch}$fileExtension');

        UploadTask uploadTask = ref.putFile(File(image.path));

        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          setState(() {
            _uploadProgress =
                (i + (snapshot.bytesTransferred / snapshot.totalBytes)) /
                    _images.length;
          });
        });

        await uploadTask;
        String downloadUrl = await ref.getDownloadURL();
        uploadedUrls.add(downloadUrl);
      }

      // Add image URLs to bus details
      widget.busDetails['imageUrls'] = uploadedUrls;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Images uploaded successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading images: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0.0;
      });
    }
  }

  List<List<int?>> _createSeatMap(String seatFormat) {
    int seatsPerRow = seatFormat == '4 seater' ? 4 : 5;
    int rows = 10;
    return List.generate(rows, (row) {
      return List.generate(seatsPerRow + 1, (col) {
        if (col == 2) return null; // Add null for aisle
        int seatNumber = row * seatsPerRow + (col > 2 ? col - 1 : col) + 1;
        return seatNumber <= _calculateTotalSeats(seatFormat)
            ? seatNumber
            : null;
      });
    });
  }

  int _calculateTotalSeats(String seatFormat) {
    return seatFormat == '4 seater' ? 40 : 50;
  }

  Future<void> _handleNext() async {
    if (_images.isNotEmpty && !widget.busDetails.containsKey('imageUrls')) {
      await _uploadImages();
    }

    // Create a BusModel instance
    final busModel = BusModel(
      id: widget.busDetails['busNo'],
      name: widget.busDetails['busName'] ?? 'Bus ${widget.busDetails['busNo']}',
      imageUrl: widget.busDetails['imageUrls']?.isNotEmpty == true
          ? widget.busDetails['imageUrls'][0]
          : null,
      seatMap: _createSeatMap(widget.busDetails['seatFormat']),
      totalSeats: _calculateTotalSeats(widget.busDetails['seatFormat']),
    );

    // Navigate to BusSeatLayoutOverview
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BusSeatLayoutOverview(
          busDetails: widget.busDetails,
          busModel: busModel,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border.all(
              width: 3, color: const Color.fromARGB(255, 71, 145, 2)),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          color: Colors.green[200],
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 80, 80, 80).withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Add images of bus No: ${widget.busDetails['busNo']} (Optional)\nUploaded images will help passengers identify your bus easily.',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      child: const Text(
                        'Add Images',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    if (_images.isNotEmpty) ...[
                      SizedBox(height: 10),
                      Text('${_images.length} images selected'),
                      SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _images.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                    SizedBox(height: 20),
                    if (_isUploading)
                      LinearProgressIndicator(value: _uploadProgress),
                    SizedBox(height: 20),
                    if (_images.isNotEmpty)
                      ElevatedButton(
                        onPressed: _isUploading ? null : _uploadImages,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 15,
                          ),
                        ),
                        child: Icon(
                          Icons.upload,
                          size: 30,
                          color: _isUploading ? Colors.grey : Colors.green,
                        ),
                      ),
                    SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: _isUploading ? null : _handleNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 27, 117, 30),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 20,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
