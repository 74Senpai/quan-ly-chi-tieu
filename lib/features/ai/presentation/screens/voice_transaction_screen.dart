import 'package:flutter/material.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/ai_demo_data.dart';
import '../widgets/assistant_components.dart';
import 'camera_capture_demo_screen.dart';
import 'voice_listening_screen.dart';

class VoiceTransactionScreen extends StatelessWidget {
  const VoiceTransactionScreen({super.key});

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
        const UserBubble(text: AiDemoData.voiceTranscript),
        const SizedBox(height: 24),
        const AiBubble(text: AiDemoData.voiceConfirmation),
        const SizedBox(height: 24),
        ActionCard(
          title: 'XÁC NHẬN GIAO DỊCH',
          icon: Icons.receipt_long_outlined,
          fields: AiDemoData.voiceFields,
          primaryLabel: 'Lưu ngay',
          secondaryLabel: 'Chỉnh sửa',
          onPrimaryTap: () =>
              _showDemoSnack(context, 'Đã lưu demo giao dịch giọng nói.'),
          onSecondaryTap: () => _showDemoSnack(
            context,
            'Màn chỉnh sửa chưa được dựng trong demo này.',
          ),
        ),
      ],
      onMicTap: () {
        Navigator.of(
          context,
        ).pushReplacement(buildFadeSlideRoute(const VoiceListeningScreen()));
      },
      onCameraTap: () {
        Navigator.of(
          context,
        ).push(buildFadeSlideRoute(const CameraCaptureDemoScreen()));
      },
    );
  }
}
