import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';
import '../features/home/presentation/screens/home_splash_screen.dart';

class ExpenseAssistantApp extends StatelessWidget {
  const ExpenseAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wallet Manager',
      theme: buildAppTheme(),
      home: const HomeSplashScreen(),
    );
  }
}
