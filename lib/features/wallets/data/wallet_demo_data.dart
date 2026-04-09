import 'package:flutter/material.dart';

enum WalletType { cash, bank, ewallet, credit }

extension WalletTypeX on WalletType {
  String get label {
    switch (this) {
      case WalletType.cash:
        return 'Tiền mặt';
      case WalletType.bank:
        return 'Ngân hàng';
      case WalletType.ewallet:
        return 'Ví điện tử';
      case WalletType.credit:
        return 'Thẻ tín dụng';
    }
  }

  IconData get icon {
    switch (this) {
      case WalletType.cash:
        return Icons.payments_outlined;
      case WalletType.bank:
        return Icons.account_balance_rounded;
      case WalletType.ewallet:
        return Icons.smartphone_rounded;
      case WalletType.credit:
        return Icons.credit_card_rounded;
    }
  }
}

class WalletTransaction {
  const WalletTransaction({
    required this.title,
    required this.timeLabel,
    required this.categoryLabel,
    required this.amount,
    required this.positive,
    required this.icon,
    required this.iconBackground,
  });

  final String title;
  final String timeLabel;
  final String categoryLabel;
  final int amount;
  final bool positive;
  final String icon;
  final Color iconBackground;
}

class WalletItem {
  const WalletItem({
    required this.id,
    required this.type,
    required this.name,
    required this.subtitle,
    required this.balance,
    required this.icon,
    required this.color,
    required this.isConfigured,
    this.bankName,
    this.isArchived = false,
    this.creditLimit,
    this.usedAmount = 0,
    this.transactions = const [],
  });

  final String id;
  final WalletType type;
  final String name;
  final String subtitle;
  final int balance;
  final String icon;
  final Color color;
  final bool isConfigured;
  final String? bankName;
  final bool isArchived;
  final int? creditLimit;
  final int usedAmount;
  final List<WalletTransaction> transactions;

  WalletItem copyWith({
    String? id,
    WalletType? type,
    String? name,
    String? subtitle,
    int? balance,
    String? icon,
    Color? color,
    bool? isConfigured,
    String? bankName,
    bool? isArchived,
    int? creditLimit,
    int? usedAmount,
    List<WalletTransaction>? transactions,
  }) {
    return WalletItem(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      subtitle: subtitle ?? this.subtitle,
      balance: balance ?? this.balance,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isConfigured: isConfigured ?? this.isConfigured,
      bankName: bankName ?? this.bankName,
      isArchived: isArchived ?? this.isArchived,
      creditLimit: creditLimit ?? this.creditLimit,
      usedAmount: usedAmount ?? this.usedAmount,
      transactions: transactions ?? this.transactions,
    );
  }
}

class WalletDemoData {
  const WalletDemoData._();

  static const bankNames = [
    'Techcombank',
    'Vietcombank',
    'MB Bank',
    'ACB',
    'BIDV',
    'TPBank',
  ];

  static const iconChoices = [
    '👛',
    '🏦',
    '🐷',
    '💳',
    '💰',
    '📊',
    '💎',
    '✈️',
    '🛒',
    '🏠',
    '🚗',
    '🎁',
  ];

  static const colorChoices = [
    Color(0xFF4F46E5),
    Color(0xFF0053DB),
    Color(0xFF0D9488),
    Color(0xFF059669),
    Color(0xFFD97706),
    Color(0xFFE11D48),
  ];

  static List<WalletItem> initialWallets() {
    return [
      const WalletItem(
        id: 'cash',
        type: WalletType.cash,
        name: 'Tiền mặt',
        subtitle: 'Ví tiêu dùng',
        balance: 0,
        icon: '💵',
        color: Color(0xFF0D9488),
        isConfigured: false,
      ),
      WalletItem(
        id: 'techcombank',
        type: WalletType.bank,
        name: 'Techcombank',
        subtitle: 'Tài khoản chính',
        balance: 15000000,
        icon: '🏦',
        color: const Color(0xFF0053DB),
        bankName: 'Techcombank',
        isConfigured: true,
        transactions: const [
          WalletTransaction(
            title: 'Ăn trưa',
            timeLabel: 'Thứ 3, 11:30',
            categoryLabel: 'Food & Drink',
            amount: 85000,
            positive: false,
            icon: '🍕',
            iconBackground: Color(0xFFE2E7FF),
          ),
          WalletTransaction(
            title: 'Grab',
            timeLabel: 'Thứ 3, 08:15',
            categoryLabel: 'Transport',
            amount: 42000,
            positive: false,
            icon: '🚗',
            iconBackground: Color(0xFFE2E7FF),
          ),
          WalletTransaction(
            title: 'Salary Deposit',
            timeLabel: '14 Jan, 09:00',
            categoryLabel: 'Income',
            amount: 2000000,
            positive: true,
            icon: '💰',
            iconBackground: Color(0xFF6FFBBE),
          ),
        ],
      ),
      const WalletItem(
        id: 'visa',
        type: WalletType.credit,
        name: 'Visa Credit',
        subtitle: 'Thanh toán sau',
        balance: 0,
        icon: '💳',
        color: Color(0xFF445D99),
        isConfigured: false,
        creditLimit: 10000000,
        usedAmount: 3200000,
      ),
    ];
  }
}
