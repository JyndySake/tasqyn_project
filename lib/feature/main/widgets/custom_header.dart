import 'package:flutter/material.dart';
import 'package:project_app/feature/news/news_page.dart';
import 'package:project_app/feature/predictions/statistics_and_predictions_page.dart';
import 'package:project_app/feature/map/ui/map_page.dart';
import 'package:project_app/feature/profile/ui/profile_page.dart';
import 'package:project_app/feature/auth/ui/login_page.dart';
import 'package:project_app/feature/main/ui/main_page.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({Key? key}) : super(key: key);

  void _navigateToPage(BuildContext context, Widget page, String currentPage) {
    if (ModalRoute.of(context)?.settings.name != currentPage) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => page, settings: RouteSettings(name: currentPage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? currentRoute = ModalRoute.of(context)?.settings.name;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: const Text(
              'TASQYN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              _HeaderButton(
                label: 'Home',
                onPressed: currentRoute != 'Home' ? () => _navigateToPage(context, MainPage(), 'Home') : null,
                isActive: currentRoute == 'Home',
              ),
              _HeaderButton(
                label: 'News',
                onPressed: currentRoute != 'News' ? () => _navigateToPage(context, NewsPage(), 'News') : null,
                isActive: currentRoute == 'News',
              ),
              _HeaderButton(
                label: 'Statistics',
                onPressed: currentRoute != 'Statistics' ? () => _navigateToPage(context, const PredictionsPage(), 'Statistics') : null,
                isActive: currentRoute == 'Statistics',
              ),
              _HeaderButton(
                label: 'Map',
                onPressed: currentRoute != 'Map' ? () => _navigateToPage(context, const ForecastMapPage(), 'Map') : null,
                isActive: currentRoute == 'Map',
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
  final VoidCallback? onPressed;
  final bool isActive;

  const _HeaderButton({
    Key? key,
    required this.label,
    required this.onPressed,
    required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: onPressed,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.grey : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}