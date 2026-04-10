import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../home/presentation/widgets/home_components.dart';
import '../../data/ai_demo_data.dart';

class AssistantShell extends StatelessWidget {
  const AssistantShell({
    super.key,
    required this.title,
    required this.body,
    required this.onMicTap,
    required this.onCameraTap,
    this.onDashboardTap,
    this.onCalendarTap,
    this.onWalletsTap,
    this.onSettingsTap,
    this.onNotificationTap,
  });

  final String title;
  final List<Widget> body;
  final VoidCallback onMicTap;
  final VoidCallback onCameraTap;
  final VoidCallback? onDashboardTap;
  final VoidCallback? onCalendarTap;
  final VoidCallback? onWalletsTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          SafeArea(
            child: Column(
              children: [
                AssistantHeader(title: title, onNotificationTap: onNotificationTap),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 220),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: body,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 112,
            child: InputBar(onMicTap: onMicTap, onCameraTap: onCameraTap),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: HomeBottomNavigation(
              activeTab: HomeTab.ai,
              onDashboardTap: onDashboardTap,
              onCalendarTap: onCalendarTap,
              onAiTap: () {},
              onWalletsTap: onWalletsTap,
              onSettingsTap: onSettingsTap,
            ),
          ),
        ],
      ),
    );
  }
}

class AssistantHeader extends StatelessWidget {
  const AssistantHeader({super.key, required this.title, this.onNotificationTap});

  final String title;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF475569),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFDBE1FF), width: 2),
            ),
            child: const Icon(
              Icons.lightbulb_rounded,
              color: Color(0xFFFFE5A4),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.manrope(
              color: const Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: onNotificationTap,
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF0053DB),
            ),
          ),
        ],
      ),
    );
  }
}

class InputBar extends StatelessWidget {
  const InputBar({
    super.key,
    required this.onMicTap,
    required this.onCameraTap,
  });

  final VoidCallback onMicTap;
  final VoidCallback onCameraTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x3398B1F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F113069),
            blurRadius: 50,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Ô nhập liệu đang ở chế độ demo.'),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 18,
                ),
                child: Text(
                  'Nhập yêu cầu...',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF94A3B8),
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          GradientActionButton(icon: Icons.mic_rounded, onTap: onMicTap),
          const SizedBox(width: 8),
          GradientActionButton(
            icon: Icons.camera_alt_rounded,
            onTap: onCameraTap,
          ),
        ],
      ),
    );
  }
}

class GradientActionButton extends StatelessWidget {
  const GradientActionButton({
    super.key,
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0053DB), Color(0xFF0048C1)],
        ),
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
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white),
        ),
      ),
    );
  }
}

class AiBubble extends StatelessWidget {
  const AiBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFFDBE1FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.auto_awesome,
            size: 16,
            color: Color(0xFF0053DB),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Container(
            padding: const EdgeInsets.fromLTRB(21, 13, 22, 13),
            decoration: bubbleDecoration(),
            child: Text(
              text,
              style: GoogleFonts.inter(
                color: const Color(0xFF113069),
                fontSize: 16,
                height: 26 / 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class UserBubble extends StatelessWidget {
  const UserBubble({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 290),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0053DB),
          borderRadius: BorderRadius.circular(
            16,
          ).copyWith(topRight: Radius.zero),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: const Color(0xFFF8F7FF),
            fontSize: 16,
            height: 24 / 16,
          ),
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.fields,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
  });

  final String title;
  final IconData icon;
  final List<FieldData> fields;
  final String primaryLabel;
  final String secondaryLabel;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x2698B1F2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF0053DB),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: const Color(0xFF6079B7),
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              Icon(icon, color: const Color(0xFF5686E1), size: 20),
            ],
          ),
          const SizedBox(height: 24),
          for (final field in fields) ...[
            InfoField(data: field),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onPrimaryTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF0053DB),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.check_rounded),
                  label: Text(primaryLabel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextButton.icon(
                  onPressed: onSecondaryTap,
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFE2E7FF),
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: Color(0xFF113069),
                  ),
                  label: Text(
                    secondaryLabel,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF113069),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoField extends StatelessWidget {
  const InfoField({super.key, required this.data});

  final FieldData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.label,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.value,
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 20,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class ReceiptItem extends StatelessWidget {
  const ReceiptItem({super.key, required this.item});

  final ReceiptItemData item;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFF2F3FF))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: const Color(0xFF0053DB),
              borderRadius: BorderRadius.circular(2),
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
                Text(
                  item.category,
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
                item.price,
                style: GoogleFonts.inter(
                  color: const Color(0xFF113069),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'ĐƠN GIÁ',
                style: GoogleFonts.inter(
                  color: const Color(0xFF6079B7),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PulseRing extends StatelessWidget {
  const PulseRing({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final scale = 0.45 + (progress * 0.85);
    final opacity = (1 - progress).clamp(0.0, 1.0);
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF0053DB).withValues(alpha: opacity * 0.3),
            width: 2,
          ),
        ),
      ),
    );
  }
}

class VoiceWaveBars extends StatelessWidget {
  const VoiceWaveBars({super.key, required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(9, (index) {
        final sine = math.sin((progress * 2 * math.pi) + (index * 0.55));
        final height = 16 + ((sine + 1) * 18);
        return Container(
          width: 6,
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: index.isEven
                ? const Color(0xFF0053DB)
                : const Color(0xFF6F94E7),
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class HeaderIconButton extends StatelessWidget {
  const HeaderIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.backgroundColor = const Color(0xFFF2F3FF),
    this.iconColor = const Color(0xFF113069),
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }
}

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFAF8FF),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFFFAF8FF), Color(0xFFF7FAFF)],
            ),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-1.0, -1.0),
                radius: 0.52,
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
                radius: 0.62,
                colors: [Color(0xFF6FFBBE), Color(0x006FFBBE)],
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(1.0, 1.0),
                radius: 0.58,
                colors: [Color(0xFFDBE1FF), Color(0x00DBE1FF)],
              ),
            ),
          ),
        ),
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0x0D0053DB),
                  Color(0x000053DB),
                  Color(0x0D006D4A),
                ],
                stops: [0, 0.5, 1],
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Opacity(
            opacity: 0.12,
            child: Image.network(
              AppAssets.textureBackground,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}

class SplashLogoSection extends StatelessWidget {
  const SplashLogoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 144,
      height: 144,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: const Color(0x1A0053DB),
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          Container(
            width: 96,
            height: 96,
            padding: const EdgeInsets.all(1),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x2698B1F2)),
            ),
            child: Center(
              child: SizedBox(
                width: 40,
                height: 42,
                child: Image.network(
                  AppAssets.splashChartIcon,
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          Positioned(
            right: 28,
            bottom: 18,
            child: Container(
              width: 40,
              height: 40,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: const Color(0xFF006D4A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFAF8FF), width: 2),
              ),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 20,
                  child: Image.network(
                    AppAssets.splashShieldIcon,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashBrandSection extends StatelessWidget {
  const SplashBrandSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Trợ lý ảo',
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            color: const Color(0xFF113069),
            fontSize: 36,
            fontWeight: FontWeight.w400,
            letterSpacing: -2.4,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'BẢO ĐẢM TIỀN CỦA BẠN',
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            color: const Color(0xCC445D99),
            fontSize: 12,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

class SplashLoadingSection extends StatelessWidget {
  const SplashLoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 192,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0xFFE2E7FF),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.centerLeft,
          child: Container(
            width: 45,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF0053DB),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'KHÔNG GIAN TRỢ LÝ',
              style: GoogleFonts.inter(
                color: const Color(0x99445D99),
                fontSize: 10,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(width: 8),
            const ProgressDots(),
          ],
        ),
      ],
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

class FooterBranding extends StatelessWidget {
  const FooterBranding({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'POWERED BY ATELIER INTELLIGENCE',
      textAlign: TextAlign.center,
      style: GoogleFonts.inter(
        color: const Color(0x66445D99),
        fontSize: 10,
        letterSpacing: 1,
      ),
    );
  }
}

BoxDecoration bubbleDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16).copyWith(topLeft: Radius.zero),
    border: Border.all(color: const Color(0x1A98B1F2)),
  );
}

BoxDecoration cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: const Color(0x1A98B1F2)),
  );
}
