import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_app/feature/main/widgets/custom_header.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForecastMapPage extends StatefulWidget {
  const ForecastMapPage({super.key});

  @override
  State<ForecastMapPage> createState() => _ForecastMapPageState();
}

class _ForecastMapPageState extends State<ForecastMapPage> {
  DateTime selectedDate = DateTime.now();

  void onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "INTERACTIVE MAP OF RISK ZONES",
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFBD784),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Forecast Map",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    height: 1,
                    color: Colors.white30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Select a date for the forecast",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      DatePickerWidget(
                        onDateSelected: onDateSelected,
                        selectedDate: selectedDate,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Regions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30),
                        RegionItem(regionName: "North-Kazakhstan region"),
                        SizedBox(height: 30),
                        RegionItem(regionName: "Kostanay region"),
                        SizedBox(height: 30),
                        RegionItem(regionName: "Akmolo region"),
                        SizedBox(height: 30),
                        RegionItem(regionName: "West-Kazakhstan region"),
                        SizedBox(height: 30),
                        RegionItem(regionName: "Atyrau region"),
                      ],
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    flex: 3,
                    child: SvgPicture.asset(
                      'assets/maps/kazakhstan_map.svg',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 400,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        _buildIndicator(Colors.green, "Safe 0-20%"),
                        _buildIndicator(Colors.yellow, "Caution 20-40%"),
                        _buildIndicator(Colors.orange, "Warning 40-60%"),
                        _buildIndicator(Colors.red, "Danger 60-80%"),
                        _buildIndicator(Colors.black, "Critical 80-100%"),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: GoogleMapWidget(
                        selectedDate: selectedDate,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  final Function(DateTime) onDateSelected;
  final DateTime selectedDate;

  const DatePickerWidget({
    super.key,
    required this.onDateSelected,
    required this.selectedDate,
  });

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat("dd.MM.yyyy").format(widget.selectedDate);

    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Text(
              formattedDate,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: widget.selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.blueAccent,
            hintColor: Colors.blueAccent,
            colorScheme: ColorScheme.dark(primary: Colors.blueAccent),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != widget.selectedDate) {
      widget.onDateSelected(pickedDate);
    }
  }
}

class RegionItem extends StatelessWidget {
  final String regionName;

  const RegionItem({super.key, required this.regionName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.white70),
        const SizedBox(width: 8),
        Text(
          regionName,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ],
    );
  }
}

class GoogleMapWidget extends StatefulWidget {
    final DateTime selectedDate;

  const GoogleMapWidget({
    super.key,
    required this.selectedDate,
  });

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? mapController;
  final LatLng _initialPosition = const LatLng(48.0196, 66.9237);
  Set<Circle> _circles = {};
  Set<Marker> _markers = {};
  late DateTime selectedDate;


  final Map<String, LatLng> cities = {
    'Astana': LatLng(51.1605, 71.4704),
    'Almaty': LatLng(43.2220, 76.8512),
    'Atyrau': LatLng(47.1167, 51.8833),
    'Aktau': LatLng(43.6410, 51.1658),
    'Aktobe': LatLng(50.2797, 57.2072),
    'Karaganda': LatLng(49.8046, 73.1049),
    'Kokshetau': LatLng(53.2833, 69.3833),
    'Kostanay': LatLng(53.2198, 63.6354),
    'Kyzylorda': LatLng(44.8527, 65.5097),
    'Pavlodar': LatLng(52.2873, 76.9674),
    'Semipalatinsk': LatLng(50.4111, 80.2275),
    'Shymkent': LatLng(42.3167, 69.5967),
    'Taldykorgan': LatLng(45.0167, 78.3667),
    'Taraz': LatLng(42.9000, 71.3667),
    'Ural': LatLng(51.2067, 51.3667),
    'Uskemen': LatLng(49.9714, 82.6059),
    'Zhezkazgan': LatLng(47.7833, 67.7667),
  };

   @override
  void initState() {
    super.initState();
    print('Map widget initialized');
    selectedDate = widget.selectedDate;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMarkers();
    });
  }

  @override
  void didUpdateWidget(GoogleMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate) {
      print('Date changed, fetching new weather data');
      selectedDate = widget.selectedDate;
      _updateMarkers();
    }
  }
   Future<void> _updateMarkers() async {
    Set<Marker> newMarkers = {};
    Set<Circle> newCircles = {};
    
    try {
      print('Fetching weather data for date: $selectedDate');
      setState(() {
        _circles.clear();
        _markers.clear();
      });

      String selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
      print('Selected date for API request: $selectedDateStr');

      for (var entry in cities.entries) {
        try {
          final uri = Uri.http('localhost:8000', '/api/weather-data/by-city/', {
            'city': entry.key.toLowerCase(),
            'date': selectedDateStr,
          });
          print('Fetching from: $uri');

          final response = await http.get(uri);
          if (response.statusCode == 200) {
            final List<dynamic> dataList = json.decode(response.body);
            if (dataList.isNotEmpty) {
              var matchingData = dataList.firstWhere(
                (item) => DateTime.parse(item['date']).toString().startsWith(selectedDateStr),
                orElse: () => dataList[0]
              );

              var floodRisk = 0.0;
              var rawFloodRisk = matchingData['flood_risk'];
              
              if (rawFloodRisk is int) {
                floodRisk = rawFloodRisk.toDouble();
              } else if (rawFloodRisk is double) {
                floodRisk = rawFloodRisk;
              } else if (rawFloodRisk is String) {
                floodRisk = double.tryParse(rawFloodRisk) ?? 0.0;
              }
              
              print('${entry.key} flood risk: $floodRisk');

              Color circleColor;
              if (floodRisk <= 20) {
                circleColor = Colors.green.shade300;
              } else if (floodRisk <= 40) {
                circleColor = Colors.yellow.shade600;
              } else if (floodRisk <= 60) {
                circleColor = Colors.orange.shade600;
              } else if (floodRisk <= 80) {
                circleColor = Colors.red.shade600;
              } else {
                circleColor = Colors.purple.shade600;
              }

              double baseRadius = 40000.0;
              double minRiskFactor = 1.0;
              double maxRiskFactor = 2.5;
              double riskFactor = minRiskFactor + ((maxRiskFactor - minRiskFactor) * (floodRisk / 100.0));
              double radius = baseRadius * riskFactor;

              newCircles.add(Circle(
                circleId: CircleId(entry.key),
                center: entry.value,
                radius: radius,
                fillColor: circleColor.withOpacity(0.4),
                strokeColor: circleColor.withOpacity(0.8),
                strokeWidth: 3,
              ));

              newCircles.add(Circle(
                circleId: CircleId('${entry.key}_outer'),
                center: entry.value,
                radius: 65000.0,
                fillColor: circleColor.withOpacity(0.1),
                strokeColor: circleColor.withOpacity(0.2),
                strokeWidth: 1,
              ));

              newMarkers.add(Marker(
                markerId: MarkerId(entry.key),
                position: entry.value,
                infoWindow: InfoWindow(
                  title: '${entry.key} - Flood Risk: ${floodRisk.toStringAsFixed(1)}%',
                  snippet: 'Updated: ${DateFormat('MMM d, y').format(selectedDate)}',
                ),
              ));
            }
          }
        } catch (e) {
          print('Error fetching data for ${entry.key}: $e');
        }
      }

      setState(() {
        _markers = newMarkers;
        _circles = newCircles;
      });

      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(const LatLng(48.0196, 66.9237), 5.0),
        );
      }
    } catch (e) {
      print('_updateMarkers error: $e');
    }
  }


  void _onMapCreated(GoogleMapController controller) {
    print('Map controller created');
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Building map widget, circles count: ${_circles.length}');
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 4.5,
            ),
            circles: _circles,
            markers: _markers, // Added this line
            myLocationButtonEnabled: false,
            zoomControlsEnabled: true,
            mapType: MapType.normal,
          ),
          // Debug overlay
          if (_circles.isEmpty)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.all(8),
                color: Colors.black54,
                child: const Text(
                  'No circles visible',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
