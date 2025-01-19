import 'package:flutter/material.dart';
import 'package:project_app/feature/onboard/onboard_1.dart';

class OnboardLogoPage extends StatelessWidget {
  const OnboardLogoPage({super.key});

  @override
 Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardPage()),
      );
    });
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26), // Dark background
      body: Column(
        children: [
          // Header Section with Background and Gradient
          Stack(
            children: [
              // Background Image
              Container(
                height: MediaQuery.of(context).size.height * 0.39, // Reduced height
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/1.jpg'), // Replace with your image
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Gradient Overlay
              Positioned.fill(
                top: MediaQuery.of(context).size.height * 0.29, // Adjust overlay alignment
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent, // Gradient starts transparent
                        Color(0xFF0B1D26), // Gradient blends into background color
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

           Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo Image
                Image.asset(
                  'assets/images/logo.png', // Replace with your logo file
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 4),

                // App Title
                const Text(
                  "TASQYN",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OnboardLogoPage(),
  ));
}
