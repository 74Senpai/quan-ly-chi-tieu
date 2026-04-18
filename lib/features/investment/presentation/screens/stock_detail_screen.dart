import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/investment_demo_data.dart';
import '../widgets/investment_components.dart';
import 'investment_add_screen.dart';

class StockDetailScreen extends StatefulWidget {
  const StockDetailScreen({super.key});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  String _period = '1M';

  @override
  Widget build(BuildContext context) {
    return InvestmentScreenShell(
      topBar: InvestmentTopBar(
        title: 'Chứng khoán chi tiết',
        onBack: () => Navigator.of(context).pop(),
        compact: true,
      ),
      floatingActionButton: InvestmentFloatingButton(
        onTap: () {
          Navigator.of(context).push(
            buildFadeSlideRoute(
              const InvestmentAddScreen(
                initialType: InvestmentAssetType.stocks,
              ),
            ),
          );
        },
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TỔNG GIÁ TRỊ DANH MỤC',
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: GoogleFonts.manrope(
                  color: const Color(0xFF1B4289),
                  fontSize: 56,
                  fontWeight: FontWeight.w800,
                ),
                children: [
                  const TextSpan(text: '1.25B '),
                  TextSpan(
                    text: 'VND',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF7B8FB9),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const InvestmentValueChip(
              label: '+12.4% tháng này',
              positive: true,
            ),
            const SizedBox(height: 44),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 169 / 105,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                InvestmentMetricCard(label: 'P/E RATIO', value: '14.2'),
                InvestmentMetricCard(label: 'DIVIDEND YIELD', value: '3.8%'),
                InvestmentMetricCard(label: 'EPS', value: '4,520'),
                InvestmentMetricCard(label: 'VỐN HÓA', value: '164.2T'),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x08000000),
                    blurRadius: 24,
                    offset: Offset(0, -6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VNM: Vinamilk',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Sàn HOSE • Thực phẩm & Đồ uống',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: InvestmentSegmentTabs(
                      options: const ['1D', '1W', '1M', '1Y', 'ALL'],
                      selected: _period,
                      onChanged: (value) => setState(() => _period = value),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const InvestmentCandlestickChart(
                    bars: [
                      0.10,
                      0.18,
                      0.26,
                      0.16,
                      0.32,
                      0.22,
                      0.38,
                      0.50,
                      0.32,
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (final label in const [
                          '01 TH09',
                          '08 TH09',
                          '15 TH09',
                          '22 TH09',
                          '30 TH09',
                        ])
                          Text(
                            label,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF445D99),
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            InvestmentSectionTitle(
              title: 'Lịch sử giao dịch',
              actionLabel: 'Xem tất cả',
              onActionTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Danh sách giao dịch đầy đủ đang ở chế độ demo.',
                    ),
                  ),
                );
              },
              horizontalPadding: 8,
            ),
            const SizedBox(height: 16),
            for (final item in stockTransactions) ...[
              _StockTransactionTile(item: item),
              if (item != stockTransactions.last) const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }
}

class _StockTransactionTile extends StatelessWidget {
  const _StockTransactionTile({required this.item});

  final ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8FF),
        borderRadius: BorderRadius.circular(16),
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
            child: Icon(
              item.icon,
              color: item.positive
                  ? const Color(0xFF006D4A)
                  : const Color(0xFF9F403D),
              size: 22,
            ),
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
                Text(
                  item.subtitle,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 12,
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
                style: GoogleFonts.manrope(
                  color: item.positive
                      ? const Color(0xFF006D4A)
                      : const Color(0xFF9F403D),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                item.secondaryAmount,
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
