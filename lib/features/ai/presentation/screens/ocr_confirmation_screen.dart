import 'package:flutter/material.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/ai_demo_data.dart';
import '../widgets/assistant_components.dart';
import '../../../home/presentation/screens/main_navigation_shell.dart';
import '../../../home/presentation/widgets/home_components.dart';
import '../../../notifications/presentation/screens/notifications_screen.dart';
import 'camera_capture_demo_screen.dart';
import 'voice_listening_screen.dart';

class OcrConfirmationScreen extends StatelessWidget {
  const OcrConfirmationScreen({super.key});

  void _showDemoSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return AssistantShell(
      title: 'Trợ lý AI',
      body: [
        const SizedBox(height: 22),
        const AiBubble(text: AiDemoData.assistantGreeting),
        const SizedBox(height: 24),
        const AiBubble(text: AiDemoData.receiptSummary),
        const SizedBox(height: 24),
        ActionCard(
          title: 'XÁC NHẬN GIAO DỊCH',
          icon: Icons.receipt_long_outlined,
          fields: AiDemoData.ocrFields,
          primaryLabel: 'Lưu ngay',
          secondaryLabel: 'Chỉnh sửa',
          onPrimaryTap: () =>
              _showDemoSnack(context, 'Đã lưu demo giao dịch OCR.'),
          onSecondaryTap: () => _showDemoSnack(
            context,
            'Màn chỉnh sửa chi tiết chưa được dựng trong demo này.',
          ),
        ),
      ],
      onMicTap: () {
        Navigator.of(
          context,
        ).push(buildFadeSlideRoute(const VoiceListeningScreen()));
      },
      onCameraTap: () {
        Navigator.of(
          context,
        ).push(buildFadeSlideRoute(const CameraCaptureDemoScreen()));
      },
      onDashboardTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          buildFadeSlideRoute(const MainNavigationShell(initialTab: HomeTab.dashboard)),
          (route) => false,
        );
      },
      onCalendarTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          buildFadeSlideRoute(const MainNavigationShell(initialTab: HomeTab.calendar)),
          (route) => false,
        );
      },
      onWalletsTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          buildFadeSlideRoute(const MainNavigationShell(initialTab: HomeTab.wallets)),
          (route) => false,
        );
      },
      onSettingsTap: () {
        Navigator.of(context).pushAndRemoveUntil(
          buildFadeSlideRoute(const MainNavigationShell(initialTab: HomeTab.settings)),
          (route) => false,
        );
      },
      onNotificationTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
        );
      },
    );
  }
}
