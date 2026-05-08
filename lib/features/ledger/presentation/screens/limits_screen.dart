import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/header.dart';
import '../../core/theme.dart';

class LimitsScreen extends StatefulWidget {
  const LimitsScreen({super.key});

  @override
  State<LimitsScreen> createState() => _LimitsScreenState();
}

class _LimitsScreenState extends State<LimitsScreen> {
  final Map<String, bool> _categorySwitches = {
    'Ăn uống': true,
    'Mua sắm': true,
    'Di chuyển': true,
    'Giải trí': true,
    'Hóa đơn': true,
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
                  'Hạn mức Chi tiêu',
                  style: GoogleFonts.inter(
                    color: AppTheme.darkBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quản lý ngân sách thông minh',
                  style: GoogleFonts.inter(
                    color: AppTheme.textGray,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                // Blue Summary Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TỔNG CHI TIÊU THÁNG NÀY',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '14.250.000đ',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '/ 20.000.000đ',
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Progress bar
                      Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: 0.71,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppTheme.primaryGreen,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Bạn đã sử dụng 71% ngân sách của mình.',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildCategoryItem(
                  icon: Icons.restaurant,
                  title: 'Ăn uống',
                  subtitle: 'Còn lại 1.200.000đ',
                  spent: '3.8M',
                  total: '5M',
                  progress: 0.76,
                  iconColor: AppTheme.primaryBlue,
                ),
                const SizedBox(height: 16),
                _buildCategoryItem(
                  icon: Icons.shopping_bag,
                  title: 'Mua sắm',
                  subtitle: 'Còn lại 3.500.000đ',
                  spent: '1.5M',
                  total: '5M',
                  progress: 0.3,
                  iconColor: AppTheme.primaryBlue,
                ),
                const SizedBox(height: 16),
                _buildCategoryItem(
                  icon: Icons.directions_car,
                  title: 'Di chuyển',
                  subtitle: 'Còn lại 500.000đ',
                  spent: '1.5M',
                  total: '2M',
                  progress: 0.75,
                  iconColor: Colors.orange,
                ),
                const SizedBox(height: 16),
                _buildCategoryItem(
                  icon: Icons.movie,
                  title: 'Giải trí',
                  subtitle: 'Còn lại 1.000.000đ',
                  spent: '1M',
                  total: '2M',
                  progress: 0.5,
                  iconColor: Colors.purple,
                ),
                const SizedBox(height: 16),
                _buildCategoryItem(
                  icon: Icons.receipt,
                  title: 'Hóa đơn',
                  subtitle: 'Còn lại 0đ',
                  spent: '3M',
                  total: '3M',
                  progress: 1.0,
                  iconColor: Colors.redAccent,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String spent,
    required String total,
    required double progress,
    required Color iconColor,
  }) {
    return Container(
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
      child: Column(
        children: [
          Row(
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
                    const SizedBox(height: 2),
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
                value: _categorySwitches[title] ?? true,
                onChanged: (value) {
                  setState(() {
                    _categorySwitches[title] = value;
                  });
                },
                activeColor: Colors.white,
                activeTrackColor: AppTheme.primaryGreen,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '$spent / $total',
                style: GoogleFonts.inter(
                  color: AppTheme.primaryBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
