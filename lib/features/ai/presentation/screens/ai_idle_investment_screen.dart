import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

class AiIdleInvestmentScreen extends StatelessWidget {
  const AiIdleInvestmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                _TopBar(
                  title: 'Đầu tư nhàn rỗi',
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Đầu tư nhàn rỗi',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.9,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Trí tuệ nhân tạo phát hiện số dư chưa được tối ưu hóa trong tài khoản của bạn.',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _InsightCard(
                          onTap: () {
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Đang tối ưu hóa khoản nhàn rỗi...',
                                  ),
                                ),
                              );
                          },
                        ),
                        const SizedBox(height: 26),
                        Row(
                          children: [
                            Text(
                              'Ước tính lợi nhuận',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF113069),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              'DỰA TRÊN 6.0%/NĂM',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF0053DB),
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: const [
                            Expanded(
                              child: _ProfitCard(
                                label: '1 THÁNG',
                                value: '+25,000đ',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _ProfitCard(
                                label: '6 THÁNG',
                                value: '+150,000đ',
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _ProfitCard(
                                label: '12 THÁNG',
                                value: '+300,000đ',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        Text(
                          'Sản phẩm đề xuất',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const _ProductTile(
                          title: 'Tài khoản tích lũy',
                          subtitle: 'Lãi suất 6.0% • Linh hoạt',
                          tag: 'Linh hoạt',
                          tagColor: Color(0xFF0053DB),
                        ),
                        const SizedBox(height: 12),
                        const _ProductTile(
                          title: 'Tiết kiệm kỳ hạn',
                          subtitle: 'Lãi suất 7.5% • Kỳ hạn 6 tháng',
                          tag: 'Trung bình',
                          tagColor: Color(0xFF0053DB),
                        ),
                        const SizedBox(height: 12),
                        const _ProductTile(
                          title: 'Trái phiếu doanh nghiệp',
                          subtitle: 'Lãi suất 9.2% • Kỳ hạn 12 tháng',
                          tag: 'Cố định',
                          tagColor: Color(0xFF625B77),
                        ),
                      ],
                    ),
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

class _TopBar extends StatelessWidget {
  const _TopBar({required this.title, required this.onBack});

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
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
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              title,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: const Color(0xFFDBE1FF),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome_rounded,
                color: Color(0xFF0053DB),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'TRỢ LÝ AI',
                style: GoogleFonts.inter(
                  color: const Color(0xFF0053DB),
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.35,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Bạn đang có 5tr trong ví\nMoMo chưa sinh lời',
            style: GoogleFonts.inter(
              color: const Color(0xFF0048BF),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              style: GoogleFonts.inter(
                color: const Color(0xCC0048BF),
                fontSize: 14,
                height: 1.65,
              ),
              children: [
                const TextSpan(
                  text:
                      'Chuyển ngay vào Tài khoản Tích lũy để\nhưởng lãi suất ',
                ),
                TextSpan(
                  text: '6%/năm',
                  style: GoogleFonts.inter(
                    color: const Color(0xFF0053DB),
                    fontSize: 14,
                    height: 1.65,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const TextSpan(text: ' thay vì để tiền\nnằm yên.'),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0053DB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 10,
                shadowColor: const Color(0x330053DB),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Tối ưu hóa ngay',
                    style: GoogleFonts.inter(
                      color: const Color(0xFFF8F7FF),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFFF8F7FF),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfitCard extends StatelessWidget {
  const _ProfitCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: GoogleFonts.manrope(
              color: const Color(0xFF006D4A),
              fontSize: 18,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductTile extends StatelessWidget {
  const _ProductTile({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagColor,
  });

  final String title;
  final String subtitle;
  final String tag;
  final Color tagColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text('Mở sản phẩm: $title')));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0x4DDFD5F7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.account_balance_rounded,
                  color: Color(0xFF113069),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
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
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    tag,
                    style: GoogleFonts.inter(
                      color: tagColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF6C82B3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
