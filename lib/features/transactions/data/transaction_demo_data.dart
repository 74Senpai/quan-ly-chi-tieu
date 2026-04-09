import 'package:flutter/material.dart';

class ExpenseCategory {
  const ExpenseCategory({
    required this.name,
    required this.icon,
    required this.count,
    required this.backgroundColor,
  });

  final String name;
  final IconData icon;
  final int count;
  final Color backgroundColor;
}

class TransactionDemoData {
  const TransactionDemoData._();

  static const categories = [
    ExpenseCategory(
      name: 'Ăn uống',
      icon: Icons.restaurant_rounded,
      count: 11,
      backgroundColor: Color(0xFFFFEDD5),
    ),
    ExpenseCategory(
      name: 'Nhà cửa',
      icon: Icons.home_rounded,
      count: 4,
      backgroundColor: Color(0xFFDBEAFE),
    ),
    ExpenseCategory(
      name: 'Di chuyển',
      icon: Icons.directions_car_filled_outlined,
      count: 8,
      backgroundColor: Color(0xFFD9E2FF),
    ),
    ExpenseCategory(
      name: 'Mua sắm',
      icon: Icons.shopping_bag_outlined,
      count: 15,
      backgroundColor: Color(0xFFFCE7F3),
    ),
    ExpenseCategory(
      name: 'Giải trí',
      icon: Icons.movie_creation_outlined,
      count: 6,
      backgroundColor: Color(0xFFF3E8FF),
    ),
    ExpenseCategory(
      name: 'Khác',
      icon: Icons.widgets_outlined,
      count: 2,
      backgroundColor: Color(0xFFE0E7FF),
    ),
  ];
}
