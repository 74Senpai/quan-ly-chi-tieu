import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

enum ReportPeriod { week, month, year }

class IncomeExpenseReportScreen extends StatefulWidget {
  const IncomeExpenseReportScreen({super.key, this.initialPeriod});

  final ReportPeriod? initialPeriod;

  @override
  State<IncomeExpenseReportScreen> createState() =>
      _IncomeExpenseReportScreenState();
}

class _IncomeExpenseReportScreenState extends State<IncomeExpenseReportScreen> {
  late ReportPeriod _period = widget.initialPeriod ?? ReportPeriod.week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                _TopBar(onBack: () => Navigator.of(context).pop()),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _PeriodTabs(
                          period: _period,
                          onChanged: (value) => setState(() => _period = value),
                        ),
                        const SizedBox(height: 16),
                        _TrendCard(period: _period),
                        const SizedBox(height: 16),
                        Row(
                          children: const [
                            Expanded(
                              child: _SummaryCard(
                                icon: Icons.arrow_downward_rounded,
                                iconBackground: Color(0xFFCFEFE6),
                                iconForeground: Color(0xFF006D4A),
                                label: 'TỔNG THU',
                                value: '+890.000',
                                valueColor: Color(0xFF006D4A),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _SummaryCard(
                                icon: Icons.arrow_upward_rounded,
                                iconBackground: Color(0xFFFCE2E1),
                                iconForeground: Color(0xFF9F403D),
                                label: 'TỔNG CHI',
                                value: '-395.000',
                                valueColor: Color(0xFF9F403D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _DifferenceCard(
                          onCopy: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text('Đã sao chép chênh lệch.'),
                                ),
                              );
                          },
                        ),
                        const SizedBox(height: 22),
                        _SectionHeader(
                          title: 'Giao dịch gần đây',
                          actionLabel: 'Xem tất cả',
                          onTap: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Đang hiển thị tất cả giao dịch.',
                                  ),
                                ),
                              );
                          },
                        ),
                        const SizedBox(height: 12),
                        const _TransactionsCard(),
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
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

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
          const SizedBox(width: 6),
          Text(
            'Báo cáo Thu Chi',
            style: GoogleFonts.manrope(
              color: const Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodTabs extends StatelessWidget {
  const _PeriodTabs({required this.period, required this.onChanged});

  final ReportPeriod period;
  final ValueChanged<ReportPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: _PeriodTab(
                label: 'Tuần',
                selected: period == ReportPeriod.week,
                onTap: () => onChanged(ReportPeriod.week),
              ),
            ),
            Expanded(
              child: _PeriodTab(
                label: 'Tháng',
                selected: period == ReportPeriod.month,
                onTap: () => onChanged(ReportPeriod.month),
              ),
            ),
            Expanded(
              child: _PeriodTab(
                label: 'Năm',
                selected: period == ReportPeriod.year,
                onTap: () => onChanged(ReportPeriod.year),
              ),
            ),
          ],
        ),
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
    final child = Center(
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: selected ? const Color(0xFF0053DB) : const Color(0xFF445D99),
          fontSize: 16,
          fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
        ),
      ),
    );
    if (!selected) {
      return InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: child,
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: child,
      ),
    );
  }
}

class _TrendCard extends StatelessWidget {
  const _TrendCard({required this.period});

  final ReportPeriod period;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(25, 26, 25, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Xu hướng tháng này',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Biểu đồ Tổng\nquát',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: -0.6,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const _Legend(),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0x1A98B1F2)),
          const SizedBox(height: 16),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: switch (period) {
              ReportPeriod.year => const _YearBars(key: ValueKey('year')),
              ReportPeriod.month => const _MonthCalendar(
                key: ValueKey('month'),
              ),
              ReportPeriod.week => const _WeekCalendar(key: ValueKey('week')),
            },
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LegendItem(color: const Color(0xFF10B981), label: 'THU'),
        const SizedBox(width: 14),
        _LegendItem(color: const Color(0xFFEF4444), label: 'CHI'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF445D99),
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.55,
          ),
        ),
      ],
    );
  }
}

class _YearBars extends StatelessWidget {
  const _YearBars({super.key});

  @override
  Widget build(BuildContext context) {
    const months = [
      _BarMonth(label: 'T1', income: 7, expense: 5),
      _BarMonth(label: 'T2', income: 9, expense: 4),
      _BarMonth(label: 'T3', income: 6, expense: 8),
      _BarMonth(label: 'T4', income: 12, expense: 3),
      _BarMonth(label: 'T5', income: 8, expense: 6),
      _BarMonth(label: 'T6', income: 11, expense: 7),
      _BarMonth(label: 'T7', income: 7, expense: 9),
      _BarMonth(label: 'T8', income: 13, expense: 5),
      _BarMonth(label: 'T9', income: 10, expense: 7),
      _BarMonth(label: 'T10', income: 9, expense: 8),
      _BarMonth(label: 'T11', income: 8, expense: 6),
      _BarMonth(label: 'T12', income: 6, expense: 5),
    ];

    return SizedBox(
      height: 260,
      child: CustomPaint(
        painter: _BarsPainter(months: months),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _BarsPainter extends CustomPainter {
  const _BarsPainter({required this.months});

  final List<_BarMonth> months;

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0x1A98B1F2)
      ..strokeWidth = 1;
    final axisPaint = Paint()
      ..color = const Color(0x330053DB)
      ..strokeWidth = 1.2;

    const paddingLeft = 8.0;
    const paddingRight = 8.0;
    const paddingTop = 8.0;
    const paddingBottom = 26.0;
    final chartRect = Rect.fromLTWH(
      paddingLeft,
      paddingTop,
      size.width - paddingLeft - paddingRight,
      size.height - paddingTop - paddingBottom,
    );

    for (var i = 0; i < 4; i++) {
      final y = chartRect.top + (chartRect.height / 4) * i;
      canvas.drawLine(
        Offset(chartRect.left, y),
        Offset(chartRect.right, y),
        gridPaint,
      );
    }
    canvas.drawLine(
      Offset(chartRect.left, chartRect.bottom),
      Offset(chartRect.right, chartRect.bottom),
      axisPaint,
    );

    final maxValue = months.fold<double>(
      0,
      (max, m) =>
          math.max(max, math.max(m.income.toDouble(), m.expense.toDouble())),
    );
    final safeMax = maxValue <= 0 ? 1 : maxValue;

    final incomePaint = Paint()..color = const Color(0xFF10B981);
    final expensePaint = Paint()..color = const Color(0xFFEF4444);

    final groupWidth = chartRect.width / months.length;
    final barWidth = math.min(10.0, groupWidth * 0.24);
    final gap = math.min(6.0, groupWidth * 0.14);

    for (var i = 0; i < months.length; i++) {
      final xCenter = chartRect.left + groupWidth * (i + 0.5);
      final incomeHeight = (months[i].income / safeMax) * chartRect.height;
      final expenseHeight = (months[i].expense / safeMax) * chartRect.height;

      final incomeRect = Rect.fromLTWH(
        xCenter - gap / 2 - barWidth,
        chartRect.bottom - incomeHeight,
        barWidth,
        incomeHeight,
      );
      final expenseRect = Rect.fromLTWH(
        xCenter + gap / 2,
        chartRect.bottom - expenseHeight,
        barWidth,
        expenseHeight,
      );

      canvas.drawRRect(
        RRect.fromRectAndRadius(incomeRect, const Radius.circular(6)),
        incomePaint,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(expenseRect, const Radius.circular(6)),
        expensePaint,
      );

      final textPainter = TextPainter(
        text: TextSpan(
          text: months[i].label,
          style: GoogleFonts.inter(
            color: const Color(0xFF0053DB),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      textPainter.paint(
        canvas,
        Offset(xCenter - textPainter.width / 2, chartRect.bottom + 6),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BarsPainter oldDelegate) =>
      oldDelegate.months != months;
}

class _BarMonth {
  const _BarMonth({
    required this.label,
    required this.income,
    required this.expense,
  });

  final String label;
  final double income;
  final double expense;
}

class _MonthCalendar extends StatelessWidget {
  const _MonthCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return _CalendarGrid(
      header: const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
      rows: const [
        [
          _Cell(day: '', muted: true),
          _Cell(day: '', muted: true),
          _Cell(day: '1', muted: true),
          _Cell(day: '2', muted: true),
          _Cell(day: '3', income: '+1.2M', expense: '-450k'),
          _Cell(day: '4'),
          _Cell(day: '5', expense: '-2.1M'),
        ],
        [
          _Cell(day: '6', selected: true, income: '+200k', expense: '-50k'),
          _Cell(day: '7', expense: '-120k'),
          _Cell(day: '8'),
          _Cell(day: '9', income: '+5.0M'),
          _Cell(day: '10', expense: '-85k'),
          _Cell(day: '11'),
          _Cell(day: '12'),
        ],
        [
          _Cell(day: '13'),
          _Cell(day: '14'),
          _Cell(day: '15', income: '+800k', expense: '-300k'),
          _Cell(day: '16'),
          _Cell(day: '17'),
          _Cell(day: '18'),
          _Cell(day: '19'),
        ],
        [
          _Cell(day: '20'),
          _Cell(day: '21'),
          _Cell(day: '22'),
          _Cell(day: '23'),
          _Cell(day: '24'),
          _Cell(day: '25'),
          _Cell(day: '26'),
        ],
        [
          _Cell(day: '27'),
          _Cell(day: '28'),
          _Cell(day: '29'),
          _Cell(day: '30'),
          _Cell(day: '31'),
          _Cell(day: '', muted: true),
          _Cell(day: '', muted: true),
        ],
      ],
    );
  }
}

class _WeekCalendar extends StatelessWidget {
  const _WeekCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    return _CalendarGrid(
      header: const ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'],
      rows: const [
        [
          _Cell(day: '28', muted: true),
          _Cell(day: '29', muted: true),
          _Cell(day: '30', muted: true),
          _Cell(day: '1', marker: _Marker.green),
          _Cell(day: '2'),
          _Cell(day: '3'),
          _Cell(day: '4'),
        ],
        [
          _Cell(day: '5'),
          _Cell(day: '6'),
          _Cell(day: '7', marker: _Marker.red),
          _Cell(day: '8'),
          _Cell(day: '9', marker: _Marker.green),
          _Cell(day: '10', selected: true, marker: _Marker.green),
          _Cell(day: '11'),
        ],
      ],
      compact: true,
    );
  }
}

enum _Marker { none, green, red }

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.header,
    required this.rows,
    this.compact = false,
  });

  final List<String> header;
  final List<List<_Cell>> rows;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final cellHeight = compact ? 44.0 : 56.0;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              for (final label in header)
                Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6C82B3),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          for (final row in rows) ...[
            SizedBox(
              height: cellHeight,
              child: Row(
                children: [
                  for (final cell in row)
                    Expanded(
                      child: _CalendarCell(cell: cell, compact: compact),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Cell {
  const _Cell({
    required this.day,
    this.income,
    this.expense,
    this.selected = false,
    this.muted = false,
    this.marker = _Marker.none,
  });

  final String day;
  final String? income;
  final String? expense;
  final bool selected;
  final bool muted;
  final _Marker marker;
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({required this.cell, required this.compact});

  final _Cell cell;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isEmpty = cell.day.isEmpty;
    final textColor = cell.selected
        ? Colors.white
        : cell.muted
        ? const Color(0xFFB6C2E3)
        : const Color(0xFF113069);
    final borderColor = cell.selected
        ? const Color(0xFF0053DB)
        : const Color(0x1A98B1F2);

    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          color: cell.selected ? const Color(0xFF0053DB) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: isEmpty
            ? const SizedBox.expand()
            : Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: compact ? 6 : 5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            cell.day,
                            style: GoogleFonts.inter(
                              color: textColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        if (cell.marker != _Marker.none)
                          Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              color: cell.marker == _Marker.green
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFEF4444),
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    if (!compact) ...[
                      const Spacer(),
                      if (cell.income != null)
                        Text(
                          cell.income!,
                          style: GoogleFonts.inter(
                            color: cell.selected
                                ? const Color(0xFFDFF7EE)
                                : const Color(0xFF006D4A),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      if (cell.expense != null)
                        Text(
                          cell.expense!,
                          style: GoogleFonts.inter(
                            color: cell.selected
                                ? const Color(0xFFFCE2E1)
                                : const Color(0xFF9F403D),
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.iconBackground,
    required this.iconForeground,
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconForeground;
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: iconForeground),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.55,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: valueColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _DifferenceCard extends StatelessWidget {
  const _DifferenceCard({required this.onCopy});

  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CHÊNH LỆCH',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.55,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '+495.000',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF0053DB),
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onCopy,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: const Color(0xFFE0EAFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.copy_all_outlined,
                color: Color(0xFF0053DB),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            color: const Color(0xFF113069),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionLabel,
            style: GoogleFonts.inter(
              color: const Color(0xFF0053DB),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _TransactionsCard extends StatelessWidget {
  const _TransactionsCard();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        title: 'Mua Premi CS2',
        time: '07/03/2026 • 14:30',
        amount: '-395.000',
        amountColor: Color(0xFF9F403D),
        icon: Icons.shopping_bag_outlined,
        iconBackground: Color(0xFFFFE4E6),
      ),
      (
        title: 'Tiền làm thêm',
        time: '01/03/2026 • 08:10',
        amount: '+390.000',
        amountColor: Color(0xFF006D4A),
        icon: Icons.work_outline_rounded,
        iconBackground: Color(0xFFCFEFE6),
      ),
      (
        title: 'Cà phê',
        time: '28/02/2026 • 09:15',
        amount: '-55.000',
        amountColor: Color(0xFF9F403D),
        icon: Icons.local_cafe_outlined,
        iconBackground: Color(0xFFFFEDD5),
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A113069),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _TransactionRow(
              title: items[index].title,
              time: items[index].time,
              amount: items[index].amount,
              amountColor: items[index].amountColor,
              icon: items[index].icon,
              iconBackground: items[index].iconBackground,
            ),
            if (index != items.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: Color(0x1498B1F2)),
              ),
          ],
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.title,
    required this.time,
    required this.amount,
    required this.amountColor,
    required this.icon,
    required this.iconBackground,
  });

  final String title;
  final String time;
  final String amount;
  final Color amountColor;
  final IconData icon;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF113069)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xFF113069),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                time,
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          amount,
          style: GoogleFonts.inter(
            color: amountColor,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
