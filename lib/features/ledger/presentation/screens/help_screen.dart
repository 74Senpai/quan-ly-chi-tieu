import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';
import '../../core/theme.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
                  'Chúng tôi có thể giúp gì cho bạn?',
                  style: GoogleFonts.inter(
                    color: AppTheme.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tìm kiếm hướng dẫn, mẹo và giải pháp để tối ưu hóa trải nghiệm của bạn.',
                  style: GoogleFonts.inter(
                    color: AppTheme.textGray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm hướng dẫn...',
                      hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                      border: InputBorder.none,
                      icon: Icon(Icons.search, color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Chủ đề phổ biến',
                  style: GoogleFonts.inter(
                    color: AppTheme.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTopicCard(
                  icon: Icons.security,
                  iconColor: AppTheme.primaryBlue,
                  title: 'Bảo mật tài khoản',
                  subtitle: 'Cách chứng thực thiết bị và bảo vệ tài khoản của bạn bằng...',
                ),
                _buildTopicCard(
                  icon: Icons.account_balance_wallet,
                  iconColor: AppTheme.primaryGreen,
                  title: 'Quản lý dữ liệu',
                  subtitle: 'Mẹo thiết lập và duy trì hạn mức chi tiêu...',
                ),
                _buildTopicCard(
                  icon: Icons.payment,
                  iconColor: Colors.orange,
                  title: 'Giao dịch & Thanh toán',
                  subtitle: 'Hướng dẫn quét hóa đơn và theo dõi giao dịch...',
                ),
                _buildTopicCard(
                  icon: Icons.settings,
                  iconColor: Colors.purple,
                  title: 'Cài đặt & Tùy chỉnh',
                  subtitle: 'Cách thay đổi thông báo và giao diện...',
                ),
                _buildTopicCard(
                  icon: Icons.question_answer,
                  iconColor: Colors.redAccent,
                  title: 'Câu hỏi thường gặp',
                  subtitle: 'Các câu hỏi phổ biến từ người dùng...',
                ),
                const SizedBox(height: 32),
                Center(
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Liên hệ Bộ phận Hỗ trợ',
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopicCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 28),
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
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.grey),
        ],
      ),
    );
  }
}
