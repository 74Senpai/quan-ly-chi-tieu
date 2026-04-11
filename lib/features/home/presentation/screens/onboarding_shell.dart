import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../data/home_demo_data.dart';
import '../widgets/home_components.dart';
import 'mode_selection_screen.dart';

class OnboardingShell extends StatefulWidget {
  const OnboardingShell({super.key});

  @override
  State<OnboardingShell> createState() => _OnboardingShellState();
}

class _OnboardingShellState extends State<OnboardingShell> {
  final PageController _pageController = PageController();
  double _scrollOffset = 0.0;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      if (_pageController.hasClients) {
        setState(() {
          _scrollOffset = _pageController.page ?? 0.0;
        });
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.of(context).pushReplacement(
        buildFadeSlideRoute(const ModeSelectionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      body: Stack(
        children: [
          // Base Background
          const Positioned.fill(child: HomeBackground(showTexture: true)),
          
          // Layer 1: Dynamic Glow Spots (Parallax)
          _GlowSpot(
            color: _getGlowColor(0),
            size: 400,
            top: 100 - (_scrollOffset * 40),
            left: -100 + (_scrollOffset * 30),
            opacity: 0.2 + (_scrollOffset * 0.1),
          ),
          _GlowSpot(
            color: _getGlowColor(1),
            size: 350,
            bottom: 100 + (_scrollOffset * 20),
            right: -50 - (_scrollOffset * 40),
            opacity: 0.15 + (math.max(0, 1 - _scrollOffset) * 0.1),
          ),
          
          // Layer 2: Center Aura (Changes with page)
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              width: size.width * 0.8,
              height: size.width * 0.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _getAuraColor().withValues(alpha: 0.12),
                    _getAuraColor().withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Background Backdrop for AI page (index 2)
          if (_scrollOffset > 1.0)
            Positioned.fill(
              child: Opacity(
                opacity: ((_scrollOffset - 1.0).clamp(0.0, 1.0) * 0.4),
                child: Image.network(
                  AppAssets.onboardingAiBackdrop,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),

          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                  child: const TopBrandBar(),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentPage = index),
                    children: [
                      _OfflineOnboardingView(onNext: _nextPage),
                      _CalendarOnboardingView(onNext: _nextPage),
                      _AiOnboardingView(onNext: _nextPage),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 64),
                  child: Column(
                    children: [
                      OnboardingProgress(index: _currentPage),
                      const SizedBox(height: 28),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: PrimaryBlueButton(
                          label: _getButtonLabel(),
                          icon: _currentPage == 0 ? null : Icons.arrow_forward_rounded,
                          onTap: _nextPage,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getButtonLabel() {
    switch (_currentPage) {
      case 0: return HomeDemoData.offlinePage.buttonText;
      case 1: return HomeDemoData.calendarPage.buttonText;
      case 2: return HomeDemoData.aiPage.buttonText;
      default: return 'Tiếp tục';
    }
  }
}

// --- PAGE 1: OFFLINE ---
class _OfflineOnboardingView extends StatelessWidget {
  final VoidCallback onNext;
  const _OfflineOnboardingView({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return _EntranceAnimation(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const Spacer(),
            _OfflineIllustration(),
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
          ],
        ),
      ),
    );
  }
}

class _OfflineIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  image: NetworkImage(AppAssets.onboardingOfflinePhoto),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// --- PAGE 2: CALENDAR ---
class _CalendarOnboardingView extends StatelessWidget {
  final VoidCallback onNext;
  const _CalendarOnboardingView({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return _EntranceAnimation(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _CalendarIllustration(),
            const SizedBox(height: 54),
            Text(
              HomeDemoData.calendarPage.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 30,
                fontWeight: FontWeight.w700,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),
            ...HomeDemoData.calendarPage.descriptionLines.map(
              (line) => Text(
                line,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xCC445D99),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CalendarIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F3FF),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A113069),
                blurRadius: 32,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Tháng 10',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  for (final icon in [
                    Icons.chevron_left_rounded,
                    Icons.chevron_right_rounded,
                  ]) ...[
                    Container(
                      width: 32,
                      height: 32,
                      margin: const EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E7FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 16, color: const Color(0xFF113069)),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN']
                    .map((day) => Text(
                          day,
                          style: TextStyle(color: Color(0x99445D99), fontSize: 10),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 12),
              _CalendarRow(
                days: const ['28', '29', '30', '1', '2', '3', '4'],
                selected: '1',
                dottedDays: const ['1'],
              ),
              const SizedBox(height: 8),
              _CalendarRow(
                days: const ['5', '6', '7', '8', '9', '10', '11'],
                selected: '6',
                dottedDays: const ['7', '9'],
              ),
            ],
          ),
        ),
        Positioned(
          left: -6,
          top: -16,
          child: Container(
            width: 172,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1A113069),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'TĂNG TRƯỞNG',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 10,
                        letterSpacing: 1,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.trending_up_rounded, size: 16, color: Color(0xFF006D4A)),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 48,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      _Bar(height: 20, color: Color(0x1A0053DB)),
                      _Bar(height: 30, color: Color(0x330053DB)),
                      _Bar(height: 25, color: Color(0x660053DB)),
                      _Bar(height: 40, color: Color(0x990053DB)),
                      _Bar(height: 48, color: Color(0xFF0053DB)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _CalendarRow extends StatelessWidget {
  const _CalendarRow({
    required this.days,
    required this.selected,
    required this.dottedDays,
  });

  final List<String> days;
  final String selected;
  final List<String> dottedDays;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) {
        final isSelected = day == selected;
        return Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0053DB) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: isSelected ? null : Border.all(color: const Color(0x1A98B1F2)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                day,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : const Color(0xFF113069),
                  fontSize: 11,
                ),
              ),
              if (dottedDays.contains(day))
                Positioned(
                  bottom: 3,
                  child: Container(
                    width: 3,
                    height: 3,
                    decoration: const BoxDecoration(color: Color(0xFF006D4A), shape: BoxShape.circle),
                  ),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.height, required this.color});
  final double height;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(2)),
        ),
      ),
    );
  }
}

// --- PAGE 3: AI ---
class _AiOnboardingView extends StatelessWidget {
  final VoidCallback onNext;
  const _AiOnboardingView({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return _EntranceAnimation(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          children: [
            const Spacer(),
            _AiIllustration(),
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
          ],
        ),
      ),
    );
  }
}

class _AiIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _WaveBar(32, Color(0xFF0053DB)),
                    _WaveBar(64, Color(0x990053DB)),
                    _WaveBar(80, Color(0x660053DB)),
                    _WaveBar(48, Color(0xCC0053DB)),
                    _WaveBar(70, Color(0xFF0053DB)),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: const Color(0xFF0053DB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.support_agent_rounded, size: 40, color: Colors.white),
              ),
            ],
          ),
        ),
        Positioned(
          left: -14,
          top: 36,
          child: _FloatingChip(icon: Icons.mic_none_rounded, text: '"Cà phê sáng 45k"'),
        ),
        Positioned(
          right: -18,
          bottom: 80,
          child: _FloatingChip(icon: Icons.insights_outlined, text: 'Phân tích chi tiêu'),
        ),
      ],
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
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1A98B1F2)),
        boxShadow: const [BoxShadow(color: Color(0x1A000000), blurRadius: 10)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0B7B59)),
          const SizedBox(width: 8),
          Text(text, style: GoogleFonts.inter(color: const Color(0xFF113069), fontSize: 11)),
        ],
      ),
    );
  }
}

// --- HELPERS ---
class _GlowSpot extends StatelessWidget {
  const _GlowSpot({
    required this.color,
    required this.size,
    this.top,
    this.left,
    this.bottom,
    this.right,
    required this.opacity,
  });

  final Color color;
  final double size;
  final double? top;
  final double? left;
  final double? bottom;
  final double? right;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
      top: top,
      left: left,
      bottom: bottom,
      right: right,
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 1000),
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: opacity),
                color.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

extension _OnboardingShellStateHelpers on _OnboardingShellState {
  Color _getGlowColor(int index) {
    if (_scrollOffset < 1.0) {
      // Transition from Green/Teal to Deep Blue
      return Color.lerp(
        const Color(0xFF006D4A),
        const Color(0xFF0053DB),
        _scrollOffset.clamp(0.0, 1.0),
      )!;
    } else {
      // Transition from Deep Blue to Indigo/Indigo-Purple (AI page)
      return Color.lerp(
        const Color(0xFF0053DB),
        const Color(0xFF4F46E5),
        (_scrollOffset - 1.0).clamp(0.0, 1.0),
      )!;
    }
  }

  Color _getAuraColor() {
    if (_scrollOffset < 1.0) {
      return const Color(0xFF0053DB);
    } else {
      return const Color(0xFF6366F1);
    }
  }
}

// --- CURATED ENTRANCE ANIMATION ---
class _EntranceAnimation extends StatelessWidget {
  final Widget child;
  const _EntranceAnimation({required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
