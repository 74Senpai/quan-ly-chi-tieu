import 'package:flutter/material.dart';

enum InvestmentAssetType { stocks, gold, crypto, realEstate }

extension InvestmentAssetTypeX on InvestmentAssetType {
  String get label => switch (this) {
    InvestmentAssetType.stocks => 'Chứng khoán',
    InvestmentAssetType.gold => 'Vàng',
    InvestmentAssetType.crypto => 'Crypto',
    InvestmentAssetType.realEstate => 'BĐS',
  };

  String get shortLabel => switch (this) {
    InvestmentAssetType.stocks => 'CP',
    InvestmentAssetType.gold => 'Vàng',
    InvestmentAssetType.crypto => 'Coin',
    InvestmentAssetType.realEstate => 'BĐS',
  };

  IconData get icon => switch (this) {
    InvestmentAssetType.stocks => Icons.show_chart_rounded,
    InvestmentAssetType.gold => Icons.payments_outlined,
    InvestmentAssetType.crypto => Icons.currency_bitcoin_rounded,
    InvestmentAssetType.realEstate => Icons.house_siding_outlined,
  };

  Color get iconBackground => switch (this) {
    InvestmentAssetType.stocks => const Color(0xFFDBE1FF),
    InvestmentAssetType.gold => const Color(0xFF6FFBBE),
    InvestmentAssetType.crypto => const Color(0xFFDFD5F7),
    InvestmentAssetType.realEstate => const Color(0xFFE2E7FF),
  };

  Color get accent => switch (this) {
    InvestmentAssetType.stocks => const Color(0xFF0053DB),
    InvestmentAssetType.gold => const Color(0xFF006D4A),
    InvestmentAssetType.crypto => const Color(0xFF6D4ACF),
    InvestmentAssetType.realEstate => const Color(0xFF5A6FA8),
  };
}

class InvestmentPortfolioItem {
  const InvestmentPortfolioItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.changeLabel,
    required this.changePositive,
  });

  final InvestmentAssetType type;
  final String title;
  final String subtitle;
  final String value;
  final String changeLabel;
  final bool changePositive;
}

class StockPosition {
  const StockPosition({
    required this.symbol,
    required this.change,
    required this.changePositive,
    required this.volume,
    required this.costPrice,
    required this.currentPrice,
  });

  final String symbol;
  final String change;
  final bool changePositive;
  final String volume;
  final String costPrice;
  final String currentPrice;
}

class MarketTicker {
  const MarketTicker({
    required this.symbol,
    required this.label,
    required this.price,
    required this.change,
    required this.changePositive,
    required this.icon,
    required this.background,
  });

  final String symbol;
  final String label;
  final String price;
  final String change;
  final bool changePositive;
  final IconData icon;
  final Color background;
}

class ActivityItem {
  const ActivityItem({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.secondaryAmount,
    required this.icon,
    required this.iconBackground,
    required this.positive,
  });

  final String title;
  final String subtitle;
  final String amount;
  final String secondaryAmount;
  final IconData icon;
  final Color iconBackground;
  final bool positive;
}

const portfolioItems = <InvestmentPortfolioItem>[
  InvestmentPortfolioItem(
    type: InvestmentAssetType.stocks,
    title: 'Chứng khoán',
    subtitle: '12 mã tài sản',
    value: '1.250.000.000đ',
    changeLabel: '+12.4%',
    changePositive: true,
  ),
  InvestmentPortfolioItem(
    type: InvestmentAssetType.gold,
    title: 'Vàng SJC',
    subtitle: 'Tài sản trú ẩn',
    value: '820.000.000đ',
    changeLabel: '-2.5%',
    changePositive: false,
  ),
  InvestmentPortfolioItem(
    type: InvestmentAssetType.crypto,
    title: 'Tiền mã hóa',
    subtitle: 'BTC, ETH, SOL',
    value: '415.000.000đ',
    changeLabel: '+42.8%',
    changePositive: true,
  ),
];

const stockPositions = <StockPosition>[
  StockPosition(
    symbol: 'VNM',
    change: '+4.2%',
    changePositive: true,
    volume: '10,000',
    costPrice: '68.2',
    currentPrice: '71.1',
  ),
  StockPosition(
    symbol: 'HPG',
    change: '-1.5%',
    changePositive: false,
    volume: '25,000',
    costPrice: '28.5',
    currentPrice: '28.1',
  ),
  StockPosition(
    symbol: 'FPT',
    change: '+12.8%',
    changePositive: true,
    volume: '5,000',
    costPrice: '92.0',
    currentPrice: '104.5',
  ),
];

const cryptoTickers = <MarketTicker>[
  MarketTicker(
    symbol: 'Bitcoin',
    label: 'BTC',
    price: '\$64,124.80',
    change: '+2.14%',
    changePositive: true,
    icon: Icons.currency_bitcoin_rounded,
    background: Color(0xFFFFF4E8),
  ),
  MarketTicker(
    symbol: 'Ethereum',
    label: 'ETH',
    price: '\$3,452.12',
    change: '-0.82%',
    changePositive: false,
    icon: Icons.token_rounded,
    background: Color(0xFFEAE8FF),
  ),
];

const cryptoTodayActivities = <ActivityItem>[
  ActivityItem(
    title: 'Nhận BTC',
    subtitle: '10:45 • Từ: External Wallet',
    amount: '+0.015 BTC',
    secondaryAmount: '≈ 24.5M VND',
    icon: Icons.south_west_rounded,
    iconBackground: Color(0xFFE5F6EE),
    positive: true,
  ),
  ActivityItem(
    title: 'Hoán đổi ETH -> USDT',
    subtitle: '08:20 • Phí: 0.002 ETH',
    amount: '620 USDT',
    secondaryAmount: '≈ 39.2M VND',
    icon: Icons.swap_horiz_rounded,
    iconBackground: Color(0xFFF2F3FF),
    positive: true,
  ),
];

const cryptoYesterdayActivities = <ActivityItem>[
  ActivityItem(
    title: 'Chuyển SOL',
    subtitle: '15:30 • Đến: 4s3h...9z2a',
    amount: '-12.0 SOL',
    secondaryAmount: '≈ 42.1M VND',
    icon: Icons.north_east_rounded,
    iconBackground: Color(0xFFFCE7E5),
    positive: false,
  ),
];

const goldHoldingItems = <ActivityItem>[
  ActivityItem(
    title: 'Vàng miếng SJC 9999',
    subtitle: '12 Tháng 02, 2024',
    amount: '5.0 lượng',
    secondaryAmount: 'GIÁ MUA: 68.2M',
    icon: Icons.workspace_premium_outlined,
    iconBackground: Color(0xFFEAF0FF),
    positive: true,
  ),
  ActivityItem(
    title: 'Vàng miếng SJC 9999',
    subtitle: '05 Tháng 01, 2024',
    amount: '7.5 lượng',
    secondaryAmount: 'GIÁ MUA: 74.5M',
    icon: Icons.workspace_premium_outlined,
    iconBackground: Color(0xFFEAF0FF),
    positive: true,
  ),
];

const stockTransactions = <ActivityItem>[
  ActivityItem(
    title: 'Mua VNM',
    subtitle: '25 Th09, 2023 • 500 CP',
    amount: '-38,450,000đ',
    secondaryAmount: 'GIÁ: 76,900',
    icon: Icons.south_west_rounded,
    iconBackground: Color(0xFFFCE7E5),
    positive: false,
  ),
  ActivityItem(
    title: 'Bán FPT',
    subtitle: '18 Th09, 2023 • 200 CP',
    amount: '+19,240,000đ',
    secondaryAmount: 'GIÁ: 96,200',
    icon: Icons.north_east_rounded,
    iconBackground: Color(0xFFE5F6EE),
    positive: true,
  ),
  ActivityItem(
    title: 'Mua HPG',
    subtitle: '12 Th09, 2023 • 1,000 CP',
    amount: '-28,150,000đ',
    secondaryAmount: 'GIÁ: 28,150',
    icon: Icons.south_west_rounded,
    iconBackground: Color(0xFFFCE7E5),
    positive: false,
  ),
];
