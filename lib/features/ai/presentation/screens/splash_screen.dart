import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/navigation/app_routes.dart';
import '../widgets/assistant_components.dart';
import 'assistant_landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(buildFadeSlideRoute(const AssistantLandingScreen()));
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          final height = constraints.maxHeight;
          final topSpacing = height * 0.12;
          final headingSpacing = height * 0.06;
          final progressSpacing = height * 0.09;
          final footerBottom = height * 0.055;

          return Stack(
            children: [
              const Positioned.fill(child: AppBackground()),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 416),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        SizedBox(height: topSpacing.clamp(72, 120)),
                        const SplashLogoSection(),
                        SizedBox(height: headingSpacing.clamp(44, 72)),
                        const SplashBrandSection(),
                        SizedBox(height: progressSpacing.clamp(56, 100)),
                        const SplashLoadingSection(),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: footerBottom.clamp(28, 48),
                          ),
                          child: const FooterBranding(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
