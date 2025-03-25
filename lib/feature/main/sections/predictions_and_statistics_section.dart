import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PredictionsAndStatisticsSection extends StatefulWidget {
  const PredictionsAndStatisticsSection({super.key});

  @override
  _PredictionsAndStatisticsSectionState createState() =>
      _PredictionsAndStatisticsSectionState();
}

class _PredictionsAndStatisticsSectionState
    extends State<PredictionsAndStatisticsSection> {
  String selectedTimeFrame = "12 months";
  String selectedFactor = "Infrastructure Stress"; // Default selected factor

  final List<String> timeFrames = ["12 months", "30 days", "7 days", "24 hours"];
  final List<String> factors = [
    'Infrastructure Stress',
    'Snowmelt and Ice Thaw',
    'Soil Moisture Content',
    'River Water Levels',
    'Rainfall Intensity',
  ];

  List<String> generateDates() {
    DateTime now = DateTime.now();
    List<String> dates = [];
    int range = 12;
    if (selectedTimeFrame == "30 days") {
      range = 30;
    } else if (selectedTimeFrame == "7 days") {
      range = 7;
    } else if (selectedTimeFrame == "24 hours") {
      range = 24;
    }

    for (int i = 0; i < range; i++) {
      dates.add(DateFormat(
              selectedTimeFrame == "12 months"
                  ? 'MMM'
                  : selectedTimeFrame == "24 hours"
                      ? 'HH:mm'
                      : 'MMM d')
          .format(now.add(Duration(
              days: selectedTimeFrame == "12 months"
                  ? i * 30
                  : (selectedTimeFrame == "24 hours" ? 0 : i),
              hours: selectedTimeFrame == "24 hours" ? i : 0))));
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    List<String> timeLabels = generateDates();
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildFactorSelector(), // Factor Filter UI
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
                        return value.toInt() == 0
                            ? Text(
                                selectedFactor, // Show only once
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.left,
                              )
                            : const SizedBox.shrink();
                      },
                      reservedSize: 140,
                      interval: 1,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        if (value.toInt() >= 0 && value.toInt() < timeLabels.length) {
                          return Text(
                            timeLabels[value.toInt()],
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
                barGroups: _buildBarGroups(timeLabels.length), // Show multiple bars
                maxY: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// **Title and Time Frame Selector**
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Flood Risk Trends by Time Frame and Category",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        _buildTimeFrameSelector(),
      ],
    );
  }

  /// **Factor Selector Dropdown**
  Widget _buildFactorSelector() {
    return Row(
      children: [
        const Text(
          "Select Factor:",
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: selectedFactor,
          dropdownColor: const Color(0xFF0B1D26),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          items: factors.map((String factor) {
            return DropdownMenuItem<String>(
              value: factor,
              child: Text(
                factor,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: (String? newFactor) {
            if (newFactor != null) {
              setState(() {
                selectedFactor = newFactor; // Update selected factor
              });
            }
          },
        ),
      ],
    );
  }

  /// **Time Frame Selector**
  Widget _buildTimeFrameSelector() {
    return Wrap(
      spacing: 8,
      children: timeFrames.map((timeFrame) {
        return ChoiceChip(
          label: Text(
            timeFrame,
            style: TextStyle(
              color: selectedTimeFrame == timeFrame ? Colors.black : Colors.white,
              fontWeight: selectedTimeFrame == timeFrame
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          selected: selectedTimeFrame == timeFrame,
          selectedColor: Colors.white,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(8),
          ),
          onSelected: (bool selected) {
            if (selected) {
              setState(() {
                selectedTimeFrame = timeFrame;
              });
            }
          },
        );
      }).toList(),
    );
  }

  /// **Generate Multiple Bars for Selected Factor**
  List<BarChartGroupData> _buildBarGroups(int count) {
    return List.generate(
      count,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            fromY: 0,
            toY: 1, // Creates multiple bars
            color: Colors.amberAccent,
            width: 18,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }
}
