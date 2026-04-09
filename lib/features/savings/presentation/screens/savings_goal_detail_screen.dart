import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../home/presentation/widgets/home_components.dart';
import '../../data/savings_goal_store.dart';
import 'savings_goal_deposit_screen.dart';
import 'savings_goal_editor_screen.dart';
import 'savings_goal_withdraw_screen.dart';

class SavingsGoalDetailScreen extends StatelessWidget {
  const SavingsGoalDetailScreen({super.key, required this.goalId});

  final String goalId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAECF0),
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: ValueListenableBuilder<List<SavingsGoal>>(
              valueListenable: SavingsGoalStore.instance,
              builder: (context, goals, _) {
                final goal = SavingsGoalStore.instance.byId(goalId);
                if (goal == null) {
                  return Column(
                    children: [
                      _TopBar(
                        title: 'Chi tiết mục tiêu',
                        onBack: () => Navigator.of(context).pop(),
                        onMore: null,
                      ),
                      const Expanded(
                        child: Center(child: Text('Mục tiêu không tồn tại.')),
                      ),
                    ],
                  );
                }

                final deposits = goal.transactions
                    .where((t) => t.type == SavingsTransactionType.deposit)
                    .fold<int>(0, (sum, t) => sum + t.amount);
                final times = goal.transactions
                    .where((t) => t.type == SavingsTransactionType.deposit)
                    .length;

                return Column(
                  children: [
                    _TopBar(
                      title: 'Chi tiết mục tiêu',
                      onBack: () => Navigator.of(context).pop(),
                      onMore: () {
                        _showMore(context, goal);
                      },
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _SummaryCard(goal: goal),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: _MiniStat(
                                    label: 'TỔNG ĐÃ\nNẠP',
                                    value: formatVnd(deposits),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _MiniStat(
                                    label: 'SỐ LẦN\nNẠP',
                                    value: times.toString(),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _MiniStat(
                                    label: 'NẠP TB/\nTHÁNG',
                                    value: formatVnd(goal.monthlySaving),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Expanded(
                                  child: _ActionButton(
                                    label: 'NẠP TIỀN',
                                    primary: true,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        buildFadeSlideRoute(
                                          SavingsGoalDepositScreen(goalId: goal.id),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _ActionButton(
                                    label: 'RÚT TIỀN',
                                    primary: false,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        buildFadeSlideRoute(
                                          SavingsGoalWithdrawScreen(goalId: goal.id),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 18),
                            _GrowthCard(goal: goal),
                            const SizedBox(height: 18),
                            Text(
                              'Chi tiết giao dịch',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF113069),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _TransactionSection(goal: goal),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showMore(BuildContext context, SavingsGoal goal) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFFFAF8FF),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
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
              ListTile(
                leading: const Icon(Icons.edit_rounded, color: Color(0xFF0053DB)),
                title: const Text('Chỉnh sửa mục tiêu'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    buildFadeSlideRoute(SavingsGoalEditorScreen(goalId: goal.id)),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFF9F403D)),
                title: const Text('Xóa mục tiêu'),
                onTap: () {
                  SavingsGoalStore.instance.deleteGoal(goal.id);
                  Navigator.of(context)
                    ..pop()
                    ..pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.title,
    required this.onBack,
    required this.onMore,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onMore;

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

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Center(child: Text(goal.emoji, style: const TextStyle(fontSize: 26))),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 4),
                Text(
                  '${formatVnd(goal.currentAmount)} / ${formatVnd(goal.targetAmount)}',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: LinearProgressIndicator(
                    value: goal.progress,
                    minHeight: 8,
                    backgroundColor: const Color(0xFFE2E7FF),
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0053DB)),
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

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A113069),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: const Color(0xFF0053DB),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.primary,
    required this.onTap,
  });

  final String label;
  final bool primary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: primary
          ? FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0053DB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0xFFF8F7FF),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            )
          : FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE2E7FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  color: const Color(0xFF113069),
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
    );
  }
}

class _GrowthCard extends StatelessWidget {
  const _GrowthCard({required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
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
                      'Tăng trưởng tích lũy',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Lộ trình 5 tháng qua',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6FFEE),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Đúng kế hoạch',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF006D4A),
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: _GoalGrowthPainter(),
            ),
          ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'MỤC TIÊU ${_compact(goal.targetAmount)}',
              style: GoogleFonts.inter(
                color: const Color(0xFF0053DB),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _compact(int amount) {
    if (amount >= 1000000) {
      final value = amount / 1000000;
      return '${value.toStringAsFixed(value >= 10 ? 0 : 1)}M';
    }
    return amount.toString();
  }
}

class _GoalGrowthPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(8, 12, size.width - 16, size.height - 28);
    final gridPaint = Paint()
      ..color = const Color(0x1A98B1F2)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(rect.left, rect.bottom), Offset(rect.right, rect.bottom), gridPaint);

    final values = <double>[0.20, 0.30, 0.36, 0.52, 0.55];
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = rect.left + (rect.width / (values.length - 1)) * i;
      final y = rect.bottom - (values[i].clamp(0, 1) * rect.height);
      points.add(Offset(x, y));
    }

    final fillPath = Path()
      ..moveTo(points.first.dx, rect.bottom)
      ..lineTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      fillPath.lineTo(points[i].dx, points[i].dy);
    }
    fillPath.lineTo(points.last.dx, rect.bottom);
    fillPath.close();

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0053DB).withValues(alpha: 0.18),
          const Color(0xFF0053DB).withValues(alpha: 0.0),
        ],
      ).createShader(rect);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF0053DB)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke;

    final linePath = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      linePath.lineTo(points[i].dx, points[i].dy);
    }
    canvas.drawPath(linePath, linePaint);

    final dotPaint = Paint()..color = const Color(0xFF0053DB);
    for (var i = 0; i < points.length; i++) {
      canvas.drawCircle(points[i], i == points.length - 1 ? 4.0 : 2.8, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _TransactionSection extends StatelessWidget {
  const _TransactionSection({required this.goal});

  final SavingsGoal goal;

  @override
  Widget build(BuildContext context) {
    if (goal.transactions.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x1A98B1F2)),
        ),
        child: Text(
          'Chưa có giao dịch nào.',
          style: GoogleFonts.inter(
            color: const Color(0xFF6C82B3),
            fontSize: 13,
          ),
        ),
      );
    }

    final grouped = <String, List<SavingsTransaction>>{};
    for (final tx in goal.transactions) {
      final key = 'Tháng ${tx.createdAt.month}';
      grouped.putIfAbsent(key, () => []).add(tx);
    }

    return Column(
      children: [
        for (final entry in grouped.entries) ...[
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 4),
              child: Text(
                entry.key.toUpperCase(),
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
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
                for (var i = 0; i < entry.value.length; i++) ...[
                  _TxRow(tx: entry.value[i]),
                  if (i != entry.value.length - 1)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(height: 1, color: Color(0x1498B1F2)),
                    ),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _TxRow extends StatelessWidget {
  const _TxRow({required this.tx});

  final SavingsTransaction tx;

  @override
  Widget build(BuildContext context) {
    final isDeposit = tx.type == SavingsTransactionType.deposit;
    final color = isDeposit ? const Color(0xFF006D4A) : const Color(0xFF9F403D);
    final iconBackground = isDeposit ? const Color(0x1A006D4A) : const Color(0x1AFE8983);
    final icon = isDeposit ? Icons.account_balance_wallet_outlined : Icons.outbox_rounded;

    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBackground,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isDeposit
                    ? 'Nạp từ ${tx.source ?? 'Ví'}'
                    : 'Rút về ${tx.source ?? 'Ví'}',
                style: GoogleFonts.inter(
                  color: const Color(0xFF113069),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _date(tx.createdAt, note: tx.note),
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${isDeposit ? '+' : '-'}${formatVnd(tx.amount)}',
          style: GoogleFonts.manrope(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }

  String _date(DateTime date, {String? note}) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final y = date.year.toString();
    final suffix = note == null || note.isEmpty ? '' : ' • $note';
    return '$d/$m/$y$suffix';
  }
}

