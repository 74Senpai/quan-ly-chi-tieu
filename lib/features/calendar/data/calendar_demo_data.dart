import 'package:flutter/material.dart';

class CalendarDayData {
  const CalendarDayData({
    required this.day,
    this.amountLabel,
    this.income = false,
    this.isSelected = false,
    this.hasDot = false,
    this.hasNote = false,
  });

  final int day;
  final String? amountLabel;
  final bool income;
  final bool isSelected;
  final bool hasDot;
  final bool hasNote;
}

class CalendarTransaction {
  const CalendarTransaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.icon,
    required this.iconBackground,
    this.positive = false,
  });

  final String title;
  final String subtitle;
  final String amount;
  final IconData icon;
  final Color iconBackground;
  final bool positive;
}

class CalendarMonthData {
  const CalendarMonthData({
    required this.label,
    required this.startOffset,
    required this.totalDays,
    required this.totalIncome,
    required this.totalExpense,
    required this.days,
    required this.monthTransactions,
  });

  final String label;
  final int startOffset;
  final int totalDays;
  final String totalIncome;
  final String totalExpense;
  final List<CalendarDayData> days;
  final List<CalendarTransaction> monthTransactions;
}

class CalendarDemoData {
  const CalendarDemoData._();

  static const months = [
    CalendarMonthData(
      label: 'Tháng 3',
      startOffset: 5,
      totalDays: 31,
      totalIncome: '23.500.000 đ',
      totalExpense: '15.420.000 đ',
      days: [
        CalendarDayData(day: 4, amountLabel: '-240k', hasDot: true),
        CalendarDayData(day: 11, amountLabel: '-1.2M', hasDot: true),
        CalendarDayData(day: 15, amountLabel: '+8M', income: true),
        CalendarDayData(day: 22, amountLabel: '-450k', hasDot: true),
      ],
      monthTransactions: [
        CalendarTransaction(
          title: 'Lương tháng 3',
          subtitle: '20 Th03, 09:00',
          amount: '+18.000.000 đ',
          icon: Icons.payments_outlined,
          iconBackground: Color(0xFFDDFBE8),
          positive: true,
        ),
        CalendarTransaction(
          title: 'Siêu thị cuối tuần',
          subtitle: '22 Th03, 18:30',
          amount: '-450.000 đ',
          icon: Icons.shopping_bag_outlined,
          iconBackground: Color(0xFFFCE7F3),
        ),
        CalendarTransaction(
          title: 'Đóng tiền điện',
          subtitle: '11 Th03, 14:20',
          amount: '-1.200.000 đ',
          icon: Icons.bolt_outlined,
          iconBackground: Color(0xFFFFEDD5),
        ),
      ],
    ),
    CalendarMonthData(
      label: 'Tháng 4',
      startOffset: 1,
      totalDays: 30,
      totalIncome: '0 đ',
      totalExpense: '10.000 đ',
      days: [
        CalendarDayData(day: 5),
        CalendarDayData(
          day: 6,
          amountLabel: '-10k',
          isSelected: true,
          hasDot: true,
        ),
        CalendarDayData(day: 17, hasNote: true),
      ],
      monthTransactions: [
        CalendarTransaction(
          title: 'Ăn uống',
          subtitle: '06 Th04, 08:30 • Tiền mặt',
          amount: '-10.000 đ',
          icon: Icons.restaurant_rounded,
          iconBackground: Color(0xFFFFE7E3),
        ),
        CalendarTransaction(
          title: 'Cà phê sáng',
          subtitle: '03 Th04, 08:30',
          amount: '-45.000 đ',
          icon: Icons.local_cafe_outlined,
          iconBackground: Color(0xFFEAEDFF),
        ),
        CalendarTransaction(
          title: 'Ăn trưa',
          subtitle: '03 Th04, 12:45',
          amount: '-120.000 đ',
          icon: Icons.lunch_dining_outlined,
          iconBackground: Color(0xFFEAEDFF),
        ),
        CalendarTransaction(
          title: 'Hóa đơn điện',
          subtitle: '02 Th04, 15:20',
          amount: '-850.000 đ',
          icon: Icons.bolt_outlined,
          iconBackground: Color(0xFFEAEDFF),
        ),
      ],
    ),
    CalendarMonthData(
      label: 'Tháng 5',
      startOffset: 4,
      totalDays: 31,
      totalIncome: '24.000.000 đ',
      totalExpense: '8.240.000 đ',
      days: [
        CalendarDayData(day: 2, amountLabel: '-320k', hasDot: true),
        CalendarDayData(day: 8, amountLabel: '-2.1M', hasDot: true),
        CalendarDayData(day: 20, amountLabel: '+24M', income: true),
        CalendarDayData(day: 23, amountLabel: '-1.6M', hasDot: true),
      ],
      monthTransactions: [
        CalendarTransaction(
          title: 'Lương tháng',
          subtitle: '20 Th05, 09:00',
          amount: '+24.000.000 đ',
          icon: Icons.payments_outlined,
          iconBackground: Color(0xFFDDFBE8),
          positive: true,
        ),
        CalendarTransaction(
          title: 'Siêu thị',
          subtitle: '23 Th05, 18:10',
          amount: '-1.600.000 đ',
          icon: Icons.shopping_cart_outlined,
          iconBackground: Color(0xFFEAEDFF),
        ),
        CalendarTransaction(
          title: 'Ăn trưa',
          subtitle: '18 Th05, 12:10',
          amount: '-90.000 đ',
          icon: Icons.ramen_dining_outlined,
          iconBackground: Color(0xFFFFEDD5),
        ),
      ],
    ),
  ];
}
