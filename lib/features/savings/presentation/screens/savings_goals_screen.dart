import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../home/presentation/widgets/home_components.dart';
import '../../data/savings_goal_store.dart';
import 'savings_goal_detail_screen.dart';
import 'savings_goal_editor_screen.dart';

class SavingsGoalsScreen extends StatelessWidget {
  const SavingsGoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: ValueListenableBuilder<List<SavingsGoal>>(
              valueListenable: SavingsGoalStore.instance,
              builder: (context, goals, _) {
                final store = SavingsGoalStore.instance;
                final active = goals.where((g) => !g.isCompleted).toList();
                final completed = goals.where((g) => g.isCompleted).toList();

                return Column(
                  children: [
                    _TopBar(onBack: () => Navigator.of(context).pop()),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            _HeroSummary(
                              totalSaved: store.totalSaved,
                              goalsCount: store.goalsCount,
                              overallProgress: store.overallProgress,
                            ),
                            const SizedBox(height: 18),
                            _SectionHeader(
                              title: 'Đang thực hiện',
                              actionLabel: 'Xem tất cả',
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text('Đang hiển thị toàn bộ mục tiêu.'),
                                    ),
                                  );
                              },
                            ),
                            const SizedBox(height: 12),
                            for (final goal in active) ...[
                              _GoalCard(
                                goal: goal,
                                onTap: () {
                                  Navigator.of(context).push(
                                    buildFadeSlideRoute(
                                      SavingsGoalDetailScreen(goalId: goal.id),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 14),
                            ],
                            _AddGoalCard(
                              onTap: () {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(
                                    const SavingsGoalEditorScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            _AiHintCard(
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(content: Text('Mở gợi ý tiết kiệm AI.')),
                                  );
                              },
                            ),
                            const SizedBox(height: 16),
                            _CompletedGoals(
                              goals: completed,
                              onTapGoal: (goal) {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(
                                    SavingsGoalDetailScreen(goalId: goal.id),
                                  ),
                                );
                              },
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
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
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
                  color: Color(0xFF0F172A),
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Mục Tiêu Tích Lũy',
            style: GoogleFonts.manrope(
              color: const Color(0xFF0F172A),
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSummary extends StatelessWidget {
  const _HeroSummary({
    required this.totalSaved,
    required this.goalsCount,
    required this.overallProgress,
  });

  final int totalSaved;
  final int goalsCount;
  final double overallProgress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0053DB), Color(0xFF0048C1)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TỔNG TIỀN ĐÃ TIẾT KIỆM',
            style: GoogleFonts.inter(
              color: const Color(0xCCF8F7FF),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatVnd(totalSaved).replaceAll('đ', ''),
                style: GoogleFonts.manrope(
                  color: const Color(0xFFF8F7FF),
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.9,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'đ',
                style: GoogleFonts.inter(
                  color: const Color(0xE6F8F7FF),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _HeroMiniStat(
                  label: 'Số mục tiêu',
                  value: goalsCount.toString().padLeft(2, '0'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _HeroMiniStat(
                  label: 'Tiến độ chung',
                  value: '${(overallProgress * 100).round()}%',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMiniStat extends StatelessWidget {
  const _HeroMiniStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xB3F8F7FF),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: const Color(0xFFF8F7FF),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            color: const Color(0xFF113069),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionLabel,
            style: GoogleFonts.inter(
              color: const Color(0xFF0053DB),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.onTap});

  final SavingsGoal goal;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(goal.emoji, style: const TextStyle(fontSize: 26)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                goal.name,
                                style: GoogleFonts.manrope(
                                  color: const Color(0xFF113069),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  ScaffoldMessenger.of(context)
                                    ..hideCurrentSnackBar()
                                    ..showSnackBar(
                                      SnackBar(content: Text('Tuỳ chọn: ${goal.name}')),
                                    );
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(6),
                                  child: Icon(
                                    Icons.more_vert_rounded,
                                    color: Color(0xFF6C82B3),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6FFEE),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'ĐANG TIẾT KIỆM',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF006D4A),
                                  fontSize: 10,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text(
                              formatVnd(goal.currentAmount),
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0053DB),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              ' / ${formatVnd(goal.targetAmount)}',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF445D99),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: goal.progress,
                  minHeight: 10,
                  backgroundColor: const Color(0xFFE2E7FF),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0053DB)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF6C82B3)),
                  const SizedBox(width: 8),
                  Text(
                    'Dự kiến: ${formatGoalMonthYear(goal.targetDate ?? DateTime.now())}',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${(goal.progress * 100).round()}%',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF0053DB),
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddGoalCard extends StatelessWidget {
  const _AddGoalCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFF0053DB),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x330053DB),
                      blurRadius: 18,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(Icons.add_rounded, color: Colors.white, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  'Thêm mục tiêu mới',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
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

class _AiHintCard extends StatelessWidget {
  const _AiHintCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0x336FFBBE),
      borderRadius: BorderRadius.circular(32),
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0x1A006D4A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Color(0xFF006D4A),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gợi ý tiết kiệm AI',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF006D4A),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Bạn có thể rút ngắn 2 tháng tiết kiệm máy ảnh nếu giảm chi tiêu ăn uống 10%.',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 14,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletedGoals extends StatefulWidget {
  const _CompletedGoals({required this.goals, required this.onTapGoal});

  final List<SavingsGoal> goals;
  final ValueChanged<SavingsGoal> onTapGoal;

  @override
  State<_CompletedGoals> createState() => _CompletedGoalsState();
}

class _CompletedGoalsState extends State<_CompletedGoals> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => setState(() => _expanded = !_expanded),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Mục tiêu đã hoàn tất (${widget.goals.length})',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: const Color(0xFF6C82B3),
                  ),
                ],
              ),
              if (_expanded) ...[
                const SizedBox(height: 12),
                for (final goal in widget.goals) ...[
                  InkWell(
                    onTap: () => widget.onTapGoal(goal),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(goal.emoji, style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              goal.name,
                              style: GoogleFonts.inter(
                                color: const Color(0xFF113069),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Text(
                            formatVnd(goal.targetAmount),
                            style: GoogleFonts.inter(
                              color: const Color(0xFF006D4A),
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(height: 1, color: Color(0x1498B1F2)),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

