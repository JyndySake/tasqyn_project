import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft, // Align widget to the left
      child: Container(
        width: MediaQuery.of(context).size.width * 0.1703125, // 17.03% of screen width
        margin: const EdgeInsets.only(left: 8), // Move to the left with 8px margin
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.black, width: 1), // 1px border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Text Field
            Container(
              width: MediaQuery.of(context).size.width *
                  0.1703125 *
                  0.44648318042, // TextField width: 44.64% of widget width
              child: TextField(
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: "Search by keyword..",
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 15),
                  border: InputBorder.none,
                ),
              ),
            ),
            // Add space between text and icon
            const SizedBox(width: 80), // 8px gap between text and icon
            // Search Icon
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: IconButton(
                onPressed: () {
                  // Add search logic
                },
                icon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
