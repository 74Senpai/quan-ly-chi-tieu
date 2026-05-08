import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';
import '../../core/theme.dart';

class ScanResultScreen extends StatelessWidget {
  const ScanResultScreen({super.key});

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
                // Receipt Image Container
                Container(
                  height: 300,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppTheme.darkBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Placeholder for actual receipt image
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Container(
                          color: Colors.white,
                          child: Opacity(
                            opacity: 0.8,
                            child: Image.network(
                              'https://cdn-icons-png.flaticon.com/512/100/100075.png',
                              color: Colors.grey.shade400,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      // Scan Line
                      Positioned(
                        top: 100, // Fixed position for demo
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: AppTheme.primaryBlue,
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryBlue.withOpacity(0.5),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'GIAO DỊCH MỚI',
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Siêu thị Metro Mart',
                  style: GoogleFonts.inter(
                    color: AppTheme.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '12 Tháng 10, 2023 • 14:30',
                  style: GoogleFonts.inter(
                    color: AppTheme.textGray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildActionCard(
                        icon: Icons.account_balance_wallet,
                        title: 'TỔNG CỘNG',
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        iconColor: AppTheme.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildActionCard(
                        icon: Icons.category,
                        title: 'DANH MỤC',
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        iconColor: AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'CHI TIẾT HÓA ĐƠN',
                  style: GoogleFonts.inter(
                    color: AppTheme.primaryBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                _buildReceiptItem('Sữa tươi Vinamilk 1L', '1', '35.000đ'),
                _buildReceiptItem('Bánh mì Sandwich', '2', '40.000đ'),
                _buildReceiptItem('Nước giải khát Coca', '1', '15.000đ'),
                _buildReceiptItem('Trái cây nhập khẩu', '1', '120.000đ'),
                _buildReceiptItem('Thịt bò Úc 500g', '1', '250.000đ'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'TỔNG CỘNG',
                      style: GoogleFonts.inter(
                        color: AppTheme.darkBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '460.000đ',
                      style: GoogleFonts.inter(
                        color: AppTheme.primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'LƯU GIAO DỊCH',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReceiptItem(String name, String qty, String price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              '$qty x $name',
              style: GoogleFonts.inter(color: AppTheme.darkBlue, fontSize: 14),
            ),
          ),
          Text(
            price,
            style: GoogleFonts.inter(
              color: AppTheme.darkBlue,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 12),
          Text(
            title,
            style: GoogleFonts.inter(
              color: AppTheme.darkBlue,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
