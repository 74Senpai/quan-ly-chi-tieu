import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/ai_demo_data.dart';
import '../widgets/assistant_components.dart';
import 'voice_transaction_screen.dart';

class VoiceListeningScreen extends StatefulWidget {
  const VoiceListeningScreen({super.key});

  @override
  State<VoiceListeningScreen> createState() => _VoiceListeningScreenState();
}

class _VoiceListeningScreenState extends State<VoiceListeningScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _transitionTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    _transitionTimer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(buildFadeSlideRoute(const VoiceTransactionScreen()));
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
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
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
                      ),
                      const Spacer(),
                      Text(
                        'Đang lắng nghe',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF0F172A),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const Spacer(),
                      HeaderIconButton(
                        icon: Icons.close_rounded,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return SizedBox(
                        width: 240,
                        height: 240,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            for (final factor in [1.0, 0.72, 0.44])
                              PulseRing(
                                progress: (_controller.value + factor) % 1,
                              ),
                            Container(
                              width: 108,
                              height: 108,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF0053DB),
                                    Color(0xFF0048C1),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(28),
                              ),
                              child: const Icon(
                                Icons.mic_rounded,
                                color: Colors.white,
                                size: 42,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Hãy nói khoản chi của bạn',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Demo animation nhận diện giọng nói đang hoạt động',
                    style: GoogleFonts.inter(
                      color: const Color(0xCC445D99),
                      fontSize: 14,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) =>
                        VoiceWaveBars(progress: _controller.value),
                  ),
                  const SizedBox(height: 28),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.88),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0x3398B1F2)),
                    ),
                    child: Text(
                      '“${AiDemoData.voiceTranscript}”',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF113069),
                        fontSize: 16,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Đang xử lý và chuẩn bị xác nhận giao dịch...',
                    style: GoogleFonts.inter(
                      color: const Color(0x99445D99),
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
