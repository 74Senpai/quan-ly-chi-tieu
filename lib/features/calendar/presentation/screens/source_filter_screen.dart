import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

class SourceFilterScreen extends StatefulWidget {
  const SourceFilterScreen({super.key});

  @override
  State<SourceFilterScreen> createState() => _SourceFilterScreenState();
}

class _SourceFilterScreenState extends State<SourceFilterScreen> {
  final Set<String> _selectedSources = {'Tiền mặt', 'Visa Credit'};

  void _toggleSource(String name) {
    setState(() {
      if (_selectedSources.contains(name)) {
        _selectedSources.remove(name);
      } else {
        _selectedSources.add(name);
      }
    });
  }

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
          'Nguồn tiền',
          style: GoogleFonts.manrope(
            color: const Color(0xFF113069),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'LỌC THEO NGUỒN TIỀN',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Chọn nguồn\ntiền cần tìm',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 32),
                _SourceSection(
                  title: 'Tiền mặt & Ngân hàng',
                  count: '2 Ví',
                  children: [
                    _SourceRow(
                      name: 'Tiền mặt',
                      value: '2.450.000 đ',
                      icon: Icons.payments_rounded,
                      color: const Color(0xFFD1FAE5),
                      selected: _selectedSources.contains('Tiền mặt'),
                      onTap: () => _toggleSource('Tiền mặt'),
                    ),
                    _SourceRow(
                      name: 'Techcombank',
                      value: '15.820.000 đ',
                      icon: Icons.account_balance_rounded,
                      color: const Color(0xFFDBEAFE),
                      selected: _selectedSources.contains('Techcombank'),
                      onTap: () => _toggleSource('Techcombank'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _SourceSection(
                  title: 'Thẻ tín dụng',
                  count: '1 Thẻ',
                  children: [
                    _SourceRow(
                      name: 'Visa Credit',
                      value: 'Hạn mức: 50.000.000 đ',
                      icon: Icons.credit_card_rounded,
                      color: const Color(0xFFF3E8FF),
                      selected: _selectedSources.contains('Visa Credit'),
                      onTap: () => _toggleSource('Visa Credit'),
                    ),
                  ],
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
              onTap: () => Navigator.of(context).pop(_selectedSources.toList()),
              icon: Icons.filter_list_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _SourceSection extends StatelessWidget {
  const _SourceSection({
    required this.title,
    required this.count,
    required this.children,
  });

  final String title;
  final String count;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E7FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                count,
                style: GoogleFonts.inter(
                  color: const Color(0xFF0053DB),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...children.expand((w) => [w, const SizedBox(height: 12)]).toList()..removeLast(),
      ],
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({
    required this.name,
    required this.value,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String name;
  final String value;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF113069).withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: const Color(0xFF113069)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: selected ? const Color(0xFF0053DB) : const Color(0xFFD9E2FF),
                  width: 2,
                ),
                color: selected ? const Color(0xFF0053DB) : Colors.transparent,
              ),
              child: selected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
            ),
          ],
        ),
      ),
    );
  }
}
