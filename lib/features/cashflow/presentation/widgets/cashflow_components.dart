import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';
import '../../data/cashflow_demo_data.dart';

class CashFlowScreenShell extends StatelessWidget {
  const CashFlowScreenShell({
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

class CashFlowTopBar extends StatelessWidget {
  const CashFlowTopBar({super.key, required this.onBack});

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
              'Dòng tiền',
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

class CashFlowPeriodTabs extends StatelessWidget {
  const CashFlowPeriodTabs({
    super.key,
    required this.period,
    required this.onChanged,
  });

  final CashFlowPeriod period;
  final ValueChanged<CashFlowPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _PeriodTab(
            label: '7 ngày',
            selected: period == CashFlowPeriod.days7,
            onTap: () => onChanged(CashFlowPeriod.days7),
          ),
          _PeriodTab(
            label: '30 ngày',
            selected: period == CashFlowPeriod.days30,
            onTap: () => onChanged(CashFlowPeriod.days30),
          ),
          _PeriodTab(
            label: '90 ngày',
            selected: period == CashFlowPeriod.days90,
            onTap: () => onChanged(CashFlowPeriod.days90),
          ),
        ],
      ),
    );
  }
}

class _PeriodTab extends StatelessWidget {
  const _PeriodTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: selected
                  ? const [
                      BoxShadow(
                        color: Color(0x14000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: selected
                      ? const Color(0xFF0053DB)
                      : const Color(0xFF445D99),
                  fontSize: 14,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CashFlowChip extends StatelessWidget {
  const CashFlowChip({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
    required this.icon,
  });

  final String label;
  final Color background;
  final Color foreground;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: foreground, size: 16),
          const SizedBox(width: 8),
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

class CashFlowLegendRow extends StatelessWidget {
  const CashFlowLegendRow({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: compact ? 16 : 18,
      runSpacing: 8,
      children: [for (final item in cashFlowLegend) _LegendItem(item: item)],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.item});

  final CashFlowLegendItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.dashed ? Colors.transparent : item.color,
            border: item.dashed
                ? Border.all(color: item.color, width: 2)
                : null,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          item.label,
          style: GoogleFonts.inter(
            color: const Color(0xFF445D99),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class CashFlowMultiLineChart extends StatelessWidget {
  const CashFlowMultiLineChart({
    super.key,
    required this.income,
    required this.expense,
    required this.balance,
    required this.yAxisLabels,
    this.height = 260,
  });

  final List<double> income;
  final List<double> expense;
  final List<double> balance;
  final List<String> yAxisLabels;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _CashFlowChartPainter(
          income: income,
          expense: expense,
          balance: balance,
          yAxisLabels: yAxisLabels,
        ),
      ),
    );
  }
}

class _CashFlowChartPainter extends CustomPainter {
  _CashFlowChartPainter({
    required this.income,
    required this.expense,
    required this.balance,
    required this.yAxisLabels,
  });

  final List<double> income;
  final List<double> expense;
  final List<double> balance;
  final List<String> yAxisLabels;

  @override
  void paint(Canvas canvas, Size size) {
    final seriesLength = <int>[
      income.length,
      expense.length,
      balance.length,
    ].reduce(math.min);
    if (seriesLength < 2) return;

    const leftPadding = 36.0;
    const topPadding = 18.0;
    const bottomPadding = 18.0;
    final chartWidth = size.width - leftPadding;
    final chartHeight = size.height - topPadding - bottomPadding;

    final allValues = <double>[
      ...income.take(seriesLength),
      ...expense.take(seriesLength),
      ...balance.take(seriesLength),
    ];
    final minValue = allValues.reduce(math.min);
    final maxValue = allValues.reduce(math.max);
    final range = math.max(maxValue - minValue, 1.0);

    Offset pointAt(int index, double value) {
      final dx = leftPadding + (chartWidth / (seriesLength - 1)) * index;
      final normalized = (value - minValue) / range;
      final dy = topPadding + (1 - normalized) * chartHeight;
      return Offset(dx, dy);
    }

    final gridPaint = Paint()
      ..color = const Color(0x1A98B1F2)
      ..strokeWidth = 1;

    final rows = math.max(yAxisLabels.length - 1, 3);
    for (var i = 0; i <= rows; i++) {
      final y = topPadding + (chartHeight / rows) * i;
      canvas.drawLine(Offset(leftPadding, y), Offset(size.width, y), gridPaint);
    }

    final columns = seriesLength - 1;
    for (var i = 0; i <= columns; i++) {
      final x = leftPadding + (chartWidth / columns) * i;
      canvas.drawLine(
        Offset(x, topPadding),
        Offset(x, size.height - bottomPadding),
        gridPaint,
      );
    }

    final textStyle = GoogleFonts.inter(
      color: const Color(0x8098B1F2),
      fontSize: 10,
      fontWeight: FontWeight.w700,
    );
    for (var i = 0; i < yAxisLabels.length; i++) {
      final label = yAxisLabels[i];
      final y = topPadding + (chartHeight / (yAxisLabels.length - 1)) * i;
      final tp = TextPainter(
        text: TextSpan(text: label, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: leftPadding - 8);
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    void drawSeries({
      required List<double> values,
      required Color color,
      bool dashed = false,
    }) {
      final path = Path()
        ..moveTo(pointAt(0, values[0]).dx, pointAt(0, values[0]).dy);
      for (var i = 1; i < seriesLength; i++) {
        final prev = pointAt(i - 1, values[i - 1]);
        final cur = pointAt(i, values[i]);
        final controlX = (prev.dx + cur.dx) / 2;
        path.cubicTo(controlX, prev.dy, controlX, cur.dy, cur.dx, cur.dy);
      }

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = dashed ? 3.5 : 4
        ..strokeCap = StrokeCap.round;

      if (!dashed) {
        canvas.drawPath(path, paint);
        return;
      }

      const dashWidth = 10.0;
      const dashSpace = 7.0;
      for (final metric in path.computeMetrics()) {
        var distance = 0.0;
        while (distance < metric.length) {
          final len = math.min(dashWidth, metric.length - distance);
          final extract = metric.extractPath(distance, distance + len);
          canvas.drawPath(extract, paint);
          distance += dashWidth + dashSpace;
        }
      }
    }

    drawSeries(values: income, color: const Color(0xFF006D4A));
    drawSeries(values: expense, color: const Color(0xFF9F403D));
    drawSeries(values: balance, color: const Color(0xFF0053DB), dashed: true);
  }

  @override
  bool shouldRepaint(covariant _CashFlowChartPainter oldDelegate) {
    return oldDelegate.income != income ||
        oldDelegate.expense != expense ||
        oldDelegate.balance != balance ||
        oldDelegate.yAxisLabels != yAxisLabels;
  }
}
