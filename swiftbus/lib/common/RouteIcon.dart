import 'package:flutter/material.dart';

class RouteIcon extends StatelessWidget {
  final double width;
  final Color lineColor;
  final Color dotColor;

  const RouteIcon({
    Key? key,
    this.width = 50,
    this.lineColor = const Color(0xFF129C38),
    this.dotColor = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, 10),
      painter: _RouteIconPainter(
        lineColor: lineColor,
        dotColor: dotColor,
      ),
    );
  }
}

class _RouteIconPainter extends CustomPainter {
  final Color lineColor;
  final Color dotColor;

  _RouteIconPainter({
    required this.lineColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Add rounded ends to the line

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    // Draw the line
    canvas.drawLine(
      Offset(0, size.height / 2),
      Offset(size.width, size.height / 2),
      linePaint,
    );

    // Draw start dot
    // canvas.drawCircle(Offset(0, size.height / 2), 3, dotPaint);

    // Draw end dot
    canvas.drawCircle(Offset(size.width, size.height / 2), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
