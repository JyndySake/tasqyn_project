import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_app/feature/news/news_mobile_page.dart';
import 'package:project_app/feature/profile/ui/profile_mobile.dart';
import 'package:project_app/feature/map/ui/map_mobile.dart';
import 'package:project_app/feature/auth/ui/login_page_mobile.dart';

void main() {
  runApp(const FloodPredictionApp());
}

class FloodPredictionApp extends StatelessWidget {
  const FloodPredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const StatisticsPage(),
    );
  }
}

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
       
        extendBodyBehindAppBar: true,
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with Background Image and Gradient
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.4,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/images/1.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          top: MediaQuery.of(context).size.height * 0.3,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Color(0xFF0B1D26),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.15,
                          left: 20,
                          right: 20,
                          child: const HeaderSection(),
                        ),
                      ],
                    ),

                    // Predictions and Statistics Section
                    const SectionContainer(
                      title: "Overview of Data by Region and Risk Level",
                      subtitle: "Predictions And Statistics",
                      child: PredictionsAndStatisticsSection(),
                    ),

                    SectionContainer(
                      title: "",
                      subtitle: "Flood Risk Progression Over Time",
                      child: TabSelectorWithChart(
                        tabs: ["12 months", "30 days", "7 days", "24 hours"],
                        chart: const LineChartWidget(),
                      ),
                    ),

                    SectionContainer(
                      title: "",
                      subtitle: "Water Level Volatility in Major Rivers",
                      child: TabSelectorWithChart(
                        tabs: ["12 months", "30 days", "7 days", "24 hours"],
                        chart: const WaterLevelVolatilityChart(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

void _showMenu(BuildContext context) {
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
              leading: const Icon(Icons.article, color: Colors.white),
              title: const Text(
                'News',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsPageApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.white),
              title: const Text(
                'Statistics',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FloodPredictionApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.white),
              title: const Text(
                'Map',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapPageApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_circle, color: Colors.white),
              title: const Text(
                'Account',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePageApp()),
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
                  MaterialPageRoute(
                      builder: (context) => const LoginPageMobile()),
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


class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Overview of Data by Region and Risk Level',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFFFBD784),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Predictions And Statistics',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class SectionContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const SectionContainer({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1D26), // Background color
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class PredictionsAndStatisticsSection extends StatelessWidget {
  const PredictionsAndStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Flood Risk Trends by Time Frame and Category",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        CustomPaint(
          size: const Size(300, 150),
          painter: SemiCircleChartPainter(),
        ),
        const SizedBox(height: 16),
        Column(
          children: const [
            LegendItem(label: "Snow melting", color: Color(0xFF9C7FF5), percentage: "46%"),
            SizedBox(height: 8),
            LegendItem(label: "Temperature", color: Color(0xFFCA9AF8), percentage: "24%"),
            SizedBox(height: 8),
            LegendItem(label: "Rainfall intensity", color: Color(0xFF6DCFF6), percentage: "15%"),
          ],
        ),
      ],
    );
  }
}

class SemiCircleChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 12.0;
    final Paint baseCircle = Paint()
      ..color = const Color(0xFFF1F1F1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    final Paint audienceArc = Paint()
      ..color = const Color(0xFF9C7FF5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final Paint earningsArc = Paint()
      ..color = const Color(0xFFCA9AF8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final Paint salesArc = Paint()
      ..color = const Color(0xFF6DCFF6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height),
        radius: size.height,
      ),
      3.14,
      3.14,
      false,
      baseCircle,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height),
        radius: size.height,
      ),
      3.14,
      1.5,
      false,
      audienceArc,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height),
        radius: size.height,
      ),
      4.64,
      0.9,
      false,
      earningsArc,
    );
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height),
        radius: size.height,
      ),
      5.74,
      0.5,
      false,
      salesArc,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final String percentage;

  const LegendItem({
    super.key,
    required this.label,
    required this.color,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16),
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
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


class TabSelector extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const TabSelector({
    Key? key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // Adjust height for better visibility
      decoration: BoxDecoration(
        color: const Color(0xFF0B1D26),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey, width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final text = entry.value;

          final bool isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class TabSelectorWithChart extends StatefulWidget {
  final List<String> tabs;
  final Widget chart;

  const TabSelectorWithChart({
    Key? key,
    required this.tabs,
    required this.chart,
  }) : super(key: key);

  @override
  _TabSelectorWithChartState createState() => _TabSelectorWithChartState();
}

class _TabSelectorWithChartState extends State<TabSelectorWithChart> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TabSelector(
          tabs: widget.tabs,
          selectedIndex: _selectedIndex,
          onTabChanged: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
        const SizedBox(height: 30),
        widget.chart,
      ],
    );
  }
}