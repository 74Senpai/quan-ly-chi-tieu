import 'package:flutter/material.dart';

class SavingsGoalEditorScreen extends StatelessWidget {
  const SavingsGoalEditorScreen({super.key, this.goalId});

  final String? goalId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(goalId == null ? 'Thêm mục tiêu' : 'Sửa mục tiêu'),
      ),
      body: Center(
        child: Text('Savings goal editor feature is coming soon.'),
      ),
    );
  }
}
