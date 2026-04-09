import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../data/home_demo_data.dart';
import '../widgets/home_components.dart';
import 'mode_selection_screen.dart';

class AiOnboardingScreen extends StatelessWidget {
  const AiOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Image.network(
                AppAssets.onboardingAiBackdrop,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 80, 32, 64),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 256,
                              height: 320,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(48),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x1A113069),
                                    blurRadius: 40,
                                    offset: Offset(0, 20),
                                  ),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 68,
                                    height: 128,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: const [
                                        _WaveBar(32, Color(0xFF0053DB)),
                                        _WaveBar(64, Color(0x990053DB)),
                                        _WaveBar(96, Color(0x660053DB)),
                                        _WaveBar(48, Color(0xCC0053DB)),
                                        _WaveBar(80, Color(0xFF0053DB)),
                                        _WaveBar(40, Color(0x4D0053DB)),
                                        _WaveBar(56, Color(0x800053DB)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Container(
                                    width: 96,
                                    height: 96,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0053DB),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.support_agent_rounded,
                                      size: 44,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              left: -14,
                              top: 36,
                              child: _FloatingChip(
                                icon: Icons.mic_none_rounded,
                                text: '"Cà phê sáng 45k"',
                              ),
                            ),
                            Positioned(
                              right: -18,
                              bottom: 80,
                              child: _FloatingChip(
                                icon: Icons.insights_outlined,
                                text: 'Phân tích chi tiêu',
                              ),
                            ),
                            Positioned(
                              right: -42,
                              bottom: -36,
                              child: Opacity(
                                opacity: 0.16,
                                child: Image.network(
                                  AppAssets.onboardingAiPattern,
                                  width: 128,
                                  height: 128,
                                  errorBuilder: (_, _, _) =>
                                      const SizedBox.shrink(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 54),
                        Text(
                          HomeDemoData.aiPage.title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 36,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1.8,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...HomeDemoData.aiPage.descriptionLines.map(
                          (line) => Text(
                            line,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF445D99),
                              fontSize: 18,
                              height: 1.6,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const OnboardingProgress(index: 2),
                        const SizedBox(height: 28),
                        PrimaryBlueButton(
                          label: HomeDemoData.aiPage.buttonText,
                          icon: Icons.arrow_forward_rounded,
                          onTap: () {
                            Navigator.of(context).push(
                              buildFadeSlideRoute(const ModeSelectionScreen()),
                            );
                          },
                        ),
                      ],
                    ),
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

class _WaveBar extends StatelessWidget {
  const _WaveBar(this.height, this.color);

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 6,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class _FloatingChip extends StatelessWidget {
  const _FloatingChip({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1A98B1F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0B7B59)),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0xFF113069),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
