import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:project_app/feature/map/ui/map_mobile.dart';
import 'package:project_app/feature/news/news_mobile_page.dart';
import 'package:project_app/feature/predictions/statistics_and_predictions_mobile.dart';
import 'package:project_app/feature/profile/ui/profile_mobile.dart';
import 'package:project_app/feature/auth/ui/login_page_mobile.dart';
import 'package:project_app/feature/notification/notification_mobile.dart';

void main() {
  runApp(const FloodPredictionAppMobile());
}

class FloodPredictionAppMobile extends StatelessWidget {
  const FloodPredictionAppMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
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
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MainContentPage(),
    const NewsPageApp(),
    const FloodPredictionApp(),
    const MapPageApp(),
    const ProfilePageApp(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        actions: [
  IconButton(
    icon: const Icon(Icons.notifications, color: Colors.white),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const NotificationApp(),
        ),
      );
    },
  ),
],

      ),
     drawer: Drawer(
          backgroundColor: Colors.white,
  child: SafeArea(
    child: Container(
      color: Colors.white, // Set the entire drawer bckground to white
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.white, // Set header background to white
            ),
            child: Text(
              'Username',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black, // Text colorto black
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle, color: Colors.black),
            title: const Text(
              'My Profile',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfilePageApp(),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.email, color: Colors.black),
            title: const Text(
              'Contact Us',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: Colors.black),
            title: const Text(
              'Privacy Policy',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.black),
            title: const Text(
              'Helps & FAQs',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.black),
            title: const Text(
              'Sign Out',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginPageMobile(),
                ),
              );
            },
          ),
        ],
      ),
    ),
  ),
),

      extendBodyBehindAppBar: true,
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFFFBD784),
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class MainContentPage extends StatelessWidget {
  const MainContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
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
                const SectionContainer(
                  title: "Alerts and Current Events",
                  subtitle: "News & Forecasts",
                  child: NewsAndForecastsSection(),
                ),
                const SectionContainer(
                  title: "Overview of Data by Region and Risk Level",
                  subtitle: "Predictions and Statistics",
                  child: PredictionsAndStatisticsSection(),
                ),
                const SectionContainer(
                  title: "Flood Risk Map",
                  subtitle: "Regions with a higher probability of flooding",
                  child: FloodRiskMapSection(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    double responsiveFontSize = MediaQuery.of(context).size.width * 0.08;
    final double fontSize = responsiveFontSize.clamp(24.0, 36.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 1,
              color: const Color(0xFFFBD784),
            ),
            const SizedBox(width: 8),
            const Text(
              'GET TIMELY INFORMATION AND PREPARE IN ADVANCE',
              style: TextStyle(
                fontSize: 9,
                color: Color(0xFFFBD784),
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Flood Prediction And\nEarly Warning Platform',
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 30),
        Row(
          children: const [
            Text(
              'scroll down',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(width: 8),
            Icon(
              Icons.arrow_downward,
              color: Colors.white,
              size: 18,
            ),
          ],
        ),
      ],
    );
  }
}

class SectionContainer extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const SectionContainer({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1D26), 
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 2,
                width: 20, 
                color: const Color(0xFFFBD784), 
              ),
              const SizedBox(width: 8), 
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFBD784), 
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(width: 8), 
              Icon(
                Icons.open_in_new, 
                color: Colors.white,
                size: 25,
              ),
            ],
          ),
          const SizedBox(height: 8), 
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16), 
          child, 
        ],
      ),
    );
  }
}

class NewsAndForecastsSection extends StatelessWidget {
  const NewsAndForecastsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: const [
          NewsCard(
            headline: 'Flood Warning in City X',
            description: 'Authorities have issued a flood warning...',
            imageAsset: 'assets/images/2.jpg',
          ),
          NewsCard(
            headline: 'Heavy Rains Expected',
            description: 'Meteorologists forecast heavy rains...',
            imageAsset: 'assets/images/3.jpg',
          ),
        ],
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String headline;
  final String description;
  final String imageAsset;

  const NewsCard({
    super.key,
    required this.headline,
    required this.description,
    required this.imageAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1D26),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              imageAsset,
              width: double.infinity,
              height: 400,
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
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class PredictionsAndStatisticsSection extends StatelessWidget {
  const PredictionsAndStatisticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1D26),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Section title
          const Text(
            "Flood Risk Trends by Time Frame and Category",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          CustomPaint(
            size: const Size(300, 150), 
            painter: SemiCircleChartPainter(),
          ),
          const SizedBox(height: 16),
          Column(
            children: const [
              LegendItem(
                label: "Snow melting",
                color: Color(0xFF9C7FF5), 
                percentage: "45%",
              ),
              SizedBox(height: 8),
              LegendItem(
                label: "Temperature",
                color: Color(0xFFCA9AF8), 
                percentage: "24%",
              ),
              SizedBox(height: 8),
              LegendItem(
                label: "Rainfall intensity",
                color: Color(0xFF6DCFF6), 
                percentage: "15%",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SemiCircleChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const double strokeWidth = 12.0;

    final Paint baseCircle = Paint()
      ..color = const Color(0xFFF1F1F1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint audienceArc = Paint()
      ..color = const Color(0xFF9C7FF5) 
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint temperatureArc = Paint()
      ..color = const Color(0xFFCA9AF8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final Paint rainfallArc = Paint()
      ..color = const Color(0xFF6DCFF6) 
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height),
        radius: size.height,
      ),
      3.14, 
      3.14, 
      false,
      baseCircle,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height),
        radius: size.height,
      ),
      3.14,
      1.5, 
      false,
      audienceArc,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height),
        radius: size.height,
      ),
      4.64, 
      0.9, 
      false,
      temperatureArc,
    );

    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height),
        radius: size.height,
      ),
      5.74, 
      0.5, 
      false,
      rainfallArc,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final String percentage;

  const LegendItem({
    super.key,
    required this.label,
    required this.color,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8), 
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 16), 
        Text(
          percentage,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}


class FloodRiskMapSection extends StatelessWidget {
  const FloodRiskMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Flood Risk Map Placeholder',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}