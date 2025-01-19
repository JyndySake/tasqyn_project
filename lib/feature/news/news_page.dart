import 'package:flutter/material.dart';
import 'package:project_app/feature/news/widgets/search_bar.dart';
import 'package:project_app/feature/news/widgets/pagination_widget.dart';
import 'package:project_app/feature/map/ui/map_page.dart';
import 'package:project_app/feature/predictions/statistics_and_predictions_page.dart';
import 'package:project_app/feature/profile/ui/profile_page.dart';
import 'package:project_app/feature/auth/ui/login_page.dart';
import 'package:project_app/feature/main/ui/main_page.dart';


void main() {
  runApp(const MaterialApp(
    home: NewsPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26), // Dark background
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                            (route) => false, // Clear the navigation stac
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

            // Section Title
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 2,
                        color: const Color(0xFFFBD784),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "ALERTS AND CURRENT EVENTS",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFBD784),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "News & Forecasts",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      SearchBarWidget(),
                      SizedBox(width: 16),
                    ],
                  ),
                ],
              ),
            ),

            // Centered News Cards (First Two Cards)
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                child: Wrap(
                  spacing: 16, // Consistent horizontal spacing
                  runSpacing: 16, // Consistent vertical spacing
                  alignment: WrapAlignment.center,
                  children: const [
                    SizedBox(
                      width: 515,
                      child: NewsCard(
                        headline: "News headline",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        imageAsset: "assets/images/1.jpg",
                        imageHeight: 400, // Larger image height
                      ),
                    ),
                    SizedBox(
                      width: 515,
                      child: NewsCard(
                        headline: "News headline",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        imageAsset: "assets/images/2.jpg",
                        imageHeight: 400, // Larger image height
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32), // Add space between sections

            // Wrapped 4 News Cards with Smaller Images
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                child: Wrap(
                  spacing: 16, // Horizontal spacing
                  runSpacing: 16, // Vertical spacing
                  alignment: WrapAlignment.center,
                  children: const [
                    SizedBox(
                      width: 250, // Reduced width for 4 cards
                      child: NewsCard(
                        headline: "News headline",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        imageAsset: "assets/images/2.jpg",
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: NewsCard(
                        headline: "News headline",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        imageAsset: "assets/images/2.jpg",
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: NewsCard(
                        headline: "News headline",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        imageAsset: "assets/images/2.jpg",
                      ),
                    ),
                    SizedBox(
                      width: 250,
                      child: NewsCard(
                        headline: "News headline",
                        description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                        imageAsset: "assets/images/2.jpg",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Pagination Section
            const SizedBox(height: 32),
            Center(
              child: PaginationWidget(
                totalPages: 10, // Total pages
                onPageSelected: (page) {
                  print("Selected page: $page");
                },
              ),
            ),

            // Footer Section
            const SizedBox(height: 32),
            Container(
              color: const Color(0xFF0B1D26),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Flood prediction and Early warning platform",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Important information for preparedness",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Copyright 2023, Terms & Privacy",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
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


class HeaderMenuItem extends StatelessWidget {
  final String title;
  const HeaderMenuItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        color: Colors.white70,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String headline;
  final String description;
  final String imageAsset;
  final double imageHeight;

  const NewsCard({
    super.key,
    required this.headline,
    required this.description,
    required this.imageAsset,
    this.imageHeight = 180, // Default image height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              imageAsset,
              height: imageHeight,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            headline,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: const [
              Text(
                "read more",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.amber,
                ),
              ),
              SizedBox(width: 4),
              Icon(
                Icons.arrow_forward,
                color: Colors.amber,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

