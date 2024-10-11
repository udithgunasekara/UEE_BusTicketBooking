import 'package:flutter/material.dart';
import 'package:swiftbus/BusSearch/service/firestore.dart';
import 'package:swiftbus/common/Home.dart';

class PaymentSummary extends StatefulWidget {
  final double totalPayment;
  String price = '150.0';
  final List<int> seatNumbers;
  final String to;
  final String from;
  final String busNo;

  PaymentSummary(
      {required this.price,
      required this.seatNumbers,
      required this.to,
      required this.from,
      required this.busNo})
      : totalPayment = _calculateTotalPayment(price, seatNumbers);

  static double _calculateTotalPayment(String price, List<int> seatNumbers) {
    double total = 0.0;
    try {
      total = double.parse(price) * seatNumbers.length;
    } catch (e) {
      print('Error parsing price: $e');
    }
    return total;
  }

  @override
  State<PaymentSummary> createState() => _PaymentSummaryState();
}

class _PaymentSummaryState extends State<PaymentSummary> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentTotal(),
        const SizedBox(height: 50),
        const Text('Add your card details', style: TextStyle(fontSize: 16)),
        const SizedBox(height: 8),
        _buildCardOption('Axis Bank', '8395', 'mastercard'),
        const SizedBox(height: 8),
        _buildCardOption('HDFC Bank', '6246', 'visa'),
        const SizedBox(height: 8),
        _buildAddNewCardButton(),
        const SizedBox(height: 50),
        _buildTotalBill(),
        const SizedBox(height: 24),
        _buildProcessPaymentButton(),
      ],
    );
  }

  Widget _buildPaymentTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Total Payment',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(widget.totalPayment.toStringAsFixed(2),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCardOption(String bank, String lastFour, String network) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.network('https://cdn-icons-png.flaticon.com/512/196/196578.png',
              width: 40, height: 25),
          const SizedBox(width: 16),
          Text('$bank **** **** **** $lastFour'),
          const Spacer(),
          const Icon(Icons.radio_button_off, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildAddNewCardButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.add_circle_outline, color: Colors.green),
          SizedBox(width: 16),
          Text('Add New Card', style: TextStyle(color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildTotalBill() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Bill',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.end, // Align the text to the right
          children: [
            Text(
              'Rs. ${widget.price} × ${widget.seatNumbers.length}', // The smaller text showing the breakdown
              style: TextStyle(
                  fontSize: 12, color: Colors.grey), // Smaller, lighter text
            ),
            SizedBox(
                height: 4), // Spacing between the breakdown and total amount
            Text(
              'Rs. ${widget.totalPayment.toStringAsFixed(2)}', // The total amount
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold), // Larger, bold text
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProcessPaymentButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // Call the savePaymentDetails function when the button is pressed
          firestoreService.savePaymentDetails(
            seatNumbers: widget.seatNumbers,
            busNumber:
                widget.busNo, // Example bus number (replace with real value)
            to: widget.to,
            from: widget.from,
            totalPayment: widget.totalPayment,
          );

          // Show a toast message indicating that the payment is processing
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Your payment is processing...'),
              duration: Duration(seconds: 2),
            ),
          );

          Future.delayed(Duration(seconds: 2), () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Home()),
            );
          });

          print('Process Payment button pressed');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFD6905),
          padding: EdgeInsets.symmetric(vertical: 16),
        ),
        child: const Text(
          'Process Payment',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              //   fontWeight: FontWeight,
              letterSpacing: 1.2),
        ),
      ),
    );
  }
}
