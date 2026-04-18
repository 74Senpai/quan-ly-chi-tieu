import 'package:flutter/material.dart';

import '../../data/transaction_demo_data.dart';
import '../widgets/transaction_components.dart';
import 'category_picker_screen.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  String _amount = '';
  ExpenseCategory _selectedCategory = TransactionDemoData.categories.first;

  void _appendAmount(String value) {
    setState(() {
      if (_amount == '0') {
        _amount = value;
      } else {
        _amount += value;
      }
    });
  }

  void _deleteAmount() {
    setState(() {
      if (_amount.isEmpty) {
        return;
      }
      _amount = _amount.substring(0, _amount.length - 1);
    });
  }

  Future<void> _pickCategory() async {
    final selected = await Navigator.of(context).push<ExpenseCategory>(
      MaterialPageRoute(
        builder: (_) => CategoryPickerScreen(current: _selectedCategory),
      ),
    );
    if (selected != null) {
      setState(() => _selectedCategory = selected);
    }
  }

  void _save() {
    final amount = _amount.isEmpty ? '0' : _amount;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            'Đã lưu chi tiêu $amount₫ cho ${_selectedCategory.name}.',
          ),
        ),
      );
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                TransactionHeader(
                  title: 'Thêm Chi Tiêu',
                  onBack: () => Navigator.of(context).pop(),
                  onCancel: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 160),
                    child: Column(
                      children: [
                        AmountDisplay(amount: _amount),
                        const SizedBox(height: 32),
                        Row(
                          children: const [
                            Expanded(
                              child: DetailCard(
                                icon: Icons.calendar_month_outlined,
                                label: 'NGÀY',
                                value: 'Hôm nay',
                                trailing: SizedBox.shrink(),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: DetailCard(
                                icon: Icons.account_balance_wallet_outlined,
                                label: 'VÍ',
                                value: 'Ví chính',
                                trailing: SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        DetailCard(
                          icon: _selectedCategory.icon,
                          label: 'DANH MỤC',
                          value: _selectedCategory.name,
                          onTap: _pickCategory,
                          large: true,
                        ),
                        const SizedBox(height: 12),
                        const NoteCard(text: 'Ăn trưa, Đổ xăng...'),
                        const SizedBox(height: 24),
                        NumberPad(
                          onKeyTap: _appendAmount,
                          onDeleteTap: _deleteAmount,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x00FAF8FF),
                    Color(0xFFFAF8FF),
                    Color(0xFFFAF8FF),
                  ],
                ),
              ),
              child: SaveExpenseButton(onTap: _save),
            ),
          ),
        ],
      ),
    );
  }
}
