import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../home/presentation/widgets/home_components.dart';

class SpendingStructureScreen extends StatefulWidget {
  const SpendingStructureScreen({super.key});

  @override
  State<SpendingStructureScreen> createState() =>
      _SpendingStructureScreenState();
}

class _SpendingStructureScreenState extends State<SpendingStructureScreen> {
  DateTime _selectedMonth = DateTime(2026, 3);

  void _shiftMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = <_StructureCategory>[
      const _StructureCategory(
        name: 'Ăn uống',
        percentLabel: '15% của tổng chi',
        amount: 3575000,
        barColor: Color(0xFF0053DB),
        amountColor: Color(0xFF0053DB),
        trendIcon: Icons.trending_up_rounded,
      ),
      const _StructureCategory(
        name: 'Nhà cửa',
        percentLabel: '20% của tổng chi',
        amount: 4900000,
        barColor: Color(0xFF0C8A5D),
        amountColor: Color(0xFF0C8A5D),
        trendIcon: Icons.trending_flat_rounded,
      ),
      const _StructureCategory(
        name: 'Di chuyển',
        percentLabel: '2% của tổng chi',
        amount: 500000,
        barColor: Color(0xFF4B5563),
        amountColor: Color(0xFF6B7280),
        trendIcon: Icons.trending_up_rounded,
      ),
      const _StructureCategory(
        name: 'Mua sắm',
        percentLabel: '15% của tổng chi',
        amount: 675000,
        barColor: Color(0xFF9F403D),
        amountColor: Color(0xFF9F403D),
        trendIcon: Icons.trending_down_rounded,
      ),
      const _StructureCategory(
        name: 'Khác',
        percentLabel: '5% của tổng chi',
        amount: 1225000,
        barColor: Color(0xFFDFD5F7),
        amountColor: Color(0xFF445D99),
        trendIcon: Icons.trending_flat_rounded,
      ),
    ];

    final total = categories.fold<int>(0, (sum, item) => sum + item.amount);
    final segments = categories
        .map(
          (e) => _DonutSegment(value: e.amount.toDouble(), color: e.barColor),
        )
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                _TopBar(onBack: () => Navigator.of(context).pop()),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 18),
                        _MonthSelector(
                          label: _monthLabel(_selectedMonth),
                          onPrev: () => _shiftMonth(-1),
                          onNext: () => _shiftMonth(1),
                        ),
                        const SizedBox(height: 22),
                        _DonutSummary(
                          label: 'TỔNG CHI',
                          value: _formatVnNumber(total),
                          segments: segments,
                        ),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'CHI TIẾT DANH MỤC',
                            style: GoogleFonts.manrope(
                              color: const Color(0xFF445D99),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        for (final item in categories) ...[
                          _CategoryCard(item: item),
                          const SizedBox(height: 12),
                        ],
                        const SizedBox(height: 12),
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

  String _monthLabel(DateTime date) => 'Tháng ${date.month}, ${date.year}';
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF113069),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Cơ cấu thu chi',
            style: GoogleFonts.manrope(
              color: const Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.label,
    required this.onPrev,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F3FF),
      borderRadius: BorderRadius.circular(12),
      elevation: 0.6,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              visualDensity: VisualDensity.compact,
              iconSize: 18,
              onPressed: onPrev,
              icon: const Icon(Icons.chevron_left_rounded),
              color: const Color(0xFF113069),
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 16,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              visualDensity: VisualDensity.compact,
              iconSize: 18,
              onPressed: onNext,
              icon: const Icon(Icons.chevron_right_rounded),
              color: const Color(0xFF113069),
            ),
          ],
        ),
      ),
    );
  }
}

class _DonutSummary extends StatelessWidget {
  const _DonutSummary({
    required this.label,
    required this.value,
    required this.segments,
  });

  final String label;
  final String value;
  final List<_DonutSegment> segments;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 256,
      height: 256,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(256, 256),
            painter: _DonutPainter(segments: segments),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.item});

  final _StructureCategory item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F3FF),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            buildFadeSlideRoute(
              CategoryTransactionHistoryScreen(category: item),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 40,
                decoration: BoxDecoration(
                  color: item.barColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.percentLabel,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_formatVnNumber(item.amount)}đ',
                    style: GoogleFonts.manrope(
                      color: item.amountColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Icon(item.trendIcon, size: 14, color: item.amountColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryTransactionHistoryScreen extends StatelessWidget {
  const CategoryTransactionHistoryScreen({super.key, required this.category});

  final _StructureCategory category;

  @override
  Widget build(BuildContext context) {
    final transactions = _demoTransactionsFor(category.name);
    final total = transactions.fold<int>(0, (sum, item) => sum + item.amount);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                _CategoryTopBar(
                  title: category.name,
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CategorySummaryCard(
                          categoryName: category.name,
                          subtitle: 'Lịch sử giao dịch theo danh mục',
                          totalAmount: total,
                          accent: category.barColor,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'GIAO DỊCH',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF445D99),
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (transactions.isEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: const Color(0x1A98B1F2),
                              ),
                            ),
                            child: Text(
                              'Chưa có giao dịch nào trong danh mục này.',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF6C82B3),
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x0A113069),
                                  blurRadius: 18,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                for (
                                  var index = 0;
                                  index < transactions.length;
                                  index++
                                ) ...[
                                  _CategoryTransactionRow(
                                    transaction: transactions[index],
                                  ),
                                  if (index != transactions.length - 1)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Divider(
                                        height: 1,
                                        color: Color(0x1498B1F2),
                                      ),
                                    ),
                                ],
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
        ],
      ),
    );
  }
}

class _CategoryTopBar extends StatelessWidget {
  const _CategoryTopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF113069),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: const Color(0xFF0F172A),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategorySummaryCard extends StatelessWidget {
  const _CategorySummaryCard({
    required this.categoryName,
    required this.subtitle,
    required this.totalAmount,
    required this.accent,
  });

  final String categoryName;
  final String subtitle;
  final int totalAmount;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final isIncome = totalAmount >= 0;
    final valueColor = isIncome
        ? const Color(0xFF006D4A)
        : const Color(0xFF9F403D);
    final sign = isIncome ? '+' : '-';
    final compact = '${_formatVnNumber(totalAmount.abs())}đ';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 52,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryName,
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF6C82B3),
                    fontSize: 12,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$sign$compact',
            style: GoogleFonts.manrope(
              color: valueColor,
              fontSize: 16,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryTransactionRow extends StatelessWidget {
  const _CategoryTransactionRow({required this.transaction});

  final _DemoTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.amount >= 0;
    final amountColor = isIncome
        ? const Color(0xFF006D4A)
        : const Color(0xFF9F403D);
    final sign = isIncome ? '+' : '-';
    final compact = '${_formatVnNumber(transaction.amount.abs())}đ';

    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: transaction.iconBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(transaction.icon, color: const Color(0xFF113069)),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: GoogleFonts.inter(
                  color: const Color(0xFF113069),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                transaction.time,
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$sign$compact',
          style: GoogleFonts.inter(
            color: amountColor,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _DemoTransaction {
  const _DemoTransaction({
    required this.title,
    required this.time,
    required this.amount,
    required this.icon,
    required this.iconBackground,
  });

  final String title;
  final String time;
  final int amount;
  final IconData icon;
  final Color iconBackground;
}

List<_DemoTransaction> _demoTransactionsFor(String categoryName) {
  switch (categoryName) {
    case 'Ăn uống':
      return const [
        _DemoTransaction(
          title: 'Bún bò trưa',
          time: '06/03/2026 • 12:45',
          amount: -85000,
          icon: Icons.restaurant_rounded,
          iconBackground: Color(0xFFFFEDD5),
        ),
        _DemoTransaction(
          title: 'Trà sữa',
          time: '05/03/2026 • 20:15',
          amount: -52000,
          icon: Icons.local_cafe_outlined,
          iconBackground: Color(0xFFFFEDD5),
        ),
        _DemoTransaction(
          title: 'Siêu thị mini',
          time: '03/03/2026 • 18:05',
          amount: -210000,
          icon: Icons.shopping_cart_outlined,
          iconBackground: Color(0xFFFFEDD5),
        ),
      ];
    case 'Nhà cửa':
      return const [
        _DemoTransaction(
          title: 'Tiền điện',
          time: '04/03/2026 • 09:10',
          amount: -350000,
          icon: Icons.lightbulb_outline_rounded,
          iconBackground: Color(0xFFDDFBE8),
        ),
        _DemoTransaction(
          title: 'Tiền nước',
          time: '04/03/2026 • 09:12',
          amount: -120000,
          icon: Icons.water_drop_outlined,
          iconBackground: Color(0xFFDDFBE8),
        ),
        _DemoTransaction(
          title: 'Thuê nhà',
          time: '01/03/2026 • 08:00',
          amount: -3800000,
          icon: Icons.home_outlined,
          iconBackground: Color(0xFFDDFBE8),
        ),
      ];
    case 'Di chuyển':
      return const [
        _DemoTransaction(
          title: 'Đổ xăng',
          time: '02/03/2026 • 08:10',
          amount: -120000,
          icon: Icons.local_gas_station_outlined,
          iconBackground: Color(0xFFDBE1FF),
        ),
        _DemoTransaction(
          title: 'Gửi xe',
          time: '02/03/2026 • 18:30',
          amount: -15000,
          icon: Icons.directions_car_outlined,
          iconBackground: Color(0xFFDBE1FF),
        ),
      ];
    case 'Mua sắm':
      return const [
        _DemoTransaction(
          title: 'Mua Premi CS2',
          time: '07/03/2026 • 14:30',
          amount: -395000,
          icon: Icons.shopping_bag_outlined,
          iconBackground: Color(0xFFFFE4E6),
        ),
        _DemoTransaction(
          title: 'Áo thun',
          time: '03/03/2026 • 21:05',
          amount: -280000,
          icon: Icons.checkroom_outlined,
          iconBackground: Color(0xFFFFE4E6),
        ),
      ];
    case 'Khác':
      return const [
        _DemoTransaction(
          title: 'Quà tặng',
          time: '05/03/2026 • 19:40',
          amount: -150000,
          icon: Icons.card_giftcard_rounded,
          iconBackground: Color(0xFFF3E8FF),
        ),
        _DemoTransaction(
          title: 'Tiền làm thêm',
          time: '01/03/2026 • 08:10',
          amount: 390000,
          icon: Icons.work_outline_rounded,
          iconBackground: Color(0xFFCFEFE6),
        ),
      ];
  }
  return const [];
}

class _StructureCategory {
  const _StructureCategory({
    required this.name,
    required this.percentLabel,
    required this.amount,
    required this.barColor,
    required this.amountColor,
    required this.trendIcon,
  });

  final String name;
  final String percentLabel;
  final int amount;
  final Color barColor;
  final Color amountColor;
  final IconData trendIcon;
}

class _DonutSegment {
  const _DonutSegment({required this.value, required this.color});

  final double value;
  final Color color;
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({required List<_DonutSegment> segments}) : _segments = segments;

  final List<_DonutSegment> _segments;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (math.min(size.width, size.height) / 2) - 12;
    final rect = Rect.fromCircle(center: center, radius: radius);

    const strokeWidth = 20.0;
    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt
      ..color = const Color(0xFFE7EDFF);
    canvas.drawArc(rect, 0, math.pi * 2, false, backgroundPaint);

    final total = _segments.fold<double>(0, (sum, item) => sum + item.value);
    if (total <= 0) return;

    final segmentPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    const gapRadians = 0.03;
    var startAngle = -math.pi / 2;

    for (final segment in _segments) {
      final sweep = (segment.value / total) * (math.pi * 2);
      final sweepWithGap = math.max(0.0, sweep - gapRadians);
      segmentPaint.color = segment.color;
      canvas.drawArc(rect, startAngle, sweepWithGap, false, segmentPaint);
      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) =>
      oldDelegate._segments != _segments;
}

String _formatVnNumber(int amount) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    final reverseIndex = digits.length - index;
    buffer.write(digits[index]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }
  final prefix = amount < 0 ? '-' : '';
  return '$prefix${buffer.toString()}';
}
