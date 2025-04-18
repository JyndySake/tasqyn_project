import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:project_app/feature/auth/ui/login_page.dart';
import 'package:project_app/feature/onboard/onboard_logo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
 
  runApp(const FloodPredictionApp());
}

class FloodPredictionApp extends StatelessWidget {
  const FloodPredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flood Prediction Platform',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: _getHomePage(),
    );
  }

  Widget _getHomePage() {
    if (kIsWeb) {
      return LoginPage();
    } else {
      return const OnboardLogoPage();
    }
  }
}
