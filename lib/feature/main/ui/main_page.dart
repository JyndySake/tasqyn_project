import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:project_app/feature/main/widgets/custom_header.dart';
import 'package:project_app/feature/main/sections/header_section.dart';
import 'package:project_app/feature/main/sections/predictions_and_statistics_section.dart';
import 'package:project_app/feature/main/sections/news_and_forecasts_section.dart';
import 'package:project_app/feature/main/sections/flood_risk_map_section.dart';


void main() {
  runApp(const FloodPredictionApp());
}

class FloodPredictionApp extends StatelessWidget {
  const FloodPredictionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(), // Optional dark theme
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Add the Header at the Top          
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Extended Background (Image + Gradient)
                  Stack(
                    children: [
                      Container(
                        height: 1000, // Background Image Height
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/1.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      
                       const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: CustomHeader(),
          ),
                      Positioned.fill(
                        top: 800,
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
                      Container(
  height: MediaQuery.of(context).size.height * 0.7,
  alignment: Alignment.centerLeft,
  padding: EdgeInsets.symmetric(
    horizontal: MediaQuery.of(context).size.width * 0.05, 
    vertical: MediaQuery.of(context).size.height * 0.2, 
  ),
  child: const HeaderSection(),
),

                    ],
                  ),

                  Container(
                    color: const Color(0xFF0B1D26),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: NewsAndForecastsSection(),
                    ),
                  ),
                  Container(
                    color: const Color(0xFF0B1D26),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: PredictionsAndStatisticsSection(),
                    ),
                  ),
                  Container(
                    color: const Color(0xFF0B1D26),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: FloodRiskMapSection(),
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
}


class _TimeFrameButton extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _TimeFrameButton({
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
