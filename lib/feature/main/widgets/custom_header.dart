import 'package:flutter/material.dart';
import 'package:project_app/feature/news/news_page.dart';
import 'package:project_app/feature/predictions/statistics_and_predictions_page.dart';
import 'package:project_app/feature/map/ui/map_page.dart';
import 'package:project_app/feature/profile/ui/profile_page.dart';
import 'package:project_app/feature/auth/ui/login_page.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({Key? key}) : super(key: key);

  void _navigateToPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _HeaderButton(
                label: 'News',
                onPressed: () => _navigateToPage(context, NewsPage()),
              ),
              const SizedBox(width: 16),
              _HeaderButton(
                label: 'Statistics',
                onPressed: () => _navigateToPage(context, const PredictionsPage()),
              ),
              const SizedBox(width: 16),
              _HeaderButton(
                label: 'Map',
                onPressed: () => _navigateToPage(context, const ForecastMapPage()),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: const Color(0xFF0B1D26),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                builder: (_) => SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.settings, color: Colors.white),
                        title: const Text('Settings', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout, color: Colors.redAccent),
                        title: const Text('Log Out', style: TextStyle(color: Colors.redAccent)),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginPage()));
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
            child: Row(
              children: const [
                Icon(Icons.account_circle, color: Colors.white),
                SizedBox(width: 8),
                Text('Account', style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _HeaderButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _HeaderButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}


class _HeaderMenuItem extends StatelessWidget {
  final String title;

  const _HeaderMenuItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
