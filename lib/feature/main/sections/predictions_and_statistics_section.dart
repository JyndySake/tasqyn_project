import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PredictionsAndStatisticsSection extends StatelessWidget {
  const PredictionsAndStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Predictions and Statistics",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Flood Risk Trends by Time Frame and Category",
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 2.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const factors = [
                          'Rainfall Intensity',
                          'River Water Levels',
                          'Soil Moisture Content',
                          'Snowmelt and Ice Thaw',
                          'Infrastructure Stress',
                        ];
                        if (value.toInt() >= 0 && value.toInt() < factors.length) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              factors[value.toInt()],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 140,
                      interval: 1,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec',
                        ];
                        if (value.toInt() >= 0 && value.toInt() < months.length) {
                          return Text(
                            months[value.toInt()],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(show: true),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(),
                maxY: 5.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
 

    return List.generate(
      12,
      (monthIndex) => BarChartGroupData(
        x: monthIndex,
        barRods: [
          BarChartRodData(
            fromY: 0,
            toY: 0.4,
            color: const Color(0xFFFBD784).withOpacity(1.0),
            width: 16,
            rodStackItems: [
              BarChartRodStackItem(0, 16, const Color(0xFFFBD784).withOpacity(1.0)),
              BarChartRodStackItem(16, 24, const Color(0xFFFBD784).withOpacity(0.6)),
              BarChartRodStackItem(24, 32, const Color(0xFFFBD784).withOpacity(0.4)),
              BarChartRodStackItem(32, 40, const Color(0xFFFBD784).withOpacity(0.2)),
            ],
          ),
        ],
      ),
    );
  }
}
