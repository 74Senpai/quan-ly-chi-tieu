import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/transaction_demo_data.dart';
import '../widgets/transaction_components.dart';

class CategoryPickerScreen extends StatelessWidget {
  const CategoryPickerScreen({super.key, required this.current});

  final ExpenseCategory current;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              child: SizedBox(
                height: 64,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(12),
                      child: const SizedBox(
                        width: 32,
                        height: 32,
                        child: Icon(Icons.arrow_back_rounded),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Danh mục',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Tất cả danh mục',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '6 DANH MỤC',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 12,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    for (final category in TransactionDemoData.categories) ...[
                      CategoryRow(
                        category: category,
                        selected: category.name == current.name,
                        locked: category.name == 'Khác',
                        onTap: category.name == 'Khác'
                            ? null
                            : () => Navigator.of(context).pop(category),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBE1FF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mẹo nhỏ',
                            style: GoogleFonts.manrope(
                              color: const Color(0xFF0048BF),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Phân loại giao dịch chính xác giúp bạn theo dõi chi tiêu hiệu quả hơn mỗi tuần.',
                            style: GoogleFonts.inter(
                              color: const Color(0xCC0048BF),
                              fontSize: 14,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
