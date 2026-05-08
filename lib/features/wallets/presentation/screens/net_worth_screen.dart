import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NetWorthScreen extends StatelessWidget {
  const NetWorthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 8),
                    _HeroSection(),
                    SizedBox(height: 16),
                    _AllocationSection(),
                    SizedBox(height: 16),
                    _AssetSection(),
                    SizedBox(height: 16),
                    _LiabilitySection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFAF8FF),
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            color: const Color(0xFF113069),
          ),
          Text(
            'Net Worth',
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0053DB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TOTAL NET WORTH',
            style: GoogleFonts.inter(
              color: const Color(0xFFB8CBFF),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            alignment: Alignment.centerLeft,
            fit: BoxFit.scaleDown,
            child: Text(
              '\$1,245,890.00',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 48,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF006D4A),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up_rounded, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  '+\$12,450 (1.01%)',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
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

class _AllocationSection extends StatelessWidget {
  const _AllocationSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Allocation',
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 16,
              child: Row(
                children: [
                  Expanded(
                    flex: 75,
                    child: Container(color: const Color(0xFF0053DB)),
                  ),
                  Expanded(
                    flex: 25,
                    child: Container(color: const Color(0xFF9F403D)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LegendDot(color: const Color(0xFF0053DB)),
              const SizedBox(width: 6),
              Text(
                'Assets (75%)',
                style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 13),
              ),
              const SizedBox(width: 20),
              _LegendDot(color: const Color(0xFF9F403D)),
              const SizedBox(width: 6),
              Text(
                'Liabilities (25%)',
                style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _AssetSection extends StatelessWidget {
  const _AssetSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Assets',
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '\$1,661,186.00',
              style: GoogleFonts.manrope(
                color: const Color(0xFF006D4A),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _FinancialItem(
          icon: Icons.account_balance_rounded,
          iconBg: const Color(0xFFDBE1FF),
          iconColor: const Color(0xFF0053DB),
          title: 'Bank Accounts',
          subtitle: 'Checking & Savings',
          amount: '\$85,420.00',
          positive: true,
        ),
        const SizedBox(height: 8),
        _FinancialItem(
          icon: Icons.trending_up_rounded,
          iconBg: const Color(0xFFDBE1FF),
          iconColor: const Color(0xFF0053DB),
          title: 'Investments',
          subtitle: 'Stocks & ETFs',
          amount: '\$425,766.00',
          positive: true,
        ),
        const SizedBox(height: 8),
        _FinancialItem(
          icon: Icons.home_rounded,
          iconBg: const Color(0xFFDBE1FF),
          iconColor: const Color(0xFF0053DB),
          title: 'Property',
          subtitle: 'Primary Residence',
          amount: '\$1,150,000.00',
          positive: true,
        ),
      ],
    );
  }
}

class _LiabilitySection extends StatelessWidget {
  const _LiabilitySection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Liabilities',
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '-\$415,296.00',
              style: GoogleFonts.manrope(
                color: const Color(0xFF9F403D),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _FinancialItem(
          icon: Icons.credit_card_rounded,
          iconBg: const Color(0xFFFE8983),
          iconColor: const Color(0xFF9F403D),
          title: 'Credit Cards',
          subtitle: 'Amex & Visa',
          amount: '-\$5,296.00',
          positive: false,
        ),
        const SizedBox(height: 8),
        _FinancialItem(
          icon: Icons.real_estate_agent_rounded,
          iconBg: const Color(0xFFFE8983),
          iconColor: const Color(0xFF9F403D),
          title: 'Mortgage',
          subtitle: '30-Year Fixed',
          amount: '-\$410,000.00',
          positive: false,
        ),
      ],
    );
  }
}

class _FinancialItem extends StatelessWidget {
  const _FinancialItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.positive,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final String amount;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 22),
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
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.manrope(
              color: positive ? const Color(0xFF006D4A) : const Color(0xFF9F403D),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
