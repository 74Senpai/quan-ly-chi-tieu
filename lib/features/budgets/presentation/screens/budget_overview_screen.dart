import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../home/presentation/widgets/home_components.dart';
import '../../data/budget_demo_data.dart';

class BudgetOverviewScreen extends StatelessWidget {
  const BudgetOverviewScreen({super.key});

  void _openEditor(BuildContext context, {BudgetLimit? budget}) {
    Navigator.of(
      context,
    ).push(buildFadeSlideRoute(BudgetEditorScreen(existingBudget: budget)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: ValueListenableBuilder<List<BudgetLimit>>(
              valueListenable: BudgetStore.instance,
              builder: (context, budgets, _) {
                final store = BudgetStore.instance;
                return Column(
                  children: [
                    _BudgetTopBar(onBack: () => Navigator.of(context).pop()),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(30, 8, 30, 132),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _BudgetHeroCard(
                              totalBudget: store.totalBudget,
                              totalSpent: store.totalSpent,
                              totalRemaining: store.totalRemaining,
                              progress: store.overallProgress,
                            ),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Hạn mức chi tiết',
                                    style: GoogleFonts.manrope(
                                      color: const Color(0xFF113069),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context)
                                      ..hideCurrentSnackBar()
                                      ..showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Đang hiển thị toàn bộ hạn mức hiện có.',
                                          ),
                                        ),
                                      );
                                  },
                                  child: Text(
                                    'Xem tất cả',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF0053DB),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            for (final budget in budgets) ...[
                              _BudgetListCard(
                                budget: budget,
                                onTap: () =>
                                    _openEditor(context, budget: budget),
                              ),
                              const SizedBox(height: 16),
                            ],
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
            right: 22,
            bottom: 82,
            child: FloatingActionButton(
              onPressed: () => _openEditor(context),
              backgroundColor: const Color(0xFF0053DB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BudgetEditorScreen extends StatefulWidget {
  const BudgetEditorScreen({super.key, this.existingBudget});

  final BudgetLimit? existingBudget;

  @override
  State<BudgetEditorScreen> createState() => _BudgetEditorScreenState();
}

class _BudgetEditorScreenState extends State<BudgetEditorScreen> {
  late final TextEditingController _amountController;
  late BudgetCategoryTemplate _selectedTemplate;
  late BudgetCycle _cycle;

  bool get _isEditing => widget.existingBudget != null;

  @override
  void initState() {
    super.initState();
    final budget = widget.existingBudget;
    _selectedTemplate =
        budget?.template ?? BudgetStore.instance.availableTemplates().first;
    _cycle = budget?.cycle ?? BudgetCycle.monthly;
    _amountController = TextEditingController(text: _initialAmountText())
      ..addListener(() => setState(() {}));
  }

  String _initialAmountText() {
    final amount = widget.existingBudget?.limitAmount ?? 5000000;
    return _formatDigitsOnly(amount);
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int get _amountValue {
    final digits = _amountController.text.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(digits) ?? 0;
  }

  int get _spentAmount => widget.existingBudget?.spentAmount ?? 3600000;

  String _formatDigitsOnly(int amount) {
    return formatCurrency(amount).replaceAll('₫', '');
  }

  void _onAmountChanged(String value) {
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    final parsed = int.tryParse(digits);
    if (parsed == null) {
      _amountController.value = const TextEditingValue(text: '');
      return;
    }
    final formatted = _formatDigitsOnly(parsed);
    _amountController.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }

  Future<void> _save() async {
    if (_amountValue <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập số tiền hạn mức hợp lệ.')),
      );
      return;
    }

    final store = BudgetStore.instance;
    final savedBudget = BudgetLimit(
      id:
          widget.existingBudget?.id ??
          'budget-${_selectedTemplate.id}-${DateTime.now().millisecondsSinceEpoch}',
      template: _selectedTemplate,
      limitAmount: _amountValue,
      spentAmount: widget.existingBudget?.spentAmount ?? _spentAmount,
      cycle: _cycle,
    );

    if (_isEditing) {
      store.updateBudget(savedBudget);
    } else {
      store.addBudget(savedBudget);
    }

    if (!mounted) return;
    Navigator.of(context).pop();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _DeleteBudgetSheet(
        categoryName: widget.existingBudget!.template.name,
      ),
    );
    if (confirmed == true) {
      BudgetStore.instance.deleteBudget(widget.existingBudget!.id);
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableTemplates = BudgetStore.instance.availableTemplates(
      editingBudgetId: widget.existingBudget?.id,
    );
    final currentTemplateStillAvailable = availableTemplates.any(
      (template) => template.id == _selectedTemplate.id,
    );
    if (!currentTemplateStillAvailable && availableTemplates.isNotEmpty) {
      _selectedTemplate = availableTemplates.first;
    }

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 36),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BudgetTopBar(
                    title: _isEditing ? 'Sửa Hạn mức' : 'Thêm Hạn mức',
                    onBack: () => Navigator.of(context).pop(),
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 20),
                    _EditBudgetHero(
                      budget: widget.existingBudget!,
                      amountValue: _amountValue,
                    ),
                    const SizedBox(height: 32),
                  ] else ...[
                    const SizedBox(height: 14),
                    Center(
                      child: Text(
                        'SỐ TIỀN HẠN MỨC',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF445D99),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.4,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: _amountController.text.isEmpty
                                  ? '0'
                                  : _amountController.text,
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF0153DB),
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1.2,
                              ),
                            ),
                            TextSpan(
                              text: '₫',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF0153DB),
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Chọn Danh mục',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 102,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: availableTemplates.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final template = availableTemplates[index];
                          final active = template.id == _selectedTemplate.id;
                          return _BudgetCategoryChip(
                            template: template,
                            active: active,
                            onTap: () => setState(() {
                              _selectedTemplate = template;
                            }),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                  Text(
                    _isEditing ? 'Cấu hình Hạn mức' : 'Chu kỳ',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: _isEditing ? 20 : 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isEditing) ...[
                    const _EditorLabel('Số tiền hạn mức mới'),
                    const SizedBox(height: 8),
                  ],
                  _AmountField(
                    controller: _amountController,
                    onChanged: _onAmountChanged,
                  ),
                  const SizedBox(height: 24),
                  if (_isEditing) ...[
                    const _EditorLabel('Chu kỳ lặp lại'),
                    const SizedBox(height: 8),
                  ],
                  _CycleSelector(
                    value: _cycle,
                    onChanged: (value) => setState(() => _cycle = value),
                    expanded: _isEditing,
                  ),
                  const SizedBox(height: 26),
                  Text(
                    _isEditing ? 'Lịch sử Chi tiêu' : 'Xem trước thẻ',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_isEditing)
                    _BudgetHistoryCard(
                      categoryId: _selectedTemplate.id,
                      suggestedLimit: _amountValue,
                    )
                  else
                    _BudgetPreviewCard(
                      template: _selectedTemplate,
                      amount: _amountValue,
                      spentAmount: _spentAmount,
                      cycle: _cycle,
                    ),
                  const SizedBox(height: 28),
                  PrimaryBlueButton(
                    label: _isEditing ? 'Lưu thay đổi' : 'Thiết lập',
                    onTap: _save,
                    icon: _isEditing ? null : Icons.arrow_forward_rounded,
                  ),
                  if (_isEditing) ...[
                    const SizedBox(height: 16),
                    TextButton.icon(
                      onPressed: _confirmDelete,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: Color(0xFF9F403D),
                      ),
                      label: Text(
                        'Xóa hạn mức',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF9F403D),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BudgetTopBar extends StatelessWidget {
  const _BudgetTopBar({required this.onBack, this.title = 'Hạn mức Ngân sách'});

  final VoidCallback onBack;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Color(0xFF0053DB),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.4,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menu hành động đang ở chế độ demo.'),
                ),
              );
            },
            icon: const Icon(Icons.more_vert_rounded, color: Color(0xFF0053DB)),
          ),
        ],
      ),
    );
  }
}

class _BudgetHeroCard extends StatelessWidget {
  const _BudgetHeroCard({
    required this.totalBudget,
    required this.totalSpent,
    required this.totalRemaining,
    required this.progress,
  });

  final int totalBudget;
  final int totalSpent;
  final int totalRemaining;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
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
            color: Color(0x290053DB),
            blurRadius: 28,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TỔNG NGÂN SÁCH',
                  style: GoogleFonts.inter(
                    color: const Color(0xCCF8F7FF),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatCurrency(totalBudget),
                  style: GoogleFonts.manrope(
                    color: const Color(0xFFF8F7FF),
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.9,
                  ),
                ),
                const SizedBox(height: 20),
                _HeroLine(
                  icon: Icons.payments_outlined,
                  label: 'Đã chi: ${formatCurrency(totalSpent)}',
                  highlight: false,
                ),
                const SizedBox(height: 10),
                _HeroLine(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Còn lại: ${formatCurrency(totalRemaining)}',
                  highlight: true,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          SizedBox(
            width: 96,
            height: 96,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: clampedProgress,
                  strokeWidth: 8,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF6FFBBE)),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${(clampedProgress * 100).round()}%',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'SỬ DỤNG',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 10,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroLine extends StatelessWidget {
  const _HeroLine({
    required this.icon,
    required this.label,
    required this.highlight,
  });

  final IconData icon;
  final String label;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            color: highlight
                ? const Color(0xFF6FFBBE)
                : const Color(0xFFF8F7FF),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _BudgetListCard extends StatelessWidget {
  const _BudgetListCard({required this.budget, required this.onTap});

  final BudgetLimit budget;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = switch (budget.status) {
      BudgetStatus.safe => (
        label: 'AN TOÀN',
        background: const Color(0xFFE6FFEE),
        foreground: const Color(0xFF006D4A),
      ),
      BudgetStatus.warning => (
        label: 'CẢNH BÁO',
        background: const Color(0xFFFFF4E5),
        foreground: const Color(0xFFB25E09),
      ),
      BudgetStatus.critical => (
        label: 'VƯỢT MỨC',
        background: const Color(0x33FE8983),
        foreground: const Color(0xFF9F403D),
      ),
    };

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(21),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x1498B1F2)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: budget.template.tintColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    budget.template.icon,
                    color: const Color(0xFF0053DB),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        budget.template.name,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF113069),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Còn lại: ${formatCurrency(math.max(0, budget.remainingAmount))}',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF445D99),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: status.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.label,
                    style: GoogleFonts.inter(
                      color: status.foreground,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Flexible(
                  child: Text(
                    'Đã dùng ${budget.usagePercent}%',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Spacer(),
                Flexible(
                  child: Text(
                    'Hạn mức: ${formatCurrency(budget.limitAmount)}',
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: budget.progress.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: const Color(0xFFEAEDFF),
                valueColor: AlwaysStoppedAnimation(budget.template.accentColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetCategoryChip extends StatelessWidget {
  const _BudgetCategoryChip({
    required this.template,
    required this.active,
    required this.onTap,
  });

  final BudgetCategoryTemplate template;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = active
        ? const Color(0xFF0053DB)
        : const Color(0xFFE2E7FF);
    final foreground = active ? Colors.white : const Color(0xFF445D99);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: background,
                borderRadius: BorderRadius.circular(12),
                boxShadow: active
                    ? const [
                        BoxShadow(
                          color: Color(0x330053DB),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ]
                    : null,
              ),
              child: Icon(template.icon, color: foreground, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              template.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: active
                    ? const Color(0xFF0053DB)
                    : const Color(0xFF445D99),
                fontSize: 12,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditorLabel extends StatelessWidget {
  const _EditorLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: const Color(0xFF445D99),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE2E7FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        onChanged: onChanged,
        style: GoogleFonts.manrope(
          color: const Color(0xFF0053DB),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 18,
          ),
          border: InputBorder.none,
          hintText: '0',
          hintStyle: GoogleFonts.manrope(
            color: const Color(0x990053DB),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
          suffixText: 'VNĐ',
          suffixStyle: GoogleFonts.manrope(
            color: const Color(0xFF445D99),
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _CycleSelector extends StatelessWidget {
  const _CycleSelector({
    required this.value,
    required this.onChanged,
    required this.expanded,
  });

  final BudgetCycle value;
  final ValueChanged<BudgetCycle> onChanged;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final children = BudgetCycle.values.map((cycle) {
      final active = cycle == value;
      return Expanded(
        child: GestureDetector(
          onTap: () => onChanged(cycle),
          child: Container(
            height: expanded ? 66 : 56,
            decoration: BoxDecoration(
              color: active ? const Color(0xFFDBE1FF) : const Color(0xFFE2E7FF),
              borderRadius: BorderRadius.circular(expanded ? 8 : 16),
              border: active
                  ? Border.all(color: const Color(0xFF0053DB))
                  : null,
            ),
            alignment: Alignment.center,
            child: Text(
              cycle.label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: active
                    ? const Color(0xFF0053DB)
                    : const Color(0xFF445D99),
                fontSize: 14,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ),
      );
    }).toList();

    return Row(
      children: [
        children.first,
        const SizedBox(width: 12),
        children[1],
        const SizedBox(width: 12),
        children[2],
      ],
    );
  }
}

class _BudgetPreviewCard extends StatelessWidget {
  const _BudgetPreviewCard({
    required this.template,
    required this.amount,
    required this.spentAmount,
    required this.cycle,
  });

  final BudgetCategoryTemplate template;
  final int amount;
  final int spentAmount;
  final BudgetCycle cycle;

  @override
  Widget build(BuildContext context) {
    final progress = amount == 0 ? 0.0 : (spentAmount / amount).clamp(0.0, 1.0);
    final remainingPercent = ((1 - progress) * 100).clamp(0, 100).round();
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0053DB), Color(0xFF0048C1)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x290053DB),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(template.icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'HẠN MỨC ${template.name.toUpperCase()}',
                      style: GoogleFonts.inter(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      cycle.label,
                      style: GoogleFonts.manrope(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Còn lại $remainingPercent%',
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Đã chi: ${formatCurrency(spentAmount)}',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                ),
              ),
              const Spacer(),
              Text(
                formatCurrency(amount),
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditBudgetHero extends StatelessWidget {
  const _EditBudgetHero({required this.budget, required this.amountValue});

  final BudgetLimit budget;
  final int amountValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E7FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                budget.template.icon,
                color: const Color(0xFF0053DB),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DANH MỤC',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 14,
                    letterSpacing: 1.4,
                  ),
                ),
                Text(
                  budget.template.name,
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        _EditInfoCard(
          title: 'Hạn mức hiện tại',
          primary: formatCurrency(budget.limitAmount),
          progress: budget.progress,
        ),
        const SizedBox(height: 16),
        _EditInfoCard(
          title: 'Đã chi tiêu (Tháng này)',
          primary: formatCurrency(budget.spentAmount),
          secondary:
              'Còn lại: ${formatCurrency(math.max(0, amountValue - budget.spentAmount))}',
        ),
      ],
    );
  }
}

class _EditInfoCard extends StatelessWidget {
  const _EditInfoCard({
    required this.title,
    required this.primary,
    this.secondary,
    this.progress,
  });

  final String title;
  final String primary;
  final String? secondary;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            primary,
            style: GoogleFonts.manrope(
              color: title == 'Hạn mức hiện tại'
                  ? const Color(0xFF0053DB)
                  : const Color(0xFF113069),
              fontSize: 30,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: const Color(0xFFD9E2FF),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF0053DB)),
              ),
            ),
          ],
          if (secondary != null) ...[
            const SizedBox(height: 8),
            Text(
              secondary!,
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BudgetHistoryCard extends StatelessWidget {
  const _BudgetHistoryCard({
    required this.categoryId,
    required this.suggestedLimit,
  });

  final String categoryId;
  final int suggestedLimit;

  @override
  Widget build(BuildContext context) {
    final history = budgetHistoryFor(categoryId);
    final average = history.isEmpty
        ? 0
        : history.reduce((value, element) => value + element) ~/ history.length;
    final maxValue = [
      ...history,
      suggestedLimit,
    ].fold<int>(1, (max, value) => value > max ? value : max);
    final difference = average == 0
        ? 0
        : (((suggestedLimit - average) / average) * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Lịch sử Chi tiêu',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'So sánh 3 tháng gần nhất',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'TRUNG BÌNH',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                      letterSpacing: -0.6,
                    ),
                  ),
                  Text(
                    '${(average / 1000).round()}k/th',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF006D4A),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 176,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < history.length; index++) ...[
                  Expanded(
                    child: _HistoryBar(
                      label: 'THÁNG ${10 + index}',
                      value: history[index],
                      maxValue: maxValue,
                      active: index == history.length - 1,
                    ),
                  ),
                  if (index != history.length - 1) const SizedBox(width: 16),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: Color(0xFF445D99),
                  size: 14,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Mức hạn mức ${_compactMoney(suggestedLimit)} sẽ ${difference >= 0 ? 'cao hơn' : 'thấp hơn'} ${difference.abs()}% so với chi tiêu trung bình.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                      height: 1.35,
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

  String _compactMoney(int amount) =>
      '${(amount / 1000000).toStringAsFixed(1)}M';
}

class _HistoryBar extends StatelessWidget {
  const _HistoryBar({
    required this.label,
    required this.value,
    required this.maxValue,
    required this.active,
  });

  final String label;
  final int value;
  final int maxValue;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final height = maxValue == 0 ? 0.0 : (value / maxValue) * 141;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 50,
          height: height,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF0153DB) : const Color(0xFF445D99),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            color: active ? const Color(0xFF0053DB) : const Color(0xFF445D99),
            fontSize: 10,
            fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DeleteBudgetSheet extends StatelessWidget {
  const _DeleteBudgetSheet({required this.categoryName});

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFFAF8FF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 30,
            offset: Offset(0, -8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
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
          const SizedBox(height: 24),
          Text(
            'Xóa hạn mức?',
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bạn có chắc chắn muốn xóa hạn mức cho $categoryName? Hành động này không thể hoàn tác.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 14,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF9F403D),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Xóa',
                style: GoogleFonts.inter(
                  color: const Color(0xFFFFF7F6),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE2E7FF),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                'Hủy',
                style: GoogleFonts.inter(
                  color: const Color(0xFF113069),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
