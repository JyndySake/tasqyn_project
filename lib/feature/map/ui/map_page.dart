import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_app/feature/predictions/statistics_and_predictions_page.dart';
import 'package:project_app/feature/profile/ui/profile_page.dart';
import 'package:project_app/feature/auth/ui/login_page.dart';
import 'package:project_app/feature/main/ui/main_page.dart';
import 'package:project_app/feature/news/news_page.dart';


class ForecastMapPage extends StatelessWidget {
  const ForecastMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26),
      body: Column(
        children: [
          // Header Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            color: const Color(0xFF0B1D26),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _NavigationButton(
                      title: "Home",
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const FloodPredictionApp()),
                          (route) => false,
                        );
                      },
                    ),
                    _NavigationButton(
                      title: "News",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NewsPage()),
                        );
                      },
                    ),
                    _NavigationButton(
                      title: "Statistics",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PredictionsPage()),
                        );
                      },
                    ),
                    _NavigationButton(
                      title: "Map",
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForecastMapPage()),
                        );
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _showAccountMenu(context),
                  child: Row(
                    children: const [
                      Icon(Icons.account_circle_outlined, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Account",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title Section
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
                  const SizedBox(height: 32),

                  // Map Content
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Side: Regions
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
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
                        const SizedBox(width: 32),

                        // Right Side: Map
                        Expanded(
                          flex: 3,
                          child: SvgPicture.asset(
                            'assets/maps/kazakhstan_map.svg',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
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

  void _showAccountMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0B1D26),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.white),
                title: const Text(
                  'Settings',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.redAccent),
                title: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavigationButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const _NavigationButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }
}

class DatePickerWidget extends StatelessWidget {
  const DatePickerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: const [
          Text(
            "07.10.2024",
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          SizedBox(width: 8),
          Icon(Icons.calendar_today, size: 16, color: Colors.black54),
        ],
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