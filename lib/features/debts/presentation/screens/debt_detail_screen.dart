import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';
import '../../data/debt_store.dart';
import 'edit_debt_screen.dart';

class DebtDetailScreen extends StatelessWidget {
  const DebtDetailScreen({super.key, required this.debtId});

  final String debtId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: ValueListenableBuilder<List<DebtItem>>(
              valueListenable: DebtStore.instance,
              builder: (context, debts, _) {
                final debt = debts.where((e) => e.id == debtId).firstOrNull;
                if (debt == null) {
                  return Column(
                    children: [
                      _TopBar(
                        title: 'Chi tiết khoản nợ',
                        onBack: () => Navigator.of(context).pop(),
                        onEdit: null,
                      ),
                      const Expanded(
                        child: Center(child: Text('Khoản nợ không tồn tại.')),
                      ),
                    ],
                  );
                }

                return Column(
                  children: [
                    _TopBar(
                      title: 'Chi tiết khoản nợ',
                      onBack: () => Navigator.of(context).pop(),
                      onEdit: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => EditDebtScreen(debtId: debt.id),
                          ),
                        );
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 140),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _HeroCard(debt: debt),
                            const SizedBox(height: 18),
                            Row(
                              children: [
                                Text(
                                  'Lịch sử thanh toán',
                                  style: GoogleFonts.manrope(
                                    color: const Color(0xFF113069),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2E7FF),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                  child: Text(
                                    '${debt.payments.length} Giao dịch',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF445D99),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (debt.payments.isEmpty)
                              Container(
                                width: double.infinity,
                                height: 150,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F3FF),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: const Color(0x3398B1F2),
                                    style: BorderStyle.solid,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.history_toggle_off_rounded,
                                    color: Color(0xFF6C82B3),
                                    size: 44,
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
                                      var i = 0;
                                      i < debt.payments.length;
                                      i++
                                    ) ...[
                                      _PaymentRow(payment: debt.payments[i]),
                                      if (i != debt.payments.length - 1)
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
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _BottomAction(onTap: () => _recordPayment(context)),
          ),
        ],
      ),
    );
  }

  Future<void> _recordPayment(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFFAF8FF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            20 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0x4D98B1F2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Ghi nhận trả nợ',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F3FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Số tiền (vd: 500000)',
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: () {
                    final digits = controller.text.replaceAll(
                      RegExp(r'[^0-9]'),
                      '',
                    );
                    final amount = int.tryParse(digits) ?? 0;
                    Navigator.of(context).pop(amount);
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF006D4A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Xác nhận',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFFE6FFEE),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
    if (result == null || result <= 0) return;

    DebtStore.instance.recordPayment(
      debtId,
      DebtPayment(amount: result, paidAt: DateTime.now()),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onBack,
    required this.onEdit,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onEdit;

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
              onTap: onEdit,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.edit_rounded,
                  color: onEdit == null
                      ? const Color(0x806C82B3)
                      : const Color(0xFF0053DB),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.debt});

  final DebtItem debt;

  @override
  Widget build(BuildContext context) {
    final initials = debt.personName.trim().isEmpty
        ? '?'
        : debt.personName.trim().split(' ').take(2).map((w) => w[0]).join();
    final percent = (debt.progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 22, 18, 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 30,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 128,
            height: 128,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 128,
                  height: 128,
                  child: CircularProgressIndicator(
                    value: debt.progress,
                    strokeWidth: 8,
                    backgroundColor: const Color(0xFFEAEDFF),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      debt.isSettled
                          ? const Color(0xFF006D4A)
                          : const Color(0xFF0053DB),
                    ),
                  ),
                ),
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBE1FF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Center(
                    child: Text(
                      initials.toUpperCase(),
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF0048BF),
                        fontSize: 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF113069),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$percent% PAID',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFFAF8FF),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            debt.personName,
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.75,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatVnMoney(debt.amount),
            style: GoogleFonts.manrope(
              color: const Color(0xFF0053DB),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          if (debt.isOverdue)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: const Color(0x33FE8983),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Quá hạn',
                style: GoogleFonts.inter(
                  color: const Color(0xFF9F403D),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          const SizedBox(height: 10),
          Text(
            'Hạn thanh toán: ${formatVnDate(debt.dueDate ?? debt.loanDate)}',
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 14,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StatBox(
                  label: 'ĐÃ TRẢ',
                  value: formatVnMoney(debt.safePaidAmount),
                  valueColor: const Color(0xFF006D4A),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _StatBox(
                  label: 'CÒN LẠI',
                  value: formatVnMoney(debt.remaining),
                  valueColor: debt.isSettled
                      ? const Color(0xFF006D4A)
                      : const Color(0xFF9F403D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: valueColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  const _PaymentRow({required this.payment});

  final DebtPayment payment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: const Color(0xFFCFEFE6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.payments_outlined, color: Color(0xFF006D4A)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Trả nợ',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                formatVnDate(payment.paidAt),
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(
          '+${formatVnMoney(payment.amount)}',
          style: GoogleFonts.manrope(
            color: const Color(0xFF006D4A),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _BottomAction extends StatelessWidget {
  const _BottomAction({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xCCFAF8FF),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -8),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        24,
        16,
        24,
        32 + MediaQuery.paddingOf(context).bottom,
      ),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF006D4A),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(
            Icons.add_circle_outline_rounded,
            color: Color(0xFFE6FFEE),
          ),
          label: Text(
            'Ghi nhận trả nợ',
            style: GoogleFonts.manrope(
              color: const Color(0xFFE6FFEE),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

extension on Iterable<DebtItem> {
  DebtItem? get firstOrNull => isEmpty ? null : first;
}
