import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:project_app/feature/news/news_mobile_page.dart';
import 'package:project_app/feature/profile/ui/profile_mobile.dart';
import 'package:project_app/feature/map/ui/map_mobile.dart';
import 'package:project_app/feature/auth/ui/login_page_mobile.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:io' show Platform;


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

  Future<List<Map<String, dynamic>>> fetchWeatherData({String period = '12months', String city = 'almaty'}) async {
     try {
      final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
      final response = await http.get(
        Uri.parse('http://$host:8000/api/weather-data/by-city/?city=$city'),
     );

      if (response.statusCode == 200) {
        final List<dynamic> rawData = json.decode(response.body);
        print('API Response for $city: ${response.body}');
        
        // Convert dynamic list to List<Map<String, dynamic>>
        return rawData.map((item) => Map<String, dynamic>.from(item)).toList();
      } else {
        print('API Error: ${response.statusCode}');
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Failed to load data');
    }
  }
  
   Future<List<Map<String, dynamic>>> generateForecastData(String period, String city) async {
  final now = DateTime.now();
   final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
  final response = await http.get(Uri.parse('http://$host:8000/api/weather-data/by-city/?city=$city'));
  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    
    // Sort the data by date
    jsonData.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
    
    switch (period) {
      case '12months':
        return List.generate(12, (index) {
          final date = DateTime(now.year, now.month + index);
          final monthData = jsonData.firstWhere(
            (item) => DateTime.parse(item['date']).month == date.month,
            orElse: () => jsonData[index % jsonData.length],
          );
          return {
            'date': DateFormat('MMMM yyyy').format(date),
            'risk': monthData['flood_risk_month'] ?? 0,
          };
        });
      case '30days':
        return List.generate(30, (index) {
          final date = now.add(Duration(days: index));
          final formattedDate = DateFormat('yyyy-MM-dd').format(date);
          final dayData = jsonData.firstWhere(
            (item) => DateFormat('yyyy-MM-dd').format(DateTime.parse(item['date'])) == formattedDate,
            orElse: () => jsonData[index % jsonData.length],
          );
          return {
            'date': formattedDate,
            'risk': dayData['flood_risk'] ?? 0,
          };
        });
      case '7days':
        return List.generate(7, (index) {
          final date = now.add(Duration(days: index));
          final formattedDate = DateFormat('yyyy-MM-dd').format(date);
          final dayData = jsonData.firstWhere(
            (item) => DateFormat('yyyy-MM-dd').format(DateTime.parse(item['date'])) == formattedDate,
            orElse: () => jsonData[index % jsonData.length],
          );
          return {
            'date': formattedDate,
            'risk': dayData['flood_risk'] ?? 0,
          };
        });
      default:
        throw ArgumentError('Invalid period: $period');
    }
  } else {
    throw Exception('Failed to load forecast data');
  }
}

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
                    const SectionContainer(
                      title: "Overview of Data by Region and Risk Level",
                      subtitle: "Predictions And Statistics",
                      child: PredictionsAndStatisticsSection(),
                    ),
                    SectionContainer(
                      title: "",
                      subtitle: "Flood Risk Progression Over Time",
                      child: TabSelectorWithChart(
                     ),
                    ),
                   
                    SectionContainer(
                      title: "",
                      subtitle: "Weather Data Analysis",
                      child: WeatherDataTableSection(
                        fetchData: fetchWeatherData,
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
        color: Color(0xFF0B1D26), 
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

class BarChartWidget extends StatefulWidget {
  final String selectedTimeframe;
  final String selectedDataType;
  final String selectedCity;

  const BarChartWidget({
    Key? key,
    required this.selectedTimeframe,
    required this.selectedDataType,
    required this.selectedCity,
  }) : super(key: key);

  @override
  _BarChartWidgetState createState() => _BarChartWidgetState();
}

class _BarChartWidgetState extends State<BarChartWidget> {
  late Future<List<BarChartGroupData>> _dataFuture;

  @override
  void initState() {
    super.initState();
    _dataFuture = _fetchData();
  }

  @override
  void didUpdateWidget(BarChartWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTimeframe != oldWidget.selectedTimeframe ||
        widget.selectedDataType != oldWidget.selectedDataType ||
        widget.selectedCity != oldWidget.selectedCity) {
      _dataFuture = _fetchData();
    }
  }

  Future<List<BarChartGroupData>> _fetchData() async {
    try {
      final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
      final url = 'http://$host:8000/api/weather-data/by-city/?city=${widget.selectedCity.toLowerCase()}';
      print('Fetching from URL: $url');
      
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        print('Decoded data length: ${jsonData.length}');
        if (jsonData.isNotEmpty) {
          print('Sample data item: ${jsonData.first}');
        }
        
        // Filter data for the next 7 or 30 days from today
        final now = DateTime.now();
        final endDate = now.add(Duration(days: widget.selectedTimeframe == "30 days" ? 30 : 7));
        final filteredData = jsonData.where((item) {
          final itemDate = DateTime.parse(item['date']);
          return itemDate.isAfter(now.subtract(Duration(days: 1))) && itemDate.isBefore(endDate);
        }).toList();
        
        filteredData.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
        
        return _processData(filteredData);
      } else {
        print('Error status code: ${response.statusCode}');
        return [];
      }
    } catch (e, stackTrace) {
      print('Error fetching data: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  List<BarChartGroupData> _processData(List<dynamic> data) {
    try {
      List<BarChartGroupData> barGroups = [];
      String dataKey = _getDataKey();
      print('Processing data with key: $dataKey');
      
      print('Processing ${data.length} data points');
      
      for (int i = 0; i < data.length; i++) {
        var item = data[i];
        print('Processing item: $item');
        
        double value = 0.0;
        if (item[dataKey] != null) {
          if (item[dataKey] is num) {
            value = item[dataKey].toDouble();
          } else {
            value = double.tryParse(item[dataKey].toString()) ?? 0.0;
          }
        }
        
        print('Value for $dataKey: $value');
        
        barGroups.add(
          BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: value,
                color: _getBarColor(i),
                width: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        );
      }
      
      print('Created ${barGroups.length} bar groups');
      return barGroups;
    } catch (e, stackTrace) {
      print('Error in _processData: $e');
      print('Stack trace: $stackTrace');
      return [];
    }
  }

  String _getDataKey() {
    switch (widget.selectedDataType) {
      case 'Humidity':
        return "humidity_avg";
      case 'Pressure':
        return "pressure_station";
      case 'Cloud Cover':
        return "cloud_total";
      case 'Soil Moisture':
        return "soil_temp_avg";
      case 'Air Temperature':
        return "air_temp_avg";
      case 'Wind Speed':
        return "wind_speed_avg";
      case 'Precipitation':
        return "precipitation";
      case 'Flood Risk':
        return "flood_risk";
      default:
        return "humidity_avg";
    }
  }

  Color _getBarColor(int index) {
    final colors = [
      const Color(0xFF6DD5FA),
      const Color(0xFF2980B9),
      const Color(0xFF1E88E5),
    ];
    return colors[index % colors.length];
  }

  List<String> _generateLabels() {
    DateTime now = DateTime.now();
    List<String> labels = [];
    int range = widget.selectedTimeframe == "30 days" ? 30 : 7;

    for (int i = 0; i < range; i++) {
      labels.add(DateFormat('MMM d').format(now.add(Duration(days: i))));
    }

    return labels;
  }

  @override
  Widget build(BuildContext context) {
    List<String> timeLabels = _generateLabels();
    return FutureBuilder<List<BarChartGroupData>>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No data available'));
        } else {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.blueGrey[900]!,
                  Colors.blueGrey[800]!,
                  Colors.blueGrey[700]!,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 2,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(),
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        return BarTooltipItem(
                          '${rod.toY.toStringAsFixed(2)}',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        );
                      },
                    )
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index < timeLabels.length) {
                            if (widget.selectedTimeframe == "30 days") {
                              if (index % 5 == 0 || index == timeLabels.length - 1) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Text(
                                    timeLabels[index],
                                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                                  ),
                                );
                              }
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  timeLabels[index],
                                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                                ),
                              );
                            }
                          }
                          return const SizedBox.shrink();
                        },
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white70, fontSize: 10),
                          );
                        },
                        reservedSize: 40,
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.white10,
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: snapshot.data,
                ),
              ),
            ),
          );
        }
      },
    );
  }

  double _getMaxY() {
    switch (widget.selectedDataType) {
      case 'Humidity':
        return 100;
      case 'Pressure':
        return 1100;
      case 'Cloud Cover':
        return 10;
      case 'Soil Moisture':
        return 50;
      case 'Air Temperature':
        return 40;
      case 'Wind Speed':
        return 20;
      case 'Precipitation':
        return 50;
      case 'Flood Risk':
        return 100;
      default:
        return 100;
    }
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
      height: 40,
      decoration: BoxDecoration(
        color: Colors.blueGrey[900],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final index = entry.key;
          final text = entry.value;
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  text,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
  const TabSelectorWithChart({Key? key}) : super(key: key);

  @override
  _TabSelectorWithChartState createState() => _TabSelectorWithChartState();
}

class _TabSelectorWithChartState extends State<TabSelectorWithChart> {
  int _selectedTimeframeIndex = 0;
  int _selectedDataTypeIndex = 0;
  int _selectedCityIndex = 0;
  final List<String> timeframes = ['7 days', '30 days'];
  final List<String> dataTypes = [
    'Humidity',
    'Pressure',
    'Cloud Cover',
    'Soil Moisture',
    'Air Temperature',
    'Wind Speed',
    'Precipitation',
    'Flood Risk'
  ];
  final List<String> cities = [
    'Astana',
    'Almaty',
    'Atyrau',
    'Aktau',
    'Aktobe',
    'Karaganda',
    'Kokshetau',
    'Kostanay',
    'Kyzylorda',
    'Pavlodar',
    'Semipalatinsk',
    'Shymkent',
    'Taldykorgan',
    'Taraz',
    'Ural',
    'Uskemen',
    'Zhezkazgan'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabSelector(
          tabs: timeframes,
          selectedIndex: _selectedTimeframeIndex,
          onTabChanged: (index) {
            setState(() {
              _selectedTimeframeIndex = index;
            });
          },
        ),
        const SizedBox(height: 16),
        TabSelector(
          tabs: dataTypes,
          selectedIndex: _selectedDataTypeIndex,
          onTabChanged: (index) {
            setState(() {
              _selectedDataTypeIndex = index;
            });
          },
        ),
        const SizedBox(height: 16),
        DropdownButton<int>(
          value: _selectedCityIndex,
          items: cities.asMap().entries.map((entry) {
            return DropdownMenuItem<int>(
              value: entry.key,
              child: Text(entry.value),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              _selectedCityIndex = newValue!;
            });
          },
          style: TextStyle(color: Colors.white),
          dropdownColor: Colors.blueGrey[900],
        ),
        const SizedBox(height: 24),
        BarChartWidget(
          selectedTimeframe: timeframes[_selectedTimeframeIndex],
          selectedDataType: dataTypes[_selectedDataTypeIndex],
          selectedCity: cities[_selectedCityIndex],
        ),
      ],
    );
  }
}



class WeatherDataTableSection extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function({String period, String city}) fetchData;

  const WeatherDataTableSection({Key? key, required this.fetchData}) : super(key: key);

  @override
  State<WeatherDataTableSection> createState() => _WeatherDataTableSectionState();
}

class TimeRangeFilter extends StatelessWidget {
  final List<String> timeframes;
  final String selectedTimeframe;
  final Function(String) onTimeframeChanged;

  const TimeRangeFilter({
    Key? key,
    required this.timeframes,
    required this.selectedTimeframe,
    required this.onTimeframeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: timeframes.map((timeframe) {
        return ChoiceChip(
          label: Text(
            timeframe,
            style: TextStyle(
              color: selectedTimeframe == timeframe ? Colors.black : Colors.white,
            ),
          ),
          selected: selectedTimeframe == timeframe,
          selectedColor: Colors.white,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(8),
          ),
          onSelected: (bool selected) {
            if (selected) {
              onTimeframeChanged(timeframe);
            }
          },
        );
      }).toList(),
    );
  }
}

class _WeatherDataTableSectionState extends State<WeatherDataTableSection> {
  String _selectedTimeframe = "12 months";
  String _selectedCity = "Astana";
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;

  late final Map<String, String> _cities;

  @override
  void initState() {
    super.initState();
    final host = Platform.isAndroid ? '10.0.2.2' : 'localhost';
    _cities = {
      'Astana': 'http://$host:8000/api/weather-data/by-city/?city=astana',
      'Almaty': 'http://$host:8000/api/weather-data/by-city/?city=almaty',
      'Atyrau': 'http://$host:8000/api/weather-data/by-city/?city=atyrau',
      'Aktau': 'http://$host:8000/api/weather-data/by-city/?city=aktau',
      'Aktobe': 'http://$host:8000/api/weather-data/by-city/?city=aktobe',
      'Karaganda': 'http://$host:8000/api/weather-data/by-city/?city=karaganda',
      'Kokshetau': 'http://$host:8000/api/weather-data/by-city/?city=kokshetau',
      'Kostanay': 'http://$host:8000/api/weather-data/by-city/?city=kostanay',
      'Kyzylorda': 'http://$host:8000/api/weather-data/by-city/?city=kyzylorda',
      'Pavlodar': 'http://$host:8000/api/weather-data/by-city/?city=pavlodar',
      'Semipalatinsk': 'http://$host:8000/api/weather-data/by-city/?city=semipalatinsk',
      'Shymkent': 'http://$host:8000/api/weather-data/by-city/?city=shymkent',
      'Taldykorgan': 'http://$host:8000/api/weather-data/by-city/?city=taldykorgan',
      'Taraz': 'http://$host:8000/api/weather-data/by-city/?city=taraz',
      'Ural': 'http://$host:8000/api/weather-data/by-city/?city=ural',
      'Uskemen': 'http://$host:8000/api/weather-data/by-city/?city=uskemen',
      'Zhezkazgan': 'http://$host:8000/api/weather-data/by-city/?city=zhezkazgan',
    };
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      print('Loading data for city: $_selectedCity, timeframe: $_selectedTimeframe');

      final fetchedData = await widget.fetchData(
        period: _selectedTimeframe.replaceAll(' ', '').toLowerCase(),
        city: _selectedCity.toLowerCase()
      );
      
      if (fetchedData.isNotEmpty) {
        setState(() {
          _data = _processData(fetchedData);
          _isLoading = false;
        });
        print('Processed ${_data.length} data points');
      } else {
        throw Exception('No data available');
      }
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
        _data = [];
      });
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<Map<String, dynamic>> _processData(List<Map<String, dynamic>> rawData) {
      print('Processing ${rawData.length} raw data points'); // Debug log
    final now = DateTime.now();

    if (_selectedTimeframe == "12 months") {
      return List.generate(12, (index) {
        final targetDate = DateTime(now.year, now.month + index, 1);
        print('Processing month: ${targetDate.year}-${targetDate.month}'); // Debug log
        
        // Try to find monthly risk data first
        var monthlyData = rawData.firstWhere(
          (item) => 
            item['flood_risk_month'] != null && 
            DateTime.parse(item['date']).month == targetDate.month,
          orElse: () => {'flood_risk_month': null},
        );
        
        // If monthly data exists, use it directly
        if (monthlyData['flood_risk_month'] != null) {
          double risk = (monthlyData['flood_risk_month'] is num)
              ? (monthlyData['flood_risk_month'] as num).toDouble()
              : double.tryParse(monthlyData['flood_risk_month'].toString()) ?? 0.0;
              
          return {
            'date': targetDate.toIso8601String(),
            'risk': risk,
          };
        }  
        double monthlyRisk = 0.0;
        
        return {
          'date': targetDate.toIso8601String(),
          'risk': monthlyRisk,
        };
      });
    }else if (_selectedTimeframe == "30 days" || _selectedTimeframe == "7 days") {
      final days = _selectedTimeframe == "30 days" ? 30 : 7;
      
      // Sort raw data by date
      rawData.sort((a, b) => DateTime.parse(a['date']).compareTo(DateTime.parse(b['date'])));
      
      return List.generate(days, (index) {
        final targetDate = now.add(Duration(days: index));
        
        // Find data point for this date
        final dayData = rawData.firstWhere(
          (item) {
            final itemDate = DateTime.parse(item['date']);
            return itemDate.year == targetDate.year && 
                   itemDate.month == targetDate.month && 
                   itemDate.day == targetDate.day;
          },
          orElse: () {
            print('No data found for date: ${targetDate.toString()}'); // Debug log
            return {'flood_risk': 0.0};
          },
        );
        
        // Extract flood risk, ensuring it's a double
        double risk = 0.0;
        if (dayData['flood_risk'] != null) {
          risk = (dayData['flood_risk'] is num) 
              ? (dayData['flood_risk'] as num).toDouble()
              : double.tryParse(dayData['flood_risk'].toString()) ?? 0.0;
        }
        
        print('Date: ${targetDate.toString()}, Risk: $risk'); // Debug log
        
        return {
          'date': targetDate.toIso8601String(),
          'risk': risk,
        };
      });
    }
    return [];
  }

  List<FlSpot> _getChartData() {
    return _data.asMap().entries.map((entry) {
      final num value = entry.value['risk'] ?? 0;
      return FlSpot(entry.key.toDouble(), value.toDouble());
    }).toList();
  }

  List<String> _getDateLabels() {
    if (_selectedTimeframe == "12 months") {
      final now = DateTime.now();
      return List.generate(12, (index) {
        final month = (now.month + index) % 12;
        return _getMonthAbbreviation(month == 0 ? 12 : month);
      });
    } else {
      return _data.map((item) {
        DateTime date = DateTime.parse(item['date']);
        return '${date.day} ${_getMonthAbbreviation(date.month)}';
      }).toList();
    }
  }

  String _getMonthAbbreviation(int month) {
    const monthAbbreviations = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return monthAbbreviations[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: TimeRangeFilter(
            timeframes: const ["12 months", "30 days", "7 days"],
            selectedTimeframe: _selectedTimeframe,
            onTimeframeChanged: (String timeframe) {
              setState(() {
                _selectedTimeframe = timeframe;
              });
              _loadData();
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: DropdownButton<String>(
            value: _selectedCity,
            onChanged: (String? newValue) {
              setState(() {
                _selectedCity = newValue!;
              });
              _loadData();
            },
            items: _cities.keys.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_data.isEmpty)
          const Center(child: Text("No data available"))
        else
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white.withOpacity(0.05),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Flood Risk Forecast",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Statistical graph showing risk percentage over time",
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 24),
                _buildWeatherGraph(),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildWeatherGraph() {
    List<String> labels = _getDateLabels();
    List<FlSpot> chartData = _getChartData();
    
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            getDrawingHorizontalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1),
            getDrawingVerticalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 20 == 0 && value <= 100) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text('${value.toInt()}%',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                        textAlign: TextAlign.right,
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
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  final int index = value.toInt();
                  final int interval = _selectedTimeframe == "12 months" ? 1 : (_selectedTimeframe == "30 days" ? 5 : 1);
                  if (index >= 0 && index < labels.length && (index % interval == 0 || index == labels.length - 1)) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(labels[index],
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                        textAlign: TextAlign.center,
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
          borderData: FlBorderData(show: true, border: Border.all(color: Colors.white.withOpacity(0.2))),
          minX: 0,
          maxX: chartData.length - 1.0,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: chartData,
              isCurved: true,
              color: Colors.yellowAccent,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                  radius: 4,
                  color: Colors.yellowAccent,
                  strokeWidth: 1,
                  strokeColor: Colors.black,
                ),
              ),
              belowBarData: BarAreaData(show: true, color: Colors.yellowAccent.withOpacity(0.2)),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.black.withOpacity(0.8),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot spot) {
                  final int index = spot.x.toInt();
                  final String date = index < labels.length ? labels[index] : '';
                  final String value = '${spot.y.toStringAsFixed(1)}%';
                  return LineTooltipItem(
                    '$date\n$value',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
