import 'package:flutter/material.dart';

class PaymentSummary extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentTotal(),
        SizedBox(height: 50),
        Text('Add your card details', style: TextStyle(fontSize: 16)),
        SizedBox(height: 8),
        _buildCardOption('Axis Bank', '8395', 'mastercard'),
        SizedBox(height: 8),
        _buildCardOption('HDFC Bank', '6246', 'visa'),
        SizedBox(height: 8),
        _buildAddNewCardButton(),
        SizedBox(height: 50),
        _buildTotalBill(),
        SizedBox(height: 24),
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
        Text('Rs 5,357.00',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildCardOption(String bank, String lastFour, String network) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Image.network('https://cdn-icons-png.flaticon.com/512/196/196578.png',
              width: 40, height: 25),
          SizedBox(width: 16),
          Text('$bank **** **** **** $lastFour'),
          Spacer(),
          Icon(Icons.radio_button_off, color: Colors.grey),
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
    return const Row(
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
              'Rs 1360.00 × 2', // The smaller text showing the breakdown
              style: TextStyle(
                  fontSize: 12, color: Colors.grey), // Smaller, lighter text
            ),
            SizedBox(
                height: 4), // Spacing between the breakdown and total amount
            Text(
              'Rs 5,357.00', // The total amount
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
          // TODO: Implement payment processing logic
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
