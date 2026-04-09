import 'package:flutter/foundation.dart';

enum DebtType { lend, borrow }

class DebtPayment {
  const DebtPayment({required this.amount, required this.paidAt, this.note});

  final int amount;
  final DateTime paidAt;
  final String? note;
}

class DebtItem {
  const DebtItem({
    required this.id,
    required this.type,
    required this.personName,
    required this.amount,
    required this.paidAmount,
    required this.loanDate,
    this.dueDate,
    this.interestRatePercent,
    this.walletName,
    this.note,
    this.payments = const [],
  });

  final String id;
  final DebtType type;
  final String personName;
  final int amount;
  final int paidAmount;
  final DateTime loanDate;
  final DateTime? dueDate;
  final double? interestRatePercent;
  final String? walletName;
  final String? note;
  final List<DebtPayment> payments;

  int get remaining => (amount - paidAmount).clamp(0, amount);
  int get safePaidAmount => paidAmount.clamp(0, amount);

  double get progress =>
      amount <= 0 ? 0 : (safePaidAmount / amount).clamp(0.0, 1.0);

  bool get isSettled => remaining <= 0;

  bool get isOverdue {
    final due = dueDate;
    if (due == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dueDay = DateTime(due.year, due.month, due.day);
    return !isSettled && dueDay.isBefore(today);
  }

  DebtItem copyWith({
    DebtType? type,
    String? personName,
    int? amount,
    int? paidAmount,
    DateTime? loanDate,
    DateTime? dueDate,
    double? interestRatePercent,
    String? walletName,
    String? note,
    List<DebtPayment>? payments,
  }) {
    return DebtItem(
      id: id,
      type: type ?? this.type,
      personName: personName ?? this.personName,
      amount: amount ?? this.amount,
      paidAmount: paidAmount ?? this.paidAmount,
      loanDate: loanDate ?? this.loanDate,
      dueDate: dueDate ?? this.dueDate,
      interestRatePercent: interestRatePercent ?? this.interestRatePercent,
      walletName: walletName ?? this.walletName,
      note: note ?? this.note,
      payments: payments ?? this.payments,
    );
  }
}

class DebtStore extends ValueNotifier<List<DebtItem>> {
  DebtStore._() : super(_seedDebts());

  static final DebtStore instance = DebtStore._();

  int outstandingFor(DebtType type) => value
      .where((item) => item.type == type)
      .fold<int>(0, (sum, item) => sum + item.remaining);

  int totalAmountFor(DebtType type) => value
      .where((item) => item.type == type)
      .fold<int>(0, (sum, item) => sum + item.amount);

  void addDebt(DebtItem item) {
    value = [item, ...value];
  }

  void updateDebt(DebtItem updated) {
    value = [
      for (final item in value)
        if (item.id == updated.id) updated else item,
    ];
  }

  void deleteDebt(String id) {
    value = value.where((item) => item.id != id).toList(growable: false);
  }

  void recordPayment(String debtId, DebtPayment payment) {
    final current = value;
    final index = current.indexWhere((item) => item.id == debtId);
    if (index < 0) return;

    final item = current[index];
    final newPaidAmount = (item.paidAmount + payment.amount).clamp(
      0,
      item.amount,
    );
    final updated = item.copyWith(
      paidAmount: newPaidAmount,
      payments: [payment, ...item.payments],
    );

    value = [
      for (final existing in current)
        if (existing.id == debtId) updated else existing,
    ];
  }
}

List<DebtItem> _seedDebts() {
  return [
    DebtItem(
      id: 'debt-1',
      type: DebtType.lend,
      personName: 'Nguyễn Văn A',
      amount: 2000000,
      paidAmount: 500000,
      loanDate: DateTime(2025, 3, 1),
      dueDate: DateTime(2025, 3, 1),
      interestRatePercent: 0,
      walletName: 'Ví tiền mặt',
      note: 'Nhắc trả cuối tháng.',
      payments: [DebtPayment(amount: 500000, paidAt: DateTime(2025, 3, 5))],
    ),
    DebtItem(
      id: 'debt-2',
      type: DebtType.borrow,
      personName: 'Trần Thị B',
      amount: 5000000,
      paidAmount: 0,
      loanDate: DateTime(2025, 1, 15),
      dueDate: DateTime(2025, 2, 15),
      interestRatePercent: 2,
      walletName: 'Ví tiền mặt',
      note: 'Khoản vay ngắn hạn.',
    ),
  ];
}

String formatVnMoney(int amount) {
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

String formatVnDate(DateTime date) {
  String pad2(int value) => value.toString().padLeft(2, '0');
  return '${pad2(date.day)}/${pad2(date.month)}/${date.year}';
}
