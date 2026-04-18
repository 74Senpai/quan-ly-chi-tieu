import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../home/presentation/widgets/home_components.dart';
import '../../data/investment_demo_data.dart';
import '../widgets/investment_components.dart';
import 'investment_add_screen.dart';

class GoldDetailScreen extends StatelessWidget {
  const GoldDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InvestmentScreenShell(
      topBar: InvestmentTopBar(
        title: 'Chi tiết Vàng SJC',
        onBack: () => Navigator.of(context).pop(),
        compact: true,
      ),
      bottomBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: PrimaryBlueButton(
          label: 'THÊM GIAO DỊCH MỚI',
          icon: Icons.add_rounded,
          onTap: () {
            Navigator.of(context).push(
              buildFadeSlideRoute(
                const InvestmentAddScreen(
                  initialType: InvestmentAssetType.gold,
                ),
              ),
            );
          },
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 96),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TỔNG SỞ HỮU',
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            RichText(
              text: TextSpan(
                style: GoogleFonts.manrope(
                  color: const Color(0xFF1B4289),
                  fontSize: 54,
                  fontWeight: FontWeight.w800,
                ),
                children: [
                  const TextSpan(text: '12.5 '),
                  TextSpan(
                    text: 'lượng',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF4F69A7),
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(21),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A113069),
                          blurRadius: 20,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.sell_outlined,
                              color: Color(0xFF0053DB),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'GIÁ HIỆN TẠI',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0053DB),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          '82.4M',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '/ lượng',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF4F69A7),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6FFBBE),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.payments_outlined,
                              color: Color(0xFF006D4A),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'LỢI NHUẬN',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF006D4A),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          '+148.5M',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF006D4A),
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '+15.82%',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF006D4A),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3FF),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Biểu đồ 30 ngày',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFCAD7FB),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'SJC 9999',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0053DB),
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const InvestmentLineChart(
                    values: [
                      0.32,
                      0.34,
                      0.34,
                      0.46,
                      0.52,
                      0.58,
                      0.68,
                      0.72,
                      0.73,
                      0.74,
                      0.82,
                    ],
                    labels: ['15 TH05', '01 TH06', 'HÔM NAY'],
                    height: 220,
                    gradient: [Color(0xFFAAC3FB), Color(0xFF3D79E6)],
                    lineColor: Color(0xFF4B7DE8),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            InvestmentSectionTitle(
              title: 'Lịch sử nắm giữ',
              actionLabel: 'XEM TẤT CẢ',
              onActionTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đang hiển thị dữ liệu nắm giữ demo.'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            for (final item in goldHoldingItems) ...[
              _GoldHoldingTile(item: item),
              if (item != goldHoldingItems.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _GoldHoldingTile extends StatelessWidget {
  const _GoldHoldingTile({required this.item});

  final ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: item.iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(item.icon, color: const Color(0xFF0053DB), size: 22),
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
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                item.secondaryAmount,
                style: GoogleFonts.inter(
                  color: const Color(0xFF006D4A),
                  fontSize: 14,
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
