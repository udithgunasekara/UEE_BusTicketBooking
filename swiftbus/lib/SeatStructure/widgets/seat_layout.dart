import 'package:flutter/material.dart';
import 'legend.dart';

class SeatLayout extends StatelessWidget {
  final Set<int> disabledSeats;
  final Function(int)? onSeatTap;
  final Color Function(int) seatColor;
  final List<LegendItem> legendItems;

  const SeatLayout({
    Key? key,
    required this.disabledSeats,
    required this.onSeatTap,
    required this.seatColor,
    required this.legendItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<List<int?>> seatMap = [
      [01, 02, null, 03, 04, 05],
      [06, 07, null, 08, 09, 10],
      [11, 12, null, 13, 14, 15],
      [16, 17, null, 18, 19, 20],
      [21, 22, null, 23, 24, 25],
      [26, 27, null, 28, 29, 30],
      [31, 32, null, 34, 35, 36],
      [37, 38, null, 39, 40, 41],
      [42, 43, null, 44, 45, 46],
      [47, 48, null, 49, 50, 51],
      [52, 53, null, 54, 55, 56],
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildBusHeader(),
          Expanded(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: seatMap.asMap().entries.map((entry) {
                  int rowIndex = entry.key;
                  List<int?> row = entry.value;
                  return _buildSeatRow(rowIndex, row);
                }).toList(),
              ),
            ),
          ),
          Legend(items: legendItems),
        ],
      ),
    );
  }

  Widget _buildBusHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Front',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Icon(Icons.directions_bus, size: 32, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildSeatRow(int rowIndex, List<int?> row) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 24,
            child: Text(
              String.fromCharCode(65 + rowIndex),
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xff000000)),
            ),
          ),
          ...row.map((seatNumber) {
            if (seatNumber == null) {
              return SizedBox(width: 16);
            } else {
              return _buildSeat(seatNumber);
            }
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSeat(int seatNumber) {
    bool isDisabled = disabledSeats.contains(seatNumber);
    return GestureDetector(
      onTap: onSeatTap != null && !isDisabled
          ? () => onSeatTap!(seatNumber)
          : null,
      child: Container(
        margin: EdgeInsets.all(2),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: seatColor(seatNumber),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            seatNumber.toString().padLeft(2, '0'),
            style: TextStyle(
              color: isDisabled ? Colors.white60 : Colors.black87,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
