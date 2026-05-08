import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';
import '../../core/theme.dart';

class ExportHistoryScreen extends StatelessWidget {
  const ExportHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const HeaderWidget(),
        Expanded(
          child: Container(
            color: const Color(0xFFE0E7FF), // Light purple/blue background
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.history, color: AppTheme.primaryBlue, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'TÀI LIỆU CỦA BẠN',
                        style: GoogleFonts.inter(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lịch sử Xuất dữ liệu',
                    style: GoogleFonts.inter(
                      color: AppTheme.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Quản lý và tải lại các báo cáo tài chính đã được trích xuất từ hệ thống Ledger.',
                    style: GoogleFonts.inter(
                      color: AppTheme.textGray,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Stats Cards
                  _buildStatCard(
                    title: 'Tổng số tệp',
                    value: '24',
                    color: Colors.white,
                    valueColor: AppTheme.primaryBlue,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Định dạng phổ biến',
                    value: 'PDF',
                    color: Colors.white,
                    valueColor: AppTheme.darkBlue,
                  ),
                  const SizedBox(height: 16),
                  _buildStatCard(
                    title: 'Dung lượng đã dùng',
                    value: '128 MB',
                    color: AppTheme.primaryGreen,
                    valueColor: AppTheme.darkBlue,
                    titleColor: AppTheme.darkBlue,
                  ),
                  const SizedBox(height: 24),
                  
                  // Filters
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip('Tất cả', isActive: true),
                        _buildFilterChip('PDF'),
                        _buildFilterChip('CSV'),
                        _buildFilterChip('Excel'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Tài liệu gần đây',
                    style: GoogleFonts.inter(
                      color: AppTheme.darkBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDocumentItem('Báo cáo chi tiêu Tháng 10', 'PDF', '1.2 MB', '12/10/2023'),
                  _buildDocumentItem('Giao dịch Quý 3', 'CSV', '3.4 MB', '01/10/2023'),
                  _buildDocumentItem('Hóa đơn tiền điện năng', 'PDF', '0.8 MB', '25/09/2023'),
                  _buildDocumentItem('Biến động số dư Tháng 9', 'Excel', '2.1 MB', '01/09/2023'),
                  _buildDocumentItem('Báo cáo chi tiêu Tháng 8', 'PDF', '1.5 MB', '12/08/2023'),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentItem(String title, String type, String size, String date) {
    IconData icon;
    Color iconColor;
    if (type == 'PDF') {
      icon = Icons.picture_as_pdf;
      iconColor = Colors.redAccent;
    } else if (type == 'CSV') {
      icon = Icons.description;
      iconColor = Colors.green;
    } else {
      icon = Icons.table_chart;
      iconColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$type • $size • $date',
                  style: GoogleFonts.inter(
                    color: AppTheme.textGray,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, color: AppTheme.primaryBlue),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required Color valueColor,
    Color titleColor = AppTheme.textGray,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (color == Colors.white)
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: titleColor,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.inter(
              color: valueColor,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isActive = false}) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.primaryBlue : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: isActive ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          color: isActive ? Colors.white : AppTheme.darkBlue,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }
}
