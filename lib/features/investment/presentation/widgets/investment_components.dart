import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

class InvestmentTopBar extends StatelessWidget {
  const InvestmentTopBar({
    super.key,
    required this.title,
    required this.onBack,
    this.trailing,
    this.compact = false,
  });

  final String title;
  final VoidCallback onBack;
  final Widget? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: compact ? 64 : 70,
      padding: EdgeInsets.fromLTRB(24, compact ? 16 : 20, 24, 16),
      child: Row(
        children: [
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                compact
                    ? Icons.arrow_back_ios_new_rounded
                    : Icons.close_rounded,
                color: const Color(0xFF33539B),
                size: compact ? 16 : 22,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: compact ? 18 : 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
          if (trailing case final Widget trailingWidget) trailingWidget,
        ],
      ),
    );
  }
}

class InvestmentScreenShell extends StatelessWidget {
  const InvestmentScreenShell({
    super.key,
    required this.topBar,
    required this.child,
    this.bottomBar,
    this.floatingActionButton,
  });

  final Widget topBar;
  final Widget child;
  final Widget? bottomBar;
  final Widget? floatingActionButton;

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
          if (bottomBar case final Widget bar)
            Positioned(left: 0, right: 0, bottom: 0, child: bar),
          if (floatingActionButton case final Widget fab) fab,
        ],
      ),
    );
  }
}

class InvestmentSectionTitle extends StatelessWidget {
  const InvestmentSectionTitle({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
    this.horizontalPadding = 0,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          if (actionLabel != null)
            TextButton(
              onPressed: onActionTap,
              child: Text(
                actionLabel!,
                style: GoogleFonts.inter(
                  color: const Color(0xFF0053DB),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class InvestmentPill extends StatelessWidget {
  const InvestmentPill({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    this.icon,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: foreground, size: 14),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: GoogleFonts.inter(
              color: foreground,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class InvestmentValueChip extends StatelessWidget {
  const InvestmentValueChip({
    super.key,
    required this.label,
    required this.positive,
  });

  final String label;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return InvestmentPill(
      label: label,
      icon: Icons.trending_up_rounded,
      background: positive ? const Color(0x336FFBBE) : const Color(0x33FE8983),
      foreground: positive ? const Color(0xFF006D4A) : const Color(0xFF9F403D),
    );
  }
}

class InvestmentSegmentTabs extends StatelessWidget {
  const InvestmentSegmentTabs({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.compact = false,
  });

  final List<String> options;
  final String selected;
  final ValueChanged<String> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          for (final option in options) ...[
            GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: EdgeInsets.symmetric(
                  horizontal: compact ? 12 : 16,
                  vertical: compact ? 4 : 8,
                ),
                decoration: BoxDecoration(
                  color: option == selected
                      ? const Color(0xFF0053DB)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(compact ? 8 : 12),
                  boxShadow: option == selected
                      ? const [
                          BoxShadow(
                            color: Color(0x260053DB),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Text(
                  option,
                  style: GoogleFonts.inter(
                    color: option == selected
                        ? Colors.white
                        : const Color(0xFF445D99),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class InvestmentLineChart extends StatelessWidget {
  const InvestmentLineChart({
    super.key,
    required this.values,
    required this.labels,
    this.height = 180,
    this.gradient = const [Color(0xFF0D57DA), Color(0xFFCAD7FB)],
    this.lineColor = const Color(0xFF0D57DA),
    this.showArea = true,
  });

  final List<double> values;
  final List<String> labels;
  final double height;
  final List<Color> gradient;
  final Color lineColor;
  final bool showArea;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height,
          width: double.infinity,
          child: CustomPaint(
            painter: _InvestmentLineChartPainter(
              values: values,
              gradient: gradient,
              lineColor: lineColor,
              showArea: showArea,
            ),
          ),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (final label in labels)
              Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0x8098B1F2),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _InvestmentLineChartPainter extends CustomPainter {
  const _InvestmentLineChartPainter({
    required this.values,
    required this.gradient,
    required this.lineColor,
    required this.showArea,
  });

  final List<double> values;
  final List<Color> gradient;
  final Color lineColor;
  final bool showArea;

  @override
  void paint(Canvas canvas, Size size) {
    final chartRect = Rect.fromLTWH(0, 6, size.width, size.height - 12);
    final gridPaint = Paint()
      ..color = const Color(0x1498B1F2)
      ..strokeWidth = 1;

    for (final ratio in [0.2, 0.55, 0.9]) {
      final y = chartRect.top + chartRect.height * ratio;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

    if (values.length < 2) return;

    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = chartRect.left + (chartRect.width / (values.length - 1)) * i;
      final y = chartRect.bottom - chartRect.height * values[i];
      points.add(Offset(x, y));
    }

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 0; i < points.length - 1; i++) {
      final current = points[i];
      final next = points[i + 1];
      final controlX = (current.dx + next.dx) / 2;
      linePath.cubicTo(
        controlX,
        current.dy,
        controlX,
        next.dy,
        next.dx,
        next.dy,
      );
    }

    if (showArea) {
      final fillPath = Path.from(linePath)
        ..lineTo(points.last.dx, chartRect.bottom)
        ..lineTo(points.first.dx, chartRect.bottom)
        ..close();
      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            gradient.first.withValues(alpha: 0.24),
            gradient.last.withValues(alpha: 0.06),
          ],
        ).createShader(chartRect);
      canvas.drawPath(fillPath, fillPaint);
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round
      ..shader = LinearGradient(colors: gradient).createShader(chartRect);
    canvas.drawPath(linePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant _InvestmentLineChartPainter oldDelegate) =>
      oldDelegate.values != values ||
      oldDelegate.gradient != gradient ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.showArea != showArea;
}

class InvestmentCandlestickChart extends StatelessWidget {
  const InvestmentCandlestickChart({
    super.key,
    required this.bars,
    this.highlightIndex = 7,
  });

  final List<double> bars;
  final int highlightIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 272,
      width: double.infinity,
      child: CustomPaint(
        painter: _InvestmentCandlestickPainter(
          bars: bars,
          highlightIndex: highlightIndex,
        ),
      ),
    );
  }
}

class _InvestmentCandlestickPainter extends CustomPainter {
  const _InvestmentCandlestickPainter({
    required this.bars,
    required this.highlightIndex,
  });

  final List<double> bars;
  final int highlightIndex;

  @override
  void paint(Canvas canvas, Size size) {
    final chartRect = Rect.fromLTWH(0, 16, size.width, size.height - 16);
    final gridPaint = Paint()
      ..color = const Color(0x0D113069)
      ..strokeWidth = 1;
    for (final ratio in [0.0, 0.33, 0.66, 0.99]) {
      final y = chartRect.top + chartRect.height * ratio;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }

    final positivePaint = Paint()..color = const Color(0xFF006D4A);
    final negativePaint = Paint()..color = const Color(0xFF9F403D);
    final groupWidth = size.width / math.max(1, bars.length);

    for (var i = 0; i < bars.length; i++) {
      final barHeight = chartRect.height * bars[i];
      final x = groupWidth * i + groupWidth / 2;
      final isPositive = i.isEven || i == highlightIndex;
      final wickPaint = Paint()
        ..color = (isPositive
            ? const Color(0x336FFBBE)
            : const Color(0x33FE8983));
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x, chartRect.bottom - barHeight / 2),
            width: 4,
            height: barHeight,
          ),
          const Radius.circular(3),
        ),
        wickPaint,
      );
      final bodyHeight = math.max(16.0, barHeight / 2);
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset(x, chartRect.bottom - barHeight / 2),
          width: 4,
          height: bodyHeight,
        ),
        isPositive ? positivePaint : negativePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _InvestmentCandlestickPainter oldDelegate) =>
      oldDelegate.bars != bars || oldDelegate.highlightIndex != highlightIndex;
}

class InvestmentMetricCard extends StatelessWidget {
  const InvestmentMetricCard({
    super.key,
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class InvestmentFloatingButton extends StatelessWidget {
  const InvestmentFloatingButton({
    super.key,
    required this.onTap,
    this.bottom = 72,
    this.right = 37,
  });

  final VoidCallback onTap;
  final double bottom;
  final double right;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      bottom: bottom,
      child: FloatingActionButton(
        onPressed: onTap,
        backgroundColor: const Color(0xFF0053DB),
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 30),
      ),
    );
  }
}
