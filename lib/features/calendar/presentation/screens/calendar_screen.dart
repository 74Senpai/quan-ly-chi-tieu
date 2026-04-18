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
import 'amount_filter_screen.dart';
import 'category_filter_screen.dart';
import 'source_filter_screen.dart';
import 'time_range_filter_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int _monthIndex = 1;
  bool _gridMode = true;
  bool _isFilterApplied = false;

  // Filter values
  String _selectedMonthName = 'Nov 2026';
  List<String> _selectedCategories = ['Ăn Uống'];
  String _selectedAmountRange = '>500k';
  List<String> _selectedSources = [];

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

  Future<void> _showFilterSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _FilterBottomSheet(
        categoryCount: _selectedCategories.length,
        hasTimeFilter: _selectedMonthName.isNotEmpty,
        hasAmountFilter: _selectedAmountRange.isNotEmpty,
        hasSourceFilter: _selectedSources.isNotEmpty,
        selectedCategories: _selectedCategories,
        selectedAmount: _selectedAmountRange,
        selectedSources: _selectedSources,
        selectedMonth: _selectedMonthName,
        onUpdate: (cats, amt, sources, month) {
          setState(() {
            if (cats != null) _selectedCategories = cats;
            if (amt != null) _selectedAmountRange = amt;
            if (sources != null) _selectedSources = sources;
            if (month != null) _selectedMonthName = month;
          });
        },
        onApply: () => setState(() => _isFilterApplied = true),
      ),
    );
  }

  void _clearFilters() {
    setState(() {
      _isFilterApplied = false;
      _selectedCategories = [];
      _selectedAmountRange = '';
      _selectedSources = [];
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
                if (!_isFilterApplied)
                  const TopBrandBar(userName: 'Trang')
                else
                  _AppliedFilterHeader(
                    onBack: _clearFilters,
                    onFilterTap: _showFilterSheet,
                  ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(_isFilterApplied ? 0 : 16, 16, _isFilterApplied ? 0 : 16, 132),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!_isFilterApplied) ...[
                          _CalendarControls(
                            label: _month.label,
                            gridMode: _gridMode,
                            onPrevious: () => _changeMonth(-1),
                            onNext: () => _changeMonth(1),
                            onGridTap: () => setState(() => _gridMode = true),
                            onListTap: () => setState(() => _gridMode = false),
                            onFilterTap: _showFilterSheet,
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
                              onDayTap: _showDaySheet,
                            ),
                          const SizedBox(height: 20),
                          _SummaryRow(month: _month),
                          const SizedBox(height: 24),
                          if (_gridMode)
                            _MonthTransactionsSection(
                              transactions: _month.monthTransactions,
                              onAddTap: _openAddExpense,
                            ),
                        ] else ...[
                          _AppliedFilterContent(
                            month: _selectedMonthName,
                            categories: _selectedCategories,
                            amount: _selectedAmountRange,
                            total: '-812.000đ',
                            count: 3,
                          ),
                          const SizedBox(height: 20),
                          _MonthTransactionsSection(
                            transactions: _month.monthTransactions.take(3).toList(),
                            onAddTap: _openAddExpense,
                          ),
                          const SizedBox(height: 32),
                          Center(
                            child: TextButton.icon(
                              onPressed: _clearFilters,
                              icon: const Icon(Icons.filter_list_off_rounded, color: Color(0xFF0053DB)),
                              label: Text(
                                'Clear Filters',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF0053DB),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: TextButton.styleFrom(
                                backgroundColor: const Color(0xFFF2F3FF),
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                            ),
                          ),
                        ],
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

class _AppliedFilterHeader extends StatelessWidget {
  const _AppliedFilterHeader({required this.onBack, required this.onFilterTap});

  final VoidCallback onBack;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF113069)),
            onPressed: onBack,
          ),
          Text(
            'Lịch sử giao dịch',
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.tune_rounded, color: Color(0xFF0053DB)),
            onPressed: onFilterTap,
          ),
        ],
      ),
    );
  }
}

class _AppliedFilterContent extends StatelessWidget {
  const _AppliedFilterContent({
    required this.month,
    required this.categories,
    required this.amount,
    required this.total,
    required this.count,
  });

  final String month;
  final List<String> categories;
  final String amount;
  final String total;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _FilterChip(icon: Icons.calendar_today_rounded, label: month),
                const SizedBox(width: 8),
                for (var cat in categories) ...[
                  _FilterChip(icon: Icons.restaurant_rounded, label: cat),
                  const SizedBox(width: 8),
                ],
                if (amount.isNotEmpty) _FilterChip(icon: Icons.payments_outlined, label: amount),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tổng giao dịch',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF445D99),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        total,
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Tìm thấy $count giao dịch',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF113069).withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF0053DB)),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF0053DB),
              fontSize: 14,
              fontWeight: FontWeight.w600,
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
    required this.onFilterTap,
  });

  final String label;
  final bool gridMode;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onGridTap;
  final VoidCallback onListTap;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MonthButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.manrope(
            color: const Color(0xFF0053DB),
            fontSize: 20,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(width: 8),
        _MonthButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        const Spacer(),
        _ModeChip(label: 'Lưới', selected: gridMode, onTap: onGridTap),
        const SizedBox(width: 4),
        _ModeChip(label: 'Danh sách', selected: !gridMode, onTap: onListTap),
        const SizedBox(width: 6),
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(8),
          child: const Padding(
            padding: EdgeInsets.all(4),
            child: Icon(
              Icons.filter_list_rounded,
              color: Color(0xFF0053DB),
              size: 24,
            ),
          ),
        ),
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
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3FF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF7789BE), size: 16),
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
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? const Color(0x1A0053DB) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? const Color(0xFF0053DB) : const Color(0xFF445D99),
            fontSize: 11,
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
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title.toUpperCase(),
                style: GoogleFonts.inter(
                  color: color.withValues(alpha: 0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.w800,
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
    required this.onDayTap,
  });

  final CalendarMonthData month;
  final ValueChanged<CalendarDayData> onDayTap;

  @override
  Widget build(BuildContext context) {
    // Generate some demo days to match the screenshot if it's Tháng 4
    final isApril = month.label == 'Tháng 4';
    
    final List<Map<String, dynamic>> displayDays = isApril ? [
      {
        'day': '12',
        'weekday': 'CN',
        'dateLabel': 'Chủ nhật, 12/04',
        'infoLabel': 'Hôm nay',
        'amount': '-420.000đ',
        'positive': false,
      },
      {
        'day': '11',
        'weekday': 'T7',
        'dateLabel': 'Thứ 7, 11/04',
        'infoLabel': '3 giao dịch',
        'amount': '+1.200.000đ',
        'positive': true,
      },
      {
        'day': '10',
        'weekday': 'T6',
        'dateLabel': 'Thứ 6, 10/04',
        'infoLabel': '5 giao dịch',
        'amount': '-10.000đ',
        'positive': false,
      },
      {
        'day': '09',
        'weekday': 'T5',
        'dateLabel': 'Thứ 5, 09/04',
        'infoLabel': '2 giao dịch',
        'amount': '+350.000đ',
        'positive': true,
      },
      {
        'day': '08',
        'weekday': 'T4',
        'dateLabel': 'Thứ 4, 08/04',
        'infoLabel': '0 giao dịch',
        'amount': '0đ',
        'positive': false,
      },
      {
        'day': '07',
        'weekday': 'T3',
        'dateLabel': 'Thứ 3, 07/04',
        'infoLabel': '8 giao dịch',
        'amount': '-2.100.000đ',
        'positive': false,
      },
      {
        'day': '06',
        'weekday': 'T2',
        'dateLabel': 'Thứ 2, 06/04',
        'infoLabel': '1 giao dịch',
        'amount': '+150.000đ',
        'positive': true,
      },
    ] : [];

    if (displayDays.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Không có dữ liệu cho ${month.label}',
            style: GoogleFonts.inter(color: const Color(0xFF445D99)),
          ),
        ),
      );
    }

    return Column(
      children: displayDays.map((d) => InkWell(
        onTap: () => onDayTap(CalendarDayData(day: int.parse(d['day'] as String))),
        child: _DailySummaryCard(
          day: d['day'] as String,
          weekday: d['weekday'] as String,
          dateLabel: d['dateLabel'] as String,
          infoLabel: d['infoLabel'] as String,
          amount: d['amount'] as String,
          positive: d['positive'] as bool,
        ),
      )).toList(),
    );
  }
}

class _DailySummaryCard extends StatelessWidget {
  const _DailySummaryCard({
    required this.day,
    required this.weekday,
    required this.dateLabel,
    required this.infoLabel,
    required this.amount,
    required this.positive,
  });

  final String day;
  final String weekday;
  final String dateLabel;
  final String infoLabel;
  final String amount;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF113069).withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: const Color(0xFFE9EFFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  weekday,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  day,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateLabel,
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  infoLabel,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF7789BE),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                amount,
                style: GoogleFonts.manrope(
                  color: positive ? const Color(0xFF006D4A) : const Color(0xFF9F403D),
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Xem chi tiết',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0053DB),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
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

class _FilterBottomSheet extends StatelessWidget {
  const _FilterBottomSheet({
    this.hasTimeFilter = false,
    this.categoryCount = 0,
    this.hasAmountFilter = false,
    this.hasSourceFilter = false,
    required this.onApply,
    required this.onUpdate,
    this.selectedCategories = const [],
    this.selectedAmount = '',
    this.selectedSources = const [],
    this.selectedMonth = '',
  });

  final bool hasTimeFilter;
  final int categoryCount;
  final bool hasAmountFilter;
  final bool hasSourceFilter;
  final VoidCallback onApply;
  final Function(List<String>?, String?, List<String>?, String?) onUpdate;
  final List<String> selectedCategories;
  final String selectedAmount;
  final List<String> selectedSources;
  final String selectedMonth;

  @override
  Widget build(BuildContext context) {
    return _SheetFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Bộ lọc',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  onUpdate([], '', [], '');
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Đặt lại',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _FilterItem(
            icon: Icons.calendar_today_rounded,
            title: 'Khoảng thời gian',
            subtitle: selectedMonth.isNotEmpty ? selectedMonth : 'Tháng này, Năm nay...',
            selected: selectedMonth.isNotEmpty,
            onTap: () async {
              final result = await Navigator.of(context).push<String>(
                MaterialPageRoute(builder: (_) => const TimeRangeFilterScreen()),
              );
              if (result != null) onUpdate(null, null, null, result);
            },
          ),
          const SizedBox(height: 12),
          _FilterItem(
            icon: Icons.widgets_outlined,
            title: 'Danh mục',
            subtitle: selectedCategories.isNotEmpty ? '${selectedCategories.length} danh mục đã chọn' : 'Ăn uống, Mua sắm, Nhà cửa...',
            selected: selectedCategories.isNotEmpty,
            onTap: () async {
              final result = await Navigator.of(context).push<List<String>>(
                MaterialPageRoute(builder: (_) => CategoryFilterScreen(initialSelected: selectedCategories)),
              );
              if (result != null) onUpdate(result, null, null, null);
            },
          ),
          const SizedBox(height: 12),
          _FilterItem(
            icon: Icons.payments_outlined,
            title: 'Số tiền',
            subtitle: selectedAmount.isNotEmpty ? selectedAmount : 'Dưới 500k, 500k - 2Tr...',
            selected: selectedAmount.isNotEmpty,
            onTap: () async {
              final result = await Navigator.of(context).push<String>(
                MaterialPageRoute(builder: (_) => const AmountFilterScreen()),
              );
              if (result != null) onUpdate(null, result, null, null);
            },
          ),
          const SizedBox(height: 12),
          _FilterItem(
            icon: Icons.account_balance_wallet_outlined,
            title: 'Nguồn tiền',
            subtitle: selectedSources.isNotEmpty ? '${selectedSources.length} nguồn đã chọn' : 'Ví chính, Thẻ tín dụng...',
            selected: selectedSources.isNotEmpty,
            onTap: () async {
              final result = await Navigator.of(context).push<List<String>>(
                MaterialPageRoute(builder: (_) => const SourceFilterScreen()),
              );
              if (result != null) onUpdate(null, null, result, null);
            },
          ),
          const SizedBox(height: 32),
          PrimaryBlueButton(
            label: 'Áp dụng',
            onTap: () {
              onApply();
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

class _FilterItem extends StatelessWidget {
  const _FilterItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF0053DB), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? const Color(0xFF0053DB) : const Color(0xFFD9E2FF),
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0053DB),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
