import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

class SavingsAnalysisScreen extends StatelessWidget {
  const SavingsAnalysisScreen({super.key});

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
                  title: 'Phân tích tích lũy',
                  onBack: () => Navigator.of(context).pop(),
                  onBell: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Thông báo đang được hoàn thiện.'),
                        ),
                      );
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Phân tích Tích lũy',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.75,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _Badge(
                              background: const Color(0x806FFBBE),
                              icon: Icons.check_circle_outline_rounded,
                              text: 'Đạt 50% mục tiêu!',
                              textColor: const Color(0xFF005E3F),
                              iconColor: const Color(0xFF006D4A),
                            ),
                            const SizedBox(width: 8),
                            _Badge(
                              background: const Color(0x80DBE1FF),
                              icon: Icons.local_fire_department_outlined,
                              text: '3 tháng liên tiếp',
                              textColor: const Color(0xFF0048BF),
                              iconColor: const Color(0xFF0053DB),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _GaugeCard(
                          percent: 0.65,
                          subtitle:
                              'Tỷ lệ tiết kiệm tháng này đã tăng 12% so với tháng trước',
                        ),
                        const SizedBox(height: 16),
                        _GoalProgressCard(
                          progress: 0.50,
                          saved: 12500000,
                          goal: 25000000,
                        ),
                        const SizedBox(height: 15),
                        const _DataTile(
                          iconBackground: Color(0x806FFBBE),
                          icon: Icons.trending_up_rounded,
                          label: 'TIẾT KIỆM RÒNG',
                          value: '+2.4M',
                          valueColor: Color(0xFF006D4A),
                        ),
                        const SizedBox(height: 15),
                        const _DataTile(
                          iconBackground: Color(0x4DFE8983),
                          icon: Icons.query_stats_rounded,
                          label: 'DỰ BÁO T1',
                          value: '1.8M',
                          valueColor: Color(0xFF113069),
                        ),
                      ],
                    ),
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
  const _TopBar({
    required this.title,
    required this.onBack,
    required this.onBell,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onBell;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBell,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Color(0xFF0053DB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.background,
    required this.icon,
    required this.text,
    required this.textColor,
    required this.iconColor,
  });

  final Color background;
  final IconData icon;
  final String text;
  final Color textColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 14),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugeCard extends StatelessWidget {
  const _GaugeCard({required this.percent, required this.subtitle});

  final double percent;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A113069),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 192,
            height: 112,
            child: CustomPaint(
              painter: _SemiGaugePainter(value: percent),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(percent * 100).round()}%',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF0053DB),
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'SAVINGS RATE',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF445D99),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 14,
              height: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _SemiGaugePainter extends CustomPainter {
  _SemiGaugePainter({required this.value});

  final double value;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = math.min(size.width / 2, size.height) - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = const Color(0xFFF2F3FF)
      ..strokeCap = StrokeCap.round;

    final valuePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = const Color(0xFF0053DB)
      ..strokeCap = StrokeCap.round;

    const start = math.pi;
    const sweep = math.pi;
    canvas.drawArc(rect, start, sweep, false, bgPaint);
    canvas.drawArc(rect, start, sweep * value.clamp(0, 1), false, valuePaint);
  }

  @override
  bool shouldRepaint(covariant _SemiGaugePainter oldDelegate) =>
      oldDelegate.value != value;
}

class _GoalProgressCard extends StatelessWidget {
  const _GoalProgressCard({
    required this.progress,
    required this.saved,
    required this.goal,
  });

  final double progress;
  final int saved;
  final int goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress.clamp(0, 1),
                  strokeWidth: 6,
                  backgroundColor: const Color(0xFFE7EDFF),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF006D4A),
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF113069),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIẾN ĐỘ MỤC TIÊU',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text.rich(
                  TextSpan(
                    style: GoogleFonts.inter(
                      color: const Color(0xFF113069),
                      fontSize: 14,
                      height: 1.35,
                      fontWeight: FontWeight.w700,
                    ),
                    children: [
                      const TextSpan(text: 'Đã tiết kiệm '),
                      TextSpan(
                        text: _money(saved),
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0053DB),
                          fontSize: 14,
                          height: 1.35,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Mục tiêu: ${_money(goal)}',
                  style: GoogleFonts.inter(
                    color: const Color(0xB3445D99),
                    fontSize: 12,
                  ),
                ),
              ],
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

class _DataTile extends StatelessWidget {
  const _DataTile({
    required this.iconBackground,
    required this.icon,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final Color iconBackground;
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF113069)),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: GoogleFonts.manrope(
                    color: valueColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
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
