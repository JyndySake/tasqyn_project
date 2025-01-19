import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60, // Adjust height as needed
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        // Transparent background over an image
        color: Colors.transparent, // No solid color, image will be shown
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Home Icon (Left-aligned)
          InkWell(
            onTap: () {
              // Add functionality for Home button
            },
            child: const Icon(
              Icons.home_outlined, // Home icon
              color: Colors.white, // White color
              size: 28,
            ),
          ),
          // Menu Icon (Right-aligned)
          InkWell(
            onTap: () {
              // Add functionality for Menu button
            },
            child: const Icon(
              Icons.menu, // Hamburger menu icon
              color: Colors.white, // White color
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
