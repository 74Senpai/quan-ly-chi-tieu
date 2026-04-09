import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/transaction_demo_data.dart';

class TransactionHeader extends StatelessWidget {
  const TransactionHeader({
    super.key,
    required this.title,
    required this.onBack,
    required this.onCancel,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: SizedBox(
        height: 64,
        child: Row(
          children: [
            InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(12),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.close_rounded,
                  color: Color(0xFF113069),
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 18,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.45,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onCancel,
              child: Text(
                'Hủy',
                style: GoogleFonts.manrope(
                  color: const Color(0xFF0053DB),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AmountDisplay extends StatelessWidget {
  const AmountDisplay({super.key, required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    final display = amount.isEmpty ? '0' : amount;
    return Column(
      children: [
        Text(
          'SỐ TIỀN',
          style: GoogleFonts.inter(
            color: const Color(0xFF445D99),
            fontSize: 12,
            letterSpacing: 2.4,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: GoogleFonts.manrope(color: const Color(0xFF113069)),
            children: [
              TextSpan(
                text: display,
                style: const TextStyle(
                  fontSize: 48,
                  height: 1,
                  letterSpacing: -2.4,
                ),
              ),
              const TextSpan(
                text: ' ₫',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFF0053DB),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 48,
          height: 4,
          decoration: BoxDecoration(
            color: const Color(0x330053DB),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}

class DetailCard extends StatelessWidget {
  const DetailCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.onTap,
    this.trailing,
    this.large = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(large ? 24 : 12),
      ),
      child: Row(
        children: [
          Container(
            width: large ? 48 : 40,
            height: large ? 48 : 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF0053DB),
              size: large ? 20 : 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF113069),
                    fontSize: large ? 16 : 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          trailing ??
              const Icon(Icons.chevron_right_rounded, color: Color(0xFF445D99)),
        ],
      ),
    );

    if (onTap == null) return child;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(large ? 24 : 12),
      child: child,
    );
  }
}

class NoteCard extends StatelessWidget {
  const NoteCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'GHI CHÚ (TÙY CHỌN)',
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 10,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: GoogleFonts.inter(
              color: const Color(0x66445D99),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class NumberPad extends StatelessWidget {
  const NumberPad({
    super.key,
    required this.onKeyTap,
    required this.onDeleteTap,
  });

  final ValueChanged<String> onKeyTap;
  final VoidCallback onDeleteTap;

  @override
  Widget build(BuildContext context) {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '000', '0'];
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        for (final key in keys)
          _KeyButton(
            label: key,
            onTap: () => onKeyTap(key),
            highlighted: key == '000',
          ),
        _KeyButton(
          icon: Icons.backspace_outlined,
          onTap: onDeleteTap,
          highlighted: true,
          iconColor: const Color(0xFFB64039),
        ),
      ],
    );
  }
}

class _KeyButton extends StatelessWidget {
  const _KeyButton({
    this.label,
    this.icon,
    required this.onTap,
    this.highlighted = false,
    this.iconColor,
  });

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;
  final bool highlighted;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Ink(
        decoration: BoxDecoration(
          color: highlighted ? const Color(0xFFF2F3FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: label != null
              ? Text(
                  label!,
                  style: GoogleFonts.manrope(
                    color: highlighted
                        ? const Color(0xFF445D99)
                        : const Color(0xFF113069),
                    fontSize: label == '000' ? 20 : 24,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Icon(icon, color: iconColor ?? const Color(0xFF113069)),
        ),
      ),
    );
  }
}

class SaveExpenseButton extends StatelessWidget {
  const SaveExpenseButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF0053DB),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x400053DB),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Lưu giao dịch',
                  style: GoogleFonts.manrope(color: Colors.white, fontSize: 18),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle_outline_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryRow extends StatelessWidget {
  const CategoryRow({
    super.key,
    required this.category,
    this.selected = false,
    this.onTap,
    this.locked = false,
  });

  final ExpenseCategory category;
  final bool selected;
  final VoidCallback? onTap;
  final bool locked;

  @override
  Widget build(BuildContext context) {
    final body = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: locked ? const Color(0x80F2F3FF) : Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: category.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(category.icon, color: const Color(0xFF113069)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Row(
              children: [
                Text(
                  category.name,
                  style: GoogleFonts.manrope(
                    color: locked
                        ? const Color(0x99113069)
                        : const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (locked) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.lock_outline_rounded,
                    size: 14,
                    color: Color(0x66445D99),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: selected
                  ? const Color(0xFF0053DB)
                  : const Color(0xFFE2E7FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${category.count}',
              style: GoogleFonts.inter(
                color: selected ? Colors.white : const Color(0xFF445D99),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return body;
    return InkWell(onTap: onTap, child: body);
  }
}
