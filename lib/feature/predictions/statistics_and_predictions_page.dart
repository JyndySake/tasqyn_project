import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb, kDebugMode;
import 'package:project_app/feature/main/widgets/custom_header.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'dart:io' show Platform;
import 'dart:async';
import 'dart:ui';



// Simple configuration for API URLs
class ApiConfig {
  // Default API URL for backend
  static String defaultApiUrl = 'http://127.0.0.1:8000/api/weather-data/';
  
  // Get appropriate URL based on platform
  static String getApiUrl() {
    // Ensure URL ends with trailing slash
    if (!defaultApiUrl.endsWith('/')) {
      return defaultApiUrl + '/';
    }
    return defaultApiUrl;
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PredictionsPage(),
  ));
}

class PredictionsPage extends StatefulWidget {
  const PredictionsPage({super.key});

  @override
  _PredictionsPageState createState() => _PredictionsPageState();
}

class _PredictionsPageState extends State<PredictionsPage> {
  // Separate states for filtering
  

  // API function to fetch real weather data
  Future<List<Map<String, dynamic>>> fetchWeatherData({String period = '12months'}) async {
    try {
      String apiUrl = ApiConfig.getApiUrl();
      // Add a random cache-busting parameter to force fresh data
      final uri = Uri.parse(apiUrl).replace(
        queryParameters: {
          'period': period,
          'nocache': DateTime.now().millisecondsSinceEpoch.toString()
        }
      );
      print('Attempting to fetch data from: $uri');
      
      final response = await http.get(uri)
        .timeout(const Duration(seconds: 10)); // Increased timeout
      
      if (response.statusCode == 200) {
        print('API responded with status code: ${response.statusCode}');
        final List<dynamic> data = json.decode(response.body);
        
        if (data.isNotEmpty) {
          print('Successfully parsed ${data.length} items from API');
          // Convert API data to the expected format
          final formattedData = List<Map<String, dynamic>>.from(data);
          
          // Print a sample of the data for debugging
          if (formattedData.isNotEmpty) {
            print('Sample API data item: ${formattedData[0]}');
          }
          
          return formattedData;
        } else {
          print('API returned empty data array');
          return _generateFallbackData(period);
        }
      } else {
        print('API responded with error status code: ${response.statusCode}');
        return _generateFallbackData(period);
      }
    } catch (e) {
      print('Error fetching data: $e');
      return _generateFallbackData(period);
    }
  }

  // Fallback method to generate mock data if API call fails
  List<Map<String, dynamic>> _generateFallbackData(String period) {
    print('Generating fallback data for period: $period');
    final List<Map<String, dynamic>> data = [];
    
    // Using current date as the reference point
    final now = DateTime.now();
    final monthFormat = DateFormat('MMM');
    final dayFormat = DateFormat('MMM d');

    if (period == '12months') {
      // Generate one data point per month for the last 12 months
      for (int i = 11; i >= 0; i--) {
        final date = DateTime(now.year - (now.month <= i ? 1 : 0), 
                            now.month <= i ? 12 - (i - now.month) : now.month - i, 1);
        
        // Generate a risk value between 0 and 100
        double monthRisk = 30.0 + 40.0 * sin((date.month - 1) * 30 * pi / 180);
        
        data.add({
          'date': monthFormat.format(date),
          'flood_risk_month': monthRisk,
        });
      }
    } else if (period == '30days') {
      // Generate data for the next 30 days from today
      for (int i = 0; i < 30; i++) {
        final date = now.add(Duration(days: i));
        final baseRisk = 40.0 + 20.0 * sin((date.day) * 12 * pi / 180);
       
        data.add({
          'date': dayFormat.format(date),
          'flood_risk': baseRisk,
        });
      }
    } else if (period == '7days') {
      // Generate data for the next 7 days from today
      for (int i = 0; i < 7; i++) {
        final date = now.add(Duration(days: i));
        final baseRisk = 45.0 + 25.0 * sin((date.day) * 51.43 * pi / 180);
        
        data.add({
          'date': dayFormat.format(date),
          'flood_risk': baseRisk,
        });
      }
    }
    
    print("Generated fallback data for $period: ${data.map((item) => 
      period == "12months" ? 
        "${item['date']}: ${item['flood_risk_month']}" : 
        "${item['date']}: ${item['flood_risk']}").toList()}");
    
    return data;
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHeader(),

            const SectionTitle("Predictions And Statistics"),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Container(
                height: 0.6,
                width: double.infinity,
                color: Colors.white,
              ),
            ),

            // Predictions Section
            _buildHeader(
              "Flood Risk Trends by Time Frame and Category",
              () => _buildTimeFrameSelector(selectedTimeFramePredictions, _setTimeFramePredictions),
              _buildFactorSelector(),
            ),
            PredictionsAndStatisticsSection(
              timeFrame: selectedTimeFramePredictions,
              timeLabels: generateDates(selectedTimeFramePredictions),
              selectedFactor: selectedFactor,
              fetchData: fetchWeatherData,

            ),

            const SizedBox(height: 30),

            // Weather Data Table Section
            _buildHeader(
              "Weather Data Analysis",
              null,
              null,
            ),
            WeatherDataTableSection(
              fetchData: fetchWeatherData,
            ),

            const SizedBox(height: 40),
            const FooterSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title, Widget Function()? timeFrameSelector, Widget? factorSelector) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              factorSelector ?? Container(), // Factor selector appears only for Predictions
              timeFrameSelector != null ? timeFrameSelector() : Container(),
            ],
          ),
        ],
      ),
    );
  }

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
              _setFactor(newFactor);
            }
          },
        ),
      ],
    );
  }
void _setTimeFramePredictions(String timeFrame) {
  setState(() {
    selectedTimeFramePredictions = timeFrame;
    fetchWeatherData(
      period: timeFrame == "30 days" ? "30days" : "7days"
    ).then((data) {
      if (mounted) {
        setState(() {
          weatherData = data;
        });
      }
    });
  });
}

 
  void _setFactor(String factor) {
    setState(() {
      selectedFactor = factor;
    });
  }

  @override
  void initState() {
    super.initState();
    // Fetch data immediately instead of using Future.delayed
    fetchWeatherData(
      period: selectedTimeFramePredictions == "30 days" ? "30days" : "7days"
    ).then((data) {
      if (mounted) {
        setState(() {
          print('Setting weather data: $data'); // Debug print
          weatherData = data;
        });
      }
    }).catchError((error) {
      print('Error fetching weather data: $error'); // Debug print
    });
  }

  Widget _buildTimeFrameSelector(String selectedTimeFrame, Function(String) setTimeFrame) {
    return Wrap(
      spacing: 8,
      children: timeFrames.map((timeFrame) {
        return ChoiceChip(
          label: Text(
            timeFrame,
            style: TextStyle(
              color: selectedTimeFrame == timeFrame ? Colors.black : Colors.white,
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
              setTimeFrame(timeFrame);
            }
          },
        );
      }).toList(),
    );
  }
}
String selectedTimeFramePredictions = "30 days";
  String selectedFactor = "Humidity"; // Default selected factor
  List<Map<String, dynamic>>? weatherData; // Added weatherData declaration

  final List<String> timeFrames = ["30 days", "7 days"];
  final List<String> factors = [
    'Humidity',
    'Pressure',
    'Soil Moisture',
    'Cloud cover',
  ];

  /// Generate time labels dynamically based on selected time frame
  List<String> generateDates(String selectedTimeFrame) {
    DateTime now = DateTime.now();
    List<String> dates = [];
    int range = selectedTimeFrame == "7 days" ? 7 : 30;

    for (int i = 0; i < range; i++) {
      dates.add(DateFormat('MMM d').format(now.add(Duration(days: i))));
    }
    return dates;
  }

class PredictionsAndStatisticsSection extends StatefulWidget {
  final String timeFrame;
  final List<String> timeLabels;
  final String selectedFactor;
  final Future<List<Map<String, dynamic>>> Function({String period}) fetchData;

  const PredictionsAndStatisticsSection({
    super.key,
    required this.timeFrame,
    required this.timeLabels,
    required this.selectedFactor,
    required this.fetchData,
  });

  @override
  State<PredictionsAndStatisticsSection> createState() => _PredictionsAndStatisticsSectionState();
}

class _PredictionsAndStatisticsSectionState extends State<PredictionsAndStatisticsSection> {
  List<Map<String, dynamic>> weatherData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  void didUpdateWidget(PredictionsAndStatisticsSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.timeFrame != widget.timeFrame) {
      fetchWeatherData();
    }
  }

  Future<void> fetchWeatherData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final Uri uri = Uri.parse('http://127.0.0.1:8000/api/weather-data/');
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          weatherData = List<Map<String, dynamic>>.from(jsonData);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      print('Error fetching weather data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> getFilteredData() {
    final DateTime now = DateTime.now();
    final DateTime endDate = now.add(Duration(days: widget.timeFrame == "30 days" ? 30 : 7));
    
    return weatherData.where((data) {
      final DateTime date = DateTime.parse(data['date']);
      return date.isAfter(now.subtract(const Duration(days: 1))) && date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Map<String, dynamic>> filteredData = getFilteredData();
    final List<String> xAxisLabels = filteredData.map((data) => DateFormat('MMM d').format(DateTime.parse(data['date']))).toList();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.2),
            Colors.purple.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFBD784).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFBD784).withOpacity(0.2),
                      blurRadius: 5,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  widget.selectedFactor,
                  style: const TextStyle(
                    color: Color(0xFFFBD784),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                _getUnit(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 2.5,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipRoundedRadius: 8,
                    tooltipMargin: 8,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${_getDataValue(filteredData[groupIndex], groupIndex).toStringAsFixed(1)}${_getUnit()}',
                        const TextStyle(
                          color: Color(0xFF0B1D26),
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                      interval: _getYAxisInterval(),
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        int index = value.toInt();
                        if (index >= 0 && index < xAxisLabels.length) {
                          return Transform.rotate(
                            angle: -0.5,
                            child: SizedBox(
                              width: 60,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  xAxisLabels[index],
                                  style: TextStyle(
                                    color: index == 0 ? const Color(0xFFFBD784) : Colors.white.withOpacity(0.8),
                                    fontSize: 11,
                                    fontWeight: index == 0 ? FontWeight.bold : FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                      reservedSize: 50,
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: _getYAxisInterval(),
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(0.2),
                      strokeWidth: 1,
                      dashArray: [5, 5],
                    );
                  },
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(show: false),
                barGroups: _buildBarGroups(filteredData),
                maxY: _getMaxY(),
                minY: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getDataValue(Map<String, dynamic> dayData, int index) {
    if (dayData.isEmpty) return 0.0;
    
    switch (widget.selectedFactor.toLowerCase()) {
      case 'humidity':
        return (dayData['humidity_avg'] ?? 0.0);
      case 'pressure':
        return (dayData['pressure_station'] ?? 0.0);
      case 'soil moisture':
        return (dayData['soil_temp_avg'] ?? 0.0);
      case 'cloud cover':
        return (dayData['cloud_total'] ?? 0.0);
      default:
        return 0.0;
    }
  }

  List<BarChartGroupData> _buildBarGroups(List<Map<String, dynamic>> displayData) {
    return List.generate(
      displayData.length,
      (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: _getDataValue(displayData[index], index),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFBD784),
                Color(0xFFFF9F43),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 16,
            borderRadius: BorderRadius.circular(4),
            backDrawRodData: BackgroundBarChartRodData(
              show: true,
              toY: _getMaxY(),
              color: Colors.white.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }

  double _getMaxY() {
    switch (widget.selectedFactor.toLowerCase()) {
      case 'pressure':
        return 1100.0;
      case 'humidity':
      case 'temperature':
      case 'wind speed':
        return 100.0;
      default:
        return 100.0;
    }
  }

  double _getYAxisInterval() {
    switch (widget.selectedFactor.toLowerCase()) {
      case 'pressure':
        return 100.0;
      case 'humidity':
      case 'temperature':
      case 'wind speed':
        return 20.0;
      default:
        return 20.0;
    }
  }

  String _getUnit() {
    switch (widget.selectedFactor.toLowerCase()) {
      case 'pressure':
        return 'hPa';
      case 'humidity':
      case 'temperature':
      case 'wind speed':
        return '%';
      default:
        return '';
    }
  }
}

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(  
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
            Container(
                        width: 50,
                        height: 2,
                        color: const Color(0xFFFBD784),
                      ),
                      const SizedBox(width: 8),
          const Text(
            "OVERVIEW OF DATA BY REGION AND RISK LEVEL",
            style: TextStyle(
              color: Color(0xFFFBD784), 
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
            ]
          ),
          const SizedBox(height: 4), 

          // Main Title
          Text(
            title,  
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,  
              fontWeight: FontWeight.bold,
              fontFamily: 'Serif',  
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}





class FooterSection extends StatelessWidget {
  const FooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: const Color(0xFF0B1D26),
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

class WeatherDataTableSection extends StatefulWidget {
  final Future<List<Map<String, dynamic>>> Function({String period}) fetchData;

  const WeatherDataTableSection({
    super.key,
    required this.fetchData,
  });

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
  List<Map<String, dynamic>> _data = [];
  bool _isLoading = true;
  String _errorMessage = '';

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      String apiPeriod = _selectedTimeframe.replaceAll(' ', '').toLowerCase();
      final fetchedData = await widget.fetchData(period: apiPeriod);
      
      if (fetchedData.isNotEmpty) {
        setState(() {
          _data = _processData(fetchedData);
          _isLoading = false;
        });
      } else {
        throw Exception('No data received');
      }
    } catch (e) {
      setState(() {
        _data = _generateTestData();
        _isLoading = false;
        _errorMessage = 'Failed to load data: $e';
      });
    }
  }

  List<Map<String, dynamic>> _processData(List<Map<String, dynamic>> rawData) {
    final now = DateTime.now();
    if (_selectedTimeframe == "12 months") {
      return List.generate(12, (index) {
        final month = (now.month + index - 1) % 12 + 1;
        final year = now.year + (now.month + index > 12 ? 1 : 0);
        final date = DateTime(year, month, 1);
        final monthData = rawData.firstWhere(
          (item) => DateTime.parse(item['date']).month == month,
          orElse: () => {'flood_risk_month': 0.0}
        );
        return {
          'date': DateFormat('MMMM').format(date),
          'flood_risk_month': monthData['flood_risk_month'] ?? 0.0,
        };
      });
    } else {
  int days = _selectedTimeframe == "30 days" ? 30 : 7;
  return List.generate(days, (index) {
    // Start from today and look forward
    final date = DateTime.now().add(Duration(days: index));
    final formattedDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(date);
    
    // Find exact matching date
    final dayData = rawData.firstWhere(
      (item) => DateTime.parse(item['date']).year == date.year &&
                DateTime.parse(item['date']).month == date.month &&
                DateTime.parse(item['date']).day == date.day,
      orElse: () => {'flood_risk': 0.0}
    );
    
    return {
      'date': DateFormat('MMM d').format(date),
      'flood_risk': dayData['flood_risk'] ?? 0.0,
    };
  });
}
  }

  List<Map<String, dynamic>> _generateTestData() {
    final now = DateTime.now();
    if (_selectedTimeframe == "12 months") {
      return List.generate(12, (index) {
        final month = (now.month + index - 1) % 12 + 1;
        final date = DateTime(now.year, month, 1);
        return {
          'date': DateFormat('MMMM').format(date),
          'flood_risk_month': (15 + Random().nextInt(11)).toDouble(),
        };
      });
    } else {
      int days = _selectedTimeframe == "30 days" ? 30 : 7;
      return List.generate(days, (index) {
        final date = now.add(Duration(days: index));
        return {
          'date': DateFormat('MMM d').format(date),
          'flood_risk': (15 + Random().nextInt(11)).toDouble(),
        };
      });
    }
  }

  List<FlSpot> _getChartData() {
    return _data.asMap().entries.map((entry) {
      return FlSpot(
        entry.key.toDouble(),
        entry.value['flood_risk'] ?? entry.value['flood_risk_month'] ?? 0.0,
      );
    }).toList();
  }

  List<String> _getDateLabels() {
    return _data.map((item) => item['date'].toString()).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    Timer.periodic(const Duration(hours: 24), (timer) {
      if (mounted) _loadData();
      else timer.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: TimeRangeFilter(
              timeframes: const ["12 months", "30 days", "7 days"],
              selectedTimeframe: _selectedTimeframe,
              onTimeframeChanged: (String timeframe) {
                setState(() => _selectedTimeframe = timeframe);
                _loadData();
              },
            ),
          ),
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: Colors.white))
          else if (_errorMessage.isNotEmpty)
            _buildErrorWidget()
          else if (_data.isEmpty)
            const Center(child: Text("No data available", style: TextStyle(color: Colors.white)))
          else
            _buildChartWidget(),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("API Connection Error",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 8),
          Text(_errorMessage, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildChartWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Flood Risk Forecast",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        const Text("Statistical graph showing risk percentage over time",
          style: TextStyle(fontSize: 14, color: Colors.white70)),
        const SizedBox(height: 16),
        Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black.withOpacity(0.3), Colors.black.withOpacity(0.1)],
            ),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, spreadRadius: 1)],
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 16, top: 24, left: 8, bottom: 8),
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 20,
                  verticalInterval: 1,
                  getDrawingHorizontalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1),
                  getDrawingVerticalLine: (value) => FlLine(color: Colors.white10, strokeWidth: 1, dashArray: [5, 5]),
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < _getDateLabels().length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Transform.rotate(
                              angle: _selectedTimeframe == "12 months" ? 0 : 0.3,
                              child: Text(_getDateLabels()[value.toInt()],
                                style: TextStyle(color: Colors.white70, fontSize: 10)),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 20,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}%',
                          style: const TextStyle(color: Colors.white70, fontSize: 10));
                      },
                      reservedSize: 36,
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: true, border: Border.all(color: Colors.white24)),
                minX: 0,
                maxX: (_data.length - 1).toDouble(),
                minY: 0,
                maxY: 100,
                lineBarsData: [
                  LineChartBarData(
                    spots: _getChartData(),
                    isCurved: true,
                    color: Colors.amber,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.amber.withOpacity(0.3), Colors.amber.withOpacity(0.0)],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ElevatedButton(
            onPressed: _loadData,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.refresh, size: 18),
                SizedBox(width: 8),
                Text("Refresh Data"),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
