import 'package:flutter/material.dart';

class PaginationWidget extends StatefulWidget {
  final int totalPages;
  final Function(int) onPageSelected;

  const PaginationWidget({
    super.key,
    this.totalPages = 10,
    required this.onPageSelected,
  });

  @override
  _PaginationWidgetState createState() => _PaginationWidgetState();
}

class _PaginationWidgetState extends State<PaginationWidget> {
  int currentPage = 1;

  void _changePage(int page) {
    setState(() {
      currentPage = page;
    });
    widget.onPageSelected(page);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 8, // Space between buttons
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          // First and Previous Buttons
          _buildButton("«", isEnabled: currentPage > 1, onPressed: () => _changePage(1)),
          _buildButton("‹", isEnabled: currentPage > 1, onPressed: () => _changePage(currentPage - 1)),

          // Left Ellipsis
          if (currentPage > 3) _buildStaticButton("..."),

          // Page Buttons
          for (int i = currentPage - 2; i <= currentPage + 1; i++)
            if (i >= 1 && i <= widget.totalPages - 1)
              _buildButton(
                "$i",
                isEnabled: i != currentPage,
                isSelected: i == currentPage,
                onPressed: () => _changePage(i),
              ),

          // Right Ellipsis and Last Page
          if (currentPage < widget.totalPages - 3) _buildStaticButton("..."),
          _buildButton(
            "${widget.totalPages}",
            isEnabled: currentPage != widget.totalPages,
            isSelected: currentPage == widget.totalPages,
            onPressed: () => _changePage(widget.totalPages),
          ),

          // Next and Last Buttons
          _buildButton("›", isEnabled: currentPage < widget.totalPages, onPressed: () => _changePage(currentPage + 1)),
          _buildButton("»", isEnabled: currentPage < widget.totalPages, onPressed: () => _changePage(widget.totalPages)),
        ],
      ),
    );
  }

  // Builds a dynamic button
  Widget _buildButton(
    String label, {
    required bool isEnabled,
    bool isSelected = false,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: isEnabled ? onPressed : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: isSelected ? Colors.black : Colors.black54,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: isSelected ? Colors.black : Colors.black54,
        ),
      ),
    );
  }

  // Builds a static, non-clickable ellipsis button
  Widget _buildStaticButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
    );
  }
}
