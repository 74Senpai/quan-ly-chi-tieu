import 'package:flutter/material.dart';

enum BudgetCycle { monthly, weekly, custom }

extension BudgetCycleX on BudgetCycle {
  String get label {
    switch (this) {
      case BudgetCycle.monthly:
        return 'Hàng tháng';
      case BudgetCycle.weekly:
        return 'Hàng tuần';
      case BudgetCycle.custom:
        return 'Tùy chỉnh';
    }
  }
}

enum BudgetStatus { safe, warning, critical }

class BudgetCategoryTemplate {
  const BudgetCategoryTemplate({
    required this.id,
    required this.name,
    required this.icon,
    required this.tintColor,
    required this.accentColor,
  });

  final String id;
  final String name;
  final IconData icon;
  final Color tintColor;
  final Color accentColor;
}

class BudgetLimit {
  const BudgetLimit({
    required this.id,
    required this.template,
    required this.limitAmount,
    required this.spentAmount,
    required this.cycle,
  });

  final String id;
  final BudgetCategoryTemplate template;
  final int limitAmount;
  final int spentAmount;
  final BudgetCycle cycle;

  double get progress => limitAmount == 0 ? 0 : spentAmount / limitAmount;

  int get remainingAmount => limitAmount - spentAmount;

  int get usagePercent => (progress * 100).round();

  BudgetStatus get status {
    if (progress >= 0.9) {
      return BudgetStatus.critical;
    }
    if (progress >= 0.65) {
      return BudgetStatus.warning;
    }
    return BudgetStatus.safe;
  }

  BudgetLimit copyWith({
    String? id,
    BudgetCategoryTemplate? template,
    int? limitAmount,
    int? spentAmount,
    BudgetCycle? cycle,
  }) {
    return BudgetLimit(
      id: id ?? this.id,
      template: template ?? this.template,
      limitAmount: limitAmount ?? this.limitAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      cycle: cycle ?? this.cycle,
    );
  }
}

class BudgetStore extends ValueNotifier<List<BudgetLimit>> {
  BudgetStore._() : super(_initialBudgets);

  static final BudgetStore instance = BudgetStore._();

  static const templates = [
    BudgetCategoryTemplate(
      id: 'food',
      name: 'Ăn uống',
      icon: Icons.restaurant_rounded,
      tintColor: Color(0xFFD9E2FF),
      accentColor: Color(0xFFF97316),
    ),
    BudgetCategoryTemplate(
      id: 'shopping',
      name: 'Mua sắm',
      icon: Icons.shopping_bag_outlined,
      tintColor: Color(0xFFD9E2FF),
      accentColor: Color(0xFF006D4A),
    ),
    BudgetCategoryTemplate(
      id: 'transport',
      name: 'Di chuyển',
      icon: Icons.directions_car_filled_outlined,
      tintColor: Color(0xFFD9E2FF),
      accentColor: Color(0xFF9F403D),
    ),
    BudgetCategoryTemplate(
      id: 'entertainment',
      name: 'Giải trí',
      icon: Icons.movie_outlined,
      tintColor: Color(0xFFD9E2FF),
      accentColor: Color(0xFF8B5CF6),
    ),
    BudgetCategoryTemplate(
      id: 'home',
      name: 'Nhà cửa',
      icon: Icons.home_outlined,
      tintColor: Color(0xFFD9E2FF),
      accentColor: Color(0xFF006D4A),
    ),
  ];

  static final List<BudgetLimit> _initialBudgets = [
    BudgetLimit(
      id: 'budget-food',
      template: templates.first,
      limitAmount: 5000000,
      spentAmount: 3600000,
      cycle: BudgetCycle.monthly,
    ),
    BudgetLimit(
      id: 'budget-home',
      template: templates.last,
      limitAmount: 7000000,
      spentAmount: 1400000,
      cycle: BudgetCycle.monthly,
    ),
    BudgetLimit(
      id: 'budget-transport',
      template: templates[2],
      limitAmount: 2000000,
      spentAmount: 1900000,
      cycle: BudgetCycle.monthly,
    ),
    BudgetLimit(
      id: 'budget-shopping',
      template: templates[1],
      limitAmount: 6000000,
      spentAmount: 1550000,
      cycle: BudgetCycle.monthly,
    ),
  ];

  int get totalBudget =>
      value.fold(0, (sum, budget) => sum + budget.limitAmount);

  int get totalSpent =>
      value.fold(0, (sum, budget) => sum + budget.spentAmount);

  int get totalRemaining => totalBudget - totalSpent;

  double get overallProgress => totalBudget == 0 ? 0 : totalSpent / totalBudget;

  List<BudgetCategoryTemplate> availableTemplates({String? editingBudgetId}) {
    final currentBudget = editingBudgetId == null
        ? null
        : value.cast<BudgetLimit?>().firstWhere(
            (item) => item?.id == editingBudgetId,
            orElse: () => null,
          );
    final usedIds = value
        .where((budget) => budget.id != editingBudgetId)
        .map((budget) => budget.template.id)
        .toSet();
    return templates
        .where(
          (template) =>
              !usedIds.contains(template.id) ||
              currentBudget?.template.id == template.id,
        )
        .toList();
  }

  void addBudget(BudgetLimit budget) {
    value = [...value, budget];
  }

  void updateBudget(BudgetLimit budget) {
    value = [
      for (final item in value)
        if (item.id == budget.id) budget else item,
    ];
  }

  void deleteBudget(String id) {
    value = value.where((budget) => budget.id != id).toList();
  }
}

String formatCurrency(int amount) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    final reverseIndex = digits.length - index;
    buffer.write(digits[index]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) {
      buffer.write('.');
    }
  }
  final prefix = amount < 0 ? '-' : '';
  return '$prefix${buffer.toString()}₫';
}

List<int> budgetHistoryFor(String templateId) {
  switch (templateId) {
    case 'food':
      return const [3800000, 4900000, 4100000];
    case 'home':
      return const [1300000, 1600000, 1400000];
    case 'transport':
      return const [1200000, 1700000, 1900000];
    case 'shopping':
      return const [900000, 1250000, 1550000];
    case 'entertainment':
      return const [700000, 820000, 950000];
    default:
      return const [0, 0, 0];
  }
}
