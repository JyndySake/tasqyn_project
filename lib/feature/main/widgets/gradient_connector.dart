import 'package:flutter/material.dart';

class GradientConnector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      top: 800, // Start gradient at the bottom of the image
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent, // Transparent to blend with the image
              Color(0xFF0B1D26), // Solid teal for sections background
            ],
          ),
        ),
      ),
    );
  }
}
