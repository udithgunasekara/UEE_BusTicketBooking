import 'package:flutter/material.dart';
import 'legend.dart';

class SeatLayout extends StatelessWidget {
  final List<List<int?>> seatMap;
  final Set<int> disabledSeats;
  final Set<int> reservedSeats;
  final Function(int)? onSeatTap;
  final Color Function(int) seatColor;
  final List<LegendItem> legendItems;

  const SeatLayout({
    Key? key,
    required this.seatMap,
    required this.disabledSeats,
    required this.reservedSeats,
    this.onSeatTap,
    required this.seatColor,
    required this.legendItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: seatMap[0].length,
              childAspectRatio: 1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: seatMap.length * seatMap[0].length,
            itemBuilder: (context, index) {
              int row = index ~/ seatMap[0].length;
              int col = index % seatMap[0].length;
              int? seatNumber = seatMap[row][col];

              if (seatNumber == null) {
                return SizedBox.shrink();
              }

              bool isDisabled = disabledSeats.contains(seatNumber);
              bool isReserved = reservedSeats.contains(seatNumber);

              return GestureDetector(
                onTap: isDisabled || isReserved
                    ? null
                    : () => onSeatTap?.call(seatNumber),
                child: Container(
                  decoration: BoxDecoration(
                    color: seatColor(seatNumber),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Center(
                    child: Text(
                      seatNumber.toString(),
                      style: TextStyle(
                        color: isDisabled || isReserved
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                legendItems.map((item) => _buildLegendItem(item)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(LegendItem item) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: item.color,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        SizedBox(width: 8),
        Text(item.label),
      ],
    );
  }
}
