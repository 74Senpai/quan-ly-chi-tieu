import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme.dart';

class HelpDetailScreen extends StatefulWidget {
  const HelpDetailScreen({super.key});

  @override
  State<HelpDetailScreen> createState() => _HelpDetailScreenState();
}

class _HelpDetailScreenState extends State<HelpDetailScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _expandedIndex;

  final List<Map<String, dynamic>> _topics = [
    {
      'icon': Icons.security,
      'color': AppTheme.primaryBlue,
      'title': 'Bảo mật tài khoản',
      'subtitle': 'Cách xác thực thiết bị và bảo vệ tài khoản',
      'faq': [
        {'q': 'Làm thế nào để đổi mật khẩu?', 'a': 'Vào Cài đặt → Bảo mật → Đổi mật khẩu. Nhập mật khẩu cũ rồi nhập mật khẩu mới và xác nhận.'},
        {'q': 'Ứng dụng có hỗ trợ xác thực 2 bước không?', 'a': 'Có. Vào Cài đặt → Bảo mật → Xác thực 2 bước để bật tính năng này.'},
      ],
    },
    {
      'icon': Icons.account_balance_wallet,
      'color': AppTheme.primaryGreen,
      'title': 'Quản lý dữ liệu',
      'subtitle': 'Mẹo thiết lập và duy trì hạn mức chi tiêu',
      'faq': [
        {'q': 'Làm sao để thêm hạn mức chi tiêu?', 'a': 'Vào tab LIMITS → nhấn nút + để thêm danh mục mới và thiết lập ngân sách tương ứng.'},
        {'q': 'Dữ liệu của tôi có được sao lưu không?', 'a': 'Có. Dữ liệu được tự động sao lưu lên đám mây mỗi 24 giờ một lần.'},
      ],
    },
    {
      'icon': Icons.payment,
      'color': Colors.orange,
      'title': 'Giao dịch & Thanh toán',
      'subtitle': 'Hướng dẫn quét hóa đơn và theo dõi giao dịch',
      'faq': [
        {'q': 'Ứng dụng hỗ trợ quét loại hóa đơn nào?', 'a': 'Ứng dụng hỗ trợ quét hóa đơn giấy, ảnh chụp và PDF từ email cho các giao dịch mua hàng tại cửa hàng.'},
        {'q': 'Tôi có thể chỉnh sửa giao dịch sau khi lưu không?', 'a': 'Có. Nhấn vào giao dịch trong tab LEDGER rồi chọn biểu tượng chỉnh sửa để thay đổi.'},
      ],
    },
    {
      'icon': Icons.settings,
      'color': Colors.purple,
      'title': 'Cài đặt & Tùy chỉnh',
      'subtitle': 'Cách thay đổi thông báo và giao diện',
      'faq': [
        {'q': 'Làm sao để tắt thông báo?', 'a': 'Vào tab SETTINGS → Cài đặt thông báo → Tắt từng loại thông báo hoặc bật Giờ yên tĩnh.'},
        {'q': 'Tôi có thể đổi ngôn ngữ không?', 'a': 'Hiện tại ứng dụng hỗ trợ Tiếng Việt và Tiếng Anh. Vào Cài đặt → Ngôn ngữ để thay đổi.'},
      ],
    },
    {
      'icon': Icons.bar_chart,
      'color': Colors.teal,
      'title': 'Báo cáo & Xuất dữ liệu',
      'subtitle': 'Hướng dẫn xuất và tải về các báo cáo tài chính',
      'faq': [
        {'q': 'Tôi có thể xuất dữ liệu sang định dạng nào?', 'a': 'Ứng dụng hỗ trợ xuất sang PDF, CSV và Excel. Vào tab LEDGER → Xuất dữ liệu để chọn định dạng.'},
        {'q': 'Báo cáo hàng tuần gửi vào lúc nào?', 'a': 'Báo cáo tổng kết được gửi tự động vào 8:00 sáng thứ Hai hàng tuần.'},
      ],
    },
    {
      'icon': Icons.question_answer,
      'color': Colors.redAccent,
      'title': 'Câu hỏi thường gặp',
      'subtitle': 'Các câu hỏi phổ biến từ người dùng',
      'faq': [
        {'q': 'Ứng dụng có miễn phí không?', 'a': 'Ứng dụng cung cấp gói cơ bản miễn phí và gói Pro với đầy đủ tính năng nâng cao.'},
        {'q': 'Tôi quên mật khẩu thì phải làm gì?', 'a': 'Nhấn "Quên mật khẩu" ở màn hình đăng nhập. Chúng tôi sẽ gửi link đặt lại qua email của bạn.'},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF6EE7B7),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF065F46)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Trung tâm Trợ giúp',
          style: GoogleFonts.inter(
            color: const Color(0xFF065F46),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: Color(0xFF065F46)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Hero Text
          Text(
            'Chúng tôi có thể\ngiúp gì cho bạn?',
            style: GoogleFonts.inter(
              color: AppTheme.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 28,
              height: 1.3,
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm hướng dẫn...',
                hintStyle: GoogleFonts.inter(color: Colors.grey.shade400),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Colors.grey.shade400),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Quick Actions
          Text(
            'Hỗ trợ nhanh',
            style: GoogleFonts.inter(
              color: AppTheme.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildQuickAction(Icons.chat_bubble_outline, 'Chat\ntrực tiếp', Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildQuickAction(Icons.email_outlined, 'Gửi\nemail', Colors.orange)),
              const SizedBox(width: 12),
              Expanded(child: _buildQuickAction(Icons.phone_outlined, 'Gọi\nhiện tại', Colors.green)),
              const SizedBox(width: 12),
              Expanded(child: _buildQuickAction(Icons.video_call_outlined, 'Video\ncall', Colors.purple)),
            ],
          ),
          const SizedBox(height: 32),

          // Topics
          Text(
            'Chủ đề phổ biến',
            style: GoogleFonts.inter(
              color: AppTheme.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(_topics.length, (index) {
            final topic = _topics[index];
            final isExpanded = _expandedIndex == index;
            final faqs = topic['faq'] as List<Map<String, String>>;
            return _buildTopicCard(
              icon: topic['icon'] as IconData,
              iconColor: topic['color'] as Color,
              title: topic['title'] as String,
              subtitle: topic['subtitle'] as String,
              isExpanded: isExpanded,
              faqs: faqs,
              onTap: () {
                setState(() {
                  _expandedIndex = isExpanded ? null : index;
                });
              },
            );
          }),

          const SizedBox(height: 32),

          // Contact Banner
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue, AppTheme.primaryBlue.withBlue(220)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Vẫn cần trợ giúp?',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Đội ngũ hỗ trợ của chúng tôi luôn sẵn sàng 24/7 để giúp đỡ bạn.',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Liên hệ ngay',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppTheme.darkBlue,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool isExpanded,
    required List<Map<String, String>> faqs,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 26),
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
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
          // Expanded FAQ section
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded
                ? Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                    child: Column(
                      children: [
                        Divider(height: 1, color: Colors.grey.shade200),
                        ...faqs.map((faq) => _buildFAQItem(faq['q']!, faq['a']!)),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 2, right: 10),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  question,
                  style: GoogleFonts.inter(
                    color: AppTheme.darkBlue,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              answer,
              style: GoogleFonts.inter(
                color: AppTheme.textGray,
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
