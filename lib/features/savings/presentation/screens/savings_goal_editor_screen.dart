import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../home/presentation/widgets/home_components.dart';
import '../../data/savings_goal_store.dart';

class SavingsGoalEditorScreen extends StatefulWidget {
  const SavingsGoalEditorScreen({super.key, this.goalId});

  final String? goalId;

  @override
  State<SavingsGoalEditorScreen> createState() => _SavingsGoalEditorScreenState();
}

class _SavingsGoalEditorScreenState extends State<SavingsGoalEditorScreen> {
  final _nameController = TextEditingController();
  final _targetController = TextEditingController(text: '0');
  final _currentController = TextEditingController(text: '0');
  final _monthlyController = TextEditingController(text: '0');
  
  String _selectedEmoji = '📷';
  DateTime? _selectedDate;
  int _selectedThemeIndex = 0;

  final List<({Color start, Color end})> _themes = const [
    (start: Color(0xFF0053DB), end: Color(0xFF0048C1)), // Blue
    (start: Color(0xFF006D4A), end: Color(0xFF34D399)), // Green
    (start: Color(0xFFF97316), end: Color(0xFFFACC15)), // Orange
    (start: Color(0xFF7C3AED), end: Color(0xFFC084FC)), // Purple
    (start: Color(0xFFEC4899), end: Color(0xFFF472B6)), // Pink
    (start: Color(0xFF4B5563), end: Color(0xFF9CA3AF)), // Grey
  ];

  final List<String> _emojis = const [
    '📷', '🏍️', '🏠', '✈️', '💻', '📱', '🎓', '💍', '🚗', '🎸',
    '🌍', '👶', '🍔', '🚲', '⌚', '🛋️', '🎒', '🎨', '🎮', '🏖️'
  ];

  @override
  void initState() {
    super.initState();
    if (widget.goalId != null) {
      final goal = SavingsGoalStore.instance.byId(widget.goalId!);
      if (goal != null) {
        _nameController.text = goal.name;
        _targetController.text = goal.targetAmount.toString();
        _currentController.text = goal.currentAmount.toString();
        _monthlyController.text = goal.monthlySaving.toString();
        _selectedEmoji = goal.emoji;
        _selectedDate = goal.targetDate;
        final idx = _themes.indexWhere((t) => t.start.value == goal.themeStart.value);
        if (idx != -1) _selectedThemeIndex = idx;
      }
    }

    _targetController.addListener(() => setState(() {}));
    _currentController.addListener(() => setState(() {}));
    _monthlyController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    _monthlyController.dispose();
    super.dispose();
  }

  void _onSave() {
    final name = _nameController.text.trim();
    final target = int.tryParse(_targetController.text) ?? 0;
    final current = int.tryParse(_currentController.text) ?? 0;
    final monthly = int.tryParse(_monthlyController.text) ?? 0;

    if (name.isEmpty || target <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập tên và số tiền mục tiêu.')),
      );
      return;
    }

    final theme = _themes[_selectedThemeIndex];
    final goal = SavingsGoal(
      id: widget.goalId ?? 'goal-${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      emoji: _selectedEmoji,
      targetAmount: target,
      currentAmount: current,
      monthlySaving: monthly,
      targetDate: _selectedDate,
      themeStart: theme.start,
      themeEnd: theme.end,
      transactions: widget.goalId != null 
          ? (SavingsGoalStore.instance.byId(widget.goalId!)?.transactions ?? [])
          : [],
    );

    if (widget.goalId != null) {
      SavingsGoalStore.instance.updateGoal(goal);
    } else {
      SavingsGoalStore.instance.addGoal(goal);
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: widget.goalId == null ? 'Thêm mục tiêu' : 'Chỉnh sửa mục tiêu',
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (widget.goalId != null) ...[
                          Text(
                            'Sửa mục tiêu',
                            style: GoogleFonts.manrope(
                              color: const Color(0xFF113069),
                              fontSize: 32,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tinh chỉnh kế hoạch tài chính của bạn để đạt được kết quả tốt nhất.',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF445D99),
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),
                        ],
                        _SectionLabel('BIỂU TƯỢNG MỤC TIÊU'),
                        const SizedBox(height: 12),
                        _EmojiSelector(
                          selected: _selectedEmoji,
                          emojis: _emojis,
                          onSelect: (e) => setState(() => _selectedEmoji = e),
                        ),
                        const SizedBox(height: 32),
                        _SectionLabel('TÊN MỤC TIÊU'),
                        const SizedBox(height: 12),
                        _TextField(controller: _nameController, placeholder: 'Ví dụ: Chuyến du lịch Nhật Bản'),
                        const SizedBox(height: 24),
                        _SectionLabel('SỐ TIỀN MỤC TIÊU'),
                        const SizedBox(height: 12),
                        _AmountField(controller: _targetController, isLarge: true),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _SectionLabel('SỐ TIỀN HIỆN CÓ'),
                                  const SizedBox(height: 12),
                                  _AmountField(controller: _currentController),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _SectionLabel('NGÀY MỤC TIÊU (TÙY CHỌN)'),
                                  const SizedBox(height: 12),
                                  _DatePickerField(
                                    selectedDate: _selectedDate,
                                    onTap: () async {
                                      final date = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 30)),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                                      );
                                      if (date != null) setState(() => _selectedDate = date);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _SectionLabel('TIẾT KIỆM HÀNG THÁNG'),
                        const SizedBox(height: 12),
                        _AmountField(controller: _monthlyController),
                        const SizedBox(height: 24),
                        _EstimationBox(
                          target: int.tryParse(_targetController.text) ?? 0,
                          current: int.tryParse(_currentController.text) ?? 0,
                          monthly: int.tryParse(_monthlyController.text) ?? 0,
                        ),
                        const SizedBox(height: 32),
                        _SectionLabel('CHỦ ĐỀ MÀU SẮC'),
                        const SizedBox(height: 16),
                        _ThemeSelector(
                          themes: _themes,
                          selectedIndex: _selectedThemeIndex,
                          onSelect: (idx) => setState(() => _selectedThemeIndex = idx),
                        ),
                        const SizedBox(height: 48),
                        PrimaryBlueButton(
                          label: widget.goalId == null ? 'Thêm Mục tiêu' : 'Lưu mục tiêu',
                          icon: widget.goalId == null ? null : Icons.check_circle_outline_rounded,
                          onTap: _onSave,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;
  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2),
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
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back_rounded, color: Color(0xFF0053DB))),
          const Spacer(),
          Text(title, style: GoogleFonts.manrope(color: const Color(0xFF113069), fontSize: 18, fontWeight: FontWeight.w700)),
          const Spacer(),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF6C82B3))),
        ],
      ),
    );
  }
}

class _EmojiSelector extends StatelessWidget {
  const _EmojiSelector({required this.selected, required this.emojis, required this.onSelect});
  final String selected;
  final List<String> emojis;
  final ValueChanged<String> onSelect;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200, padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF0F2FF), borderRadius: BorderRadius.circular(32)),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 5, mainAxisSpacing: 12, crossAxisSpacing: 12),
        itemCount: emojis.length,
        itemBuilder: (context, index) {
          final e = emojis[index];
          final isActive = e == selected;
          return GestureDetector(
            onTap: () => onSelect(e),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isActive ? const Color(0xFF0053DB) : Colors.transparent, width: 2),
                boxShadow: isActive ? [BoxShadow(color: const Color(0x330053DB), blurRadius: 10, offset: const Offset(0, 4))] : null,
              ),
              child: Center(child: Text(e, style: const TextStyle(fontSize: 24))),
            ),
          );
        },
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({required this.controller, required this.placeholder});
  final TextEditingController controller;
  final String placeholder;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFE8EBFF), borderRadius: BorderRadius.circular(16)),
      child: TextField(
        controller: controller,
        style: GoogleFonts.manrope(color: const Color(0xFF113069), fontSize: 16, fontWeight: FontWeight.w600),
        decoration: InputDecoration(hintText: placeholder, hintStyle: GoogleFonts.manrope(color: const Color(0xFF8896B8)), contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), border: InputBorder.none),
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller, this.isLarge = false});
  final TextEditingController controller;
  final bool isLarge;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFE8EBFF), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller, keyboardType: TextInputType.number,
              style: GoogleFonts.manrope(color: isLarge ? const Color(0xFF0053DB) : const Color(0xFF113069), fontSize: isLarge ? 28 : 16, fontWeight: FontWeight.w800),
              decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16), border: InputBorder.none, suffixText: 'đ', suffixStyle: GoogleFonts.inter(color: isLarge ? const Color(0xFF0053DB) : const Color(0xFF8896B8), fontSize: isLarge ? 24 : 14, fontWeight: FontWeight.w700)),
            ),
          ),
          if (isLarge) ...[const Icon(Icons.account_balance_wallet_outlined, color: Color(0xFF0053DB)), const SizedBox(width: 16)],
        ],
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({required this.selectedDate, required this.onTap});
  final DateTime? selectedDate;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(color: const Color(0xFFE8EBFF), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Expanded(child: Text(selectedDate == null ? 'Chọn ngày...' : '${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}', style: GoogleFonts.manrope(color: selectedDate == null ? const Color(0xFF8896B8) : const Color(0xFF113069), fontSize: 14, fontWeight: FontWeight.w600))),
            const Icon(Icons.calendar_month_rounded, size: 20, color: Color(0xFF8896B8)),
          ],
        ),
      ),
    );
  }
}

class _EstimationBox extends StatelessWidget {
  const _EstimationBox({required this.target, required this.current, required this.monthly});
  final int target; final int current; final int monthly;
  @override
  Widget build(BuildContext context) {
    if (monthly <= 0 || target <= current) return const SizedBox.shrink();
    final remaining = target - current;
    final totalDays = (remaining / monthly) * 30.44;
    final months = (totalDays / 30.44).floor();
    final remainingDays = (totalDays % 30.44).round();
    final estimatedDate = DateTime.now().add(Duration(days: totalDays.round()));
    final dateStr = '${estimatedDate.day.toString().padLeft(2,'0')}/${estimatedDate.month.toString().padLeft(2,'0')}/${estimatedDate.year}';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: const Color(0xFFF2F4FF), borderRadius: BorderRadius.circular(24)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.lightbulb_outline_rounded, color: Color(0xFF0053DB), size: 28),
          const SizedBox(width: 16),
          Expanded(child: RichText(text: TextSpan(style: GoogleFonts.inter(color: const Color(0xFF445D99), fontSize: 14, height: 1.5), children: [const TextSpan(text: 'Nếu tiết kiệm '), TextSpan(text: formatVnd(monthly), style: const TextStyle(color: Color(0xFF0053DB), fontWeight: FontWeight.w800)), const TextSpan(text: '/tháng\n'), const TextSpan(text: '→ Đạt mục tiêu sau '), TextSpan(text: '$months tháng $remainingDays ngày', style: const TextStyle(color: Color(0xFF0053DB), fontWeight: FontWeight.w800)), TextSpan(text: ' ($dateStr)')]))),
        ],
      ),
    );
  }
}

class _ThemeSelector extends StatelessWidget {
  const _ThemeSelector({required this.themes, required this.selectedIndex, required this.onSelect});
  final List<({Color start, Color end})> themes;
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: themes.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final t = themes[index];
          final isActive = index == selectedIndex;
          return GestureDetector(
            onTap: () => onSelect(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200), width: 56, height: 56,
              decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [t.start, t.end]), border: Border.all(color: isActive ? const Color(0xFF0053DB) : Colors.transparent, width: 3), boxShadow: isActive ? [BoxShadow(color: t.start.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 6))] : null),
              child: isActive ? const Center(child: Icon(Icons.check, color: Colors.white)) : null,
            ),
          );
        },
      ),
    );
  }
}
