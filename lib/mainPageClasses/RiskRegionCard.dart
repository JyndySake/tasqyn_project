import 'package:flutter/material.dart';

class RiskRegionCard extends StatelessWidget {
  final String regionName;
  final String riskLevel; // This can be used to change color or icon based on risk

  RiskRegionCard({required this.regionName, required this.riskLevel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Icon or Image representing flood risk
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: _getRiskColor(riskLevel), // Dynamic color based on risk level
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                riskLevel[0], // Displays the first letter of risk level (e.g., "H" for High)
                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 8),
          // Region Name
          Text(
            regionName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  // Function to get risk color based on risk level
  Color _getRiskColor(String riskLevel) {
    switch (riskLevel.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
