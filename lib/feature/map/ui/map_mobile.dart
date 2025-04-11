import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_app/feature/news/news_mobile_page.dart';
import 'package:project_app/feature/predictions/statistics_and_predictions_mobile.dart';
import 'package:project_app/feature/auth/ui/login_page_mobile.dart';
import 'package:project_app/feature/profile/ui/profile_mobile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

void main() {
  runApp(const MapPageApp());
}

class MapPageApp extends StatelessWidget {
  const MapPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _controller;
  final LatLng _initialPosition = const LatLng(48.0196, 66.9237);

  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  DateTime selectedDate = DateTime.now();

  final Map<String, LatLng> cityCoordinates = {
    'Astana': const LatLng(51.1658, 71.3667),
    'Almaty': const LatLng(43.2220, 76.8512),
    'Atyrau': const LatLng(47.1167, 51.8833),
    'Aktau': const LatLng(43.6510, 51.1658),
    'Aktobe': const LatLng(50.2797, 57.2072),
    'Karaganda': const LatLng(49.8046, 73.1049),
    'Kokshetau': const LatLng(53.2833, 69.3833),
    'Kostanay': const LatLng(53.2198, 63.6354),
    'Kyzylorda': const LatLng(44.8527, 65.5097),
    'Pavlodar': const LatLng(52.2873, 76.9674),
    'Semipalatinsk': const LatLng(50.4111, 80.2275),
    'Shymkent': const LatLng(42.3167, 69.5967),
    'Taldykorgan': const LatLng(45.0167, 78.3667),
    'Taraz': const LatLng(42.9000, 71.3667),
    'Ural': const LatLng(51.2067, 51.3700),
    'Uskemen': const LatLng(49.9714, 82.6059),
    'Zhezkazgan': const LatLng(47.7833, 67.7000),
  };

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: const Color(0xFF0B1D26),
            colorScheme: const ColorScheme.dark(primary: Color(0xFF0B1D26)),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
      _updateMarkers();
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      _controller?.animateCamera(
        CameraUpdate.newLatLngZoom(const LatLng(49.0, 68.0), 6.0),
      );
    });
    _updateMarkers();
  }

   Future<void> _updateMarkers() async {
    Set<Marker> newMarkers = {};
    Set<Circle> newCircles = {};
    final Map<String, String> cityApiUrls = {
      'Astana': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=astana',
      'Almaty': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=almaty',
      'Atyrau': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=atyrau',
      'Aktau': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=aktau',
      'Aktobe': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=aktobe',
      'Karaganda': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=karaganda',
      'Kokshetau': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=kokshetau',
      'Kostanay': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=kostanay',
      'Kyzylorda': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=kyzylorda',
      'Pavlodar': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=pavlodar',
      'Semipalatinsk': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=semipalatinsk',
      'Shymkent': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=shymkent',
      'Taldykorgan': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=taldykorgan',
      'Taraz': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=taraz',
      'Ural': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=ural',
      'Uskemen': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=uskemen',
      'Zhezkazgan': 'http://10.0.2.2:8000/api/weather-data/by-city/?city=zhezkazgan',
    };

    for (var entry in cityApiUrls.entries) {
      String city = entry.key;
      String url = '${entry.value}&date=${DateFormat('yyyy-MM-dd').format(selectedDate)}';
      LatLng position = cityCoordinates[city]!;
      
      try {
        var response = await http.get(Uri.parse(url));
        
        if (response.statusCode == 200) {
          var jsonResponse = json.decode(response.body);
          
          if (jsonResponse is List && jsonResponse.isNotEmpty) {
            // Format the selected date to match API date format (without time)
            String selectedDateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
            
            // Find the data point that matches the selected date
            var matchingData = jsonResponse.firstWhere(
              (item) => DateTime.parse(item['date']).toString().startsWith(selectedDateStr),
              orElse: () => jsonResponse[0]
            );
            
            // Debug print to see the raw data and date comparison
            print('Selected date: $selectedDateStr');
            print('Raw flood risk data for $city: ${matchingData['flood_risk']} (Date: ${matchingData['date']})');
            
            // Parse flood risk with proper type handling
            var floodRisk = 0.0;
            var rawFloodRisk = matchingData['flood_risk'];
            
            if (rawFloodRisk is int) {
              floodRisk = rawFloodRisk.toDouble();
            } else if (rawFloodRisk is double) {
              floodRisk = rawFloodRisk;
            } else if (rawFloodRisk is String) {
              floodRisk = double.tryParse(rawFloodRisk) ?? 0.0;
            }
            
            print('Processed flood risk for $city: $floodRisk');
            
            // Assign color based on flood risk value
            Color circleColor;
            if (floodRisk <= 20) {
              circleColor = Colors.green.shade300;
              print('$city: GREEN (risk: $floodRisk)');
            } else if (floodRisk <= 40) {
              circleColor = Colors.yellow.shade600;
              print('$city: YELLOW (risk: $floodRisk)');
            } else if (floodRisk <= 60) {
              circleColor = Colors.orange.shade600;
              print('$city: ORANGE (risk: $floodRisk)');
            } else if (floodRisk <= 80) {
              circleColor = Colors.red.shade600;
              print('$city: RED (risk: $floodRisk)');
            } else {
              circleColor = Colors.purple.shade600;
              print('$city: PURPLE (risk: $floodRisk)');
            }

          double baseRadius = 40000.0;
          double minRiskFactor = 1.0;
          double maxRiskFactor = 2.5;
          double riskFactor = minRiskFactor + ((maxRiskFactor - minRiskFactor) * (floodRisk / 100.0));
          double radius = baseRadius * riskFactor;
            // Add main circle
             newCircles.add(
            Circle(
              circleId: CircleId(city),
              center: position,
              radius: radius,
              fillColor: circleColor.withOpacity(0.4),
              strokeColor: circleColor.withOpacity(0.8),
              strokeWidth: 3,
            ),
          );
 // Add outer glow effect
            newCircles.add(
              Circle(
                circleId: CircleId('${city}_outer'),
                center: position,
                radius: 65000.0,
                fillColor: circleColor.withOpacity(0.1),
                strokeColor: circleColor.withOpacity(0.2),
                strokeWidth: 1,
              ),
            );


            // Add outer glow effect
            newCircles.add(
              Circle(
                circleId: CircleId('${city}_outer'),
                center: position,
                radius: 65000.0,
                fillColor: circleColor.withOpacity(0.1),
                strokeColor: circleColor.withOpacity(0.2),
                strokeWidth: 1,
              ),
            );
            newMarkers.add(
            Marker(
              markerId: MarkerId(city),
              position: position,
              infoWindow: InfoWindow(
                title: '$city - Flood Risk: $floodRisk%',
                snippet: 'Updated: ${DateFormat('MMM d, y').format(selectedDate)}',
              ),
            ),
          );
          }
        }
      } catch (e) {
        print('Error fetching data for $city: $e');
      }
    }

    setState(() {
      _markers = newMarkers;
      _circles = newCircles;
    });

    // Center the map with appropriate zoom level
    if (_controller != null) {
      _controller!.animateCamera(
        CameraUpdate.newLatLngZoom(const LatLng(48.0196, 66.9237), 5.0),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Call _updateMarkers when the widget is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26),
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
                  Container(
                    color: const Color(0xFF0B1D26),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Selected Date: ${DateFormat('dd.MM.yyyy').format(selectedDate)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => _selectDate(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(12),
                          ),
                          child: const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF0B1D26),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildIndicator(Colors.green, 'Safe 0-20%'),
                        _buildIndicator(Colors.yellow, 'Caution 20-40%'),
                        _buildIndicator(Colors.orange, 'Warning 40-60%'),
                        _buildIndicator(Colors.red, 'High Risk 60-80%'),
                        _buildIndicator(Colors.purple, 'Critical 80-100%'),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0B1D26),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _initialPosition,
                          zoom: 5.5,
                        ),
                        myLocationButtonEnabled: true,
                        zoomControlsEnabled: true,
                        markers: _markers,
                        circles: _circles,
                        mapType: MapType.normal,
                        compassEnabled: true,
                        trafficEnabled: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {

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
