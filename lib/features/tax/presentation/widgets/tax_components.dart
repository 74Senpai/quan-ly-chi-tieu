import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

class TaxScreenShell extends StatelessWidget {
  const TaxScreenShell({super.key, required this.topBar, required this.child});

  final Widget topBar;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                topBar,
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaxTopBar extends StatelessWidget {
  const TaxTopBar({super.key, required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(12),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Color(0xFF0053DB),
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TaxActionButton extends StatelessWidget {
  const TaxActionButton({super.key, required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: const Color(0xFF0053DB),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TaxProgressRing extends StatelessWidget {
  const TaxProgressRing({
    super.key,
    required this.progress,
    required this.label,
  });

  final double progress;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size.square(128),
            painter: _TaxProgressRingPainter(progress: progress),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'TỶ LỆ',
                style: GoogleFonts.inter(
                  color: const Color(0xCCF8F7FF),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TaxTrendChart extends StatelessWidget {
  const TaxTrendChart({
    super.key,
    required this.values,
    required this.labels,
    required this.highlightedIndex,
    this.height = 208,
  });

  final List<double> values;
  final List<String> labels;
  final int highlightedIndex;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: height,
          child: CustomPaint(
            painter: _TaxTrendChartPainter(
              values: values,
              highlightedIndex: highlightedIndex,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(labels.length, (index) {
            final highlighted = index == highlightedIndex;
            return Container(
              padding: highlighted
                  ? const EdgeInsets.only(top: 10)
                  : EdgeInsets.zero,
              decoration: highlighted
                  ? const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFF0053DB), width: 2),
                      ),
                    )
                  : null,
              child: Text(
                labels[index],
                style: GoogleFonts.inter(
                  color: highlighted
                      ? const Color(0xFF0053DB)
                      : const Color(0xFF98B1F2),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.55,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _TaxProgressRingPainter extends CustomPainter {
  _TaxProgressRingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 8.0;
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = const Color(0x33FFFFFF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -math.pi / 2, math.pi * 2, false, trackPaint);

    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF6FFBBE), Color(0xFF76FFD0)],
      ).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      math.pi * 2 * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _TaxProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _TaxTrendChartPainter extends CustomPainter {
  _TaxTrendChartPainter({required this.values, required this.highlightedIndex});

  final List<double> values;
  final int highlightedIndex;

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) {
      return;
    }

    const topPadding = 14.0;
    const bottomPadding = 20.0;
    final drawableHeight = size.height - topPadding - bottomPadding;
    final stepX = size.width / (values.length - 1);
    final maxValue = values.reduce(math.max);
    final minValue = values.reduce(math.min);
    final range = math.max(maxValue - minValue, 1.0);

    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final normalized = (values[i] - minValue) / range;
      final x = i * stepX;
      final y = topPadding + (1 - normalized) * drawableHeight;
      points.add(Offset(x, y));
    }

    final gridPaint = Paint()
      ..color = const Color(0x1A98B1F2)
      ..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = topPadding + (drawableHeight / 3) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final areaPath = Path()
      ..moveTo(points.first.dx, size.height - bottomPadding)
      ..lineTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final controlX = (previous.dx + current.dx) / 2;
      areaPath.cubicTo(
        controlX,
        previous.dy,
        controlX,
        current.dy,
        current.dx,
        current.dy,
      );
    }
    areaPath
      ..lineTo(points.last.dx, size.height - bottomPadding)
      ..close();

    final areaPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x330053DB), Color(0x080053DB)],
      ).createShader(Rect.fromLTWH(0, topPadding, size.width, drawableHeight));
    canvas.drawPath(areaPath, areaPaint);

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final current = points[i];
      final controlX = (previous.dx + current.dx) / 2;
      linePath.cubicTo(
        controlX,
        previous.dy,
        controlX,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    final linePaint = Paint()
      ..color = const Color(0xFF0053DB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(linePath, linePaint);

    final fillPaint = Paint()..color = Colors.white;
    final borderPaint = Paint()
      ..color = const Color(0xFF0053DB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (var i = 0; i < points.length; i++) {
      final radius = i == highlightedIndex ? 7.0 : 6.0;
      canvas.drawCircle(points[i], radius, fillPaint);
      canvas.drawCircle(points[i], radius, borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _TaxTrendChartPainter oldDelegate) {
    return oldDelegate.values != values ||
        oldDelegate.highlightedIndex != highlightedIndex;
  }
}
