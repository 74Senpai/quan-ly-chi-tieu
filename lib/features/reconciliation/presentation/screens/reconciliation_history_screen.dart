import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/reconciliation_demo_data.dart';
import '../widgets/reconciliation_components.dart';

class ReconciliationHistoryScreen extends StatelessWidget {
  const ReconciliationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReconciliationScreenShell(
      topBar: ReconciliationTopBar(
        title: 'Lịch sử',
        onBack: () => Navigator.of(context).pop(),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _StatsBentoRow(),
            const SizedBox(height: 28),
            for (final month in reconciliationHistory) ...[
              _HistoryMonthSection(month: month),
              if (month != reconciliationHistory.last)
                const SizedBox(height: 34),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatsBentoRow extends StatelessWidget {
  const _StatsBentoRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _StatsCard(
            background: Color(0xFFDBE1FF),
            label: 'THÁNG NÀY',
            value: '12 Phiên',
            labelColor: Color(0xB30048BF),
            valueColor: Color(0xFF0048BF),
            icon: Icons.account_balance_outlined,
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: _StatsCard(
            background: Color(0xFF6FFBBE),
            label: 'TRẠNG THÁI',
            value: '98% Khớp',
            labelColor: Color(0xB3005E3F),
            valueColor: Color(0xFF005E3F),
            icon: Icons.check_circle_outline_rounded,
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard({
    required this.background,
    required this.label,
    required this.value,
    required this.labelColor,
    required this.valueColor,
    required this.icon,
  });

  final Color background;
  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 163,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: valueColor),
          const Spacer(),
          Text(
            label,
            style: GoogleFonts.inter(
              color: labelColor,
              fontSize: 12,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: valueColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryMonthSection extends StatelessWidget {
  const _HistoryMonthSection({required this.month});

  final ReconciliationHistoryMonth month;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                month.title,
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2.8,
                ),
              ),
            ),
            Text(
              month.countLabel,
              style: GoogleFonts.inter(
                color: const Color(0xFF98B1F2),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (final item in month.items) ...[
          _HistoryItemCard(item: item),
          if (item != month.items.last) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _HistoryItemCard extends StatelessWidget {
  const _HistoryItemCard({required this.item});

  final ReconciliationHistoryItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0x80F2F3FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: item.iconBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(item.icon, color: item.iconForeground),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.dateLabel,
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Text(
                      item.amountLabel,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.inter(
                        color: item.amountColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: item.statusBackground,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        item.statusLabel,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: item.statusForeground,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        item.walletsLabel,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF445D99),
                          fontSize: 12,
                          height: 1.25,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      item.balanceLabel,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF98B1F2),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
