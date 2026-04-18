import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../ai/presentation/screens/ai_suggestions_screen.dart';
import '../../../budgets/data/budget_demo_data.dart' as budgets;
import '../../../budgets/presentation/screens/budget_overview_screen.dart';
import '../../../forecast/presentation/screens/financial_forecast_screen.dart';
import '../../../cashflow/presentation/screens/cashflow_overview_screen.dart';
import '../../../investment/presentation/screens/investment_overview_screen.dart';
import '../../../savings/presentation/screens/savings_goals_screen.dart';
import '../../../tax/presentation/screens/tax_overview_screen.dart';
import '../../../debts/presentation/screens/debt_book_screen.dart';
import '../../../transactions/presentation/screens/add_expense_screen.dart';
import '../../../transactions/presentation/screens/income_expense_report_screen.dart';
import '../../../transactions/presentation/screens/spending_structure_screen.dart';
import '../widgets/home_components.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  Future<void> _openAddExpense(BuildContext context) async {
    final saved = await Navigator.of(
      context,
    ).push<bool>(MaterialPageRoute(builder: (_) => const AddExpenseScreen()));
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('Giao dịch đã được lưu vào ví chính.')),
        );
    }
  }

  void _openBudgets(BuildContext context) {
    Navigator.of(
      context,
    ).push(buildFadeSlideRoute(const BudgetOverviewScreen()));
  }

  void _showComingSoon(BuildContext context, String featureName) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$featureName đang được hoàn thiện.')),
      );
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
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 132),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BalanceHero(onAddTap: () => _openAddExpense(context)),
                        const SizedBox(height: 20),
                        const _WeeklyOverviewCard(),
                        const SizedBox(height: 20),
                        _BudgetDashboardSection(
                          onTap: () => _openBudgets(context),
                        ),
                        const SizedBox(height: 20),
                        const _AnalyticsGrid(),
                        const SizedBox(height: 20),
                        _SectionHeader(
                          title: 'Giao dịch gần đây',
                          actionLabel: 'Thêm chi tiêu',
                          onTap: () => _openAddExpense(context),
                        ),
                        const SizedBox(height: 12),
                        const _RecentTransactionsCard(),
                        const SizedBox(height: 20),
                        _FeatureMenuSection(
                          items: [
                            _FeatureMenuItem(
                              title: 'Thu Chi',
                              subtitle:
                                  'Biến động dòng tiền, theo dõi giao dịch.',
                              icon: Icons.account_balance_wallet_outlined,
                              iconBackground: const Color(0xFFE0EAFF),
                              iconForeground: const Color(0xFF0053DB),
                              onTap: () {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(
                                    const IncomeExpenseReportScreen(),
                                  ),
                                );
                              },
                            ),
                            _FeatureMenuItem(
                              title: 'Cơ cấu',
                              subtitle: 'Tỉ lệ chi tiêu theo danh mục.',
                              icon: Icons.pie_chart_outline_rounded,
                              iconBackground: const Color(0xFFDDFBE8),
                              iconForeground: const Color(0xFF0C8A5D),
                              onTap: () {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(
                                    const SpendingStructureScreen(),
                                  ),
                                );
                              },
                            ),
                            _FeatureMenuItem(
                              title: 'Gợi ý AI',
                              subtitle:
                                  'Tư vấn và nhắc nhở chi tiêu thông minh.',
                              icon: Icons.auto_awesome_outlined,
                              iconBackground: const Color(0xFFF3E8FF),
                              iconForeground: const Color(0xFF6D28D9),
                              onTap: () {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(
                                    const AiSuggestionsScreen(),
                                  ),
                                );
                              },
                            ),
                            _FeatureMenuItem(
                              title: 'Tích lũy',
                              subtitle: 'Theo dõi mục tiêu tiết kiệm.',
                              icon: Icons.savings_outlined,
                              iconBackground: const Color(0xFFFFEDD5),
                              iconForeground: const Color(0xFFB45309),
                              onTap: () {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(
                                    const SavingsGoalsScreen(),
                                  ),
                                );
                              },
                            ),
                            _FeatureMenuItem(
                              title: 'Dự báo',
                              subtitle: 'Dự báo tài chính 6 tháng tới.',
                              icon: Icons.show_chart_rounded,
                              iconBackground: const Color(0xFFDBE1FF),
                              iconForeground: const Color(0xFF113069),
                              onTap: () {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(
                                    const FinancialForecastScreen(),
                                  ),
                                );
                              },
                            ),
                            _FeatureMenuItem(
                              title: 'Sổ Nợ',
                              subtitle: 'Quản lý các khoản vay, nợ.',
                              icon: Icons.receipt_long_outlined,
                              iconBackground: const Color(0xFFFFE4E6),
                              iconForeground: const Color(0xFF9F403D),
                              onTap: () {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(const DebtBookScreen()),
                                );
                              },
                            ),
                            _FeatureMenuItem(
                              title: 'Hạn mức',
                              subtitle: 'Quản lý hạn mức chi tiêu.',
                              icon: Icons.tune_rounded,
                              iconBackground: const Color(0xFFE2E7FF),
                              iconForeground: const Color(0xFF113069),
                              onTap: () => _openBudgets(context),
                            ),
                            _FeatureMenuItem(
                              title: 'Dòng tiền',
                              subtitle: 'Phân tích tiền mặt và thanh khoản.',
                              icon: Icons.waterfall_chart_rounded,
                              iconBackground: const Color(0xFFE9E1FF),
                              iconForeground: const Color(0xFF5B43A8),
                              onTap: () {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(
                                    const CashFlowOverviewScreen(),
                                  ),
                                );
                              },
                            ),
                            _FeatureMenuItem(
                              title: 'Đối soát',
                              subtitle: 'Kiểm tra sai lệch giữa các tài khoản.',
                              icon: Icons.compare_arrows_rounded,
                              iconBackground: const Color(0xFFDFE8FF),
                              iconForeground: const Color(0xFF315AA9),
                              onTap: () => _showComingSoon(context, 'Đối soát'),
                            ),
                            _FeatureMenuItem(
                              title: 'Thuế',
                              subtitle: 'Dự toán và báo cáo quyết toán.',
                              icon: Icons.receipt_outlined,
                              iconBackground: const Color(0xFFE9E1FF),
                              iconForeground: const Color(0xFF6D4ACF),
                              onTap: () {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(
                                    const TaxOverviewScreen(),
                                  ),
                                );
                              },
                            ),
                            _FeatureMenuItem(
                              title: 'Đầu tư',
                              subtitle: 'Hiệu suất danh mục tài sản.',
                              icon: Icons.candlestick_chart_rounded,
                              iconBackground: const Color(0xFFE1EAFF),
                              iconForeground: const Color(0xFF1E4E9D),
                              onTap: () {
                                Navigator.of(context).push(
                                  buildFadeSlideRoute(
                                    const InvestmentOverviewScreen(),
                                  ),
                                );
                              },
                            ),
                          ],
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
              onPressed: () => _openAddExpense(context),
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

class _FeatureMenuItem {
  const _FeatureMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackground,
    required this.iconForeground,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackground;
  final Color iconForeground;
  final VoidCallback onTap;
}

class _FeatureMenuSection extends StatelessWidget {
  const _FeatureMenuSection({required this.items});

  final List<_FeatureMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _FeatureMenuTile(item: items[index]),
          if (index != items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _FeatureMenuTile extends StatelessWidget {
  const _FeatureMenuTile({required this.item});

  final _FeatureMenuItem item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: item.onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A113069),
                blurRadius: 18,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.iconBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(item.icon, color: item.iconForeground, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6C82B3),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF6C82B3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _BalanceHero extends StatelessWidget {
  const _BalanceHero({required this.onAddTap});

  final VoidCallback onAddTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0053DB), Color(0xFF0E67F2)],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330053DB),
            blurRadius: 28,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tổng số dư',
                    style: GoogleFonts.inter(
                      color: const Color(0xCCFFFFFF),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '42.500.000₫',
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -1.2,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.trending_up_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '+12.4%',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: const [
              Expanded(
                child: _PocketStat(
                  title: 'Tiền mặt',
                  value: '2.500.000₫',
                  icon: Icons.account_balance_wallet_outlined,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _PocketStat(
                  title: 'Ngân hàng',
                  value: '40.000.000₫',
                  icon: Icons.account_balance_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onAddTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.3),
                    ),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: Text(
                    'Thêm chi tiêu',
                    style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    'Tháng 4, 2026',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PocketStat extends StatelessWidget {
  const _PocketStat({
    required this.title,
    required this.value,
    required this.icon,
  });

  final String title;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.88),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyOverviewCard extends StatelessWidget {
  const _WeeklyOverviewCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Chi tiêu tuần này',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '7 ngày',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '8.450.000₫',
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tăng 6.2% so với tuần trước',
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                _WeekBar(
                  day: 'Mon',
                  amount: '620K',
                  height: 48,
                  color: Color(0x400053DB),
                ),
                _WeekBar(
                  day: 'Tue',
                  amount: '1.8M',
                  height: 128,
                  color: Color(0xA30053DB),
                ),
                _WeekBar(
                  day: 'Wed',
                  amount: '1.2M',
                  height: 92,
                  color: Color(0x6E0053DB),
                ),
                _WeekBar(
                  day: 'Thu',
                  amount: '2.1M',
                  height: 152,
                  color: Color(0xFF0053DB),
                ),
                _WeekBar(
                  day: 'Fri',
                  amount: '1.4M',
                  height: 112,
                  color: Color(0x990053DB),
                ),
                _WeekBar(
                  day: 'Sat',
                  amount: '950K',
                  height: 74,
                  color: Color(0x5C0053DB),
                ),
                _WeekBar(
                  day: 'Sun',
                  amount: '380K',
                  height: 36,
                  color: Color(0x330053DB),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeekBar extends StatelessWidget {
  const _WeekBar({
    required this.day,
    required this.amount,
    required this.height,
    required this.color,
  });

  final String day;
  final String amount;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              amount,
              style: GoogleFonts.inter(
                color: const Color(0xFF6C82B3),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              height: height,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              day,
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BudgetDashboardSection extends StatelessWidget {
  const _BudgetDashboardSection({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<budgets.BudgetLimit>>(
      valueListenable: budgets.BudgetStore.instance,
      builder: (context, budgetItems, _) {
        final store = budgets.BudgetStore.instance;
        final highlighted = budgetItems.take(3).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionHeader(
              title: 'Hạn mức ngân sách',
              actionLabel: 'Xem tất cả',
              onTap: onTap,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(32),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0053DB), Color(0xFF0048C1)],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x290053DB),
                      blurRadius: 24,
                      offset: Offset(0, 14),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'TỔNG NGÂN SÁCH',
                                style: GoogleFonts.inter(
                                  color: const Color(0xCCF8F7FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                budgets.formatCurrency(store.totalBudget),
                                style: GoogleFonts.manrope(
                                  color: const Color(0xFFF8F7FF),
                                  fontSize: 28,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.9,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${(store.overallProgress * 100).round()}%',
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Đã chi: ${budgets.formatCurrency(store.totalSpent)}',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Còn lại: ${budgets.formatCurrency(store.totalRemaining)}',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF6FFBBE),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: store.overallProgress.clamp(0.0, 1.0),
                        minHeight: 8,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(
                          Color(0xFF6FFBBE),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    for (
                      var index = 0;
                      index < highlighted.length;
                      index++
                    ) ...[
                      _BudgetSnapshotRow(budget: highlighted[index]),
                      if (index != highlighted.length - 1)
                        const SizedBox(height: 12),
                    ],
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BudgetSnapshotRow extends StatelessWidget {
  const _BudgetSnapshotRow({required this.budget});

  final budgets.BudgetLimit budget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(budget.template.icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                budget.template.name,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${budget.usagePercent}% • ${budgets.formatCurrency(budget.limitAmount)}',
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
        Text(
          budgets.formatCurrency(math.max(0, budget.remainingAmount)),
          style: GoogleFonts.inter(
            color: const Color(0xFF6FFBBE),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AnalyticsGrid extends StatelessWidget {
  const _AnalyticsGrid();

  @override
  Widget build(BuildContext context) {
    const items = [
      (
        title: 'Tháng này',
        value: '18.2M₫',
        caption: 'Chiếm 43% tổng thu nhập',
        color: Color(0xFFDBE1FF),
        icon: Icons.payments_outlined,
      ),
      (
        title: 'Tiết kiệm',
        value: '9.8M₫',
        caption: 'Đã đạt 81% mục tiêu tháng',
        color: Color(0xFFDDFBE8),
        icon: Icons.savings_outlined,
      ),
      (
        title: 'Ăn uống',
        value: '3.4M₫',
        caption: 'Danh mục chi cao nhất',
        color: Color(0xFFFFEDD5),
        icon: Icons.restaurant_rounded,
      ),
      (
        title: 'AI nhắc nhở',
        value: '02',
        caption: 'Gợi ý tối ưu ngân sách',
        color: Color(0xFFF3E8FF),
        icon: Icons.auto_awesome_outlined,
      ),
    ];

    return Column(
      children: [
        for (var row = 0; row < 2; row++)
          Padding(
            padding: EdgeInsets.only(bottom: row == 0 ? 12 : 0),
            child: Row(
              children: [
                for (var column = 0; column < 2; column++) ...[
                  Expanded(
                    child: _AnalyticsCard(
                      title: items[row * 2 + column].title,
                      value: items[row * 2 + column].value,
                      caption: items[row * 2 + column].caption,
                      color: items[row * 2 + column].color,
                      icon: items[row * 2 + column].icon,
                    ),
                  ),
                  if (column == 0) const SizedBox(width: 12),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.caption,
    required this.color,
    required this.icon,
  });

  final String title;
  final String value;
  final String caption;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1498B1F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF113069)),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 22,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            caption,
            style: GoogleFonts.inter(
              color: const Color(0xFF6C82B3),
              fontSize: 12,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onTap,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: GoogleFonts.manrope(
            color: const Color(0xFF113069),
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionLabel,
            style: GoogleFonts.inter(
              color: const Color(0xFF0053DB),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _RecentTransactionsCard extends StatelessWidget {
  const _RecentTransactionsCard();

  @override
  Widget build(BuildContext context) {
    const transactions = [
      (
        title: 'Bún bò trưa',
        category: 'Ăn uống',
        amount: '-85.000₫',
        time: 'Hôm nay • 12:45',
        background: Color(0xFFFFEDD5),
        icon: Icons.restaurant_rounded,
      ),
      (
        title: 'Đổ xăng',
        category: 'Di chuyển',
        amount: '-120.000₫',
        time: 'Hôm nay • 08:10',
        background: Color(0xFFD9E2FF),
        icon: Icons.local_gas_station_outlined,
      ),
      (
        title: 'Lương tháng 4',
        category: 'Thu nhập',
        amount: '+25.000.000₫',
        time: '08/04 • 09:00',
        background: Color(0xFFDDFBE8),
        icon: Icons.payments_outlined,
      ),
      (
        title: 'Mua đồ gia dụng',
        category: 'Mua sắm',
        amount: '-640.000₫',
        time: '07/04 • 20:21',
        background: Color(0xFFFCE7F3),
        icon: Icons.shopping_bag_outlined,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F113069),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          for (var index = 0; index < transactions.length; index++) ...[
            _TransactionRow(
              title: transactions[index].title,
              category: transactions[index].category,
              amount: transactions[index].amount,
              time: transactions[index].time,
              background: transactions[index].background,
              icon: transactions[index].icon,
            ),
            if (index != transactions.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(height: 1, color: Color(0x1498B1F2)),
              ),
          ],
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({
    required this.title,
    required this.category,
    required this.amount,
    required this.time,
    required this.background,
    required this.icon,
  });

  final String title;
  final String category;
  final String amount;
  final String time;
  final Color background;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final positive = amount.startsWith('+');
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: const Color(0xFF113069)),
        ),
        const SizedBox(width: 14),
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
                '$category • $time',
                style: GoogleFonts.inter(
                  color: const Color(0xFF6C82B3),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          amount,
          style: GoogleFonts.manrope(
            color: positive ? const Color(0xFF0C8A5D) : const Color(0xFF113069),
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
