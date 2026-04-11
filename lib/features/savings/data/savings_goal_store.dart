import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum SavingsTransactionType { deposit, withdraw }

class SavingsTransaction {
  const SavingsTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.createdAt,
    this.source,
    this.note,
  });

  final String id;
  final SavingsTransactionType type;
  final int amount;
  final DateTime createdAt;
  final String? source;
  final String? note;
}


class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.name,
    required this.emoji,
    required this.targetAmount,
    required this.currentAmount,
    required this.monthlySaving,
    this.targetDate,
    this.themeStart = const Color(0xFF0053DB),
    this.themeEnd = const Color(0xFF0048C1),
    this.transactions = const [],
  });

  final String id;
  final String name;
  final String emoji;
  final int targetAmount;
  final int currentAmount;
  final int monthlySaving;
  final DateTime? targetDate;
  final Color themeStart;
  final Color themeEnd;
  final List<SavingsTransaction> transactions;

  double get progress =>
      targetAmount <= 0 ? 0 : (currentAmount / targetAmount).clamp(0.0, 1.0);

  bool get isCompleted => currentAmount >= targetAmount;

  SavingsGoal copyWith({
    String? name,
    String? emoji,
    int? targetAmount,
    int? currentAmount,
    int? monthlySaving,
    DateTime? targetDate,
    Color? themeStart,
    Color? themeEnd,
    List<SavingsTransaction>? transactions,
  }) {
    return SavingsGoal(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      targetAmount: targetAmount ?? this.targetAmount,
      currentAmount: currentAmount ?? this.currentAmount,
      monthlySaving: monthlySaving ?? this.monthlySaving,
      targetDate: targetDate ?? this.targetDate,
      themeStart: themeStart ?? this.themeStart,
      themeEnd: themeEnd ?? this.themeEnd,
      transactions: transactions ?? this.transactions,
    );
  }
}

class SavingsGoalStore extends ValueNotifier<List<SavingsGoal>> {
  SavingsGoalStore._() : super(_seedGoals());

  static final SavingsGoalStore instance = SavingsGoalStore._();

  int get totalSaved => value.fold<int>(0, (sum, goal) => sum + goal.currentAmount);
  int get goalsCount => value.length;

  double get overallProgress {
    final totalTarget = value.fold<int>(0, (sum, goal) => sum + goal.targetAmount);
    if (totalTarget <= 0) return 0;
    return (totalSaved / totalTarget).clamp(0.0, 1.0);
  }

  SavingsGoal? byId(String id) => value.where((g) => g.id == id).firstOrNull;

  void addGoal(SavingsGoal goal) {
    value = [goal, ...value];
  }

  void updateGoal(SavingsGoal updated) {
    value = [
      for (final goal in value) if (goal.id == updated.id) updated else goal,
    ];
  }

  void deleteGoal(String id) {
    value = value.where((g) => g.id != id).toList(growable: false);
  }

  void deposit({
    required String goalId,
    required int amount,
    String? source,
    String? note,
  }) {
    if (amount <= 0) return;
    final goal = byId(goalId);
    if (goal == null) return;
    final updated = goal.copyWith(
      currentAmount: goal.currentAmount + amount,
      transactions: [
        SavingsTransaction(
          id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
          type: SavingsTransactionType.deposit,
          amount: amount,
          createdAt: DateTime.now(),
          source: source,
          note: note,
        ),
        ...goal.transactions,
      ],
    );
    updateGoal(updated);
  }

  void withdraw({
    required String goalId,
    required int amount,
    String? source,
    String? note,
  }) {
    if (amount <= 0) return;
    final goal = byId(goalId);
    if (goal == null) return;
    final newAmount = (goal.currentAmount - amount).clamp(0, goal.currentAmount);
    final updated = goal.copyWith(
      currentAmount: newAmount,
      transactions: [
        SavingsTransaction(
          id: 'tx-${DateTime.now().microsecondsSinceEpoch}',
          type: SavingsTransactionType.withdraw,
          amount: amount,
          createdAt: DateTime.now(),
          source: source,
          note: note,
        ),
        ...goal.transactions,
      ],
    );
    updateGoal(updated);
  }
}

List<SavingsGoal> _seedGoals() {
  return [
    SavingsGoal(
      id: 'goal-camera',
      name: 'Máy ảnh Sony',
      emoji: '📷',
      targetAmount: 15000000,
      currentAmount: 6500000,
      monthlySaving: 1300000,
      targetDate: DateTime(2026, 3, 1),
      themeStart: const Color(0xFF0053DB),
      themeEnd: const Color(0xFF0048C1),
      transactions: [
        SavingsTransaction(
          id: 'tx-1',
          type: SavingsTransactionType.deposit,
          amount: 1500000,
          createdAt: DateTime(2024, 5, 15),
          source: 'Techcombank',
          note: 'Thưởng tháng',
        ),
        SavingsTransaction(
          id: 'tx-2',
          type: SavingsTransactionType.deposit,
          amount: 1200000,
          createdAt: DateTime(2024, 4, 20),
          source: 'Techcombank',
          note: 'Tiết kiệm ăn sáng',
        ),
      ],
    ),
    SavingsGoal(
      id: 'goal-bike',
      name: 'Mua xe máy',
      emoji: '🏍️',
      targetAmount: 30000000,
      currentAmount: 12000000,
      monthlySaving: 2000000,
      targetDate: DateTime(2026, 3, 1),
      themeStart: const Color(0xFF006D4A),
      themeEnd: const Color(0xFF34D399),
      transactions: const [],
    ),
  ];
}

String formatVnd(int amount) {
  final digits = amount.abs().toString();
  final buffer = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    final reverseIndex = digits.length - index;
    buffer.write(digits[index]);
    if (reverseIndex > 1 && reverseIndex % 3 == 1) buffer.write('.');
  }
  final prefix = amount < 0 ? '-' : '';
  return '$prefix${buffer.toString()}đ';
}

String formatGoalMonthYear(DateTime date) => 'Tháng ${date.month.toString().padLeft(2, '0')}/${date.year}';

extension on Iterable<SavingsGoal> {
  SavingsGoal? get firstOrNull => isEmpty ? null : first;
}

