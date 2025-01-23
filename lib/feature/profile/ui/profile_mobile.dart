import 'package:flutter/material.dart';


void main() {
  runApp(
    const MaterialApp(
      home: ProfilePageApp(),
    ),
  );
}


class ProfilePageApp extends StatelessWidget {
  const ProfilePageApp({super.key});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xFF0B1D26), // Page background color
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header with Background Image and Gradient
                        Stack(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.35,
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

                        // Profile Sections
                        const ProfileSectionContainer(
                          title: "Main Information",
                          child: MainInformationForm(),
                        ),
                        const ProfileSectionContainer(
                          title: "Newsletter",
                          child: NewsletterSection(),
                        ),
                        const ProfileSectionContainer(
                          title: "Contact Us",
                          child: ContactUsForm(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Customizing Alerts and Data',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFFFBD784),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'User Profile',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class ProfileSectionContainer extends StatelessWidget {
  final String title;
  final Widget child;

  const ProfileSectionContainer({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class MainInformationForm extends StatelessWidget {
  const MainInformationForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInputRow("Email", "example@mail.ru", "Save"),
        const SizedBox(height: 16),
        _buildInputRow("Username", "Username", "Save"),
        const SizedBox(height: 16),
        _buildInputRow("Password", "********", "Change", isPassword: true),
      ],
    );
  }

Widget _buildInputRow(String label, String hint, String buttonText,
    {bool isPassword = false}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 8),
      Row(
        children: [
          Expanded(
            child: TextField(
              obscureText: isPassword,
              style: const TextStyle(color: Colors.black), // Black input text
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF5F5F5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: isPassword
                    ? const Icon(Icons.lock, color: Colors.grey)
                    : null,
              ),
            ),
          ),
          const SizedBox(width: 8),
          OutlinedButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  buttonText,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.black,
                  size: 16,
                ),
              ],
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black), // Black border
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20), // Rounded corners
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Padding inside the button
            ),
          ),
        ],
      ),
    ],
  );
}

}

class NewsletterSection extends StatelessWidget {
  const NewsletterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "You are currently subscribed to our newsletter",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Unsubscribe"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class ContactUsForm extends StatelessWidget {
  const ContactUsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Feel free to reach out for any personal matters or questions you may have",
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        TextField(
  maxLines: 4,
  style: const TextStyle(color: Colors.black), // Ensure entered text is black
  decoration: InputDecoration(
    hintText: "Type your message here",
    hintStyle: const TextStyle(color: Colors.grey), // Placeholder remains gray
    filled: true,
    fillColor: const Color(0xFFF5F5F5),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
  ),
),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {},
          child: const Text("Send"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}