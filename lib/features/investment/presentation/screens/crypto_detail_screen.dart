import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/investment_demo_data.dart';
import '../widgets/investment_components.dart';
import 'investment_add_screen.dart';

class CryptoDetailScreen extends StatelessWidget {
  const CryptoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InvestmentScreenShell(
      topBar: InvestmentTopBar(
        title: 'Chi tiết Crypto',
        onBack: () => Navigator.of(context).pop(),
        compact: true,
      ),
      floatingActionButton: InvestmentFloatingButton(
        onTap: () {
          Navigator.of(context).push(
            buildFadeSlideRoute(
              const InvestmentAddScreen(
                initialType: InvestmentAssetType.crypto,
              ),
            ),
          );
        },
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(32, 32, 32, 32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0053DB), Color(0xFF2E86D7)],
                ),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TỔNG TÀI SẢN CRYPTO',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '\$42,850.42',
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.2,
                          ),
                        ),
                      ),
                      const InvestmentPill(
                        label: '+5.24 %',
                        background: Color(0x2600FFBA),
                        foreground: Color(0xFF6FFBBE),
                        icon: Icons.trending_up_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '≈ 1.08B VND',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.72),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(17),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.16),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.currency_bitcoin_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Top Holding',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withValues(alpha: 0.74),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                'BTC 64.2%',
                                style: GoogleFonts.manrope(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: Color(0x99FFFFFF),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            InvestmentSectionTitle(
              title: 'Thị trường',
              actionLabel: 'Xem tất cả',
              onActionTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Danh sách coin đầy đủ sẽ được mở rộng sau.'),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            for (final ticker in cryptoTickers) ...[
              _MarketTickerTile(ticker: ticker),
              if (ticker != cryptoTickers.last) const SizedBox(height: 16),
            ],
            const SizedBox(height: 32),
            Text(
              'Hoạt động gần đây',
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'HÔM NAY',
              style: GoogleFonts.inter(
                color: const Color(0xFF5B74AE),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            for (final item in cryptoTodayActivities) ...[
              _ActivityTile(item: item),
              if (item != cryptoTodayActivities.last) const SizedBox(height: 8),
            ],
            const SizedBox(height: 20),
            Text(
              'HÔM QUA',
              style: GoogleFonts.inter(
                color: const Color(0xFF5B74AE),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 12),
            for (final item in cryptoYesterdayActivities)
              _ActivityTile(item: item),
          ],
        ),
      ),
    );
  }
}

class _MarketTickerTile extends StatelessWidget {
  const _MarketTickerTile({required this.ticker});

  final MarketTicker ticker;

  @override
  Widget build(BuildContext context) {
    final iconColor = ticker.symbol == 'Bitcoin'
        ? const Color(0xFFFB7B16)
        : const Color(0xFF5F5CE6);
    return Container(
      padding: const EdgeInsets.all(21),
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
              color: ticker.background,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(ticker.icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ticker.symbol,
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  ticker.label,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF4F69A7),
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
                ticker.price,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                ticker.change,
                style: GoogleFonts.inter(
                  color: ticker.changePositive
                      ? const Color(0xFF006D4A)
                      : const Color(0xFF9F403D),
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

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.item});

  final ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              item.icon,
              color: item.positive
                  ? const Color(0xFF006D4A)
                  : const Color(0xFF113069),
              size: 20,
            ),
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
                    fontSize: 12,
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
                  color: item.positive
                      ? const Color(0xFF006D4A)
                      : const Color(0xFF113069),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                item.secondaryAmount,
                style: GoogleFonts.inter(
                  color: const Color(0xFF4F69A7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
