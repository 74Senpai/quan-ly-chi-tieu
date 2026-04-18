import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';
import '../../data/investment_demo_data.dart';
import '../widgets/investment_components.dart';

class InvestmentAddScreen extends StatefulWidget {
  const InvestmentAddScreen({
    super.key,
    this.initialType = InvestmentAssetType.gold,
  });

  final InvestmentAssetType initialType;

  @override
  State<InvestmentAddScreen> createState() => _InvestmentAddScreenState();
}

class _InvestmentAddScreenState extends State<InvestmentAddScreen> {
  late InvestmentAssetType _selectedType = widget.initialType;
  final _nameController = TextEditingController(
    text: 'SJC, PNJ, Vàng nhẫn 9999',
  );
  final _quantityController = TextEditingController(text: '0.00');
  final _priceController = TextEditingController(text: '78,000,000');
  final _dateController = TextEditingController(text: 'mm/dd/yyyy');

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InvestmentScreenShell(
      topBar: InvestmentTopBar(
        title: 'Thêm Đầu tư',
        onBack: () => Navigator.of(context).pop(),
      ),
      bottomBar: _BottomConfirmBar(onTap: _confirm),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 26, 24, 140),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CHỌN LOẠI TÀI SẢN',
              style: GoogleFonts.manrope(
                color: const Color(0xFF445D99),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 163 / 132,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                for (final type in InvestmentAssetType.values)
                  _AssetTypeButton(
                    type: type,
                    selected: type == _selectedType,
                    onTap: () => setState(() => _selectedType = type),
                  ),
              ],
            ),
            const SizedBox(height: 40),
            _FieldLabel('TÊN TÀI SẢN / MÃ'),
            const SizedBox(height: 8),
            _TextFieldBox(
              controller: _nameController,
              hintColor: const Color(0xFF98B1F2),
            ),
            const SizedBox(height: 24),
            _FieldLabel('SỐ LƯỢNG'),
            const SizedBox(height: 8),
            _TextFieldBox(
              controller: _quantityController,
              hintColor: const Color(0xFF98B1F2),
            ),
            const SizedBox(height: 24),
            _FieldLabel('ĐƠN GIÁ MUA'),
            const SizedBox(height: 8),
            _TextFieldBox(
              controller: _priceController,
              hintColor: const Color(0xFF98B1F2),
              suffix: Text(
                'VND',
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 24),
            _FieldLabel('NGÀY GIAO DỊCH'),
            const SizedBox(height: 8),
            _TextFieldBox(
              controller: _dateController,
              hintColor: const Color(0xFF113069),
              suffix: const Icon(
                Icons.calendar_today_outlined,
                color: Color(0xFF445D99),
                size: 18,
              ),
            ),
            const SizedBox(height: 24),
            _FieldLabel('VÍ THANH TOÁN NGUỒN'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE2E7FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF006D4A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Techcombank Savings',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF113069),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          'Số dư: 250,000,000 VND',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF445D99),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0053DB), Color(0xFF0048C1)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x330053DB),
                    blurRadius: 24,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'TỔNG GIÁ TRỊ GIAO DỊCH',
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '0 VND',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Bao gồm thuế & phí 0.05%',
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
            ),
          ],
        ),
      ),
    );
  }

  void _confirm() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Đã thêm giao dịch ${_selectedType.label.toLowerCase()} vào danh mục demo.',
          ),
        ),
      );
    Navigator.of(context).pop();
  }
}

class _AssetTypeButton extends StatelessWidget {
  const _AssetTypeButton({
    required this.type,
    required this.selected,
    required this.onTap,
  });

  final InvestmentAssetType type;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0xFF0053DB) : Colors.transparent,
              width: selected ? 2 : 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: type.iconBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(type.icon, color: type.accent, size: 22),
                ),
                const SizedBox(height: 14),
                Text(
                  type.label,
                  style: GoogleFonts.inter(
                    color: selected
                        ? const Color(0xFF0053DB)
                        : const Color(0xFF113069),
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: const Color(0xFF445D99),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _TextFieldBox extends StatelessWidget {
  const _TextFieldBox({
    required this.controller,
    required this.hintColor,
    this.suffix,
  });

  final TextEditingController controller;
  final Color hintColor;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2E7FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: GoogleFonts.inter(
          color: hintColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          suffixIcon: suffix == null
              ? null
              : Padding(
                  padding: const EdgeInsets.only(right: 18),
                  child: suffix,
                ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 24,
            minHeight: 24,
          ),
        ),
      ),
    );
  }
}

class _BottomConfirmBar extends StatelessWidget {
  const _BottomConfirmBar({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
      decoration: BoxDecoration(
        color: const Color(0xE6FAF8FF),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140053DB),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: PrimaryBlueButton(label: 'Xác nhận thêm', onTap: onTap),
    );
  }
}
