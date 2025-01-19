import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:project_app/feature/map/ui/map_page.dart';
import 'package:project_app/feature/profile/ui/profile_page.dart';
import 'package:project_app/feature/auth/ui/login_page.dart';
import 'package:project_app/feature/main/ui/main_page.dart';
import 'package:project_app/feature/news/news_page.dart';



void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PredictionsPage(),
  ));
}

class PredictionsPage extends StatelessWidget {
  const PredictionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              color: const Color(0xFF0B1D26),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      _NavigationButton(
                        title: "Home",
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const FloodPredictionApp()),
                            (route) => false,
                          );
                        },
                      ),
                      _NavigationButton(
                        title: "News",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NewsPage()),
                          );
                        },
                      ),
                      _NavigationButton(
                        title: "Statistics",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PredictionsPage()),
                          );
                        },
                      ),
                      _NavigationButton(
                        title: "Map",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const ForecastMapPage()),
                          );
                        },
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => _showAccountMenu(context),
                    child: Row(
                      children: const [
                        Icon(Icons.account_circle_outlined, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Account",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Title
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Predictions And Statistics",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Flood Risk Trends Chart
            const SectionTitle("Flood Risk Trends by Time Frame and Category"),
            const PredictionsAndStatisticsSection(),
            // Water Level Volatility Chart
            const SectionTitle("Water Level Volatility in Major Rivers"),
            const WaterLevelVolatilityChart(),
            // Flood Risk Progression Over Time
            const SectionTitle("Flood Risk Progression Over Time"),
            const LineChartWidget(),
            const SizedBox(height: 16),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  void _showAccountMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B1D26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) =>  LoginPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _NavigationButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class PredictionsAndStatisticsSection extends StatelessWidget {
  const PredictionsAndStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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

class WaterLevelVolatilityChart extends StatelessWidget {
  const WaterLevelVolatilityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.5, // Adjust the ratio for a clean layout
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) => const FlLine(
              color: Colors.white12,
              strokeWidth: 1,
            ),
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 10 == 0) {
                    return Text(
                      '${value ~/ 1000}k',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
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
                    'Dec'
                  ];
                  if (value >= 0 && value < months.length) {
                    return Text(
                      months[value.toInt()],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: 60000,
          lineBarsData: [
            LineChartBarData(
              spots: _generateLineData(),
              isCurved: false, // Keep lines straight for volatility
              color: Colors.lightBlueAccent,
              barWidth: 2,
              dotData: FlDotData(show: false), // Hide dots for clarity
              belowBarData: BarAreaData(show: false), // No shaded area
            ),
          ],
        ),
      ),
    );
  }

  /// Generates the line data (sample values for each month).
  List<FlSpot> _generateLineData() {
    return [
      const FlSpot(0, 15000),
      const FlSpot(1, 18000),
      const FlSpot(2, 12000),
      const FlSpot(3, 30000),
      const FlSpot(4, 50000),
      const FlSpot(5, 40000),
      const FlSpot(6, 38000),
      const FlSpot(7, 10000),
      const FlSpot(8, 30000),
      const FlSpot(9, 35000),
      const FlSpot(10, 32000),
      const FlSpot(11, 45000),
    ];
  }
}


class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2.5, // Adjust aspect ratio to match the design
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            getDrawingHorizontalLine: (value) => const FlLine(
              color: Colors.white12,
              strokeWidth: 1,
            ),
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 10 == 0) {
                    return Text(
                      '${value ~/ 1000}k',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                getTitlesWidget: (value, meta) {
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
                    'Dec'
                  ];
                  if (value >= 0 && value < months.length) {
                    return Text(
                      months[value.toInt()],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: 60000,
          lineBarsData: [
            LineChartBarData(
              spots: _generateLine1Data(),
              isCurved: true,
              color: Colors.yellowAccent,
              barWidth: 3,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
            LineChartBarData(
              spots: _generateLine2Data(),
              isCurved: true,
              color: Colors.cyanAccent,
              barWidth: 3,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  /// Sample data for the first line
  List<FlSpot> _generateLine1Data() {
    return [
      const FlSpot(0, 5000),
      const FlSpot(1, 55000),
      const FlSpot(2, 20000),
      const FlSpot(3, 30000),
      const FlSpot(4, 15000),
      const FlSpot(5, 60000),
      const FlSpot(6, 40000),
      const FlSpot(7, 35000),
      const FlSpot(8, 20000),
      const FlSpot(9, 25000),
      const FlSpot(10, 10000),
      const FlSpot(11, 0),
    ];
  }

  /// Sample data for the second line
  List<FlSpot> _generateLine2Data() {
    return [
      const FlSpot(0, 10000),
      const FlSpot(1, 20000),
      const FlSpot(2, 15000),
      const FlSpot(3, 40000),
      const FlSpot(4, 30000),
      const FlSpot(5, 50000),
      const FlSpot(6, 30000),
      const FlSpot(7, 45000),
      const FlSpot(8, 35000),
      const FlSpot(9, 40000),
      const FlSpot(10, 20000),
      const FlSpot(11, 0),
    ];
  }
}

class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.black54,
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Flood prediction and Early warning platform",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Important information for preparedness",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
