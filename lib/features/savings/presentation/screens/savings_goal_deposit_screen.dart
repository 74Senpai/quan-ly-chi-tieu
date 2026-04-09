import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';
import '../../data/savings_goal_store.dart';

class SavingsGoalDepositScreen extends StatefulWidget {
  const SavingsGoalDepositScreen({super.key, required this.goalId});

  final String goalId;

  @override
  State<SavingsGoalDepositScreen> createState() => _SavingsGoalDepositScreenState();
}

class _SavingsGoalDepositScreenState extends State<SavingsGoalDepositScreen> {
  final _amountController = TextEditingController(text: '1000000');
  bool _recurring = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int _amount() {
    final digits = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  void _addQuick(int delta) {
    final next = math.max(0, _amount() + delta);
    setState(() => _amountController.text = next.toString());
  }

  @override
  Widget build(BuildContext context) {
    final goal = SavingsGoalStore.instance.byId(widget.goalId);
    if (goal == null) {
      return const Scaffold(body: Center(child: Text('Mục tiêu không tồn tại.')));
    }

    final wallet = 'Techcombank';
    final walletBalance = 15000000;
    final after = (walletBalance - _amount()).clamp(0, walletBalance);

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Nạp tiền vào mục tiêu',
                  onBack: () => Navigator.of(context).pop(),
                  onMore: () {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(const SnackBar(content: Text('Tùy chọn đang được hoàn thiện.')));
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 10, 24, 140),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _GoalHeaderCard(goal: goal),
                        const SizedBox(height: 18),
                        Text(
                          'Nạp từ ví',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF445D99),
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _WalletCard(
                          name: wallet,
                          balance: walletBalance,
                          onTap: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(const SnackBar(content: Text('Chọn ví đang được hoàn thiện.')));
                          },
                        ),
                        const SizedBox(height: 22),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                'SỐ TIỀN NẠP',
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
                                    _pretty(_amount()),
                                    style: GoogleFonts.manrope(
                                      color: const Color(0xFF0053DB),
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
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6FFEE),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  'Số dư sau khi nạp: ${formatVnd(after)}',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF006D4A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            Expanded(child: _QuickChip(label: '+100K', onTap: () => _addQuick(100000))),
                            const SizedBox(width: 10),
                            Expanded(child: _QuickChip(label: '+200K', onTap: () => _addQuick(200000))),
                            const SizedBox(width: 10),
                            Expanded(child: _QuickChip(label: '+500K', onTap: () => _addQuick(500000))),
                            const SizedBox(width: 10),
                            Expanded(child: _QuickChip(label: '+1M', selected: true, onTap: () => _addQuick(1000000))),
                          ],
                        ),
                        const SizedBox(height: 18),
                        _RecurringTile(
                          value: _recurring,
                          onChanged: (v) => setState(() => _recurring = v),
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
            child: _BottomBar(
              label: 'Nạp tiền',
              onTap: () {
                SavingsGoalStore.instance.deposit(
                  goalId: goal.id,
                  amount: _amount(),
                  source: wallet,
                  note: _recurring ? 'Nạp định kỳ' : null,
                );
                Navigator.of(context).pop();
              },
            ),
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

class _GoalHeaderCard extends StatelessWidget {
  const _GoalHeaderCard({required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FF),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text(goal.emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.name,
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${formatVnd(goal.currentAmount)} / ${formatVnd(goal.targetAmount)}',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 46,
            height: 46,
            child: CircularProgressIndicator(
              value: goal.progress,
              strokeWidth: 5,
              backgroundColor: const Color(0xFFE2E7FF),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0053DB)),
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({
    required this.name,
    required this.balance,
    required this.onTap,
  });

  final String name;
  final int balance;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF2F3FF),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
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
              const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF6C82B3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickChip extends StatelessWidget {
  const _QuickChip({required this.label, required this.onTap, this.selected = false});

  final String label;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFDBE1FF) : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? const Color(0x330053DB) : const Color(0x1A98B1F2),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: selected ? const Color(0xFF0053DB) : const Color(0xFF113069),
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class _RecurringTile extends StatelessWidget {
  const _RecurringTile({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: const Color(0x80F2F3FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0x33DBE1FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.autorenew_rounded, color: Color(0xFF0053DB)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Tự động nạp định kỳ',
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF0053DB),
          ),
        ],
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

