// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light(),
//       home: MapScreen(),
//     );
//   }
// }

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }

// class _MapScreenState extends State<MapScreen> {
//   LatLng? _currentPosition; // Current location coordinates
//   bool _isLoading = true; // Loading flag
//   String _locationError = ''; // Error message

//   @override
//   void initState() {
//     super.initState();
//     _determinePosition();
//   }

//   Future<void> _determinePosition() async {
//     try {
//       bool serviceEnabled;
//       LocationPermission permission;

//       // Check if location services are enabled
//       serviceEnabled = await Geolocator.isLocationServiceEnabled();
//       if (!serviceEnabled) {
//         setState(() {
//           _locationError = 'Location services are disabled. Please enable them.';
//           _isLoading = false;
//         });
//         return;
//       }

//       // Check and request permissions
//       permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           setState(() {
//             _locationError = 'Location access denied. Please grant permission.';
//             _isLoading = false;
//           });
//           return;
//         }
//       }

//       if (permission == LocationPermission.deniedForever) {
//         setState(() {
//           _locationError = 'Location access permanently denied.';
//           _isLoading = false;
//         });
//         return;
//       }

//       // Get the current position
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _isLoading = false;
//         _locationError = '';
//       });
//     } catch (e) {
//       setState(() {
//         _locationError = 'Error determining location: $e';
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Location'),
//       ),
//       body: _isLoading
//           ? const Center(
//               child: CircularProgressIndicator(),
//             )
//           : _locationError.isNotEmpty
//               ? Center(
//                   child: Text(
//                     _locationError,
//                     style: const TextStyle(color: Colors.red, fontSize: 16),
//                     textAlign: TextAlign.center,
//                   ),
//                 )
//               : FlutterMap(
//                   options: MapOptions(
//                     center: _currentPosition,
//                     zoom: 16.0,
//                   ),
//                   children: [
//                     TileLayer(
//                       urlTemplate:
//                           "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
//                       subdomains: ['a', 'b', 'c'],
//                     ),
//                     MarkerLayer(
//                       markers: [
//                         Marker(
//                           point: _currentPosition!,
//                           width: 80.0,
//                           height: 80.0,
//                           builder: (context) => const Icon(
//                             Icons.location_pin,
//                             color: Colors.red,
//                             size: 40.0,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//     );
//   }
// }
