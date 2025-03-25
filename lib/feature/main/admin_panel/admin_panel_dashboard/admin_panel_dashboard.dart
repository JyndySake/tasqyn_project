import 'package:flutter/material.dart';
import 'package:project_app/feature/main/admin_panel/admin_panel_add_news/admin_panel_add_news.dart' as news;
import 'package:project_app/feature/main/admin_panel/admin_panel_messages/admin_panel_message.dart' as messages;

void main() {
  runApp(const AdminDashboardApp());
}

class AdminDashboardApp extends StatelessWidget {
  const AdminDashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const AdminDashboard(),
    );
  }
}

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'Admin Menu',
                style: TextStyle(
                  color: Color(0xFF0B1D26),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: Color(0xFF0B1D26)),
              title: Text('Profile', style: TextStyle(color: Color(0xFF0B1D26))),
              onTap: () {
                // Handle profile tap
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Color(0xFF0B1D26)),
              title: Text('Log Out', style: TextStyle(color: Color(0xFF0B1D26))),
              onTap: () {
                // Handle log out tap
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
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
                        height: MediaQuery.of(context).size.height * 0.4,
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
                        child: const DashboardHeader(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // App Statistics
                  const SectionTitle(title: "App Statistics"),
                  const AdminStatisticsGrid(),
                  const SizedBox(height: 50),

                  // Quick Actions
                  const SectionTitle(title: "Quick Actions"),
                  const AdminQuickActionsGrid(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Header Section
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

// Section Title Widget
class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}

// App Statistics Grid
class AdminStatisticsGrid extends StatelessWidget {
  const AdminStatisticsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {"title": "Active flood alerts", "value": "3"},
      {"title": "Total users", "value": "50"},
      {"title": "New sign-ups", "value": "15"},
      {"title": "Active sessions", "value": "23"},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: stats.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2,
        ),
        itemBuilder: (context, index) {
          return _StatCard(
            title: stats[index]["title"]!,
            value: stats[index]["value"]!,
          );
        },
      ),
    );
  }
}

// Statistics Card
class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFBD784),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Flexible(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF0B1D26), fontSize: 14),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class AdminQuickActionsGrid extends StatelessWidget {
  const AdminQuickActionsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> actions = [
      {"title": "Add news", "route": const news.AddNewsPage()},
      {"title": "Send notification", "route": null},
      {"title": "Update flood data", "route": null},
      {"title": "Update analysis", "route": null},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: actions.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 2.5,
        ),
        itemBuilder: (context, index) {
          return _QuickActionCard(
            title: actions[index]["title"]!,
            route: actions[index]["route"] as Widget?,
          );
        },
      ),
    );
  }
}

// Quick Action Card with Navigation
class _QuickActionCard extends StatelessWidget {
  final String title;
  final Widget? route;

  const _QuickActionCard({super.key, required this.title, this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (route != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => route!),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Color(0xFF0B1D26), fontSize: 14),
            ),
            const Icon(Icons.arrow_forward, color: Color(0xFF0B1D26), size: 18),
          ],
        ),
      ),
    );
  }
}

// Bottom Navigation Bar with Navigation
class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFF0B1D26),
      selectedItemColor: const Color(0xFFFBD784),
      unselectedItemColor: Colors.white70,
      onTap: (index) {
        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const news.AddNewsPage()),
          );
        }
         if (index == 2){
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const messages.AdminMessageApp()));
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
        BottomNavigationBarItem(icon: Icon(Icons.article), label: "Add news"),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: "Messages"),
      ],
    );
  }
}
