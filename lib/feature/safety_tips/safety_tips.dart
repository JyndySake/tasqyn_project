import 'package:flutter/material.dart';
import 'package:project_app/feature/widget/nav_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Safety Tips',
      theme: ThemeData.dark(),
      home: const SafetyTipsPage(),
    );
  }
}

class SafetyTipsPage extends StatefulWidget {
  const SafetyTipsPage({Key? key}) : super(key: key);

  @override
  State<SafetyTipsPage> createState() => _SafetyTipsPageState();
}

class _SafetyTipsPageState extends State<SafetyTipsPage> {
  final Map<String, bool> beforeFloodTips = {
    'Prepare an emergency kit with food, water, first aid, and essential documents': false,
    'Stay informed about flood risks through local updates or this app': false,
    'Learn evacuation routes in your area': false,
  };

  final Map<String, bool> duringFloodTips = {
    'Avoid walking or driving through floodwaters': false,
    'Move to higher ground or designated shelters': false,
    'Stay tuned to emergency broadcasts and app alerts': false,
  };

  final Map<String, bool> afterFloodTips = {
    'Avoid standing water, as it may be contaminated': false,
    'Inspect your home for damage before entering': false,
    'Contact local authorities for updates on safety': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1D26),
        title: const Text('Safety Tips'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color(0xFF0B1D26),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stay safe during floods',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Be prepared with these essential safety measures before, during, and after floods:',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 32),
            buildSection(
              title: '01 BEFORE THE FLOOD',
              subtitle: 'Prepare in Advance',
              tips: beforeFloodTips,
            ),
            const SizedBox(height: 32),
            buildSection(
              title: '02 DURING THE FLOOD',
              subtitle: 'Act Quickly to Stay Safe',
              tips: duringFloodTips,
            ),
            const SizedBox(height: 32),
            buildSection(
              title: '03 AFTER THE FLOOD',
              subtitle: 'Returning Safely',
              tips: afterFloodTips,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSection({
    required String title,
    required String subtitle,
    required Map<String, bool> tips,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 2,
              color: const Color(0xFFFBD784),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ...tips.keys.map((tip) {
          return Row(
            children: [
              Checkbox(
                value: tips[tip],
                onChanged: (value) {
                  setState(() {
                    tips[tip] = value!;
                  });
                },
                activeColor: const Color(0xFFFBD784),
              ),
              Expanded(
                child: Text(
                  tip,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
