import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../data/ai_demo_data.dart';
import '../widgets/assistant_components.dart';
import 'camera_capture_demo_screen.dart';
import 'voice_listening_screen.dart';

class AssistantLandingScreen extends StatefulWidget {
  const AssistantLandingScreen({super.key});

  @override
  State<AssistantLandingScreen> createState() => _AssistantLandingScreenState();
}

class _AssistantLandingScreenState extends State<AssistantLandingScreen> {
  Timer? _greetingTimer;
  bool _showGreeting = false;

  @override
  void initState() {
    super.initState();
    _greetingTimer = Timer(const Duration(milliseconds: 650), () {
      if (mounted) {
        setState(() => _showGreeting = true);
      }
    });
  }

  @override
  void dispose() {
    _greetingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AssistantShell(
      title: 'Trợ lý AI',
      body: [
        const SizedBox(height: 22),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final offset = Tween<Offset>(
              begin: const Offset(0, 0.08),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(position: offset, child: child),
            );
          },
          child: _showGreeting
              ? const AiBubble(
                  key: ValueKey('greeting'),
                  text: AiDemoData.assistantGreeting,
                )
              : const SizedBox(key: ValueKey('empty')),
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
    );
  }
}
