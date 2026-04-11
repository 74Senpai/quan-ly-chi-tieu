import 'package:flutter/material.dart';

import '../../../ai/presentation/screens/assistant_landing_screen.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../wallets/presentation/screens/wallets_screen.dart';
import '../widgets/home_components.dart';
import 'dashboard_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key, this.initialTab});

  final HomeTab? initialTab;

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late HomeTab _activeTab;

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTab ?? HomeTab.dashboard;
  }

  final List<HomeTab> _tabs = [
    HomeTab.dashboard,
    HomeTab.calendar,
    HomeTab.ai,
    HomeTab.wallets,
    HomeTab.settings,
  ];

  void _onTabSelected(HomeTab tab) {
    if (_activeTab == tab) return;
    setState(() {
      _activeTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: Stack(
        children: [
          // Content
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey(_activeTab),
              child: _buildScreen(_activeTab),
            ),
          ),
          
          // Persistent Bottom Navigation
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: HomeBottomNavigation(
              activeTab: _activeTab,
              onTabSelected: _onTabSelected,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScreen(HomeTab tab) {
    switch (tab) {
      case HomeTab.dashboard:
        return const DashboardScreen();
      case HomeTab.calendar:
        return const CalendarScreen();
      case HomeTab.ai:
        return const AssistantLandingScreen();
      case HomeTab.wallets:
        return const WalletsScreen();
      case HomeTab.settings:
        return const SettingsScreen();
    }
  }
}
