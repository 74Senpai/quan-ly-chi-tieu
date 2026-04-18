import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/tax_demo_data.dart';
import '../widgets/tax_components.dart';

class TaxBreakdownScreen extends StatelessWidget {
  const TaxBreakdownScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return TaxScreenShell(
      topBar: TaxTopBar(
        title: 'Chi tiết phân loại',
        onBack: () => Navigator.of(context).pop(),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TaxSummaryHero(),
            const SizedBox(height: 36),
            Row(
              children: [
                Text(
                  'Danh mục chi tiết',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Divider(
                    color: Color(0xFFE2E7FF),
                    thickness: 1,
                    height: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            for (final item in taxCategoryDetails) ...[
              _TaxCategoryTile(item: item),
              if (item != taxCategoryDetails.last) const SizedBox(height: 16),
            ],
            const SizedBox(height: 20),
            _TaxInsightCard(
              onTap: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Hướng dẫn quyết toán sẽ được bổ sung ở bước tiếp theo.',
                      ),
                    ),
                  );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _TaxSummaryHero extends StatelessWidget {
  const _TaxSummaryHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0053DB), Color(0xFF0048C1)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x260053DB),
            blurRadius: 24,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          const TaxProgressRing(progress: 0.72, label: '72%'),
          const SizedBox(height: 28),
          Text(
            'TỔNG TIỀN THUẾ TẠM TÍNH',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xCCDBE1FF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: '42.580.000 ',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.9,
                  ),
                ),
                TextSpan(
                  text: 'VND',
                  style: GoogleFonts.manrope(
                    color: const Color(0xB3F8F7FF),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0x1AFFFFFF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0x1AFFFFFF)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.history_rounded,
                  color: Colors.white,
                  size: 14,
                ),
                const SizedBox(width: 8),
                Text(
                  'Cập nhật 5 phút trước',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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

class _TaxCategoryTile extends StatelessWidget {
  const _TaxCategoryTile({required this.item});

  final TaxCategoryDetail item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: item.emphasized ? Colors.white : const Color(0x80FFFFFF),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text('${item.title} sẽ có màn riêng sau.')),
            );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: item.emphasized
                ? null
                : Border.all(color: const Color(0x4D98B1F2)),
            boxShadow: item.emphasized
                ? const [
                    BoxShadow(
                      color: Color(0x08113069),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: item.iconBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconForeground, size: 24),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: GoogleFonts.manrope(
                              color: const Color(0xFF113069),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        _StatusBadge(item: item),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.amount,
                            style: GoogleFonts.inter(
                              color: const Color(0xFF113069),
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Text(
                          item.share,
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFB6C3E6),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.item});

  final TaxCategoryDetail item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: item.statusBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        item.status,
        style: GoogleFonts.inter(
          color: item.statusForeground,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }
}

class _TaxInsightCard extends StatelessWidget {
  const _TaxInsightCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFE2E7FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF0053DB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.lightbulb_outline_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Thông tin Quan trọng',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 14,
                      height: 1.6,
                    ),
                    children: [
                      const TextSpan(text: 'Hạn chót quyết toán '),
                      TextSpan(
                        text: 'Thuế TNCN',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF113069),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ' năm 2023 đang đến gần. Vui lòng hoàn tất hồ sơ trước ngày ',
                      ),
                      TextSpan(
                        text: '31/03/2024',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF9F403D),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.6,
                        ),
                      ),
                      const TextSpan(
                        text: ' để tránh phát sinh chi phí chậm nộp.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      child: Text(
                        'Xem hướng dẫn quyết toán',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0053DB),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
