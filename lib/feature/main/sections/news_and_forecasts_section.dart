import 'package:flutter/material.dart';


class NewsAndForecastsSection extends StatelessWidget {
  const NewsAndForecastsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1D26),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title and action
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Alerts and Current Events",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "News & Forecasts",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  // Add navigation or action here
                },
                child: Row(
                  children: const [
                    Text(
                      "See all",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white70,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Wrapping News Cards
          Center(
            child: Wrap(
              spacing: 16, // Space between cards horizontally
              runSpacing: 16, // Space between rows of cards
              alignment: WrapAlignment.center,
              children: [
                NewsCard(
                  headline: 'Flood Warning in City X',
                  description: 'Authorities have issued a flood warning...',
                  imageAsset: 'assets/images/2.jpg',
                ),
                NewsCard(
                  headline: 'Flood Prevention Efforts',
                  description: 'Recent efforts to improve flood defenses...',
                  imageAsset: 'assets/images/3.jpg',
                ),
                NewsCard(
                  headline: 'Heavy Rains Expected',
                  description: 'Meteorologists forecast heavy rains...',
                  imageAsset: 'assets/images/4.jpg',
                ),
              ],
            ),
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
      width: 400, // Matches the width from the first screenshot
      height: 758,   // Matches the height from the first screenshot
      padding: const EdgeInsets.all(24), // Matches the padding
      decoration: BoxDecoration(
        color: const Color(0xFF121212), // Background color (dark)
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white, // Border color
          width: 2, // Border width from screenshot
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.asset(
              imageAsset,
              width: double.infinity,
              height: 400, // Adjust as per the visual aspect ratio of the image
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16), // Space between image and text
          
          // Headline
          Text(
            headline,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8), // Space between headline and description
          
          // Description
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),

          // "Read More" Row
          Row(
            children: [
              Text(
                "read more",
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.amber,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
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


