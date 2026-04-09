import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

class FinancialForecastScreen extends StatelessWidget {
  const FinancialForecastScreen({super.key});

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
                  title: 'Dự báo tài chính',
                  onBack: () => Navigator.of(context).pop(),
                  onSearch: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        const SnackBar(
                          content: Text('Tìm kiếm đang được hoàn thiện.'),
                        ),
                      );
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'XU HƯỚNG TÀI SẢN',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                'Dự báo 6 tháng\ntới',
                                style: GoogleFonts.manrope(
                                  color: const Color(0xFF113069),
                                  fontSize: 36,
                                  height: 1.12,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.9,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '+12.5%',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF006D4A),
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'so với hiện\n tại',
                                  textAlign: TextAlign.right,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF445D99),
                                    fontSize: 12,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const _ForecastChartCard(
                          selectedValue: '170.000.000đ',
                          xLabels: [
                            'T04',
                            'T05',
                            'T06 (Dự kiến)',
                            'T07',
                            'T08',
                            'T09',
                          ],
                        ),
                        const SizedBox(height: 18),
                        _InsightCard(
                          onOptimize: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Đang tối ưu thêm theo gợi ý AI...',
                                  ),
                                ),
                              );
                          },
                          onDetails: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Chi tiết đang được hoàn thiện.',
                                  ),
                                ),
                              );
                          },
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
    required this.onSearch,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.2,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onSearch,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.search_rounded, color: Color(0xFF0053DB)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastChartCard extends StatelessWidget {
  const _ForecastChartCard({
    required this.selectedValue,
    required this.xLabels,
  });

  final String selectedValue;
  final List<String> xLabels;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 140,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Positioned.fill(child: _ForecastLineChart()),
                Positioned(
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF113069),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      selectedValue,
                      style: GoogleFonts.inter(
                        color: const Color(0xFFF8F7FF),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final label in xLabels)
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: label.contains('Dự kiến')
                          ? const Color(0xFF0053DB)
                          : const Color(0xFF445D99),
                      fontSize: 12,
                      fontWeight: label.contains('Dự kiến')
                          ? FontWeight.w800
                          : FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ForecastLineChart extends StatelessWidget {
  const _ForecastLineChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _ForecastLinePainter());
  }
}

class _ForecastLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(10, 18, size.width - 20, size.height - 40);
    final gridPaint = Paint()
      ..color = const Color(0x1A98B1F2)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(rect.left, rect.top),
      Offset(rect.right, rect.top),
      gridPaint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.center.dy),
      Offset(rect.right, rect.center.dy),
      gridPaint,
    );
    canvas.drawLine(
      Offset(rect.left, rect.bottom),
      Offset(rect.right, rect.bottom),
      gridPaint,
    );

    final values = <double>[0.40, 0.42, 0.48, 0.62, 0.68, 0.67];
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = rect.left + (rect.width / (values.length - 1)) * i;
      final y = rect.bottom - (values[i].clamp(0, 1) * rect.height);
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }

    final fillPath = Path()
      ..moveTo(points.first.dx, rect.bottom)
      ..lineTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath.lineTo(points.last.dx, rect.bottom);
    fillPath.close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0053DB).withValues(alpha: 0.20),
          const Color(0xFF0053DB).withValues(alpha: 0.0),
        ],
      ).createShader(rect);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF0053DB)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, linePaint);

    final dotPaint = Paint()..color = const Color(0xFF0053DB);
    for (final p in points) {
      canvas.drawCircle(p, 2.8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.onOptimize, required this.onDetails});

  final VoidCallback onOptimize;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF0053DB),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330053DB),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFFB7F0FF),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'INSIGHT AI',
                style: GoogleFonts.inter(
                  color: const Color(0xFFB7F0FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Bạn sẽ hoàn thành\nhết mục tiêu vào\nngày 15/08/2026',
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 30,
              height: 1.15,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.9,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Dựa trên tốc độ tiết kiệm hiện tại (15tr/tháng), bạn đang đi nhanh hơn kế hoạch 2 tháng.',
            style: GoogleFonts.inter(
              color: const Color(0xCCF8F7FF),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: FilledButton(
                    onPressed: onOptimize,
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Tối ưu thêm',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0053DB),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: OutlinedButton(
                    onPressed: onDetails,
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'Chi tiết',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
