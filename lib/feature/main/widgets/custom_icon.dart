import 'package:flutter/material.dart';

class CustomLocationIcon extends StatelessWidget {
  const CustomLocationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20, // Adjust size as needed
      width: 20,  // Adjust size as needed
      child: CustomPaint(
        painter: LocationIconPainter(),
      ),
    );
  }
}

class LocationIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint outerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.1; // Outer circle thickness

    final Paint innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.05; // Inner circle thickness


    // Outer pin shape
    Path outerPath = Path();
    double radius = size.width / 2;
    double pinHeight = size.height;

    // Draw the circular part of the pin
    outerPath.addArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, pinHeight * 0.4), // Adjust circle position
        radius: radius * 0.8,
      ),
      0,
      2 * 3.141592653589793,
    );

    // Draw the triangular bottom part of the pin
    outerPath.moveTo(size.width / 2, pinHeight);
    outerPath.lineTo(size.width / 2 - radius * 0.5, pinHeight * 0.7);
    outerPath.lineTo(size.width / 2 + radius * 0.5, pinHeight * 0.7);
    outerPath.close();

    // Draw the outer pin shape
    canvas.drawPath(outerPath, outerPaint);

    // Inner circle (stroke)
    canvas.drawCircle(
      Offset(size.width / 2, pinHeight * 0.4),
      radius * 0.3, // Adjust inner circle size
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
