import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../ai/presentation/screens/assistant_landing_screen.dart';
import '../../../home/presentation/screens/dashboard_screen.dart';
import '../../../home/presentation/widgets/home_components.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../../transactions/presentation/screens/add_expense_screen.dart';
import '../../../wallets/presentation/screens/wallets_screen.dart';
import '../../data/calendar_demo_data.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _monthIndex = 1;
  bool _gridMode = true;

  CalendarMonthData get _month => CalendarDemoData.months[_monthIndex];

  Future<void> _openAddExpense() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
  }

  Future<void> _showDaySheet(CalendarDayData day) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        if (day.day == 6 && _month.label == 'Tháng 4') {
          return _DayDetailsSheet(onAddTap: _openAddExpense);
        }
        return _EmptyDaySheet(
          day: day.day,
          monthLabel: _month.label,
          onAddTap: _openAddExpense,
        );
      },
    );
  }

  void _changeMonth(int delta) {
    setState(() {
      _monthIndex = (_monthIndex + delta) % CalendarDemoData.months.length;
      if (_monthIndex < 0) {
        _monthIndex = CalendarDemoData.months.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                const TopBrandBar(userName: 'Trang'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 132),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CalendarControls(
                          label: _month.label,
                          gridMode: _gridMode,
                          onPrevious: () => _changeMonth(-1),
                          onNext: () => _changeMonth(1),
                          onGridTap: () => setState(() => _gridMode = true),
                          onListTap: () => setState(() => _gridMode = false),
                        ),
                        const SizedBox(height: 14),
                        const _InteractionTip(),
                        const SizedBox(height: 16),
                        if (_gridMode)
                          _CalendarGrid(
                            month: _month,
                            onTapDay: _showDaySheet,
                            onLongPressDay: _openAddExpense,
                          )
                        else
                          _MonthListView(
                            month: _month,
                            onAddTap: _openAddExpense,
                            onDayTap: _showDaySheet,
                          ),
                        const SizedBox(height: 16),
                        _SummaryRow(month: _month),
                        const SizedBox(height: 20),
                        _MonthTransactionsSection(
                          transactions: _month.monthTransactions,
                          onAddTap: _openAddExpense,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 18,
            bottom: 110,
            child: FloatingActionButton(
              onPressed: _openAddExpense,
              backgroundColor: const Color(0xFF0053DB),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarControls extends StatelessWidget {
  const _CalendarControls({
    required this.label,
    required this.gridMode,
    required this.onPrevious,
    required this.onNext,
    required this.onGridTap,
    required this.onListTap,
  });

  final String label;
  final bool gridMode;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onGridTap;
  final VoidCallback onListTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MonthButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
        const SizedBox(width: 14),
        Text(
          label,
          style: GoogleFonts.manrope(
            color: const Color(0xFF0053DB),
            fontSize: 24,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.6,
          ),
        ),
        const SizedBox(width: 14),
        _MonthButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        const Spacer(),
        _ModeChip(label: 'Lưới', selected: gridMode, onTap: onGridTap),
        const SizedBox(width: 8),
        _ModeChip(label: 'Danh sách', selected: !gridMode, onTap: onListTap),
      ],
    );
  }
}

class _MonthButton extends StatelessWidget {
  const _MonthButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: const Color(0xFF7789BE), size: 18),
      ),
    );
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? const Color(0x1A0053DB) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? const Color(0xFF0053DB) : const Color(0xFF445D99),
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

class _InteractionTip extends StatelessWidget {
  const _InteractionTip();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          size: 14,
          color: Color(0x80445D99),
        ),
        const SizedBox(width: 8),
        Text(
          'CHẠM ĐỂ XEM CHI TIẾT, GIỮ ĐỂ THÊM NHANH',
          style: GoogleFonts.inter(
            color: const Color(0xB3445D99),
            fontSize: 11,
            letterSpacing: 0.275,
          ),
        ),
      ],
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.month,
    required this.onTapDay,
    required this.onLongPressDay,
  });

  final CalendarMonthData month;
  final ValueChanged<CalendarDayData> onTapDay;
  final VoidCallback onLongPressDay;

  @override
  Widget build(BuildContext context) {
    final dayMap = {for (final day in month.days) day.day: day};
    const weekdays = ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFEAEDFF)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 8, 17),
            child: Row(
              children: [
                for (var index = 0; index < weekdays.length; index++)
                  Expanded(
                    child: Center(
                      child: Text(
                        weekdays[index],
                        style: GoogleFonts.inter(
                          color: index == 5
                              ? const Color(0xFF006D4A)
                              : index == 6
                              ? const Color(0xFF9F403D)
                              : const Color(0xFF445D99),
                          fontSize: 10,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 28,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisExtent: 96,
            ),
            itemBuilder: (context, index) {
              final dayNumber = index - month.startOffset + 1;
              if (dayNumber < 1 || dayNumber > month.totalDays) {
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0x4DF2F3FF),
                    border: Border.all(color: const Color(0xFFF2F3FF)),
                  ),
                );
              }
              final details = dayMap[dayNumber];
              return _CalendarCell(
                day: dayNumber,
                details: details,
                isWeekend: index % 7 == 5 || index % 7 == 6,
                onTap: () =>
                    onTapDay(details ?? CalendarDayData(day: dayNumber)),
                onLongPress: onLongPressDay,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CalendarCell extends StatelessWidget {
  const _CalendarCell({
    required this.day,
    required this.details,
    required this.isWeekend,
    required this.onTap,
    required this.onLongPress,
  });

  final int day;
  final CalendarDayData? details;
  final bool isWeekend;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final selected = details?.isSelected ?? false;
    final color = selected
        ? const Color(0xFF0053DB)
        : isWeekend
        ? (day % 7 == 6 ? const Color(0xFF006D4A) : const Color(0xFF9F403D))
        : const Color(0xFF113069);

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 9),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0x0D0053DB)
              : (isWeekend ? const Color(0x33F2F3FF) : Colors.white),
          border: Border.all(
            color: selected ? const Color(0x330053DB) : const Color(0xFFF2F3FF),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '$day',
                  style: GoogleFonts.inter(
                    color: color,
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
                const Spacer(),
                if (details?.hasDot ?? false)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0053DB),
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            const Spacer(),
            if (details?.amountLabel != null)
              Text(
                details!.amountLabel!,
                style: GoogleFonts.inter(
                  color: details!.income
                      ? const Color(0xFF006D4A)
                      : const Color(0xFF9F403D),
                  fontSize: 9,
                ),
              ),
            if (details?.hasNote ?? false)
              const Icon(
                Icons.edit_note_rounded,
                color: Color(0xFF6079B7),
                size: 14,
              ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.month});

  final CalendarMonthData month;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            title: 'Tổng thu',
            value: month.totalIncome,
            color: const Color(0xFF006D4A),
            background: const Color(0x0D006D4A),
            icon: Icons.trending_up_rounded,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _SummaryCard(
            title: 'Tổng chi',
            value: month.totalExpense,
            color: const Color(0xFF9F403D),
            background: const Color(0x0D9F403D),
            icon: Icons.trending_down_rounded,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.value,
    required this.color,
    required this.background,
    required this.icon,
  });

  final String title;
  final String value;
  final Color color;
  final Color background;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 14),
              ),
              const SizedBox(width: 8),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.inter(
                  color: color,
                  fontSize: 10,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthTransactionsSection extends StatelessWidget {
  const _MonthTransactionsSection({
    required this.transactions,
    required this.onAddTap,
  });

  final List<CalendarTransaction> transactions;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Lịch sử trong tháng',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: onAddTap,
                child: Text(
                  'Thêm mới',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          for (var index = 0; index < transactions.length; index++) ...[
            _MonthTransactionRow(transaction: transactions[index]),
            if (index != transactions.length - 1) const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}

class _MonthTransactionRow extends StatelessWidget {
  const _MonthTransactionRow({required this.transaction});

  final CalendarTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: transaction.iconBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(
            transaction.icon,
            color: const Color(0xFF113069),
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                transaction.title,
                style: GoogleFonts.inter(
                  color: const Color(0xFF113069),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                transaction.subtitle.toUpperCase(),
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          transaction.amount,
          style: GoogleFonts.inter(
            color: transaction.positive
                ? const Color(0xFF006D4A)
                : const Color(0xFF9F403D),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _MonthListView extends StatelessWidget {
  const _MonthListView({
    required this.month,
    required this.onAddTap,
    required this.onDayTap,
  });

  final CalendarMonthData month;
  final VoidCallback onAddTap;
  final ValueChanged<CalendarDayData> onDayTap;

  @override
  Widget build(BuildContext context) {
    final grouped = <String, List<CalendarTransaction>>{
      'Đầu tháng': month.monthTransactions.take(2).toList(),
      'Gần đây': month.monthTransactions.skip(2).toList(),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFEAEDFF)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in grouped.entries) ...[
            Text(
              entry.key,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            for (final transaction in entry.value) ...[
              InkWell(
                onTap: () =>
                    onDayTap(const CalendarDayData(day: 6, isSelected: true)),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _MonthTransactionRow(transaction: transaction),
                ),
              ),
            ],
          ],
          const SizedBox(height: 8),
          PrimaryBlueButton(
            label: 'Thêm giao dịch mới',
            onTap: onAddTap,
            icon: Icons.add_rounded,
          ),
        ],
      ),
    );
  }
}

class _DayDetailsSheet extends StatelessWidget {
  const _DayDetailsSheet({required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chi tiết ngày 6 Tháng 4',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Text(
                          'Tổng kết ngày:',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '-10.000 đ',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF9F403D),
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              _SheetCloseButton(onTap: () => Navigator.of(context).pop()),
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0x1A9F403D),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restaurant_rounded,
                    color: Color(0xFF9F403D),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ăn uống',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Tiền mặt',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF445D99),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  '-10.000 đ',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF9F403D),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          PrimaryBlueButton(
            label: 'Thêm giao dịch mới',
            onTap: () {
              Navigator.of(context).pop();
              onAddTap();
            },
            icon: Icons.add_rounded,
          ),
        ],
      ),
    );
  }
}

class _EmptyDaySheet extends StatelessWidget {
  const _EmptyDaySheet({
    required this.day,
    required this.monthLabel,
    required this.onAddTap,
  });

  final int day;
  final String monthLabel;
  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Không có giao dịch trong ngày $day $monthLabel',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _SheetCloseButton(onTap: () => Navigator.of(context).pop()),
            ],
          ),
          const SizedBox(height: 28),
          PrimaryBlueButton(
            label: 'Thêm giao dịch mới',
            onTap: () {
              Navigator.of(context).pop();
              onAddTap();
            },
            icon: Icons.add_rounded,
          ),
        ],
      ),
    );
  }
}

class _SheetFrame extends StatelessWidget {
  const _SheetFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 110),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(28, 18, 28, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1F113069),
                blurRadius: 30,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 41,
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0x33445D99),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 24),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _SheetCloseButton extends StatelessWidget {
  const _SheetCloseButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFD9E2FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.close_rounded, color: Color(0xFF113069)),
      ),
    );
  }
}
