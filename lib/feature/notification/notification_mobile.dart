import 'package:flutter/material.dart';

import 'package:project_app/feature/profile/ui/profile_mobile.dart';
import 'package:project_app/feature/auth/ui/login_page_mobile.dart';

void main() {
  runApp(const NotificationApp());
}

class NotificationApp extends StatefulWidget {
  const NotificationApp({Key? key}) : super(key: key);

  @override
  State<NotificationApp> createState() => _NotificationAppState();
}

class _NotificationAppState extends State<NotificationApp> {
  final List<bool> _expanded = [false, false, false, false, false];

  final List<Map<String, String>> notifications = [
    {
      "title": "Flood Alert: High Risk in Almaty Region",
      "details": "Heavy rainfall expected in the next 24 hours. Stay prepared and avoid low-lying areas."
    },
    {
      "title": "New Prediction Available",
      "details": "Updated flood predictions have been generated for your area."
    },
    {
      "title": "Severe Weather Warning Issued",
      "details": "A severe storm warning has been issued for the next 48 hours."
    },
    {
      "title": "Flood Statistics Updated",
      "details": "Check out the latest flood statistics and trends in your region."
    },
    {
      "title": "Emergency Contact Reminder",
      "details": "Ensure that your emergency contact information is updated."
    },
  ];

  void toggleExpansion(int index) {
    setState(() {
      _expanded[index] = !_expanded[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
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
          title: const Text(
            'Notifications',
            style: TextStyle(color: Colors.white),
          ),
        ),
        drawer: Drawer(
          backgroundColor: Colors.white,
          child: SafeArea(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      'Username',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
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
        backgroundColor: const Color(0xFF0B1D26),
        body: NotificationPage(
          notifications: notifications,
          expanded: _expanded,
          toggleExpansion: toggleExpansion,
        ),
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  final List<Map<String, String>> notifications;
  final List<bool> expanded;
  final void Function(int) toggleExpansion;

  const NotificationPage({
    Key? key,
    required this.notifications,
    required this.expanded,
    required this.toggleExpansion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return NotificationCard(
          title: notifications[index]['title']!,
          details: notifications[index]['details']!,
          isExpanded: expanded[index],
          onToggle: () => toggleExpansion(index),
        );
      },
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String details;
  final bool isExpanded;
  final VoidCallback onToggle;

  const NotificationCard({
    Key? key,
    required this.title,
    required this.details,
    required this.isExpanded,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.white.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: Column(
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.black,
              ),
              onPressed: onToggle,
            ),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                details,
                style: const TextStyle(color: Colors.black),
              ),
            ),
        ],
      ),
    );
  }
}
