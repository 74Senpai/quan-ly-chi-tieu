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
                                value: '+36.000.000',
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
                                value: '-12.000.000',
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
                        const SizedBox(height: 32),
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
          Expanded(
            child: Text(
              'Báo cáo Thu Chi',
              style: GoogleFonts.manrope(
                color: const Color(0xFF0F172A),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
              overflow: TextOverflow.ellipsis,
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
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FE),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Tuần',
            selected: period == ReportPeriod.week,
            onTap: () => onChanged(ReportPeriod.week),
          ),
          _TabItem(
            label: 'Tháng',
            selected: period == ReportPeriod.month,
            onTap: () => onChanged(ReportPeriod.month),
          ),
          _TabItem(
            label: 'Năm',
            selected: period == ReportPeriod.year,
            onTap: () => onChanged(ReportPeriod.year),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
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
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: const Color(0x12000000),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.manrope(
                color: selected ? const Color(0xFF0053DB) : const Color(0xFF6C82B3),
                fontSize: 15,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
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
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFEAEDFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
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
              const Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: _Legend(),
                ),
              ),
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
    final cellHeight = compact ? 52.0 : 84.0;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFEAEDFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
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
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          for (var i = 0; i < rows.length; i++) ...[
            Container(
              height: cellHeight,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: const Color(0xFFEAEDFF)),
                ),
              ),
              child: Row(
                children: [
                  for (var j = 0; j < rows[i].length; j++)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            right: j < rows[i].length - 1
                                ? const BorderSide(color: Color(0xFFEAEDFF))
                                : BorderSide.none,
                          ),
                        ),
                        child: _CalendarCell(
                          cell: rows[i][j],
                          compact: compact,
                        ),
                      ),
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
    this.isToday = false,
    this.isCurrentMonth = true,
  });

  final String day;
  final String? income;
  final String? expense;
  final bool selected;
  final bool muted;
  final _Marker marker;
  final bool isToday;
  final bool isCurrentMonth;
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({required this.cell, required this.compact});

  final _Cell cell;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final isEmpty = cell.day.isEmpty;
    final active = cell.selected;

    return InkWell(
      onTap: () {},
      child: Container(
        color: active ? const Color(0xFF0053DB) : Colors.transparent,
        child: isEmpty
            ? const SizedBox.expand()
            : Padding(
                padding: EdgeInsets.all(compact ? 4.0 : 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.topRight,
                      children: [
                        _DayNumber(
                          day: cell.day,
                          isToday: cell.isToday,
                          isCurrentMonth: cell.isCurrentMonth,
                          active: active,
                        ),
                        if (cell.marker != _Marker.none)
                          Positioned(
                            right: 0,
                            top: 0,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: cell.marker == _Marker.green
                                    ? const Color(0xFF006D4A)
                                    : const Color(0xFF9F403D),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (!compact) ...[
                      const SizedBox(height: 2),
                      if (cell.income != null)
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              cell.income!,
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF006D4A),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                        ),
                      if (cell.expense != null)
                        Flexible(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              cell.expense!,
                              maxLines: 1,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF9F403D),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: -0.5,
                              ),
                            ),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FE),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0x3398B1F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Icon(icon, color: iconForeground, size: 20),
          ),
          const SizedBox(height: 14),
          Text(
            label.toUpperCase(),
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.55,
            ),
          ),
          const SizedBox(height: 6),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: GoogleFonts.manrope(
                color: valueColor,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5FE),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x6698B1F2)),
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
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '+24.000.000',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF0053DB),
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.9,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: onCopy,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFCFDDFE),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.wallet_rounded,
                color: Color(0xFF0053DB),
                size: 26,
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
        iconBackground: Color(0xFFF1F5FE),
      ),
      (
        title: 'Lương tháng 03',
        time: '10/03/2026 • 08:15',
        amount: '+35.000.000',
        amountColor: Color(0xFF006D4A),
        icon: Icons.account_balance_wallet_outlined,
        iconBackground: Color(0xFFE6F7F0),
      ),
    ];

    return Column(
      children: [
        for (final item in items)
          _TransactionRow(
            title: item.title,
            time: item.time,
            amount: item.amount,
            amountColor: item.amountColor,
            icon: item.icon,
            iconBackground: item.iconBackground,
          ),
      ],
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF113069), size: 20),
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
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6C82B3),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              amount,
              style: GoogleFonts.manrope(
                color: amountColor,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayNumber extends StatelessWidget {
  const _DayNumber({
    required this.day,
    required this.isToday,
    required this.isCurrentMonth,
    required this.active,
  });

  final String day;
  final bool isToday;
  final bool isCurrentMonth;
  final bool active;

  @override
  Widget build(BuildContext context) {
    Color textColor;
    if (active) {
      textColor = Colors.white;
    } else if (!isCurrentMonth) {
      textColor = const Color(0xFFB6C2E3);
    } else {
      textColor = const Color(0xFF113069);
    }

    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: isToday && !active
          ? const BoxDecoration(
              color: Color(0xFFEAEDFF),
              shape: BoxShape.circle,
            )
          : null,
      child: Text(
        day,
        style: GoogleFonts.inter(
          color: textColor,
          fontSize: 14,
          fontWeight: (active || isToday) ? FontWeight.w800 : FontWeight.w600,
          height: 1.1,
        ),
      ),
    );
  }
}
