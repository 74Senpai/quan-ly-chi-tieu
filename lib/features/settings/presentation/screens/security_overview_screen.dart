import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import 'security_detail_screen.dart';

class SecurityOverviewScreen extends StatefulWidget {
  const SecurityOverviewScreen({super.key});

  @override
  State<SecurityOverviewScreen> createState() => _SecurityOverviewScreenState();
}

class _SecurityOverviewScreenState extends State<SecurityOverviewScreen> {
  bool _discreetMode = true;

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
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PageHeader(),
                    const SizedBox(height: 16),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _ConnectedServicesCard()),
                          const SizedBox(width: 10),
                          Expanded(child: _DataPortabilityCard()),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    _DiscreetModeCard(
                      value: _discreetMode,
                      onChanged: (v) => setState(() => _discreetMode = v),
                    ),
                    const SizedBox(height: 10),
                    _PrivacyScoreCard(
                      onTap: () => Navigator.of(context).push(
                        buildFadeSlideRoute(const SecurityDetailScreen()),
                      ),
                    ),
                    const SizedBox(height: 10),
                    _RecentActivityCard(),
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
            'Security',
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

class _PageHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'SECURITY CENTER',
          style: GoogleFonts.inter(
            color: const Color(0xFF445D99),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Your Data,\nStrictly Private.',
          style: GoogleFonts.manrope(
            color: const Color(0xFF113069),
            fontSize: 28,
            fontWeight: FontWeight.w800,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Manage your digital footprint, review recent activity, and control how third-party services access your data.',
          style: GoogleFonts.inter(
            color: const Color(0xFF445D99),
            fontSize: 13,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

class _ConnectedServicesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.link_rounded, color: Color(0xFF0053DB), size: 24),
          const SizedBox(height: 10),
          Text(
            'Connected\nServices',
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plaid Connection',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF113069),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Read-only access',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 6),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Revoke',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF9F403D),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
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

class _DataPortabilityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.download_rounded, color: Color(0xFF0053DB), size: 24),
          const SizedBox(height: 10),
          Text(
            'Data\nPortability',
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Download a cryptographic archive of all your transactions.',
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Request Archive',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0053DB),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscreetModeCard extends StatelessWidget {
  const _DiscreetModeCard({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.visibility_off_rounded, color: Color(0xFF445D99), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Discreet Mode',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Obscure balances in public spaces',
                  style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 12),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    value
                        ? 'Active. Balances will appear as asterisks until you tap them.'
                        : 'Inactive. All balances are visible.',
                    style: GoogleFonts.inter(
                      color: value ? const Color(0xFF006D4A) : const Color(0xFF445D99),
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF0053DB),
            activeTrackColor: const Color(0xFFB8CBFF),
          ),
        ],
      ),
    );
  }
}

class _PrivacyScoreCard extends StatelessWidget {
  const _PrivacyScoreCard({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0053DB),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PRIVACY SCORE',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFB8CBFF),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '98',
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          '/100',
                          style: GoogleFonts.inter(color: const Color(0xFFB8CBFF), fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Your account security is optimal. No action required.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFB8CBFF),
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFFB8CBFF), size: 16),
          ],
        ),
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      (device: 'iPhone 14 Pro', location: 'London, UK • 192.168.1.1', time: 'Just now'),
      (device: 'MacBook Pro 16"', location: 'London, UK • 192.168.1.42', time: 'Yesterday, 14:30'),
      (device: 'Web Portal', location: 'London, UK', time: '2 days ago'),
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Login Activity',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
                  'View All',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Review where your account has been accessed',
            style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 12),
          ),
          const SizedBox(height: 14),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.devices_rounded, color: Color(0xFF445D99), size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.device,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF113069),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          item.location,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item.time,
                    style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
