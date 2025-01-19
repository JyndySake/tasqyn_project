import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_app/feature/main/widgets/custom_icon.dart';

class FloodRiskMapSection extends StatelessWidget {
  const FloodRiskMapSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0B1D26),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          const Text(
            "Flood Risk Map",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Regions with a higher probability of flooding",
            style: TextStyle(
              fontSize: 16,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 24),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column: List of Regions
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    RegionItem(regionName: "Северо-Казахстанская область"),
                    SizedBox(height: 30),
                    RegionItem(regionName: "Костанайская область"),
                    SizedBox(height: 30),
                    RegionItem(regionName: "Акмолинская область"),
                    SizedBox(height: 30),
                    RegionItem(regionName: "Западно-Казахстанская область"),
                    SizedBox(height: 30),
                    RegionItem(regionName: "Атырауская область"),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Right Column: Map
              Expanded(
                flex: 3,
                child: Container(
                  height: 400,
                  child: Stack(
                    children: [
                      FractionallySizedBox(
                        widthFactor: 1.0,
                        child: SvgPicture.asset(
                          'assets/maps/kazakhstan_map.svg',
                          fit: BoxFit.contain,
                        ),
                      ),
        
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RegionItem extends StatelessWidget {
  final String regionName;

  const RegionItem({super.key, required this.regionName});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          const CustomLocationIcon(),
          const SizedBox(width: 8),
          Text(
            regionName,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}



class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
