import 'package:flutter/material.dart';
import 'package:project_app/feature/predictions/statistics_and_predictions_mobile.dart';
import 'package:project_app/feature/profile/ui/profile_mobile.dart';
import 'package:project_app/feature/map/ui/map_mobile.dart';
import 'package:project_app/feature/auth/ui/login_page_mobile.dart';


void main() {
  runApp(const MaterialApp(
    home: NewsPageApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class NewsPageApp extends StatelessWidget {
  const NewsPageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
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
                        height: MediaQuery.of(context).size.height * 0.39,
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
                        child: const HeaderWithTextAndSearch(),
                      ),
                    ],
                  ),
                  const NewsCardsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenu(BuildContext context) {
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
              leading: const Icon(Icons.article, color: Colors.white),
              title: const Text(
                'News',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsPageApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Colors.white),
              title: const Text(
                'Statistics',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FloodPredictionApp()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map, color: Colors.white),
              title: const Text(
                'Map',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapPageApp()),
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
                  MaterialPageRoute(
                      builder: (context) => const LoginPageMobile()),
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

class HeaderWithTextAndSearch extends StatefulWidget {
  const HeaderWithTextAndSearch({super.key});

  @override
  State<HeaderWithTextAndSearch> createState() =>
      _HeaderWithTextAndSearchState();
}

class _HeaderWithTextAndSearchState extends State<HeaderWithTextAndSearch> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 2,
              color: const Color(0xFFFBD784),
            ),
            const SizedBox(width: 8),
            const Text(
              'ALERTS AND CURRENT EVENTS',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFFFBD784),
                fontWeight: FontWeight.w600,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'News & Forecasts',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            // Search field with placeholder and search icon inside
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by keyword..',
                  hintStyle: const TextStyle(color: Colors.grey),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24), // Rounded corners
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey), // Search icon
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12), // Space between the search bar and calendar icon
            // Calendar icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20), // Circle shape
              ),
              child: IconButton(
                icon: const Icon(Icons.calendar_today, color: Colors.grey),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                    // Optionally show a message
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Selected Date: ${selectedDate!.toLocal()}'.split(' ')[0],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8), // Reduced space after the search bar
        if (selectedDate != null) // Display the selected date below the search bar
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
          ),
      ],
    );
  }
}


class NewsCardsSection extends StatelessWidget {
  const NewsCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1D26), // Background color
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: List.generate(
              4,
              (index) => const Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: NewsCard(
                  headline: "News headline",
                  description:
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                  imageAsset: "assets/images/2.jpg",
                ),
              ),
            ),
          ),
        ),
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
    this.imageHeight = 360, // Default image height
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1D26),
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