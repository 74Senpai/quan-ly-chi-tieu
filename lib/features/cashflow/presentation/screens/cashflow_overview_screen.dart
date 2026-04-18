import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/cashflow_demo_data.dart';
import '../widgets/cashflow_components.dart';

class CashFlowOverviewScreen extends StatefulWidget {
  const CashFlowOverviewScreen({super.key});

  @override
  State<CashFlowOverviewScreen> createState() => _CashFlowOverviewScreenState();
}

class _CashFlowOverviewScreenState extends State<CashFlowOverviewScreen> {
  CashFlowPeriod _period = CashFlowPeriod.days30;

  @override
  Widget build(BuildContext context) {
    final snapshot = cashFlowSnapshots[_period]!;
    return CashFlowScreenShell(
      topBar: CashFlowTopBar(onBack: () => Navigator.of(context).pop()),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dòng Tiền',
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.9,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Theo dõi xu hướng tài chính của bạn',
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 20),
            CashFlowPeriodTabs(
              period: _period,
              onChanged: (value) => setState(() => _period = value),
            ),
            const SizedBox(height: 20),
            if (_period == CashFlowPeriod.days7)
              _HeroBalanceCard(snapshot: snapshot)
            else
              _ChartBalanceCard(snapshot: snapshot),
            const SizedBox(height: 20),
            if (_period == CashFlowPeriod.days7) ...[
              _CompactChartSection(snapshot: snapshot),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeroBalanceCard extends StatelessWidget {
  const _HeroBalanceCard({required this.snapshot});

  final CashFlowSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0053DB), Color(0xFF003798)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SỐ DƯ HIỆN TẠI',
            style: GoogleFonts.inter(
              color: const Color(0xCCF8F7FF),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            snapshot.currentBalanceLabel,
            style: GoogleFonts.manrope(
              color: const Color(0xFFF8F7FF),
              fontSize: 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              CashFlowChip(
                label: snapshot.incomeDeltaLabel,
                icon: Icons.arrow_upward_rounded,
                background: const Color(0x1AFFFFFF),
                foreground: const Color(0xFF6FFBBE),
              ),
              const SizedBox(width: 16),
              CashFlowChip(
                label: snapshot.expenseDeltaLabel,
                icon: Icons.arrow_downward_rounded,
                background: const Color(0x1AFFFFFF),
                foreground: const Color(0xFFFE8983),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ChartBalanceCard extends StatelessWidget {
  const _ChartBalanceCard({required this.snapshot});

  final CashFlowSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x1A98B1F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'SỐ DƯ HIỆN TẠI',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      snapshot.currentBalanceLabel,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0053DB),
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.75,
                      ),
                    ),
                  ],
                ),
              ),
              _TrendBadge(label: snapshot.balanceTrendLabel),
            ],
          ),
          const SizedBox(height: 18),
          const Divider(color: Color(0x1AE2E7FF), height: 1),
          const SizedBox(height: 18),
          CashFlowMultiLineChart(
            income: snapshot.incomeSeries,
            expense: snapshot.expenseSeries,
            balance: snapshot.balanceSeries,
            yAxisLabels: snapshot.yAxisLabels,
          ),
          const SizedBox(height: 20),
          const Divider(color: Color(0x1AE2E7FF), height: 1),
          const SizedBox(height: 14),
          const CashFlowLegendRow(compact: true),
        ],
      ),
    );
  }
}

class _TrendBadge extends StatelessWidget {
  const _TrendBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.trending_up_rounded,
          color: Color(0xFF006D4A),
          size: 18,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF006D4A),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CompactChartSection extends StatelessWidget {
  const _CompactChartSection({required this.snapshot});

  final CashFlowSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Biểu đồ dòng tiền',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const CashFlowLegendRow(compact: true),
            ],
          ),
          const SizedBox(height: 18),
          CashFlowMultiLineChart(
            income: snapshot.incomeSeries,
            expense: snapshot.expenseSeries,
            balance: snapshot.balanceSeries,
            yAxisLabels: snapshot.yAxisLabels,
            height: 220,
          ),
        ],
      ),
    );
  }
}
