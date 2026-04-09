import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/navigation/app_routes.dart';
import '../widgets/assistant_components.dart';
import 'ocr_result_screen.dart';

class CameraCaptureDemoScreen extends StatefulWidget {
  const CameraCaptureDemoScreen({super.key});

  @override
  State<CameraCaptureDemoScreen> createState() =>
      _CameraCaptureDemoScreenState();
}

class _CameraCaptureDemoScreenState extends State<CameraCaptureDemoScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _transitionTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _transitionTimer = Timer(const Duration(milliseconds: 2200), () {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(buildFadeSlideRoute(const OcrResultScreen()));
    });
  }

  @override
  void dispose() {
    _transitionTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF07111F),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Opacity(
            opacity: 0.42,
            child: Image.network(
              AppAssets.receiptPreview,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
          Container(color: const Color(0xA8000000)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      HeaderIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.of(context).pop(),
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        iconColor: Colors.white,
                      ),
                      const Spacer(),
                      Text(
                        'Quét hóa đơn',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      HeaderIconButton(
                        icon: Icons.flash_on_rounded,
                        onTap: () {},
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        iconColor: Colors.white,
                      ),
                    ],
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      final lineY = 180 + (_controller.value * 120);
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 300,
                            height: 380,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.28),
                              ),
                            ),
                          ),
                          Positioned(
                            top: lineY,
                            child: Container(
                              width: 250,
                              height: 3,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0x0000FFC2),
                                    Color(0xFF6FFBBE),
                                    Color(0x0000FFC2),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(99),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color(0x886FFBBE),
                                    blurRadius: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Đang mở camera và nhận diện hóa đơn',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Demo camera sẽ tự động chuyển sang màn kết quả OCR',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(),
                  Container(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(39),
                      border: Border.all(color: Colors.white, width: 3),
                    ),
                    child: Center(
                      child: Container(
                        width: 62,
                        height: 62,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
