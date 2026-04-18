import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

class TimeRangeFilterScreen extends StatefulWidget {
  const TimeRangeFilterScreen({super.key});

  @override
  State<TimeRangeFilterScreen> createState() => _TimeRangeFilterScreenState();
}

class _TimeRangeFilterScreenState extends State<TimeRangeFilterScreen> {
  String _selectedPreset = 'Tháng trước';

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
          'Khoảng thời gian',
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
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF113069).withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _PresetRow(
                        label: 'Tháng này',
                        selected: _selectedPreset == 'Tháng này',
                        onTap: () => setState(() => _selectedPreset = 'Tháng này'),
                      ),
                      const Divider(height: 1, indent: 24, endIndent: 24),
                      _PresetRow(
                        label: 'Tháng trước',
                        selected: _selectedPreset == 'Tháng trước',
                        onTap: () => setState(() => _selectedPreset = 'Tháng trước'),
                      ),
                      const Divider(height: 1, indent: 24, endIndent: 24),
                      _PresetRow(
                        label: 'Năm nay',
                        selected: _selectedPreset == 'Năm nay',
                        onTap: () => setState(() => _selectedPreset = 'Năm nay'),
                      ),
                      const Divider(height: 1, indent: 24, endIndent: 24),
                      _PresetRow(
                        label: 'Tất cả thời gian',
                        selected: _selectedPreset == 'Tất cả thời gian',
                        onTap: () => setState(() => _selectedPreset = 'Tất cả thời gian'),
                      ),
                      const Divider(height: 1, indent: 24, endIndent: 24),
                      _CustomRangeArea(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: PrimaryBlueButton(
              label: 'Áp dụng bộ lọc',
              onTap: () => Navigator.of(context).pop(_selectedPreset),
              icon: Icons.filter_list_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetRow extends StatelessWidget {
  const _PresetRow({
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
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                color: selected ? const Color(0xFF0053DB) : const Color(0xFF113069),
                fontSize: 16,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (selected)
              const Icon(Icons.check_circle_rounded, color: Color(0xFF0053DB), size: 24)
            else
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFD9E2FF), width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CustomRangeArea extends StatefulWidget {
  @override
  State<_CustomRangeArea> createState() => _CustomRangeAreaState();
}

class _CustomRangeAreaState extends State<_CustomRangeArea> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _isExpanded = !_isExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            child: Row(
              children: [
                Text(
                  'Tùy chọn',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Icon(
                  _isExpanded ? Icons.expand_less : Icons.expand_more,
                  color: const Color(0xFF445D99),
                ),
              ],
            ),
          ),
        ),
        if (_isExpanded)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DatePickerField(label: 'TỪ NGÀY', date: '01/10/2023'),
                const SizedBox(height: 16),
                _DatePickerField(label: 'ĐẾN NGÀY', date: '31/10/2023'),
              ],
            ),
          ),
      ],
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({required this.label, required this.date});

  final String label;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF445D99),
            fontSize: 10,
            letterSpacing: 0.5,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F3FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text(
                date,
                style: GoogleFonts.inter(
                  color: const Color(0xFF113069),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              const Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF0053DB)),
            ],
          ),
        ),
      ],
    );
  }
}
