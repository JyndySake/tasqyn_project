import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Open the drawer
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Add functionality for notifications
            },
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0B1D26), // Dark background
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Privacy Policy",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "1. Types data we collect",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We collect the following types of data to ensure the functionality and improvement of our Flood Prediction and Early Warning Platform:",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "• Personal Information: Name, email address, phone number, or other contact details provided during account creation or communication.\n"
              "• Location Data: GPS or location-based data to provide real-time flood alerts and notifications relevant to your area.\n"
              "• Usage Data: Information about your interactions with the app, including the pages visited, features used, and the time spent on the platform.\n"
              "• Device Information: Information about the device you use, such as the model, operating system, unique device identifiers, and IP address.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "2. Use of your personal data",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "We use your personal data to:",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "• Provide Services: Deliver accurate flood predictions, real-time alerts, and statistical information.\n"
              "• Enhance User Experience: Analyze app usage to improve features, fix bugs, and deliver a more personalized experience.\n"
              "• Communicate with You: Send important updates, notifications, or administrative communications regarding the app and its services.\n"
              "• Ensure Security: Monitor and prevent unauthorized access or malicious activities to protect your data and our platform.\n"
              "• Compliance: Fulfill legal obligations or respond to lawful requests from authorities.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "3. Disclosure of your personal data",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Your personal data may be disclosed in the following cases:",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "• To Service Providers: Third-party vendors who assist in operating the app, such as analytics tools or hosting providers, only to the extent necessary to provide their services.\n"
              "• Legal Requirements: If required by law or in response to valid legal processes, such as subpoenas, court orders, or regulatory obligations.\n"
              "• Protection of Rights: To safeguard the rights, property, or safety of users, the public, or our platform, as permitted by law.\n"
              "• Business Transfers: In the event of a merger, acquisition, or sale of the platform, your data may be transferred to the new entity, provided it adheres to this Privacy Policy.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "We take reasonable measures to ensure that your personal data is handled securely and only disclosed when necessary.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
