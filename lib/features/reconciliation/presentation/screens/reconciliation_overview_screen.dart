import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/reconciliation_demo_data.dart';
import '../widgets/reconciliation_components.dart';
import 'reconciliation_history_screen.dart';

class ReconciliationOverviewScreen extends StatelessWidget {
  const ReconciliationOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReconciliationScreenShell(
      topBar: ReconciliationTopBar(
        title: 'Đối soát tài khoản',
        onBack: () => Navigator.of(context).pop(),
        trailing: IconButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(buildFadeSlideRoute(const ReconciliationHistoryScreen()));
          },
          icon: const Icon(Icons.history_rounded, color: Color(0xFF445D99)),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TotalDiscrepancyCard(),
            const SizedBox(height: 26),
            Row(
              children: const [
                Expanded(
                  child: Text(
                    'Biểu đồ so sánh',
                    style: TextStyle(
                      color: Color(0xFF113069),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                ReconciliationLegend(),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0x1A98B1F2)),
              ),
              child: ReconciliationComparisonChart(
                pairs: reconciliationBarPairs,
              ),
            ),
            const SizedBox(height: 26),
            Text(
              'Danh sách ví',
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            for (final wallet in reconciliationWallets) ...[
              _WalletCard(wallet: wallet),
              if (wallet != reconciliationWallets.last)
                const SizedBox(height: 16),
            ],
          ],
        ),
      ),
    );
  }
}

class _TotalDiscrepancyCard extends StatelessWidget {
  const _TotalDiscrepancyCard();

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
          colors: [Color(0xFF0053DB), Color(0xFF0048C1)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TỔNG CHÊNH LỆCH',
            style: GoogleFonts.inter(
              color: const Color(0xCCF8F7FF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-2.450.000',
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.9,
                ),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'VND',
                  style: GoogleFonts.inter(
                    color: const Color(0xCCF8F7FF),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.info_outline, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Cần đối soát 3 ví tài chính',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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

class _WalletCard extends StatelessWidget {
  const _WalletCard({required this.wallet});

  final ReconciliationWallet wallet;

  @override
  Widget build(BuildContext context) {
    final discrepancyColor = wallet.discrepancy.startsWith('-')
        ? const Color(0xFF9F403D)
        : wallet.discrepancy == '0đ'
        ? const Color(0xFF006D4A)
        : const Color(0xFF006D4A);
    final discrepancyBg = wallet.discrepancy.startsWith('-')
        ? const Color(0x1AFE8983)
        : const Color(0x1A6FFBBE);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0x80F2F3FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: wallet.iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(wallet.icon, color: wallet.iconForeground),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      wallet.name,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      wallet.subtitle,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Số dư app',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    wallet.appBalance,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF113069),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetricTile(
                  title: 'SỐ DƯ THỰC TẾ',
                  value: wallet.actualBalance,
                  valueColor: const Color(0xFF0053DB),
                  background: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _MetricTile(
                  title: 'CHÊNH LỆCH',
                  value: wallet.discrepancy,
                  valueColor: discrepancyColor,
                  background: discrepancyBg,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.title,
    required this.value,
    required this.valueColor,
    required this.background,
  });

  final String title;
  final String value;
  final Color valueColor;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
