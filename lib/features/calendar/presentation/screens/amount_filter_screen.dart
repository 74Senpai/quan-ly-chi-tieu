import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

class AmountFilterScreen extends StatefulWidget {
  const AmountFilterScreen({super.key});

  @override
  State<AmountFilterScreen> createState() => _AmountFilterScreenState();
}

class _AmountFilterScreenState extends State<AmountFilterScreen> {
  RangeValues _currentRangeValues = const RangeValues(0, 50000000);
  String _selectedQuickFilter = '500k - 2M';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF113069)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Lọc theo Số tiền',
          style: GoogleFonts.manrope(
            color: const Color(0xFF113069),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Đặt lại',
              style: GoogleFonts.inter(
                color: const Color(0xFF0053DB),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THÔNG SỐ LỌC',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Thiết lập\nNgưỡng Chi tiêu',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Khoảng giới hạn',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF445D99),
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '0đ — 50.000.000đ+',
                                  style: GoogleFonts.manrope(
                                    color: const Color(0xFF113069),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E7FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.payments_outlined, color: Color(0xFF0053DB)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      RangeSlider(
                        values: _currentRangeValues,
                        max: 60000000,
                        divisions: 12,
                        activeColor: const Color(0xFF0053DB),
                        inactiveColor: const Color(0xFFE2E7FF),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentRangeValues = values;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('0 VNĐ', style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 10)),
                            Text('25M VNĐ', style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 10)),
                            Text('50M+ VNĐ', style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 10)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(child: _AmountInputField(label: 'TỪ', value: '0')),
                    const SizedBox(width: 16),
                    Expanded(child: _AmountInputField(label: 'ĐẾN', value: '50,000,000')),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'LỌC NHANH',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _QuickChip(
                      label: '< 500k',
                      selected: _selectedQuickFilter == '< 500k',
                      onTap: () => setState(() => _selectedQuickFilter = '< 500k'),
                    ),
                    _QuickChip(
                      label: '500k - 2M',
                      selected: _selectedQuickFilter == '500k - 2M',
                      onTap: () => setState(() => _selectedQuickFilter = '500k - 2M'),
                    ),
                    _QuickChip(
                      label: '2M - 5M',
                      selected: _selectedQuickFilter == '2M - 5M',
                      onTap: () => setState(() => _selectedQuickFilter = '2M - 5M'),
                    ),
                    _QuickChip(
                      label: '> 5M',
                      selected: _selectedQuickFilter == '> 5M',
                      onTap: () => setState(() => _selectedQuickFilter = '> 5M'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD1FAE5).withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF006D4A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.lightbulb_outline_rounded, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Mẹo tài chính',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF006D4A),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Lọc các giao dịch trên 2M để kiểm soát tốt hơn các khoản chi lớn trong tháng này.',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF006D4A),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: PrimaryBlueButton(
              label: 'Áp dụng bộ lọc',
              onTap: () => Navigator.of(context).pop(_selectedQuickFilter),
              icon: Icons.filter_list_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountInputField extends StatelessWidget {
  const _AmountInputField({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF445D99),
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE2E7FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Text(
                'VND',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0053DB),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF0053DB) : const Color(0xFFF2F3FF),
          borderRadius: BorderRadius.circular(12),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0053DB).withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? Colors.white : const Color(0xFF445D99),
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
