// lib/presentation/screens/main/main_screen.dart
import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../tracking/tracking_screen.dart';
import '../progress/progress_screen.dart';
import '../profile/profile_screen.dart';
import '../../../core/theme/app_theme.dart';
import '../../widgets/banner_ad_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const TrackingScreen(),
    const ProgressScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // AdMob Banner Ad
          const BannerAdWidget(),
          // Bottom Navigation Bar
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              type: BottomNavigationBarType.fixed,
              selectedItemColor: AppTheme.primaryColor,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.track_changes),
                  label: 'Track',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.trending_up),
                  label: 'Progress',
                ),
                BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
