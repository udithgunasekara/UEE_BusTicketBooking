import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swiftbus/UserSupport/Service/DatabaseMethods.dart';

class SacnQr extends StatefulWidget {
  const SacnQr({super.key});

  @override
  State<SacnQr> createState() => _SacnQrState();
}

class _SacnQrState extends State<SacnQr> {
  String scanResult = '';
  final MobileScannerController cameraController = MobileScannerController();
  bool isScanning = false;
  String? userId;

  Future<void> _checkUserIdInPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedUserId = prefs.getString('userID');
    if (storedUserId != null) {
      setState(() {
        userId = storedUserId;
      });
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    _checkUserIdInPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange, // Set background color to orange
      appBar: AppBar(
        title: const Text('Scan the QR Code in the bus'),
        backgroundColor: Colors.orange, // Match the background color
        elevation: 0, // Remove shadow for cleaner look
      ),
      body: Center(
        child: Container(
          width: 350,
          height: 600, // Set box width
          padding: const EdgeInsets.all(16), // Padding inside the box
          decoration: BoxDecoration(
            color: Colors.white, // Set box background color
            borderRadius: BorderRadius.circular(20), // Rounded corners
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Only take minimum space
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text message above the camera/QR code
              Text(
                isScanning
                    ? "Place QR code inside the box"
                    : "Click the scan button to scan",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Match text color with theme
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Stack(
                children: [
                  Padding( // Add padding around the camera/placeholder to create space
                    padding: const EdgeInsets.all(12.0), // Adjust the padding to set distance
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: isScanning
                          ? MobileScanner(
                              controller: cameraController,
                              onDetect: (capture) {
                                final List<Barcode> barcodes = capture.barcodes;
                                final String? barcode = barcodes.isNotEmpty
                                    ? barcodes.first.rawValue
                                    : null;
                                if (barcode != null) {
                                  setState(() {
                                    scanResult = barcode;
                                  });
                                  cameraController.stop(); // Stop scanning when QR is detected
                                  _showConfirmationDialog(context, barcode);
                                }
                              },
                            )
                          : Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: QrImageView(
                                data: 'Wellcome',
                                errorCorrectionLevel: QrErrorCorrectLevel.H,
                                version: QrVersions.auto,
                                gapless: true,
                              ),
                            ),
                    ),
                  ),
                  // Highlighted Corners
                  Positioned(
                    top: 0,
                    left: 0,
                    child: _topLeftCornerHighlight(),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _topRightCornerHighlight(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _bottomLeftCornerHighlight(),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _bottomRightCornerHighlight(),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              if (!isScanning)
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isScanning = true; // Switch to scan mode
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Match background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Scan'),
                ),
              if (isScanning)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        cameraController.torchEnabled
                            ? Icons.flash_on
                            : Icons.flash_off,
                      ),
                      color: Colors.orange,
                      onPressed: () => cameraController.toggleTorch(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cameraswitch),
                      color: Colors.orange,
                      onPressed: () => cameraController.switchCamera(),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Corner highlight widget
  Widget _topRightCornerHighlight() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 4.0, color: Colors.black),
          right: BorderSide(width: 4.0, color: Colors.black),
        ),
      ),
    );
  }

  Widget _bottomRightCornerHighlight() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 4.0, color: Colors.black),
          right: BorderSide(width: 4.0, color: Colors.black),
        ),
      ),
    );
  }

  Widget _bottomLeftCornerHighlight() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 4.0, color: Colors.black),
          left: BorderSide(width: 4.0, color: Colors.black),
        ),
      ),
    );
  }

  Widget _topLeftCornerHighlight() {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(width: 4.0, color: Colors.black),
          left: BorderSide(width: 4.0, color: Colors.black),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String barcode) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('QR Code Detected'),
          content: Text('Do you want to proceed with this code: $barcode?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                DatabaseMethods().setBusNo(userId!, barcode);
                Navigator.pushNamed(context, '/home'); // Navigate to second screen
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                cameraController.start(); // Restart scanning on "No"
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }
}

void updateUserRide(String barcode) {
  
}