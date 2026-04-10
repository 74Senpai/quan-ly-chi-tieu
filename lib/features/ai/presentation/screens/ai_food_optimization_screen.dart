import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../budgets/presentation/screens/budget_overview_screen.dart';
import '../../../home/presentation/widgets/home_components.dart';

class AiFoodOptimizationScreen extends StatelessWidget {
  const AiFoodOptimizationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Tối ưu hóa ăn uống',
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WEEKLY INSIGHT',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0053DB),
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text.rich(
                              TextSpan(
                                style: GoogleFonts.manrope(
                                  color: const Color(0xFF113069),
                                  fontSize: 36,
                                  height: 1.25,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.9,
                                ),
                                children: [
                                  const TextSpan(text: 'Chi tiêu ăn uống\n'),
                                  TextSpan(
                                    text: 'tăng 15%',
                                    style: GoogleFonts.manrope(
                                      color: const Color(0xFF9F403D),
                                      fontSize: 36,
                                      height: 1.25,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.9,
                                    ),
                                  ),
                                  const TextSpan(text: ' so với tuần\ntrước.'),
                                ],
                              ),
                            ),
                            const SizedBox(height: 18),
                            _BudgetProgressCard(
                              used: 4250000,
                              limit: 5000000,
                              percent: 0.85,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'So sánh chi tiêu',
                                    style: GoogleFonts.manrope(
                                      color: const Color(0xFF113069),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2E7FF),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '7 ngày qua',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF445D99),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _CompareBarsCard(
                              leftLabel: 'Tuần trước',
                              rightLabel: 'Tuần này',
                              leftValue: 1.0,
                              rightValue: 1.15,
                              badgeText: '+15% Tăng trưởng',
                            ),
                            const SizedBox(height: 18),
                            Text(
                              'Gợi ý nhanh',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF113069),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const _TipTile(
                              icon: Icons.restaurant_menu_rounded,
                              title: 'Nấu ăn tại nhà',
                              body:
                                  'Chọn 2 bữa trong tuần để tự nấu. Trung bình tiết kiệm 10–20% chi phí.',
                            ),
                            const SizedBox(height: 12),
                            const _TipTile(
                              icon: Icons.list_alt_rounded,
                              title: 'Lên danh sách đi chợ',
                              body:
                                  "Sử dụng tính năng 'Grocery List' để tránh mua sắm quá đà.",
                            ),
                            const SizedBox(height: 12),
                            const _TipTile(
                              icon: Icons.local_offer_outlined,
                              title: 'Săn ưu đãi',
                              body:
                                  'Ưu tiên quán ăn có khuyến mãi theo giờ hoặc giảm giá theo combo.',
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        left: 24,
                        right: 24,
                        bottom: 24,
                        child: _BottomCta(
                          label: 'Đặt giới hạn chi tiêu ăn uống',
                          onTap: () {
                            Navigator.of(context).push(
                              buildFadeSlideRoute(const BudgetOverviewScreen()),
                            );
                          },
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
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF113069),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.9,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetProgressCard extends StatelessWidget {
  const _BudgetProgressCard({
    required this.used,
    required this.limit,
    required this.percent,
  });

  final int used;
  final int limit;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A113069),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ngân sách đã dùng',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _money(used),
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hạn mức:',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _money(limit),
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: percent.clamp(0, 1),
              minHeight: 16,
              backgroundColor: const Color(0xFFEAEDFF),
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFF0053DB),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Bạn đã sử dụng ${(percent * 100).round()}% hạn mức của tháng này.',
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  String _money(int amount) {
    final digits = amount.abs().toString();
    final buffer = StringBuffer();
    for (var index = 0; index < digits.length; index++) {
      final reverseIndex = digits.length - index;
      buffer.write(digits[index]);
      if (reverseIndex > 1 && reverseIndex % 3 == 1) buffer.write('.');
    }
    return '${buffer.toString()}đ';
  }
}

class _CompareBarsCard extends StatelessWidget {
  const _CompareBarsCard({
    required this.leftLabel,
    required this.rightLabel,
    required this.leftValue,
    required this.rightValue,
    required this.badgeText,
  });

  final String leftLabel;
  final String rightLabel;
  final double leftValue;
  final double rightValue;
  final String badgeText;

  @override
  Widget build(BuildContext context) {
    final maxValue = math.max(leftValue, rightValue);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF113069),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badgeText,
                style: GoogleFonts.inter(
                  color: const Color(0xFFF8F7FF),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 180,
            child: Row(
              children: [
                Expanded(
                  child: _Bar(
                    label: leftLabel,
                    value: leftValue / maxValue,
                    color: const Color(0xFFDBE1FF),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: _Bar(
                    label: rightLabel,
                    value: rightValue / maxValue,
                    color: const Color(0xFF0053DB),
                    shadow: true,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.label,
    required this.value,
    required this.color,
    this.shadow = false,
  });

  final String label;
  final double value;
  final Color color;
  final bool shadow;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 86,
              height: (value.clamp(0, 1) * 160).toDouble(),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
                boxShadow: shadow
                    ? const [
                        BoxShadow(
                          color: Color(0x330053DB),
                          blurRadius: 18,
                          offset: Offset(0, 12),
                        ),
                      ]
                    : null,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF445D99),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _BottomCta extends StatelessWidget {
  const _BottomCta({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      width: double.infinity,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF0053DB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 10,
          shadowColor: const Color(0x330053DB),
        ),
        icon: const Icon(
          Icons.settings_suggest_rounded,
          color: Color(0xFFF8F7FF),
        ),
        label: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: GoogleFonts.inter(
            color: const Color(0xFFF8F7FF),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _TipTile extends StatelessWidget {
  const _TipTile({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFDBE1FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: const Color(0xFF0053DB)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  body,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 12,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
