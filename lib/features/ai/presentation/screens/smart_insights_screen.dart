import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmartInsightsScreen extends StatelessWidget {
  const SmartInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _TopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                child: Column(
                  children: const [
                    _InsightCard(
                      tag: 'ALERT',
                      tagColor: Color(0xFFFFFFFF),
                      tagBg: Color(0xFF0053DB),
                      title: 'Subscription Overlap',
                      body:
                          'We detected active subscriptions for both Spotify and Apple Music. Consolidating could save you \$9.99/month.',
                      actionLabel: 'Review Subscriptions',
                      accentColor: Color(0xFF0053DB),
                    ),
                    SizedBox(height: 8),
                    _InsightCard(
                      tag: 'GROWTH',
                      tagColor: Color(0xFFFFFFFF),
                      tagBg: Color(0xFF006D4A),
                      title: 'Savings Milestone',
                      body:
                          "You're 15% closer to your 'Emergency Fund' goal this month compared to last. Keep it up!",
                      actionLabel: 'View Goals',
                      accentColor: Color(0xFF006D4A),
                    ),
                    SizedBox(height: 8),
                    _InsightCard(
                      tag: 'ANALYSIS',
                      tagColor: Color(0xFF445D99),
                      tagBg: Color(0xFFDBE1FF),
                      title: 'Grocery Spending',
                      body:
                          'Your grocery spending is up 12% this week. This correlates with two visits to Whole Foods.',
                      actionLabel: 'View Transactions',
                      accentColor: Color(0xFF445D99),
                    ),
                    SizedBox(height: 8),
                    _InsightCard(
                      tag: 'ROUTINE',
                      tagColor: Color(0xFF113069),
                      tagBg: Color(0xFF98B1F2),
                      title: 'Upcoming Bills',
                      body:
                          'You have 3 recurring bills totaling \$245.00 due in the next 5 days. Your checking balance can cover them.',
                      actionLabel: 'Manage Bills',
                      accentColor: Color(0xFF5686E1),
                    ),
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
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                color: const Color(0xFF113069),
              ),
              Text(
                'Smart Insights',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Text(
              'Your AI-curated financial observations. We monitor the details so you can focus on what matters.',
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.tag,
    required this.tagColor,
    required this.tagBg,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.accentColor,
  });

  final String tag;
  final Color tagColor;
  final Color tagBg;
  final String title;
  final String body;
  final String actionLabel;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Color(0x0F000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 6, color: accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: tagBg,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tag,
                          style: GoogleFonts.inter(
                            color: tagColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        body,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF445D99),
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              actionLabel,
                              style: GoogleFonts.inter(
                                color: accentColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.arrow_forward_ios_rounded, size: 12, color: accentColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
