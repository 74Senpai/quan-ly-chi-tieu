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
}
