import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../data/home_demo_data.dart';
import '../widgets/home_components.dart';
import 'calendar_onboarding_screen.dart';

class OfflineOnboardingScreen extends StatelessWidget {
  const OfflineOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground(showTexture: true)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
              child: Column(
                children: [
                  const TopBrandBar(),
                  const Spacer(),
                  Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 256,
                        height: 320,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0x2698B1F2)),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x40000000),
                              blurRadius: 38,
                              offset: Offset(0, 16),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            Text(
                              'Wallet Manager',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF0053DB),
                                fontSize: 20,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: const Color(0xFFDBE1FF),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.cloud_off_rounded,
                                size: 44,
                                color: Color(0xFF0053DB),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 8,
                        bottom: 18,
                        child: Transform.rotate(
                          angle: 0.08,
                          child: Container(
                            width: 128,
                            height: 128,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33000000),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                              image: DecorationImage(
                                image: NetworkImage(
                                  AppAssets.onboardingOfflinePhoto,
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 36,
                        top: 64,
                        child: Container(
                          width: 40,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF0B7B59),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.shield_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 54),
                  Text(
                    HomeDemoData.offlinePage.title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...HomeDemoData.offlinePage.descriptionLines.map(
                    (line) => Text(
                      line,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: const Color(0xCC445D99),
                        fontSize: 18,
                        height: 1.6,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const OnboardingProgress(index: 0),
                  const SizedBox(height: 28),
                  PrimaryBlueButton(
                    label: HomeDemoData.offlinePage.buttonText,
                    onTap: () {
                      Navigator.of(context).push(
                        buildFadeSlideRoute(const CalendarOnboardingScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
