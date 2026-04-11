import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../ai/presentation/screens/assistant_landing_screen.dart';
import '../widgets/home_components.dart';
import 'main_navigation_shell.dart';
import 'mode_selection_screen.dart';

class ModeSelectionScreen extends StatelessWidget {
  const ModeSelectionScreen({super.key});

  void _startDashboard(BuildContext context, String mode) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã chọn $mode. Demo sẽ vào dashboard.')),
    );
    Navigator.of(
      context,
    ).pushReplacement(buildFadeSlideRoute(const MainNavigationShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                const TopBrandBar(showHelp: true),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 48, 24, 48),
                    child: Column(
                      children: [
                        Text(
                          'Kiến tạo không\ngian tài chính\ncủa riêng bạn.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 48,
                            height: 1.25,
                            letterSpacing: -2.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Chọn phương thức khởi đầu hành trình\nquản lý tài sản tinh tế tại The Atelier.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 18,
                            height: 1.56,
                          ),
                        ),
                        const SizedBox(height: 36),
                        _ModeCard(
                          accentColor: Colors.white,
                          backgroundColor: Colors.white,
                          iconColor: const Color(0xFF0053DB),
                          icon: Icons.cloud_done_outlined,
                          title: 'Chế độ Trực tuyến',
                          description:
                              'Đồng bộ hóa dữ liệu tức thời trên mọi thiết bị. An tâm với bảo mật đám mây và báo cáo chi tiết theo thời gian thực.',
                          bullets: const [
                            'Đồng bộ đa thiết bị',
                            'Sao lưu dữ liệu tự động',
                            'Tính năng cộng tác (Shared Wallets)',
                          ],
                          primary: true,
                          buttonLabel: 'Bắt đầu',
                          onTap: () =>
                              _startDashboard(context, 'Chế độ Trực tuyến'),
                        ),
                        const SizedBox(height: 24),
                        _ModeCard(
                          accentColor: const Color(0xFFF2F3FF),
                          backgroundColor: const Color(0xFFF2F3FF),
                          iconColor: const Color(0xFF445D99),
                          icon: Icons.shield_outlined,
                          title: 'Chế độ Ngoại tuyến',
                          description:
                              'Dữ liệu của bạn chỉ nằm trên thiết bị này. Hoàn toàn riêng tư, không cần kết nối mạng, khởi tạo ngay lập tức.',
                          bullets: const [
                            'Quyền riêng tư tuyệt đối',
                            'Tốc độ truy cập tối đa',
                            'Không quảng cáo, không theo dõi',
                          ],
                          primary: false,
                          buttonLabel: 'Trải nghiệm ngay',
                          onTap: () =>
                              _startDashboard(context, 'Chế độ Ngoại tuyến'),
                        ),
                        const SizedBox(height: 20),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Bạn có thể đổi chế độ sau trong cài đặt.',
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 13,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0x80D9E2FF),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0x1A98B1F2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.info_outline_rounded,
                                  size: 15,
                                  color: Color(0xFF113069),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Tôi có thể thay đổi sau không?',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF113069),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'DESIGNED FOR FINANCIAL CLARITY &\nSERENITY',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: const Color(0x99445D99),
                            fontSize: 14,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _FooterBadge(label: 'AES-256'),
                            const SizedBox(width: 24),
                            _FooterBadge(label: 'GDPR COMPLIANT'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              buildFadeSlideRoute(
                                const AssistantLandingScreen(),
                              ),
                            );
                          },
                          child: const Text('Xem demo module AI'),
                        ),
                      ],
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

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.accentColor,
    required this.backgroundColor,
    required this.iconColor,
    required this.icon,
    required this.title,
    required this.description,
    required this.bullets,
    required this.primary,
    required this.buttonLabel,
    required this.onTap,
  });

  final Color accentColor;
  final Color backgroundColor;
  final Color iconColor;
  final IconData icon;
  final String title;
  final String description;
  final List<String> bullets;
  final bool primary;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: primary ? const Color(0x00000000) : const Color(0x1A000000),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: primary ? const Color(0xFFDBE1FF) : Colors.white54,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 16,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          for (final bullet in bullets) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  primary
                      ? Icons.check_circle_outline_rounded
                      : Icons.verified_user_outlined,
                  size: 18,
                  color: primary
                      ? const Color(0xFF006D4A)
                      : const Color(0xFF6079B7),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    bullet,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF113069),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
          const SizedBox(height: 10),
          if (primary)
            PrimaryBlueButton(label: buttonLabel, onTap: onTap)
          else
            OutlineBlueButton(label: buttonLabel, onTap: onTap),
        ],
      ),
    );
  }
}

class _FooterBadge extends StatelessWidget {
  const _FooterBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.verified_user_outlined,
          size: 16,
          color: Color(0x66445D99),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0x66445D99),
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
