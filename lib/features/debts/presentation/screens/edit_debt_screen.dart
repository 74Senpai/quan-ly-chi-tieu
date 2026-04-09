import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';
import '../../data/debt_store.dart';

class EditDebtScreen extends StatefulWidget {
  const EditDebtScreen({super.key, required this.debtId});

  final String debtId;

  @override
  State<EditDebtScreen> createState() => _EditDebtScreenState();
}

class _EditDebtScreenState extends State<EditDebtScreen> {
  DebtItem? _debt;

  late DebtType _type;
  final _personController = TextEditingController();
  final _amountController = TextEditingController();
  final _interestController = TextEditingController();
  final _noteController = TextEditingController();

  DateTime _loanDate = DateTime.now();
  DateTime? _dueDate;
  String _walletName = 'Ví tiền mặt';

  @override
  void initState() {
    super.initState();
    final debt = DebtStore.instance.value
        .where((e) => e.id == widget.debtId)
        .firstOrNull;
    _debt = debt;
    _type = debt?.type ?? DebtType.lend;
    _personController.text = debt?.personName ?? '';
    _amountController.text = (debt?.amount ?? 0).toString();
    _interestController.text = debt?.interestRatePercent?.toString() ?? '2';
    _noteController.text = debt?.note ?? '';
    _loanDate = debt?.loanDate ?? DateTime.now();
    _dueDate = debt?.dueDate;
    _walletName = debt?.walletName ?? 'Ví tiền mặt';
  }

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

  void _save() {
    final current = _debt;
    if (current == null) return;
    DebtStore.instance.updateDebt(
      current.copyWith(
        type: _type,
        personName: _personController.text.trim().isEmpty
            ? current.personName
            : _personController.text.trim(),
        amount: _parseAmount(),
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

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xóa khoản nợ?'),
          content: const Text('Hành động này không thể hoàn tác.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF9F403D),
              ),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
    if (ok != true) return;
    DebtStore.instance.deleteDebt(widget.debtId);
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_debt == null) {
      return Scaffold(
        body: Stack(
          children: [
            const Positioned.fill(child: HomeBackground()),
            SafeArea(
              child: Column(
                children: [
                  _TopBar(
                    title: 'Sửa Khoản Nợ',
                    onBack: () => Navigator.of(context).pop(),
                    onDelete: null,
                  ),
                  const Expanded(
                    child: Center(child: Text('Khoản nợ không tồn tại.')),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

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
                  title: 'Sửa Khoản Nợ',
                  onBack: () => Navigator.of(context).pop(),
                  onDelete: _delete,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'TRANSACTION MANAGEMENT',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF0053DB),
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Sửa khoản nợ',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.9,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _TypeToggle(
                          type: _type,
                          onChanged: (value) => setState(() => _type = value),
                        ),
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'TÊN NGƯỜI',
                          child: _InputBox(
                            controller: _personController,
                            hintText: 'Tên người',
                            trailingIcon: Icons.badge_outlined,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'SỐ TIỀN',
                          child: _InputBox(
                            controller: _amountController,
                            hintText: '5000000',
                            leadingIcon: Icons.currency_exchange_rounded,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'NGÀY VAY',
                          child: _DateBox(
                            value: formatVnDate(_loanDate),
                            onTap: () => _pickDate(
                              initial: _loanDate,
                              onPicked: (d) => setState(() => _loanDate = d),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'HẠN TRẢ (TÙY CHỌN)',
                          child: _DateBox(
                            value: _dueDate == null
                                ? 'mm/dd/yyyy'
                                : formatVnDate(_dueDate!),
                            onTap: () => _pickDate(
                              initial: _dueDate ?? _loanDate,
                              onPicked: (d) => setState(() => _dueDate = d),
                            ),
                            secondaryIcon: Icons.event_repeat_rounded,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _LabeledField(
                          label: 'LÃI SUẤT',
                          child: _InputBox(
                            controller: _interestController,
                            hintText: '2',
                            leadingIcon: Icons.percent_rounded,
                            trailingText: '/ tháng',
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
                            hintText: 'Thêm ghi chú...',
                          ),
                        ),
                        const SizedBox(height: 22),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: FilledButton(
                            onPressed: _save,
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFF0053DB),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Lưu',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFFF8F7FF),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton.icon(
                            onPressed: _delete,
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              color: Color(0xFF9F403D),
                            ),
                            label: Text(
                              'Xóa khoản nợ',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF9F403D),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
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

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onBack,
    required this.onDelete,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onDelete;

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
              onTap: onDelete,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.delete_outline_rounded,
                  color: onDelete == null
                      ? const Color(0x806C82B3)
                      : const Color(0xFF9F403D),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.type, required this.onChanged});

  final DebtType type;
  final ValueChanged<DebtType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _ToggleChip(
              emoji: '💰',
              label: 'Cho vay',
              selected: type == DebtType.lend,
              onTap: () => onChanged(DebtType.lend),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _ToggleChip(
              emoji: '🤝',
              label: 'Đi vay',
              selected: type == DebtType.borrow,
              onTap: () => onChanged(DebtType.borrow),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.emoji,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Colors.white : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: selected
                ? const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                emoji,
                style: TextStyle(
                  fontSize: 16,
                  color: selected
                      ? const Color(0xFF0053DB)
                      : const Color(0xFF445D99),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: selected
                      ? const Color(0xFF0053DB)
                      : const Color(0xFF445D99),
                  fontSize: 16,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
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
        color: const Color(0xFFE2E7FF),
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
                fontSize: 12,
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
      color: const Color(0xFFE2E7FF),
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
      color: const Color(0xFFE2E7FF),
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
        color: const Color(0xFFE2E7FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
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

extension on Iterable<DebtItem> {
  DebtItem? get firstOrNull => isEmpty ? null : first;
}
