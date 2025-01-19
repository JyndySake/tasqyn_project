import 'package:flutter/material.dart';
import 'package:project_app/feature/auth/ui/login_page_mobile.dart';


class OnboardPage extends StatefulWidget {
  const OnboardPage({super.key});

  @override
  State<OnboardPage> createState() => _OnboardPageState();
}

class _OnboardPageState extends State<OnboardPage> {
  int currentIndex = 0;

  final List<Map<String, String>> onboardData = [
    {
      'image': 'assets/images/onboard_1.png',
      'title': 'Stay Informed with the Latest News',
      'description': 'Access real-time updates and critical news to stay ahead of any flood risks in your area.',
    },
    {
      'image': 'assets/images/onboard_2.png',
      'title': 'Predict and Prepare for Floods',
      'description': 'Explore flood predictions and detailed maps to help you plan and stay safe.',
    },
    {
      'image': 'assets/images/onboard_3.png',
      'title': 'Get Alerts and Track Stats',
      'description': 'Receive instant notifications and track key flood statistics at your fingertips.',
    },
  ];

  void _goToNextPage() {
    if (currentIndex < onboardData.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPageMobile()),
      );
    }
  }

  void _skipToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPageMobile()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26), // Dark background color
      body: Column(
        children: [
          // Onboard Image
          Expanded(
            flex: 6, // Slightly reduced flex for the image section
            child: Center(
              child: Image.asset(
                onboardData[currentIndex]['image']!,
                width: MediaQuery.of(context).size.width, // Extend the width
                height: MediaQuery.of(context).size.height * 0.55, // Adjust height
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Gray Dots Indicator
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0), // Place dots closer to the image
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(onboardData.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: index == currentIndex ? Colors.white : Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }),
            ),
          ),
          // Text Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center, // Align text to center
              children: [
                Text(
                  onboardData[currentIndex]['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  onboardData[currentIndex]['description']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4, // Equal width for both buttons
                  child: OutlinedButton(
                    onPressed: _skipToLoginPage,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Skip",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                // Next Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4, // Equal width for both buttons
                  child: ElevatedButton(
                    onPressed: _goToNextPage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF0B1D26),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8), // Minimal spacing below buttons
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: OnboardPage(),
  ));
}
