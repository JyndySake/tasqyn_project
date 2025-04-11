import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class PredictionsAndStatisticsSection extends StatefulWidget {
  final String timeFrame;
  final List<String> timeLabels;
  final String selectedFactor;
  final Future<List<Map<String, dynamic>>> Function({required String period}) fetchData;

  const PredictionsAndStatisticsSection({
    Key? key,
    required this.timeFrame,
    required this.timeLabels,
    required this.selectedFactor,
    required this.fetchData,
  }) : super(key: key);

  @override
  State<PredictionsAndStatisticsSection> createState() => _PredictionsAndStatisticsSectionState();
}

class _PredictionsAndStatisticsSectionState extends State<PredictionsAndStatisticsSection> {
  List<Map<String, dynamic>> weatherData = [];
  bool isLoading = true;
  String selectedCity = 'Astana';

  final Map<String, String> cities = {
    'Astana': 'http://localhost:8000/api/weather-data/by-city/?city=astana',
    'Almaty': 'http://localhost:8000/api/weather-data/by-city/?city=almaty',
    'Atyrau': 'http://localhost:8000/api/weather-data/by-city/?city=atyrau',
    'Aktau': 'http://localhost:8000/api/weather-data/by-city/?city=aktau',
    'Aktobe': 'http://localhost:8000/api/weather-data/by-city/?city=aktobe',
    'Karaganda': 'http://localhost:8000/api/weather-data/by-city/?city=karaganda',
    'Kokshetau': 'http://localhost:8000/api/weather-data/by-city/?city=kokshetau',
    'Kostanay': 'http://localhost:8000/api/weather-data/by-city/?city=kostanay',
    'Kyzylorda': 'http://localhost:8000/api/weather-data/by-city/?city=kyzylorda',
    'Pavlodar': 'http://localhost:8000/api/weather-data/by-city/?city=pavlodar',
    'Semipalatinsk': 'http://localhost:8000/api/weather-data/by-city/?city=semipalatinsk',
    'Shymkent': 'http://localhost:8000/api/weather-data/by-city/?city=shymkent',
    'Taldykorgan': 'http://localhost:8000/api/weather-data/by-city/?city=taldykorgan',
    'Taraz': 'http://localhost:8000/api/weather-data/by-city/?city=taraz',
    'Ural': 'http://localhost:8000/api/weather-data/by-city/?city=ural',
    'Uskemen': 'http://localhost:8000/api/weather-data/by-city/?city=uskemen',
    'Zhezkazgan': 'http://localhost:8000/api/weather-data/by-city/?city=zhezkazgan',
  };

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
      final Uri uri = Uri.parse(cities[selectedCity]!);
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
      final DateTime date = DateTime.parse(data['timestamp'] ?? data['date']);
      return date.isAfter(now.subtract(const Duration(days: 1))) && date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final List<Map<String, dynamic>> filteredData = getFilteredData();
    final List<String> xAxisLabels = filteredData.map((data) => DateFormat('MMM d').format(DateTime.parse(data['timestamp'] ?? data['date']))).toList();

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
              DropdownButton<String>(
                value: selectedCity,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCity = newValue!;
                    fetchWeatherData();
                  });
                },
                items: cities.keys.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                style: TextStyle(color: Colors.white.withOpacity(0.8)),
                dropdownColor: Colors.blue[900],
              ),
              const SizedBox(width: 10),
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