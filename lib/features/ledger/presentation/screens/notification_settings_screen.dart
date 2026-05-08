import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';
import '../../core/theme.dart';
import 'help_detail_screen.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final Map<String, bool> _notificationSwitches = {
    'Cảnh báo Ngân sách': true,
    'Tổng kết Hàng tuần': true,
    'Nhắc nhở Hàng ngày': false,
    'Cảnh báo Bảo mật': true,
    'Bật Giờ yên tĩnh': false,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderWidget(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cài đặt Thông báo Đẩy',
                  style: GoogleFonts.inter(
                    color: AppTheme.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Quản lý cách bạn nhận thông tin cập nhật từ tài chính cá nhân.',
                  style: GoogleFonts.inter(
                    color: AppTheme.textGray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 32),
                
                _buildSettingItem(
                  icon: Icons.warning_amber_rounded,
                  iconColor: Colors.orange,
                  title: 'Cảnh báo Ngân sách',
                  subtitle: 'Thông báo khi bạn chi tiêu gần mức giới hạn',
                  value: true,
                ),
                _buildSettingItem(
                  icon: Icons.list_alt,
                  iconColor: AppTheme.primaryGreen,
                  title: 'Tổng kết Hàng tuần',
                  subtitle: 'Báo cáo tóm tắt chi tiêu mỗi sáng thứ Hai',
                  value: true,
                ),
                _buildSettingItem(
                  icon: Icons.calendar_today,
                  iconColor: AppTheme.primaryBlue,
                  title: 'Nhắc nhở Hàng ngày',
                  subtitle: 'Nhắc nhở ghi chép giao dịch hàng ngày',
                  value: false,
                ),
                _buildSettingItem(
                  icon: Icons.security,
                  iconColor: Colors.redAccent,
                  title: 'Cảnh báo Bảo mật',
                  subtitle: 'Cảnh báo đăng nhập lạ hoặc thay đổi mật khẩu',
                  value: true,
                ),
                const SizedBox(height: 24),
                Text(
                  'Giờ yên tĩnh (Silent Hours)',
                  style: GoogleFonts.inter(
                    color: AppTheme.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tắt tất cả thông báo trong khoảng thời gian này.',
                  style: GoogleFonts.inter(
                    color: AppTheme.textGray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                _buildSettingItem(
                  icon: Icons.do_not_disturb_on,
                  iconColor: Colors.deepPurple,
                  title: 'Bật Giờ yên tĩnh',
                  subtitle: 'Không làm phiền',
                  value: false,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTimePicker(
                        label: 'Từ',
                        time: '22:00',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTimePicker(
                        label: 'Đến',
                        time: '06:00',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpDetailScreen()),
                      );
                    },
                    icon: const Icon(Icons.help_outline, color: AppTheme.primaryBlue),
                    label: Text(
                      'Trung tâm Trợ giúp',
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      side: const BorderSide(color: AppTheme.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: AppTheme.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: AppTheme.textGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _notificationSwitches[title] ?? value,
            onChanged: (val) {
              setState(() {
                _notificationSwitches[title] = val;
              });
            },
            activeColor: Colors.white,
            activeTrackColor: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildTimePicker({required String label, required String time}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppTheme.textGray,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                time,
                style: GoogleFonts.inter(
                  color: AppTheme.darkBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Icon(Icons.access_time, color: AppTheme.textGray, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}
