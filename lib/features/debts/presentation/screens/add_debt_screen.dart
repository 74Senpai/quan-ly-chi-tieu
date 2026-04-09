import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';
import '../../data/debt_store.dart';

class AddDebtScreen extends StatefulWidget {
  const AddDebtScreen({super.key, required this.initialType});

  final DebtType initialType;

  @override
  State<AddDebtScreen> createState() => _AddDebtScreenState();
}

class _AddDebtScreenState extends State<AddDebtScreen> {
  final _personController = TextEditingController();
  final _amountController = TextEditingController(text: '2000000');
  final _interestController = TextEditingController(text: '2.5');
  final _noteController = TextEditingController();

  DateTime _loanDate = DateTime(2023, 10, 27);
  DateTime? _dueDate;
  String _walletName = 'Ví tiền mặt';

  @override
  void dispose() {
    _personController.dispose();
    _amountController.dispose();
    _interestController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate({
    required DateTime initial,
    required ValueChanged<DateTime> onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) onPicked(picked);
  }

  int _parseAmount() {
    final digits = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  double? _parseInterest() =>
      double.tryParse(_interestController.text.trim().replaceAll(',', '.'));

  void _submit() {
    final amount = _parseAmount();
    final person = _personController.text.trim().isEmpty
        ? 'Chưa đặt tên'
        : _personController.text.trim();
    final id = 'debt-${DateTime.now().millisecondsSinceEpoch}';

    DebtStore.instance.addDebt(
      DebtItem(
        id: id,
        type: widget.initialType,
        personName: person,
        amount: amount,
        paidAmount: 0,
        loanDate: _loanDate,
        dueDate: _dueDate,
        interestRatePercent: _parseInterest(),
        walletName: _walletName,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final interest = _parseInterest() ?? 0;
    final amount = _parseAmount();
    final estimatedMonthly = ((amount * interest / 100) / 12).round();
    final totalRepay = amount + ((amount * interest / 100)).round();

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Thêm khoản nợ',
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 140),
                    child: Column(
                      children: [
                        _AmountAnchor(controller: _amountController),
                        const SizedBox(height: 28),
                        _LabeledField(
                          label: 'TÊN NGƯỜI',
                          child: _InputBox(
                            controller: _personController,
                            hintText: 'Ai đang nợ bạn?',
                            trailingIcon: Icons.badge_outlined,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: _LabeledField(
                                label: 'NGÀY VAY',
                                child: _DateBox(
                                  value: formatVnDate(_loanDate),
                                  onTap: () => _pickDate(
                                    initial: _loanDate,
                                    onPicked: (date) =>
                                        setState(() => _loanDate = date),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _LabeledField(
                                label: 'HẠN TRẢ (TÙY CHỌN)',
                                child: _DateBox(
                                  value: _dueDate == null
                                      ? 'mm/dd/yyyy'
                                      : formatVnDate(_dueDate!),
                                  onTap: () => _pickDate(
                                    initial: _dueDate ?? _loanDate,
                                    onPicked: (date) =>
                                        setState(() => _dueDate = date),
                                  ),
                                  secondaryIcon: Icons.event_repeat_rounded,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'LÃI SUẤT (%)',
                          child: _InputBox(
                            controller: _interestController,
                            hintText: '2.5',
                            leadingIcon: Icons.percent_rounded,
                            trailingText: '%',
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        _InfoCard(
                          title:
                              'Lãi dự kiến: ${formatVnMoney(estimatedMonthly)} / tháng',
                          subtitle: 'Tổng trả: ${formatVnMoney(totalRepay)}',
                        ),
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'VÍ LIÊN KẾT',
                          child: _DropdownBox(
                            value: _walletName,
                            onTap: () {
                              setState(() {
                                _walletName = _walletName == 'Ví tiền mặt'
                                    ? 'Ví chính'
                                    : 'Ví tiền mặt';
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'GHI CHÚ',
                          child: _TextareaBox(
                            controller: _noteController,
                            hintText: 'Thêm chi tiết về khoản nợ...',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomActionBar(label: 'Thêm', onTap: _submit),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
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
          const Spacer(),
          Text(
            title,
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Tùy chọn đang được hoàn thiện.'),
                    ),
                  );
              },
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.more_vert_rounded, color: Color(0xFF113069)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmountAnchor extends StatelessWidget {
  const _AmountAnchor({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'SỐ TIỀN',
          style: GoogleFonts.inter(
            color: const Color(0x99445D99),
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₫',
              style: GoogleFonts.manrope(
                color: const Color(0xFF0053DB),
                fontSize: 30,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(width: 6),
            SizedBox(
              width: 220,
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                ),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(width: 128, height: 1, color: const Color(0x330053DB)),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _InputBox extends StatelessWidget {
  const _InputBox({
    required this.controller,
    required this.hintText,
    this.trailingIcon,
    this.leadingIcon,
    this.trailingText,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData? trailingIcon;
  final IconData? leadingIcon;
  final String? trailingText;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (leadingIcon != null) ...[
            Icon(leadingIcon, color: const Color(0xFF6C82B3)),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: GoogleFonts.inter(
                color: const Color(0xFF113069),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: GoogleFonts.inter(
                  color: const Color(0xFF6B7280),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          if (trailingText != null) ...[
            const SizedBox(width: 10),
            Text(
              trailingText!,
              style: GoogleFonts.inter(
                color: const Color(0xFF6C82B3),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (trailingIcon != null) ...[
            const SizedBox(width: 10),
            Icon(trailingIcon, color: const Color(0xFF0053DB)),
          ],
        ],
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.value,
    required this.onTap,
    this.secondaryIcon,
  });

  final String value;
  final VoidCallback onTap;
  final IconData? secondaryIcon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F3FF),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(
                secondaryIcon ?? Icons.calendar_today_rounded,
                color: const Color(0xFF6C82B3),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6FFEE),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: Color(0xFF006D4A),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF006D4A),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF1A7F5B),
                    fontSize: 12,
                    height: 1.3,
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

class _DropdownBox extends StatelessWidget {
  const _DropdownBox({required this.value, required this.onTap});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F3FF),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Color(0xFF6C82B3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextareaBox extends StatelessWidget {
  const _TextareaBox({required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        maxLines: 5,
        style: GoogleFonts.inter(
          color: const Color(0xFF113069),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: GoogleFonts.inter(
            color: const Color(0xFF6B7280),
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xCCFAF8FF),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        8,
        24,
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 64,
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0053DB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.manrope(
              color: const Color(0xFFF8F7FF),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
