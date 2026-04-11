import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';

class HomeBackground extends StatelessWidget {
  const HomeBackground({super.key, this.showTexture = false});

  final bool showTexture;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF8FF),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFAF8FF), Color(0xFFF3F6FF)],
            ),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-1.0, -1.0),
                radius: 0.7,
                colors: [Color(0xFFDBE1FF), Color(0x00DBE1FF)],
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(1.0, -1.0),
                radius: 0.75,
                colors: [
                  Color(0x55FBCA6F),
                  Color(0x336FFBBE),
                  Color(0x006FFBBE),
                ],
                stops: [0, 0.28, 0.6],
              ),
            ),
          ),
        ),
        if (showTexture)
          Positioned.fill(
            child: Opacity(
              opacity: 0.18,
              child: Image.network(
                AppAssets.homeSplashTexture,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const SizedBox.shrink(),
              ),
            ),
          ),
      ],
    );
  }
}

class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({super.key, required this.index, this.count = 3});

  final int index;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (itemIndex) {
        final active = itemIndex == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          width: active ? 32 : 8,
          height: 8,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF0053DB) : const Color(0x66D9E2FF),
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? const [
                    BoxShadow(
                      color: Color(0x4D0053DB),
                      blurRadius: 6,
                      offset: Offset(0, 1),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class PrimaryBlueButton extends StatelessWidget {
  const PrimaryBlueButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0053DB),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x330053DB),
              blurRadius: 18,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: GoogleFonts.manrope(
                      color: const Color(0xFFF8F7FF),
                      fontSize: 18,
                    ),
                  ),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 10),
                  Icon(icon, color: Colors.white, size: 18),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OutlineBlueButton extends StatelessWidget {
  const OutlineBlueButton({
    super.key,
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFF0053DB), width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: GoogleFonts.manrope(
            color: const Color(0xFF0053DB),
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

enum HomeTab { dashboard, calendar, ai, wallets, settings }

class HomeBottomNavigation extends StatelessWidget {
  const HomeBottomNavigation({
    super.key,
    required this.activeTab,
    this.onTabSelected,
    this.onDashboardTap,
    this.onCalendarTap,
    this.onAiTap,
    this.onWalletsTap,
    this.onSettingsTap,
  });

  final HomeTab activeTab;
  final ValueChanged<HomeTab>? onTabSelected;
  final VoidCallback? onDashboardTap;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onAiTap;
  final VoidCallback? onWalletsTap;
  final VoidCallback? onSettingsTap;

  @override
  Widget build(BuildContext context) {
    final items = <
      ({IconData icon, String label, HomeTab tab, VoidCallback? onTap})
    >[
      (
        icon: Icons.dashboard_outlined,
        label: 'DASHBOARD',
        tab: HomeTab.dashboard,
        onTap: onDashboardTap,
      ),
      (
        icon: Icons.calendar_month_outlined,
        label: 'CALENDAR',
        tab: HomeTab.calendar,
        onTap: onCalendarTap,
      ),
      (
        icon: Icons.auto_awesome,
        label: 'AI ASSISTANT',
        tab: HomeTab.ai,
        onTap: onAiTap,
      ),
      (
        icon: Icons.account_balance_wallet_outlined,
        label: 'WALLETS',
        tab: HomeTab.wallets,
        onTap: onWalletsTap,
      ),
      (
        icon: Icons.settings_outlined,
        label: 'SETTINGS',
        tab: HomeTab.settings,
        onTap: onSettingsTap,
      ),
    ];

    return Container(
      height: 92,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 4.5,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:
            items.map((item) {
              final active = item.tab == activeTab;
              final color = active ? const Color(0xFF5686E1) : const Color(0xFF94A3B8);
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  if (onTabSelected != null) {
                    onTabSelected!(item.tab);
                  } else if (item.onTap != null) {
                    item.onTap!();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Tab ${item.label} đang ở chế độ demo.')),
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item.icon, size: 30, color: color),
                      const SizedBox(height: 6),
                      Text(
                        item.label,
                        style: GoogleFonts.inter(
                          color: color,
                          fontSize: 11,
                          letterSpacing: 0.275,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class TopBrandBar extends StatelessWidget {
  const TopBrandBar({super.key, this.showHelp = false, this.userName});

  final bool showHelp;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            if (userName == null)
              Text(
                'Wallet Manager',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF0053DB),
                  fontSize: 20,
                  letterSpacing: -1,
                ),
              )
            else ...[
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                userName!,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
            const Spacer(),
            if (showHelp)
              Row(
                children: [
                  const Icon(
                    Icons.help_outline_rounded,
                    size: 16,
                    color: Color(0xFF6079B7),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Trợ giúp',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            else
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const NotificationsScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: Color(0xFF0053DB),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProgressDots extends StatelessWidget {
  const ProgressDots({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        ProgressDot(color: Color(0xFF0053DB)),
        SizedBox(width: 4),
        ProgressDot(color: Color(0x660053DB)),
        SizedBox(width: 4),
        ProgressDot(color: Color(0x1A0053DB)),
      ],
    );
  }
}

class ProgressDot extends StatelessWidget {
  const ProgressDot({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
