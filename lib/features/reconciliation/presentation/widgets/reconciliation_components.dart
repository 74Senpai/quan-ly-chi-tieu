import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';
import '../../data/reconciliation_demo_data.dart';

class ReconciliationScreenShell extends StatelessWidget {
  const ReconciliationScreenShell({
    super.key,
    required this.topBar,
    required this.child,
  });

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

class ReconciliationTopBar extends StatelessWidget {
  const ReconciliationTopBar({
    super.key,
    required this.title,
    required this.onBack,
    this.trailing,
  });

  final String title;
  final VoidCallback onBack;
  final Widget? trailing;

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
          if (trailing case final Widget trailingWidget) trailingWidget,
        ],
      ),
    );
  }
}

class ReconciliationLegend extends StatelessWidget {
  const ReconciliationLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        _LegendDot(color: Color(0xFF0053DB)),
        SizedBox(width: 6),
        Text(
          'APP',
          style: TextStyle(
            color: Color(0xFF113069),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
        SizedBox(width: 16),
        _LegendDot(color: Color(0xFFDBE1FF)),
        SizedBox(width: 6),
        Text(
          'THỰC TẾ',
          style: TextStyle(
            color: Color(0xFF445D99),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.6,
          ),
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}

class ReconciliationComparisonChart extends StatelessWidget {
  const ReconciliationComparisonChart({super.key, required this.pairs});

  final List<ReconciliationBarPair> pairs;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: CustomPaint(painter: _ReconciliationBarsPainter(pairs: pairs)),
    );
  }
}

class _ReconciliationBarsPainter extends CustomPainter {
  _ReconciliationBarsPainter({required this.pairs});

  final List<ReconciliationBarPair> pairs;

  @override
  void paint(Canvas canvas, Size size) {
    if (pairs.isEmpty) return;

    const leftPadding = 10.0;
    const rightPadding = 10.0;
    const topPadding = 8.0;
    const bottomPadding = 30.0;
    final chartWidth = size.width - leftPadding - rightPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    final step = chartWidth / pairs.length;
    final barWidth = math.min(18.0, step / 3);
    final gap = 8.0;

    final appPaint = Paint()..color = const Color(0xFF0053DB);
    final actualPaint = Paint()..color = const Color(0xFFDBE1FF);

    final labelStyle = GoogleFonts.inter(
      color: const Color(0xFF445D99),
      fontSize: 10,
      fontWeight: FontWeight.w600,
    );

    for (var i = 0; i < pairs.length; i++) {
      final pair = pairs[i];
      final centerX = leftPadding + step * i + step / 2;
      final appHeight = chartHeight * pair.appValue.clamp(0.0, 1.0);
      final actualHeight = chartHeight * pair.actualValue.clamp(0.0, 1.0);

      final appRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX - gap / 2 - barWidth,
          topPadding + (chartHeight - appHeight),
          barWidth,
          appHeight,
        ),
        const Radius.circular(10),
      );
      final actualRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          centerX + gap / 2,
          topPadding + (chartHeight - actualHeight),
          barWidth,
          actualHeight,
        ),
        const Radius.circular(10),
      );
      canvas.drawRRect(actualRect, actualPaint);
      canvas.drawRRect(appRect, appPaint);

      final tp = TextPainter(
        text: TextSpan(text: pair.label, style: labelStyle),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: step);
      tp.paint(
        canvas,
        Offset(centerX - tp.width / 2, size.height - bottomPadding + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ReconciliationBarsPainter oldDelegate) {
    return oldDelegate.pairs != pairs;
  }
}
