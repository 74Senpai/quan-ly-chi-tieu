import 'package:flutter/material.dart';

class TaxOverviewCategory {
  const TaxOverviewCategory({
    required this.label,
    required this.percentage,
    required this.color,
  });

  final String label;
  final String percentage;
  final Color color;
}

class TaxPaymentRecord {
  const TaxPaymentRecord({
    required this.title,
    required this.source,
    required this.date,
    required this.amount,
    required this.status,
    required this.icon,
    required this.iconBackground,
    required this.iconForeground,
  });

  final String title;
  final String source;
  final String date;
  final String amount;
  final String status;
  final IconData icon;
  final Color iconBackground;
  final Color iconForeground;
}

class TaxCategoryDetail {
  const TaxCategoryDetail({
    required this.title,
    required this.amount,
    required this.share,
    required this.status,
    required this.statusBackground,
    required this.statusForeground,
    required this.icon,
    required this.iconBackground,
    required this.iconForeground,
    this.emphasized = false,
  });

  final String title;
  final String amount;
  final String share;
  final String status;
  final Color statusBackground;
  final Color statusForeground;
  final IconData icon;
  final Color iconBackground;
  final Color iconForeground;
  final bool emphasized;
}

const taxOverviewCategories = <TaxOverviewCategory>[
  TaxOverviewCategory(
    label: 'Thuế TNCN',
    percentage: '75%',
    color: Color(0xFF0053DB),
  ),
  TaxOverviewCategory(
    label: 'Thuế VAT',
    percentage: '18%',
    color: Color(0xFF006D4A),
  ),
  TaxOverviewCategory(
    label: 'Thuế Nhà đất',
    percentage: '7%',
    color: Color(0xFF625B77),
  ),
];

const taxTrendValues = <double>[
  9.8,
  8.2,
  12.2,
  16.4,
  13.0,
  11.6,
  12.8,
  14.0,
  18.5,
  18.2,
  8.4,
];

const taxTrendLabels = <String>[
  'JAN',
  'FEB',
  'MAR',
  'APR',
  'MAY',
  'JUN',
  'JUL',
  'AUG',
  'SEP',
  'OCT',
  'NOV',
];

const taxPayments = <TaxPaymentRecord>[
  TaxPaymentRecord(
    title: 'Quyết toán Thuế TNCN',
    source: 'KHO BẠC NHÀ NƯỚC',
    date: '12 THÁNG 10, 2024',
    amount: '-12.450.000₫',
    status: 'HOÀN TẤT',
    icon: Icons.account_balance_outlined,
    iconBackground: Color(0x140053DB),
    iconForeground: Color(0xFF0053DB),
  ),
  TaxPaymentRecord(
    title: 'Thuế Giá trị gia tăng (VAT)',
    source: 'CHI CỤC THUẾ QUẬN 1',
    date: '05 THÁNG 10, 2024',
    amount: '-3.200.000₫',
    status: 'HOÀN TẤT',
    icon: Icons.storefront_outlined,
    iconBackground: Color(0x14006D4A),
    iconForeground: Color(0xFF006D4A),
  ),
  TaxPaymentRecord(
    title: 'Thuế Nhà đất phi nông nghiệp',
    source: 'CỔNG DỊCH VỤ CÔNG',
    date: '28 THÁNG 9, 2024',
    amount: '-850.000₫',
    status: 'HOÀN TẤT',
    icon: Icons.home_work_outlined,
    iconBackground: Color(0x14625B77),
    iconForeground: Color(0xFF625B77),
  ),
];

const taxCategoryDetails = <TaxCategoryDetail>[
  TaxCategoryDetail(
    title: 'Thuế Thu nhập Cá nhân (PIT)',
    amount: '28.400.000 VND',
    share: '66.7%',
    status: 'ĐÃ QUYẾT TOÁN',
    statusBackground: Color(0xFF6FFBBE),
    statusForeground: Color(0xFF005E3F),
    icon: Icons.person_outline_rounded,
    iconBackground: Color(0xFFE8F0FF),
    iconForeground: Color(0xFF0053DB),
    emphasized: true,
  ),
  TaxCategoryDetail(
    title: 'Thuế Giá trị Gia tăng (VAT)',
    amount: '11.250.000 VND',
    share: '26.4%',
    status: 'CHỜ XỬ LÝ',
    statusBackground: Color(0xFFE2E7FF),
    statusForeground: Color(0xFF445D99),
    icon: Icons.receipt_long_outlined,
    iconBackground: Color(0xFFE2F0EC),
    iconForeground: Color(0xFF006D4A),
  ),
  TaxCategoryDetail(
    title: 'Thuế Nhà đất',
    amount: '2.150.000 VND',
    share: '5.1%',
    status: 'SẮP ĐẾN HẠN',
    statusBackground: Color(0x33FE8983),
    statusForeground: Color(0xFF9F403D),
    icon: Icons.home_outlined,
    iconBackground: Color(0x1ADFD5F7),
    iconForeground: Color(0xFF625B77),
  ),
  TaxCategoryDetail(
    title: 'Các loại thuế khác',
    amount: '780.000 VND',
    share: '1.8%',
    status: '03 MỤC',
    statusBackground: Color(0xFFEFF2FA),
    statusForeground: Color(0xFF445D99),
    icon: Icons.more_horiz_rounded,
    iconBackground: Color(0x1A445D99),
    iconForeground: Color(0xFF445D99),
  ),
];
