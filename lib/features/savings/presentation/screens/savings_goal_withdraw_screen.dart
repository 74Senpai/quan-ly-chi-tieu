import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';
import '../../data/savings_goal_store.dart';

class SavingsGoalWithdrawScreen extends StatefulWidget {
  const SavingsGoalWithdrawScreen({super.key, required this.goalId});

  final String goalId;

  @override
  State<SavingsGoalWithdrawScreen> createState() =>
      _SavingsGoalWithdrawScreenState();
}

class _SavingsGoalWithdrawScreenState extends State<SavingsGoalWithdrawScreen> {
  final _amountController = TextEditingController(text: '1000000');
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  int _amount() {
    final digits = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final goal = SavingsGoalStore.instance.byId(widget.goalId);
    if (goal == null) {
      return const Scaffold(body: Center(child: Text('Mục tiêu không tồn tại.')));
    }

    final wallet = 'Techcombank';
    final walletBalance = 15000000;
    final afterWallet = walletBalance + _amount();
    final remainingGoal = (goal.currentAmount - _amount()).clamp(0, goal.currentAmount);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Rút tiền mục tiêu',
                  onBack: () => Navigator.of(context).pop(),
                  onMore: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(content: Text('Tùy chọn đang được hoàn thiện.')));
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 140),
                    child: Column(
                      children: [
                        _WarningBanner(),
                        const SizedBox(height: 16),
                        _GoalProgressCard(goal: goal),
                        const SizedBox(height: 16),
                        _AmountPanel(
                          amount: _amount(),
                          remainingInGoal: remainingGoal,
                          onAll: () => setState(() => _amountController.text = goal.currentAmount.toString()),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'CHUYỂN VỀ VÍ',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF445D99),
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        _WalletRow(name: wallet, balance: walletBalance),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.check_circle_rounded, color: Color(0xFF006D4A), size: 16),
                            const SizedBox(width: 10),
                            Text(
                              'Số dư sau khi rút: ${formatVnd(afterWallet)}',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF006D4A),
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0x330053DB)),
                          ),
                          child: TextField(
                            controller: _reasonController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Lý do rút...',
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),
                        _WithdrawImpactHint(),
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
            child: _BottomBar(
              label: 'Xác nhận rút tiền',
              onTap: () {
                SavingsGoalStore.instance.withdraw(
                  goalId: goal.id,
                  amount: _amount(),
                  source: wallet,
                  note: _reasonController.text.trim().isEmpty
                      ? null
                      : _reasonController.text.trim(),
                );
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack, required this.onMore});

  final String title;
  final VoidCallback onBack;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onMore,
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

class _WarningBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Color(0xFFB45309), size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Rút tiền sẽ làm chậm tiến độ mục tiêu',
              style: GoogleFonts.inter(
                color: const Color(0xFF78350F),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoalProgressCard extends StatelessWidget {
  const _GoalProgressCard({required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: goal.progress,
                  strokeWidth: 7,
                  backgroundColor: const Color(0xFFE2E7FF),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0053DB)),
                ),
                Text(goal.emoji, style: const TextStyle(fontSize: 20)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.name,
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  formatVnd(goal.currentAmount),
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF0053DB),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Đã tích lũy được ${(goal.progress * 100).round()}%',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 12,
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

class _AmountPanel extends StatelessWidget {
  const _AmountPanel({
    required this.amount,
    required this.remainingInGoal,
    required this.onAll,
  });

  final int amount;
  final int remainingInGoal;
  final VoidCallback onAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            'SỐ TIỀN RÚT',
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _pretty(amount),
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'đ',
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Còn lại trong mục tiêu: ${formatVnd(remainingInGoal)}',
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 10),
              TextButton(
                onPressed: onAll,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  backgroundColor: const Color(0xFFE2E7FF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  'Rút toàn bộ',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _pretty(int amount) {
    final digits = amount.abs().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < digits.length; i++) {
      final reverse = digits.length - i;
      buffer.write(digits[i]);
      if (reverse > 1 && reverse % 3 == 1) buffer.write(',');
    }
    return buffer.toString();
  }
}

class _WalletRow extends StatelessWidget {
  const _WalletRow({required this.name, required this.balance});

  final String name;
  final int balance;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(const SnackBar(content: Text('Chọn ví đang được hoàn thiện.')));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFDBE1FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.account_balance_rounded, color: Color(0xFF0053DB)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Số dư: ${formatVnd(balance)}',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF6C82B3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _WithdrawImpactHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.inter(
            color: const Color(0xFF0048BF),
            fontSize: 14,
            height: 1.6,
          ),
          children: [
            const TextSpan(text: 'Sau khi rút, bạn cần thêm '),
            TextSpan(
              text: '2 tháng',
              style: GoogleFonts.inter(
                color: const Color(0xFF0048BF),
                fontSize: 14,
                height: 1.6,
                fontWeight: FontWeight.w800,
              ),
            ),
            const TextSpan(text: ' để đạt\nmục tiêu.\n'),
            TextSpan(
              text: 'Ngày hoàn thành dự kiến: 01/12/2025',
              style: GoogleFonts.inter(
                color: const Color(0xB30053DB),
                fontSize: 11,
                height: 1.6,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.label, required this.onTap});

  final String label;
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
        24 + MediaQuery.paddingOf(context).bottom,
      ),
      child: SizedBox(
        height: 64,
        width: double.infinity,
        child: FilledButton(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF0053DB),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 12,
            shadowColor: const Color(0x400053DB),
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

