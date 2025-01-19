import 'package:flutter/material.dart';

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double widgetWidth = MediaQuery.of(context).size.width * 0.085125; // Total widget width
    double iconWidth = widgetWidth * 0.16; // 16% of widget width
    double widgetHeight = 50; // Explicit height to match SearchBarWidget

    return Container(
      width: widgetWidth, // Width of widget
      height: widgetHeight, // Height equal to SearchBarWidget
      padding: const EdgeInsets.symmetric(horizontal: 12), // Padding adjusted
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Consistent rounded corners
        border: Border.all(color: Colors.black, width: 1), // Border 1px
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Date Text with width set to 49.33% of the widget width
          Container(
            width: widgetWidth * 0.49333333333, // 49.33% of the widget width
            alignment: Alignment.centerLeft,
            child: const Text(
              "07.10.2024",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontWeight: FontWeight.w500,
                overflow: TextOverflow.ellipsis, // Prevent overflow
              ),
            ),
          ),
          // Calendar Icon with width set to 16% of widget width
          Container(
            width: iconWidth, // 16% of widget width
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                _selectDate(context);
              },
              icon: const Icon(
                Icons.calendar_today,
                color:Color(0xFF0B1D26), // Icon color
                size: 24,
              ),
              padding: EdgeInsets.zero, // Remove default padding
            ),
          ),
        ],
      ),
    );
  }

  // Function to show Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      print("Selected date: ${picked.toLocal()}");
    }
  }
}
