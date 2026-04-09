import 'package:flutter/material.dart';

enum AppLanguage {
  vietnamese('Tiếng Việt', 'Vietnamese', '🇻🇳'),
  english('English', 'Tiếng Anh', '🇺🇸'),
  japanese('日本語', 'Japanese', '🇯🇵');

  const AppLanguage(this.label, this.subtitle, this.flag);

  final String label;
  final String subtitle;
  final String flag;
}

enum DateFormatOption {
  ddmmyyyy('DD/MM/YYYY'),
  mmddyyyy('MM/DD/YYYY');

  const DateFormatOption(this.label);

  final String label;
}

class SettingsStateData {
  const SettingsStateData({
    required this.language,
    required this.currency,
    required this.dateFormat,
    required this.showBalance,
    required this.roundNumbers,
    required this.decimals,
    required this.appLockEnabled,
    required this.pinCode,
    required this.biometricEnabled,
    required this.autoLockLabel,
    required this.hideBalanceWhenLocked,
    required this.hideSensitiveNotifications,
  });

  final AppLanguage language;
  final String currency;
  final DateFormatOption dateFormat;
  final bool showBalance;
  final bool roundNumbers;
  final int decimals;
  final bool appLockEnabled;
  final String? pinCode;
  final bool biometricEnabled;
  final String autoLockLabel;
  final bool hideBalanceWhenLocked;
  final bool hideSensitiveNotifications;

  bool get hasPin => pinCode != null && pinCode!.length == 6;

  SettingsStateData copyWith({
    AppLanguage? language,
    String? currency,
    DateFormatOption? dateFormat,
    bool? showBalance,
    bool? roundNumbers,
    int? decimals,
    bool? appLockEnabled,
    String? pinCode,
    bool clearPin = false,
    bool? biometricEnabled,
    String? autoLockLabel,
    bool? hideBalanceWhenLocked,
    bool? hideSensitiveNotifications,
  }) {
    return SettingsStateData(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      dateFormat: dateFormat ?? this.dateFormat,
      showBalance: showBalance ?? this.showBalance,
      roundNumbers: roundNumbers ?? this.roundNumbers,
      decimals: decimals ?? this.decimals,
      appLockEnabled: appLockEnabled ?? this.appLockEnabled,
      pinCode: clearPin ? null : (pinCode ?? this.pinCode),
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoLockLabel: autoLockLabel ?? this.autoLockLabel,
      hideBalanceWhenLocked:
          hideBalanceWhenLocked ?? this.hideBalanceWhenLocked,
      hideSensitiveNotifications:
          hideSensitiveNotifications ?? this.hideSensitiveNotifications,
    );
  }
}

class SettingsDemoData {
  static const autoLockOptions = [
    'Ngay lập tức',
    'Sau 30 giây',
    'Sau 1 phút',
    'Sau 5 phút',
  ];

  static const currencies = ['VND', 'USD', 'JPY'];

  static const decimalOptions = [0, 1, 2];

  static SettingsStateData initial() {
    return const SettingsStateData(
      language: AppLanguage.vietnamese,
      currency: 'VND',
      dateFormat: DateFormatOption.ddmmyyyy,
      showBalance: true,
      roundNumbers: false,
      decimals: 0,
      appLockEnabled: true,
      pinCode: '245689',
      biometricEnabled: true,
      autoLockLabel: 'Ngay lập tức',
      hideBalanceWhenLocked: true,
      hideSensitiveNotifications: false,
    );
  }

  static List<ManagedCategory> initialExpenseCategories() {
    return const [
      ManagedCategory(
        id: 'expense-food',
        name: 'Ăn uống',
        emoji: '🍔',
        count: 12,
        color: Color(0xFFFFEDD5),
        type: ManagedCategoryType.expense,
      ),
      ManagedCategory(
        id: 'expense-home',
        name: 'Nhà cửa',
        emoji: '🏠',
        count: 4,
        color: Color(0xFFDBEAFE),
        type: ManagedCategoryType.expense,
      ),
      ManagedCategory(
        id: 'expense-transport',
        name: 'Di chuyển',
        emoji: '🚗',
        count: 8,
        color: Color(0xFFD9E2FF),
        type: ManagedCategoryType.expense,
      ),
      ManagedCategory(
        id: 'expense-shopping',
        name: 'Mua sắm',
        emoji: '🛍️',
        count: 15,
        color: Color(0xFFFCE7F3),
        type: ManagedCategoryType.expense,
      ),
      ManagedCategory(
        id: 'expense-entertainment',
        name: 'Giải trí',
        emoji: '🎮',
        count: 6,
        color: Color(0xFFF3E8FF),
        type: ManagedCategoryType.expense,
      ),
      ManagedCategory(
        id: 'expense-other',
        name: 'Khác',
        emoji: '📦',
        count: 2,
        color: Color(0xFFE0E7FF),
        type: ManagedCategoryType.expense,
        locked: true,
      ),
    ];
  }

  static List<ManagedCategory> initialIncomeCategories() {
    return const [
      ManagedCategory(
        id: 'income-salary',
        name: 'Lương',
        emoji: '💼',
        count: 3,
        color: Color(0xFFDDFBE8),
        type: ManagedCategoryType.income,
      ),
      ManagedCategory(
        id: 'income-bonus',
        name: 'Thưởng',
        emoji: '🎁',
        count: 2,
        color: Color(0xFFFFEDD5),
        type: ManagedCategoryType.income,
      ),
      ManagedCategory(
        id: 'income-invest',
        name: 'Đầu tư',
        emoji: '📈',
        count: 1,
        color: Color(0xFFDBEAFE),
        type: ManagedCategoryType.income,
      ),
      ManagedCategory(
        id: 'income-other',
        name: 'Khác',
        emoji: '✨',
        count: 1,
        color: Color(0xFFF3E8FF),
        type: ManagedCategoryType.income,
        locked: true,
      ),
    ];
  }

  static const iconChoices = [
    '🍔',
    '🚗',
    '🏠',
    '🛍️',
    '🎬',
    '💊',
    '🎓',
    '✈️',
    '🎁',
    '💡',
    '💼',
    '📈',
  ];

  static const colorChoices = [
    Color(0xFF2563EB),
    Color(0xFF059669),
    Color(0xFFF43F5E),
    Color(0xFFF59E0B),
    Color(0xFF6366F1),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFF14B8A6),
    Color(0xFFF97316),
    Color(0xFFEC4899),
    Color(0xFF475569),
    Color(0xFF84CC16),
  ];
}

enum ManagedCategoryType { expense, income }

extension ManagedCategoryTypeX on ManagedCategoryType {
  String get label =>
      this == ManagedCategoryType.expense ? 'Chi tiêu' : 'Thu nhập';
}

class ManagedCategory {
  const ManagedCategory({
    required this.id,
    required this.name,
    required this.emoji,
    required this.count,
    required this.color,
    required this.type,
    this.monthlyLimit,
    this.locked = false,
  });

  final String id;
  final String name;
  final String emoji;
  final int count;
  final Color color;
  final ManagedCategoryType type;
  final int? monthlyLimit;
  final bool locked;

  ManagedCategory copyWith({
    String? id,
    String? name,
    String? emoji,
    int? count,
    Color? color,
    ManagedCategoryType? type,
    int? monthlyLimit,
    bool clearMonthlyLimit = false,
    bool? locked,
  }) {
    return ManagedCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      count: count ?? this.count,
      color: color ?? this.color,
      type: type ?? this.type,
      monthlyLimit: clearMonthlyLimit
          ? null
          : (monthlyLimit ?? this.monthlyLimit),
      locked: locked ?? this.locked,
    );
  }
}

class CategoryManagerResult {
  const CategoryManagerResult({
    required this.expenseCategories,
    required this.incomeCategories,
  });

  final List<ManagedCategory> expenseCategories;
  final List<ManagedCategory> incomeCategories;
}
