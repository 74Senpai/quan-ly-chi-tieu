import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/investment_demo_data.dart';
import '../widgets/investment_components.dart';
import 'crypto_detail_screen.dart';
import 'gold_detail_screen.dart';
import 'stock_detail_screen.dart';

class InvestmentReportScreen extends StatefulWidget {
  const InvestmentReportScreen({super.key});

  @override
  State<InvestmentReportScreen> createState() => _InvestmentReportScreenState();
}

class _InvestmentReportScreenState extends State<InvestmentReportScreen> {
  String _period = '6T';

  @override
  Widget build(BuildContext context) {
    return InvestmentScreenShell(
      topBar: InvestmentTopBar(
        title: 'Báo cáo Đầu tư',
        onBack: () => Navigator.of(context).pop(),
        trailing: IconButton(
          onPressed: () => _showMessage('Xuất báo cáo sẽ được hoàn thiện sau.'),
          icon: const Icon(
            Icons.work_outline_rounded,
            color: Color(0xFF0053DB),
          ),
        ),
        compact: true,
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tổng tài sản hiện tại',
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '2.48B',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF1B4289),
                    fontSize: 54,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -1.2,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6FFBBE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+15.2%  (+328M)',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF006D4A),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0x4DDBE1FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x1A0053DB)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0053DB),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'AI Insights',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF0053DB),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text.rich(
                          TextSpan(
                            style: GoogleFonts.inter(
                              color: const Color(0xFF113069),
                              fontSize: 14,
                              height: 1.6,
                            ),
                            children: const [
                              TextSpan(
                                text:
                                    'Danh mục của bạn đang có hiệu suất tốt hơn ',
                              ),
                              TextSpan(
                                text: '85%',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: ' người dùng. Tuy nhiên, tỉ trọng ',
                              ),
                              TextSpan(
                                text: 'Crypto',
                                style: TextStyle(fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text:
                                    ' đang hơi cao, hãy cân nhắc tái cơ cấu để giảm rủi ro.',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3FF),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Biểu đồ Hiệu suất',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      InvestmentSegmentTabs(
                        options: const ['6T', '1N', 'ALL'],
                        selected: _period,
                        onChanged: (value) => setState(() => _period = value),
                        compact: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const InvestmentLineChart(
                    values: [0.12, 0.20, 0.48, 0.72, 0.78, 0.74, 0.76, 0.92],
                    labels: ['THÁNG 1', 'THÁNG 3', 'THÁNG 5', 'HIỆN TẠI'],
                    height: 210,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const InvestmentSectionTitle(title: 'Danh mục chi tiết'),
            const SizedBox(height: 16),
            _CategoryHeader(
              icon: Icons.show_chart_rounded,
              title: 'Chứng khoán',
              share: '50%',
              color: const Color(0xFF0053DB),
              onTap: () => _open(const StockDetailScreen()),
            ),
            const SizedBox(height: 16),
            for (final stock in stockPositions) ...[
              _StockCard(stock: stock),
              if (stock != stockPositions.last) const SizedBox(height: 16),
            ],
            const SizedBox(height: 24),
            _CategoryBlock(
              icon: Icons.payments_outlined,
              title: 'Vàng',
              share: '30%',
              shareColor: const Color(0xFF445D99),
              background: const Color(0xFFF2F3FF),
              onTap: () => _open(const GoldDetailScreen()),
              child: const _MiniSummaryCard(
                label: 'SJC 9999',
                value: '12 Lượng',
                trailingLabel: 'Lợi nhuận',
                trailingValue: '+8.5M',
                positive: true,
              ),
            ),
            const SizedBox(height: 16),
            _CategoryBlock(
              icon: Icons.currency_bitcoin_rounded,
              title: 'Crypto',
              share: '20%',
              shareColor: const Color(0xFF9F403D),
              background: const Color(0xFFF2F3FF),
              onTap: () => _open(const CryptoDetailScreen()),
              child: Row(
                children: const [
                  Expanded(
                    child: _MiniCryptoCard(
                      symbol: 'BTC',
                      amount: '0.45',
                      change: '+2.4%',
                      positive: true,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _MiniCryptoCard(
                      symbol: 'ETH',
                      amount: '5.20',
                      change: '-0.8%',
                      positive: false,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: const Color(0x336FFBBE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0x1A006D4A)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tăng trưởng kỳ vọng',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF006D4A),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '+18%',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF006D4A),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          'năm 2026',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF005F40),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF113069),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.shield_outlined,
                        color: Colors.white,
                        size: 18,
                      ),
                      const Spacer(),
                      Text(
                        'RISK SCORE',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Trung bình',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFFDBE1FF),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: const LinearProgressIndicator(
                      value: 0.67,
                      minHeight: 4,
                      backgroundColor: Color(0x1AFFFFFF),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFFDBE1FF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _open(Widget screen) {
    Navigator.of(context).push(buildFadeSlideRoute(screen));
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.icon,
    required this.title,
    required this.share,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String share;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            share,
            style: GoogleFonts.inter(
              color: const Color(0xFF0053DB),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _StockCard extends StatelessWidget {
  const _StockCard({required this.stock});

  final StockPosition stock;

  @override
  Widget build(BuildContext context) {
    final changeColor = stock.changePositive
        ? const Color(0xFF006D4A)
        : const Color(0xFF9F403D);
    return Container(
      padding: const EdgeInsets.all(21),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1A98B1F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                stock.symbol,
                style: GoogleFonts.inter(
                  color: const Color(0xFF113069),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              Text(
                stock.change,
                style: GoogleFonts.inter(
                  color: changeColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _InfoRow(label: 'Khối lượng', value: stock.volume),
          const SizedBox(height: 4),
          _InfoRow(label: 'Giá vốn', value: stock.costPrice),
          const SizedBox(height: 8),
          _InfoRow(
            label: 'Hiện tại',
            value: stock.currentPrice,
            emphasized: true,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.inter(
      color: emphasized ? const Color(0xFF113069) : const Color(0xFF445D99),
      fontSize: emphasized ? 14 : 11,
      fontWeight: emphasized ? FontWeight.w700 : FontWeight.w500,
    );
    return Row(
      children: [
        Text(label, style: textStyle),
        const Spacer(),
        Text(value, style: textStyle),
      ],
    );
  }
}

class _CategoryBlock extends StatelessWidget {
  const _CategoryBlock({
    required this.icon,
    required this.title,
    required this.share,
    required this.shareColor,
    required this.background,
    required this.onTap,
    required this.child,
  });

  final IconData icon;
  final String title;
  final String share;
  final Color shareColor;
  final Color background;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: const Color(0xFF113069), size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                Text(
                  share,
                  style: GoogleFonts.inter(
                    color: shareColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _MiniSummaryCard extends StatelessWidget {
  const _MiniSummaryCard({
    required this.label,
    required this.value,
    required this.trailingLabel,
    required this.trailingValue,
    required this.positive,
  });

  final String label;
  final String value;
  final String trailingLabel;
  final String trailingValue;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                trailingLabel,
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 12,
                ),
              ),
              Text(
                trailingValue,
                style: GoogleFonts.inter(
                  color: positive
                      ? const Color(0xFF006D4A)
                      : const Color(0xFF9F403D),
                  fontSize: 16,
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

class _MiniCryptoCard extends StatelessWidget {
  const _MiniCryptoCard({
    required this.symbol,
    required this.amount,
    required this.change,
    required this.positive,
  });

  final String symbol;
  final String amount;
  final String change;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            symbol,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            amount,
            style: GoogleFonts.inter(
              color: const Color(0xFF113069),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            change,
            style: GoogleFonts.inter(
              color: positive
                  ? const Color(0xFF006D4A)
                  : const Color(0xFF9F403D),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
