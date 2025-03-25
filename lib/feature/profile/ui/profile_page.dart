import 'package:flutter/material.dart';

import 'package:project_app/feature/main/widgets/custom_header.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;

    return Scaffold(
      backgroundColor: const Color(0xFF0B1D26), // Set background color
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 24,
            vertical: isSmallScreen ? 16 : 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
             const CustomHeader(),
              const SizedBox(height: 32),

              // Section Title
              const _SectionTitle(),

              // Tabs
              const _TabSection(),
              const Divider(color: Colors.white30, thickness: 1),
              const SizedBox(height: 24),

              // Content Section
              LayoutBuilder(builder: (context, constraints) {
                return Flex(
                  direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      flex: 2,
                      child: _MainInformationCard(),
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 0, width: isSmallScreen ? 0 : 16),
                    Flexible(
                      flex: 3,
                      child: Column(
                        children: const [
                          _NewsletterCard(),
                          SizedBox(height: 16),
                          _ContactUsCard(),
                        ],
                      ),
                    ),
                  ],
                );
              }),

              // Footer
              const SizedBox(height: 32),
              _FooterSection(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
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
        padding: const EdgeInsets.only(right: 24.0),
        child: Text(
          title,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }
}


class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "CUSTOMIZING ALERTS AND DATA",
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFFFBD784),
            letterSpacing: 1.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "User Profile",
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    );
  }
}

class _TabSection extends StatelessWidget {
  const _TabSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabItem(title: "User information", isActive: true),
        _TabItem(title: "Saved Alerts", isActive: false),
        _TabItem(title: "Interaction History", isActive: false),
      ],
    );
  }
}

class _FooterSection extends StatelessWidget {
  const _FooterSection();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Flood prediction and Early warning platform",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                "Important information for preparedness",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text("More", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFBD784))),
            SizedBox(height: 8),
            Text("News", style: TextStyle(color: Colors.white70)),
            Text("Statistics", style: TextStyle(color: Colors.white70)),
            Text("Map", style: TextStyle(color: Colors.white70)),
          ],
        ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isActive;

  const _TabItem({required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 32.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          color: isActive ? Colors.white : Colors.white54,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}


class _MainInformationCard extends StatelessWidget {
  const _MainInformationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Main information",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          _InputRow(label: "Email", value: "example@mail.ru"),
          const SizedBox(height: 16),

          _InputRow(label: "Username", value: "Username"),
          const SizedBox(height: 16),

          _PasswordRow(),
        ],
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final String label;
  final String value;

  const _InputRow({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label and Input
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    const Icon(Icons.edit, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Save Button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.grey),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: const Text(
            "Save",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class _PasswordRow extends StatelessWidget {
  const _PasswordRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Label and Password Field
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "********",
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                    Icon(Icons.lock_outline, size: 16, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),

        // Change Button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            side: const BorderSide(color: Colors.black),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          child: const Row(
            children: [
              Text(
                "Change",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              Icon(Icons.arrow_forward, size: 16, color: Colors.black),
            ],
          ),
        ),
      ],
    );
  }
}

class _NewsletterCard extends StatelessWidget {
  const _NewsletterCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left Content: Newsletter Info
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Newsletter",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "You are currently subscribed to our newsletter",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),
            ],
          ),

          // Right Content: Unsubscribe Button
          ElevatedButton(
            onPressed: () {
              // Add unsubscribe logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.black87),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Unsubscribe",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _ContactUsCard extends StatelessWidget {
  const _ContactUsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Feel free to reach out for any personal matters or questions you may have",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const TextField(
                style: TextStyle(color: Colors.black87),
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Type your message here",
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    // Add send logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0B1D26),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                  ),
                  child: const Text(
                    "Send",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}