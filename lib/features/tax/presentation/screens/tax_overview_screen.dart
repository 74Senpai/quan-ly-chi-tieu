import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/tax_demo_data.dart';
import '../widgets/tax_components.dart';
import 'tax_breakdown_screen.dart';

class TaxOverviewScreen extends StatelessWidget {
  const TaxOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TaxScreenShell(
      topBar: TaxTopBar(
        title: 'Báo cáo thuế',
        onBack: () => Navigator.of(context).pop(),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TaxOverviewHero(),
            const SizedBox(height: 20),
            _CategoryBreakdownCard(
              onDetailsTap: () {
                Navigator.of(
                  context,
                ).push(buildFadeSlideRoute(const TaxBreakdownScreen()));
              },
            ),
            const SizedBox(height: 20),
            const _TrendSection(),
            const SizedBox(height: 20),
            _RecentPaymentsSection(
              onViewAllTap: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Danh sách giao dịch đầy đủ sẽ được bổ sung sau.',
                      ),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TaxOverviewHero extends StatelessWidget {
  const _TaxOverviewHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0053DB), Color(0xFF0048C1)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 36,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.account_balance_wallet_outlined,
            color: Color(0x99F8F7FF),
            size: 28,
          ),
          const SizedBox(height: 18),
          Text(
            'Tổng thuế dự kiến (YTD)',
            style: GoogleFonts.inter(
              color: const Color(0xCCF8F7FF),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '142.500.000₫',
            style: GoogleFonts.manrope(
              color: const Color(0xFFF8F7FF),
              fontSize: 46,
              fontWeight: FontWeight.w800,
              height: 1.05,
              letterSpacing: -2.4,
            ),
          ),
          const SizedBox(height: 28),
          const Row(
            children: [
              Expanded(
                child: _SummaryStatCard(label: 'ĐÃ NỘP', value: '110.000.000₫'),
              ),
              SizedBox(width: 16),
              Expanded(
                child: _SummaryStatCard(label: 'CÒN LẠI', value: '32.500.000₫'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryStatCard extends StatelessWidget {
  const _SummaryStatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0x99F8F7FF),
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBreakdownCard extends StatelessWidget {
  const _CategoryBreakdownCard({required this.onDetailsTap});

  final VoidCallback onDetailsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Phân loại Thuế',
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          for (final item in taxOverviewCategories) ...[
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: item.color,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF113069),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  item.percentage,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (item != taxOverviewCategories.last) const SizedBox(height: 24),
          ],
          const SizedBox(height: 32),
          const Divider(color: Color(0x1A98B1F2), height: 1),
          const SizedBox(height: 25),
          TaxActionButton(label: 'Chi tiết phân loại →', onTap: onDetailsTap),
        ],
      ),
    );
  }
}

class _TrendSection extends StatelessWidget {
  const _TrendSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0x0D98B1F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
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
                      'Biểu đồ xu hướng',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mức đóng thuế hàng tháng trong năm 2024',
                      style: GoogleFonts.inter(
                        color: const Color(0xB3445D99),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x0D0053DB),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0x1A0053DB)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 5,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0053DB),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Năm 2024',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF0053DB),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const TaxTrendChart(
            values: taxTrendValues,
            labels: taxTrendLabels,
            highlightedIndex: 3,
          ),
        ],
      ),
    );
  }
}

class _RecentPaymentsSection extends StatelessWidget {
  const _RecentPaymentsSection({required this.onViewAllTap});

  final VoidCallback onViewAllTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Giao dịch gần đây',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            TextButton(
              onPressed: onViewAllTap,
              child: Text(
                'Xem tất cả',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0053DB),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (final item in taxPayments) ...[
          _RecentPaymentTile(item: item),
          if (item != taxPayments.last) const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _RecentPaymentTile extends StatelessWidget {
  const _RecentPaymentTile({required this.item});

  final TaxPaymentRecord item;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08113069),
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
              color: item.iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: item.iconForeground, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.date} • ${item.source}',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 12,
                    height: 1.4,
                    letterSpacing: 0.6,
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
                item.amount,
                style: GoogleFonts.inter(
                  color: const Color(0xFF9F403D),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.status,
                style: GoogleFonts.inter(
                  color: const Color(0xFF006D4A),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
