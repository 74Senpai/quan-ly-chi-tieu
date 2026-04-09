import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../data/home_demo_data.dart';
import '../widgets/home_components.dart';
import 'offline_onboarding_screen.dart';

class HomeSplashScreen extends StatefulWidget {
  const HomeSplashScreen({super.key});

  @override
  State<HomeSplashScreen> createState() => _HomeSplashScreenState();
}

class _HomeSplashScreenState extends State<HomeSplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(buildFadeSlideRoute(const OfflineOnboardingScreen()));
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground(showTexture: true)),
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0x2698B1F2)),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 40,
                              height: 42,
                              child: Image.network(
                                AppAssets.homeSplashChartIcon,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) =>
                                    const Icon(Icons.show_chart_rounded),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: const Color(0xFF006D4A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFFFAF8FF),
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 16,
                                height: 20,
                                child: Image.network(
                                  AppAssets.homeSplashShieldIcon,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, _, _) =>
                                      const Icon(Icons.shield, size: 16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      HomeDemoData.splashTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF0E51FC),
                        fontSize: 48,
                        height: 1,
                        letterSpacing: -2.4,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      HomeDemoData.splashSubtitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 12,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 72),
                    Container(
                      width: 237,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E7FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 66,
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0053DB),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          HomeDemoData.splashLoadingLabel,
                          style: GoogleFonts.inter(
                            color: const Color(0x99445D99),
                            fontSize: 10,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const ProgressDots(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
