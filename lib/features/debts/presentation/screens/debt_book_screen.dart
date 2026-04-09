import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';
import '../../data/debt_store.dart';
import 'add_debt_screen.dart';
import 'debt_detail_screen.dart';

class DebtBookScreen extends StatefulWidget {
  const DebtBookScreen({super.key});

  @override
  State<DebtBookScreen> createState() => _DebtBookScreenState();
}

class _DebtBookScreenState extends State<DebtBookScreen> {
  DebtType _type = DebtType.lend;

  void _openAddDebt() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => AddDebtScreen(initialType: _type)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: ValueListenableBuilder<List<DebtItem>>(
              valueListenable: DebtStore.instance,
              builder: (context, debts, _) {
                final store = DebtStore.instance;
                final lendOutstanding = store.outstandingFor(DebtType.lend);
                final borrowOutstanding = store.outstandingFor(DebtType.borrow);
                final filtered = debts
                    .where((item) => item.type == _type)
                    .toList();

                return Column(
                  children: [
                    _DebtTopBar(onBack: () => Navigator.of(context).pop()),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(24, 12, 24, 132),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Quản lý dòng tiền vay mượn chuyên\nnghiệp',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF445D99),
                                fontSize: 18,
                                height: 1.55,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _SummaryCard(
                              title: 'Người nợ mình',
                              amount: lendOutstanding,
                              note: '+12% vs m.trước',
                              accent: const Color(0xFF006D4A),
                              background: const Color(0x4D6FFBBE),
                            ),
                            const SizedBox(height: 16),
                            _SummaryCard(
                              title: 'Mình nợ người',
                              amount: borrowOutstanding,
                              note: '-5% vs m.trước',
                              accent: const Color(0xFF9F403D),
                              background: const Color(0x1AFE8983),
                            ),
                            const SizedBox(height: 16),
                            _TypeAndFilterRow(
                              type: _type,
                              onTypeChanged: (value) =>
                                  setState(() => _type = value),
                              onCalendar: () {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Bộ lọc theo ngày chưa hỗ trợ.',
                                      ),
                                    ),
                                  );
                              },
                              onFilter: () {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Bộ lọc đang được hoàn thiện.',
                                      ),
                                    ),
                                  );
                              },
                            ),
                            const SizedBox(height: 16),
                            for (final item in filtered) ...[
                              _DebtListCard(
                                item: item,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DebtDetailScreen(debtId: item.id),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            if (filtered.isEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  'Chưa có khoản nợ nào.',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF6C82B3),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          Positioned(
            right: 18,
            bottom: 92,
            child: FloatingActionButton(
              onPressed: _openAddDebt,
              backgroundColor: const Color(0xFF0053DB),
              elevation: 10,
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

class _DebtTopBar extends StatelessWidget {
  const _DebtTopBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18,
                  color: Color(0xFF113069),
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Sổ nợ',
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
          const Spacer(),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text('Tùy chọn đang được hoàn thiện.'),
                    ),
                  );
              },
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(Icons.more_vert_rounded, color: Color(0xFF113069)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.note,
    required this.accent,
    required this.background,
  });

  final String title;
  final int amount;
  final String note;
  final Color accent;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: accent.withValues(alpha: 0.18)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(Icons.credit_card_rounded, color: accent),
              ),
              const Spacer(),
              Text(
                note,
                style: GoogleFonts.manrope(
                  color: accent,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.inter(
              color: accent,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            formatVnMoney(amount),
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 30,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeAndFilterRow extends StatelessWidget {
  const _TypeAndFilterRow({
    required this.type,
    required this.onTypeChanged,
    required this.onCalendar,
    required this.onFilter,
  });

  final DebtType type;
  final ValueChanged<DebtType> onTypeChanged;
  final VoidCallback onCalendar;
  final VoidCallback onFilter;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
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
                Expanded(
                  child: _MiniTab(
                    label: 'Cho vay',
                    selected: type == DebtType.lend,
                    onTap: () => onTypeChanged(DebtType.lend),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _MiniTab(
                    label: 'Đi vay',
                    selected: type == DebtType.borrow,
                    onTap: () => onTypeChanged(DebtType.borrow),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        _ActionChip(
          icon: Icons.calendar_today_rounded,
          label: 'Theo ngày',
          onTap: onCalendar,
        ),
        const SizedBox(width: 10),
        _ActionChip(
          icon: Icons.filter_alt_outlined,
          label: '',
          onTap: onFilter,
          square: true,
        ),
      ],
    );
  }
}

class _MiniTab extends StatelessWidget {
  const _MiniTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? const Color(0xFFF2F3FF) : Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 42,
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: selected
                    ? const Color(0xFF0053DB)
                    : const Color(0xFF6C82B3),
                fontSize: 13,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ActionChip extends StatelessWidget {
  const _ActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
    this.square = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool square;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 54,
          padding: EdgeInsets.symmetric(horizontal: square ? 0 : 14),
          width: square ? 54 : null,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x1A98B1F2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: const Color(0xFF0053DB), size: 18),
              if (!square) ...[
                const SizedBox(width: 10),
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF113069),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DebtListCard extends StatelessWidget {
  const _DebtListCard({required this.item, required this.onTap});

  final DebtItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initials = item.personName.trim().isEmpty
        ? '?'
        : item.personName.trim().split(' ').take(2).map((w) => w[0]).join();
    final progressPercent = (item.progress * 100).round();
    final statusLabel = item.isSettled ? 'ĐÃ TRẢ' : 'ĐANG NỢ';
    final statusColor = item.isSettled
        ? const Color(0xFF006D4A)
        : item.isOverdue
        ? const Color(0xFF9F403D)
        : const Color(0xFFB45309);
    final statusBackground = statusColor.withValues(alpha: 0.14);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBE1FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        initials.toUpperCase(),
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF0048BF),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                item.personName,
                                style: GoogleFonts.manrope(
                                  color: const Color(0xFF113069),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Text(
                              formatVnMoney(item.amount),
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF0053DB),
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Text(
                              'Hạn: ${formatVnDate(item.dueDate ?? item.loanDate)}',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF445D99),
                                fontSize: 12,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: statusBackground,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                statusLabel,
                                style: GoogleFonts.inter(
                                  color: statusColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Text(
                    'TIẾN ĐỘ THANH TOÁN',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$progressPercent%',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: LinearProgressIndicator(
                  value: item.progress,
                  minHeight: 8,
                  backgroundColor: const Color(0xFFEAEDFF),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    item.isSettled
                        ? const Color(0xFF006D4A)
                        : const Color(0xFF0053DB),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    'Đã trả: ${_compactMoney(item.safePaidAmount)}',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Còn lại: ${_compactMoney(item.remaining)}',
                    style: GoogleFonts.inter(
                      color: item.isSettled
                          ? const Color(0xFF006D4A)
                          : statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _compactMoney(int amount) {
    if (amount >= 1000000) {
      final value = (amount / 1000000);
      return '${value.toStringAsFixed(value >= 10 ? 0 : 1)}M';
    }
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}k';
    }
    return amount.toString();
  }
}
