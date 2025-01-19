import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    double responsiveFontSize = MediaQuery.of(context).size.width * 0.08;

    // Limit the font size to avoid overly large text
    final double fontSize = responsiveFontSize.clamp(24.0, 48.0); // Min 24, Max 48

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Top Golden Text
        Row(
          children: [
            Container(
              width: 50,
              height: 2,
              color: const Color(0xFFFBD784),
            ),
            const SizedBox(width: 8),
            const Text(
              'GET TIMELY INFORMATION AND PREPARE IN ADVANCE',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFFFBD784),
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Main Title
        Text(
          'Flood Prediction And\nEarly Warning Platform',
          style: TextStyle(
            fontSize: fontSize, // Responsive font size with constraints
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 30),

        // Scroll Down Indicator
        Row(
          children: [
            const Text(
              'scroll down',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_downward,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ],
    );
  }
}
