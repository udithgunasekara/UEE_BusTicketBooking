import 'package:flutter/material.dart';

class PaymentScreen extends StatelessWidget {
  final List<int> bookedSeats;
  final double seatPrice = 10.0; // Assuming each seat costs 10.0

  PaymentScreen({required this.bookedSeats});

  @override
  Widget build(BuildContext context) {
    double totalPrice = bookedSeats.length * seatPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Booked Seats Section
            Text(
              'Booked Seats:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            // Displaying the list of booked seats
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: bookedSeats.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.event_seat, color: Colors.blueAccent),
                        SizedBox(width: 16),
                        Text(
                          'Seat Number: ${bookedSeats[index]}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24),

            // Total Price Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Price:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '\$${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

            // Spacer pushes the button to the bottom
            Spacer(),

            // Proceed to Payment Button
            ElevatedButton(
              onPressed: () {
                // Add payment processing logic here
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Payment Successful!')),
                );
                Navigator.pop(context); // Go back to the previous screen
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Proceed to Payment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.green, // Use backgroundColor instead of primary
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50), // Full width button
              ),
            ),
          ],
        ),
      ),
    );
  }
}
