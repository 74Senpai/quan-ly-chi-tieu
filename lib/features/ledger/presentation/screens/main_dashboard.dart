import 'package:flutter/material.dart';
import '../widgets/custom_bottom_nav.dart';
import 'scan_result_screen.dart';
import 'limits_screen.dart';
import 'export_history_screen.dart';
import 'notification_settings_screen.dart';
import 'help_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 2; // SCAN is active by default in the design

  // Using a getter to return fresh instances of screens,
  // or a list if state preservation is needed.
  final List<Widget> _screens = [
    const ExportHistoryScreen(), // Assuming Ledger tab shows export history for now, or Help screen
    const LimitsScreen(),
    const ScanResultScreen(),
    const NotificationSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
