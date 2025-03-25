import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_app/feature/main/widgets/custom_header.dart';
import 'package:intl/intl.dart';

class ForecastMapPage extends StatelessWidget {
  const ForecastMapPage({super.key});

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

            // **Title Section**
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
                    children: const [
                      Text(
                        "Select a date for the forecast",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      DatePickerWidget(),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // **Regions and SVG Map Side by Side**
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // **Regions List**
                  Expanded(
                    flex: 2, // Ensures proper spacing
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
                  const SizedBox(width: 5), // Adds spacing between regions and map

                  // **SVG Kazakhstan Map**
                  Expanded(
                    flex: 3,
                    child: SvgPicture.asset(
                      'assets/maps/kazakhstan_map.svg',
                      fit: BoxFit.contain,
                      width: MediaQuery.of(context).size.width * 0.8, // Adjust width
                      height: MediaQuery.of(context).size.width * 0.5, // Adjust height
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // Extra spacing before Google Map

            // **Google Map Widget (Centered Below SVG Map and Region List)**
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.85, // 85% width of screen
                height: 350, // Adjust height as needed
                child: const GoogleMapWidget(),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class DatePickerWidget extends StatefulWidget {
  const DatePickerWidget({super.key});

  @override
  _DatePickerWidgetState createState() => _DatePickerWidgetState();
}

class _DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime selectedDate = DateTime.now(); // Default to today's date

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Start from the currently selected date
      firstDate: DateTime.now(), // Disable past dates
      lastDate: DateTime(2100), // Set an upper limit (adjust if needed)
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

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat("dd.MM.yyyy").format(selectedDate);

    return GestureDetector(
      onTap: () => _selectDate(context), // Open date picker on tap
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
              formattedDate, // Display selected date
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
          ],
        ),
      ),
    );
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
  const GoogleMapWidget({super.key});

  @override
  _GoogleMapWidgetState createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  GoogleMapController? mapController;

  final LatLng _initialPosition = const LatLng(48.0196, 66.9237);

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white30),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _initialPosition,
          zoom: 4.5,
        ),
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
