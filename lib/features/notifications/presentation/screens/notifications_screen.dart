import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';
import '../../data/notification_data.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _HeaderAppBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          'Thông báo',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 48,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Trung tâm tài chính của bạn luôn được cập nhật.',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 48),
                        _SectionHeader(
                          title: 'Hôm nay',
                          actionLabel: '1 THÔNG BÁO MỚI',
                        ),
                        const SizedBox(height: 16),
                        ...NotificationDemoData.todayNotifications.map(
                          (n) => _NotificationCard(notification: n),
                        ),
                        const SizedBox(height: 40),
                        _SectionHeader(title: 'Tuần này', actionLabel: 'ĐÃ XEM'),
                        const SizedBox(height: 16),
                        ...NotificationDemoData.weekNotifications.map(
                          (n) => _NotificationCard(notification: n),
                        ),
                        const SizedBox(height: 40),
                        _PromoBanner(),
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

class _HeaderAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF113069),
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'Thông báo',
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.actionLabel});

  final String title;
  final String actionLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            color: const Color(0xFF113069),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        Text(
          actionLabel,
          style: GoogleFonts.inter(
            color: const Color(0xFF6C82B3),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification});

  final NotificationItem notification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A113069),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: notification.iconBackground,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              notification.icon,
              color: const Color(0xFF9F403D),
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      notification.timeLabel,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6C82B3),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notification.description,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 13,
                    height: 1.5,
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

class _PromoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0053DB), Color(0xFF0E67F2)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330053DB),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                Icons.trending_down_rounded,
                size: 140,
                color: Colors.white,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Báo cáo tuần',
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 200,
                child: Text(
                  'Có lẽ đây là khởi đầu mới chúc bạn may mắn !!',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0053DB),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Xem chi tiết',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
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
