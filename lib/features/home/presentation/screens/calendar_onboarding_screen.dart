import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/home_demo_data.dart';
import '../widgets/home_components.dart';
import 'ai_onboarding_screen.dart';

class CalendarOnboardingScreen extends StatelessWidget {
  const CalendarOnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
              child: Column(
                children: [
                  const TopBrandBar(),
                  const SizedBox(height: 36),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.fromLTRB(
                                  24,
                                  24,
                                  24,
                                  110,
                                ),
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
                                            margin: const EdgeInsets.only(
                                              left: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE2E7FF),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              icon,
                                              size: 16,
                                              color: const Color(0xFF113069),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children:
                                          const [
                                                'T2',
                                                'T3',
                                                'T4',
                                                'T5',
                                                'T6',
                                                'T7',
                                                'CN',
                                              ]
                                              .map(
                                                (day) => Text(
                                                  day,
                                                  style: TextStyle(
                                                    color: Color(0x99445D99),
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                    ),
                                    const SizedBox(height: 12),
                                    _CalendarRow(
                                      days: const [
                                        '28',
                                        '29',
                                        '30',
                                        '1',
                                        '2',
                                        '3',
                                        '4',
                                      ],
                                      selected: '1',
                                      dottedDays: const ['1'],
                                    ),
                                    const SizedBox(height: 8),
                                    _CalendarRow(
                                      days: const [
                                        '5',
                                        '6',
                                        '7',
                                        '8',
                                        '9',
                                        '10',
                                        '11',
                                      ],
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
                                  width: 192,
                                  padding: const EdgeInsets.all(17),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          const Icon(
                                            Icons.trending_up_rounded,
                                            size: 16,
                                            color: Color(0xFF006D4A),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        height: 64,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: const [
                                            _Bar(
                                              height: 26,
                                              color: Color(0x1A0053DB),
                                            ),
                                            _Bar(
                                              height: 38,
                                              color: Color(0x330053DB),
                                            ),
                                            _Bar(
                                              height: 32,
                                              color: Color(0x660053DB),
                                            ),
                                            _Bar(
                                              height: 52,
                                              color: Color(0x990053DB),
                                            ),
                                            _Bar(
                                              height: 64,
                                              color: Color(0xFF0053DB),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: -2,
                                bottom: -10,
                                child: Transform.rotate(
                                  angle: 0.05,
                                  child: Container(
                                    width: 176,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0053DB),
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x33000000),
                                          blurRadius: 18,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.payments_outlined,
                                              color: Colors.white,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'CHI TIÊU',
                                              style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontSize: 10,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '- 1.250.000 đ',
                                          style: GoogleFonts.manrope(
                                            color: Colors.white,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'Cafe & Ăn uống',
                                          style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontSize: 9,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 90),
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
                        const Spacer(),
                        const OnboardingProgress(index: 1),
                        const SizedBox(height: 28),
                        PrimaryBlueButton(
                          label: HomeDemoData.calendarPage.buttonText,
                          icon: Icons.arrow_forward_rounded,
                          onTap: () {
                            Navigator.of(context).push(
                              buildFadeSlideRoute(const AiOnboardingScreen()),
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
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF0053DB) : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: isSelected
                ? null
                : Border.all(color: const Color(0x1A98B1F2)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                day,
                style: GoogleFonts.inter(
                  color: isSelected ? Colors.white : const Color(0xFF113069),
                  fontSize: 12,
                ),
              ),
              if (dottedDays.contains(day))
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: const BoxDecoration(
                      color: Color(0xFF006D4A),
                      shape: BoxShape.circle,
                    ),
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
