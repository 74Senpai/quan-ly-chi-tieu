import 'package:flutter/material.dart';

class ReconciliationWallet {
  const ReconciliationWallet({
    required this.name,
    required this.subtitle,
    required this.appBalance,
    required this.actualBalance,
    required this.discrepancy,
    required this.icon,
    required this.iconBackground,
    required this.iconForeground,
  });

  final String name;
  final String subtitle;
  final String appBalance;
  final String actualBalance;
  final String discrepancy;
  final IconData icon;
  final Color iconBackground;
  final Color iconForeground;
}

class ReconciliationBarPair {
  const ReconciliationBarPair({
    required this.label,
    required this.appValue,
    required this.actualValue,
  });

  final String label;
  final double appValue;
  final double actualValue;
}

class ReconciliationHistoryMonth {
  const ReconciliationHistoryMonth({
    required this.title,
    required this.countLabel,
    required this.items,
  });

  final String title;
  final String countLabel;
  final List<ReconciliationHistoryItem> items;
}

class ReconciliationHistoryItem {
  const ReconciliationHistoryItem({
    required this.dateLabel,
    required this.walletsLabel,
    required this.amountLabel,
    required this.balanceLabel,
    required this.statusLabel,
    required this.statusBackground,
    required this.statusForeground,
    required this.icon,
    required this.iconBackground,
    required this.iconForeground,
    required this.amountColor,
  });

  final String dateLabel;
  final String walletsLabel;
  final String amountLabel;
  final String balanceLabel;
  final String statusLabel;
  final Color statusBackground;
  final Color statusForeground;
  final IconData icon;
  final Color iconBackground;
  final Color iconForeground;
  final Color amountColor;
}

const reconciliationBarPairs = <ReconciliationBarPair>[
  ReconciliationBarPair(label: 'Tiền mặt', appValue: 0.86, actualValue: 0.62),
  ReconciliationBarPair(label: 'Techcom', appValue: 0.94, actualValue: 0.90),
  ReconciliationBarPair(label: 'MoMo', appValue: 0.68, actualValue: 0.54),
];

const reconciliationWallets = <ReconciliationWallet>[
  ReconciliationWallet(
    name: 'Tiền mặt',
    subtitle: 'VÍ CHÍNH',
    appBalance: '12.500.000đ',
    actualBalance: '11.200.000đ',
    discrepancy: '-1.300.000đ',
    icon: Icons.payments_outlined,
    iconBackground: Color(0xFFE8F0FF),
    iconForeground: Color(0xFF0053DB),
  ),
  ReconciliationWallet(
    name: 'Techcombank',
    subtitle: 'TÀI KHOẢN',
    appBalance: '25.000.000đ',
    actualBalance: '25.150.000đ',
    discrepancy: '+150.000đ',
    icon: Icons.account_balance_outlined,
    iconBackground: Color(0xFFE2E7FF),
    iconForeground: Color(0xFF0048C1),
  ),
  ReconciliationWallet(
    name: 'MoMo',
    subtitle: 'VÍ ĐIỆN TỬ',
    appBalance: '4.800.000đ',
    actualBalance: '4.800.000đ',
    discrepancy: '0đ',
    icon: Icons.phone_iphone_outlined,
    iconBackground: Color(0xFFF3E8FF),
    iconForeground: Color(0xFF6D28D9),
  ),
];

const reconciliationHistory = <ReconciliationHistoryMonth>[
  ReconciliationHistoryMonth(
    title: 'THÁNG 10, 2023',
    countLabel: '4 giao dịch',
    items: [
      ReconciliationHistoryItem(
        dateLabel: '28 Th10, 2023',
        walletsLabel: 'Tiền mặt,\nTechcombank',
        amountLabel: '-2.450.000\nVND',
        balanceLabel: 'CHÊNH LỆCH',
        statusLabel: 'CẦN\nXỬ LÝ',
        statusBackground: Color(0x1AFE8983),
        statusForeground: Color(0xFF9F403D),
        icon: Icons.error_outline_rounded,
        iconBackground: Color(0x1AFE8983),
        iconForeground: Color(0xFF9F403D),
        amountColor: Color(0xFF9F403D),
      ),
      ReconciliationHistoryItem(
        dateLabel: '15 Th10, 2023',
        walletsLabel: 'Momo, VIB Bank',
        amountLabel: '0 VND',
        balanceLabel: 'CÂN BẰNG',
        statusLabel: 'ĐÃ KHỚP',
        statusBackground: Color(0x336FFBBE),
        statusForeground: Color(0xFF005E3F),
        icon: Icons.verified_rounded,
        iconBackground: Color(0x336FFBBE),
        iconForeground: Color(0xFF005E3F),
        amountColor: Color(0xFF113069),
      ),
    ],
  ),
  ReconciliationHistoryMonth(
    title: 'THÁNG 09, 2023',
    countLabel: '8 giao dịch',
    items: [
      ReconciliationHistoryItem(
        dateLabel: '29 Th09, 2023',
        walletsLabel: 'Tiền mặt, VPBank',
        amountLabel: '0 VND',
        balanceLabel: 'CÂN BẰNG',
        statusLabel: 'ĐÃ KHỚP',
        statusBackground: Color(0x336FFBBE),
        statusForeground: Color(0xFF005E3F),
        icon: Icons.verified_rounded,
        iconBackground: Color(0x336FFBBE),
        iconForeground: Color(0xFF005E3F),
        amountColor: Color(0xFF113069),
      ),
    ],
  ),
];
