import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

class AiBillAlertScreen extends StatelessWidget {
  const AiBillAlertScreen({super.key});

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
                  title: 'Cảnh báo hóa đơn',
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Cảnh báo hóa đơn',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.75,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Phân tích chi tiêu từ Trí tuệ nhân tạo (AI)',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _AlertCard(
                          onReview: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Đang xem xét mức tiêu thụ năng lượng...',
                                  ),
                                ),
                              );
                          },
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: [
                            Text(
                              'Sắp đến hạn',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF113069),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
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
                                '3 hóa đơn',
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
                        const _BillTile(
                          icon: Icons.flash_on_rounded,
                          title: 'Tiền điện sinh hoạt',
                          subtitle: 'Dự báo +20% tháng tới',
                          amount: '1.250.000đ',
                        ),
                        const SizedBox(height: 12),
                        const _BillTile(
                          icon: Icons.water_drop_rounded,
                          title: 'Tiền nước sinh hoạt',
                          subtitle: '-5% giảm',
                          amount: '85.000đ',
                        ),
                        const SizedBox(height: 12),
                        const _BillTile(
                          icon: Icons.wifi_rounded,
                          title: 'Internet',
                          subtitle: 'Ổn định',
                          amount: '240.000đ',
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
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.onReview});

  final VoidCallback onReview;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x1A98B1F2)),
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
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0x33FE8983),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFF9F403D),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dự báo chi phí điện tăng',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Dự kiến hóa đơn tiền điện tháng tới sẽ tăng 20% dựa trên số liệu lịch sử.',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const SizedBox(
            height: 192,
            width: double.infinity,
            child: _BillLineChart(),
          ),
          const SizedBox(height: 16),
          _AdviceBox(
            text:
                'Kiểm tra các thiết bị tiêu thụ điện năng cao hoặc cân nhắc sử dụng chế độ tiết kiệm điện. Việc tối ưu hóa điều hòa trong giờ cao điểm có thể giúp giảm tới 15% hóa đơn.',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 64,
            child: FilledButton(
              onPressed: onReview,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0053DB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Xem xét mức tiêu thụ năng\nlượng',
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  color: const Color(0xFFF8F7FF),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdviceBox extends StatelessWidget {
  const _AdviceBox({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF0053DB),
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF0053DB)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Lời khuyên AI: $text',
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 12,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillLineChart extends StatelessWidget {
  const _BillLineChart();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _LineChartPainter());
  }
}

class _LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final padding = const EdgeInsets.fromLTRB(10, 18, 10, 22);
    final rect = Rect.fromLTWH(
      padding.left,
      padding.top,
      size.width - padding.left - padding.right,
      size.height - padding.top - padding.bottom,
    );

    final gridPaint = Paint()
      ..color = const Color(0x1A98B1F2)
      ..strokeWidth = 1;
    for (var i = 0; i < 3; i++) {
      final y = rect.top + (rect.height / 3) * i;
      canvas.drawLine(Offset(rect.left, y), Offset(rect.right, y), gridPaint);
    }

    final values = <double>[0.55, 0.58, 0.52, 0.62, 0.64, 0.78];
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = rect.left + (rect.width / (values.length - 1)) * i;
      final y = rect.bottom - (values[i].clamp(0, 1) * rect.height);
      points.add(Offset(x, y));
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
          const Color(0xFF0053DB).withValues(alpha: 0.16),
          const Color(0xFF0053DB).withValues(alpha: 0.0),
        ],
      ).createShader(rect);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF0053DB)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final dashedPaint = Paint()
      ..color = const Color(0xFF0053DB)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final solidPath = Path()..moveTo(points[0].dx, points[0].dy);
    for (var i = 1; i < points.length - 1; i++) {
      solidPath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(solidPath, linePaint);

    final last = points.last;
    final beforeLast = points[points.length - 2];
    _drawDashedLine(canvas, beforeLast, last, dashedPaint);

    for (var i = 0; i < points.length - 1; i++) {
      final paint = Paint()
        ..color = const Color(0xFF0053DB)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(points[i], 3.2, paint);
    }
  }

  void _drawDashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dash = 6.0;
    const gap = 4.0;
    final distance = (b - a).distance;
    final direction = (b - a) / distance;
    var start = 0.0;
    while (start < distance) {
      final end = math.min(start + dash, distance);
      canvas.drawLine(a + direction * start, a + direction * end, paint);
      start += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _BillTile extends StatelessWidget {
  const _BillTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amount,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('Mở hóa đơn: $title')));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
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
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                amount,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
