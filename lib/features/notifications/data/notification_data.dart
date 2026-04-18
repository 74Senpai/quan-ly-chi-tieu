import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String description;
  final String timeLabel;
  final IconData icon;
  final Color iconBackground;
  final bool isNew;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.description,
    required this.timeLabel,
    required this.icon,
    required this.iconBackground,
    this.isNew = false,
  });
}

class NotificationDemoData {
  static const List<NotificationItem> todayNotifications = [
    NotificationItem(
      id: '1',
      title: 'Thông báo bảo mật',
      description:
          'Vui lòng thiết lập mã pin để có thể bảo vệ tài sản của bạn một cách tốt nhất có thể',
      timeLabel: '10:45 AM',
      icon: Icons.lock_outline_rounded,
      iconBackground: Color(0xFFFFE4E6), // Light red/pink
      isNew: true,
    ),
  ];

  static const List<NotificationItem> weekNotifications = [
    NotificationItem(
      id: '2',
      title: 'Nhắc nhở ghi chép',
      description:
          'Bạn có 3 giao dịch chưa phân loại từ cuối tuần qua. Hãy dành 1 phút để cập nhật nhé.',
      timeLabel: 'THỨ 3',
      icon: Icons.edit_note_rounded,
      iconBackground: Color(0xFFDDFBE8), // Light green
    ),
  ];
}
