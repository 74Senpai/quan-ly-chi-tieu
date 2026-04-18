import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/investment_demo_data.dart';
import '../widgets/investment_components.dart';
import 'crypto_detail_screen.dart';
import 'gold_detail_screen.dart';
import 'investment_add_screen.dart';
import 'investment_report_screen.dart';
import 'stock_detail_screen.dart';

class InvestmentOverviewScreen extends StatefulWidget {
  const InvestmentOverviewScreen({super.key});

  @override
  State<InvestmentOverviewScreen> createState() =>
      _InvestmentOverviewScreenState();
}

class _InvestmentOverviewScreenState extends State<InvestmentOverviewScreen> {
  String _period = '1T';

  @override
  Widget build(BuildContext context) {
    return InvestmentScreenShell(
      topBar: InvestmentTopBar(
        title: 'Đầu tư sinh lời',
        onBack: () => Navigator.of(context).pop(),
        compact: true,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TỔNG TÀI SẢN ĐẦU TƯ',
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '2.485.000.000',
              style: GoogleFonts.manrope(
                color: const Color(0xFF1B4289),
                fontSize: 46,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.4,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                InvestmentValueChip(label: '+15.2%', positive: true),
                SizedBox(width: 10),
                Text(
                  'so với tháng trước',
                  style: TextStyle(
                    color: Color(0xFF445D99),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 38),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3FF),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hiệu suất đầu tư',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF1B4289),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              'Lợi nhuận theo thời gian',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF5E75AC),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      InvestmentSegmentTabs(
                        options: const ['1T', '6T', '1N'],
                        selected: _period,
                        onChanged: (value) => setState(() => _period = value),
                        compact: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const InvestmentLineChart(
                    values: [0.08, 0.16, 0.36, 0.66, 0.76, 0.80],
                    labels: ['T.1', 'T.2', 'T.3', 'T.4', 'T.5', 'T.6'],
                    height: 190,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            InvestmentSectionTitle(
              title: 'Danh mục Đầu tư',
              actionLabel: 'Tất cả',
              onActionTap: _openReport,
              horizontalPadding: 8,
            ),
            const SizedBox(height: 16),
            for (final item in portfolioItems) ...[
              _PortfolioTile(item: item, onTap: () => _openDetail(item.type)),
              if (item != portfolioItems.last) const SizedBox(height: 12),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _QuickActionCard(
                    title: 'Đầu tư\nthêm',
                    background: const Color(0xFF0053DB),
                    foreground: Colors.white,
                    icon: Icons.trending_up_rounded,
                    onTap: _openAdd,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _QuickActionCard(
                    title: 'Báo cáo\nchi tiết',
                    background: const Color(0xFFE2E7FF),
                    foreground: const Color(0xFF113069),
                    icon: Icons.insert_chart_outlined_rounded,
                    onTap: _openReport,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openAdd() {
    Navigator.of(context).push(
      buildFadeSlideRoute(
        const InvestmentAddScreen(initialType: InvestmentAssetType.gold),
      ),
    );
  }

  void _openReport() {
    Navigator.of(
      context,
    ).push(buildFadeSlideRoute(const InvestmentReportScreen()));
  }

  void _openDetail(InvestmentAssetType type) {
    final route = switch (type) {
      InvestmentAssetType.stocks => const StockDetailScreen(),
      InvestmentAssetType.gold => const GoldDetailScreen(),
      InvestmentAssetType.crypto => const CryptoDetailScreen(),
      InvestmentAssetType.realEstate => null,
    };

    if (route == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('BĐS sẽ được hoàn thiện ở bước tiếp theo.'),
        ),
      );
      return;
    }

    Navigator.of(context).push(buildFadeSlideRoute(route));
  }
}

class _PortfolioTile extends StatelessWidget {
  const _PortfolioTile({required this.item, required this.onTap});

  final InvestmentPortfolioItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final changeColor = item.changePositive
        ? const Color(0xFF006D4A)
        : const Color(0xFF9F403D);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A113069),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: item.type.iconBackground.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(item.type.icon, color: item.type.accent, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.subtitle,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.value,
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    item.changeLabel,
                    style: GoogleFonts.inter(
                      color: changeColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.background,
    required this.foreground,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final Color background;
  final Color foreground;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(32),
      child: Ink(
        height: 160,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: foreground, size: 28),
            const Spacer(),
            Text(
              title,
              style: GoogleFonts.manrope(
                color: foreground,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
