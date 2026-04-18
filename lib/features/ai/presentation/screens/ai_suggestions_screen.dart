import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../budgets/presentation/screens/budget_overview_screen.dart';
import '../../../home/presentation/widgets/home_components.dart';
import 'ai_bill_alert_screen.dart';
import 'ai_idle_investment_screen.dart';
import 'ai_food_optimization_screen.dart';

class AiSuggestionsScreen extends StatelessWidget {
  const AiSuggestionsScreen({super.key});

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
                  title: 'Gợi ý AI',
                  onBack: () => Navigator.of(context).pop(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Gợi ý AI',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF113069),
                            fontSize: 56,
                            height: 1,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -2.8,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Trợ lý tài chính thông minh của bạn',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 22),
                        _SmartAnalysisHero(
                          onTap: () {
                            Navigator.of(context).push(
                              buildFadeSlideRoute(
                                const AiIdleInvestmentScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 26),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Lời khuyên cho bạn',
                                style: GoogleFonts.manrope(
                                  color: const Color(0xFF113069),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Đang hiển thị tất cả lời khuyên.',
                                      ),
                                    ),
                                  );
                              },
                              child: Text(
                                'Xem tất cả',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF0053DB),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _SuggestionCard(
                          iconBackground: const Color(0xFFFFEDD5),
                          icon: Icons.restaurant_rounded,
                          title: 'Tối ưu hóa ăn uống',
                          description:
                              'Bạn đã chi nhiều hơn 15% cho ăn uống tuần qua. Thử nấu ăn tại nhà?',
                          highlightText: '15%',
                          onTap: () {
                            Navigator.of(context).push(
                              buildFadeSlideRoute(
                                const AiFoodOptimizationScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _SuggestionCard(
                          iconBackground: const Color(0xFFDBE1FF),
                          icon: Icons.trending_up_rounded,
                          title: 'Đầu tư nhàn rỗi',
                          description:
                              'Bạn đang có 5tr trong ví MoMo chưa sinh lời. Tối ưu hóa để hưởng 6%/năm.',
                          highlightText: '6%/năm',
                          onTap: () {
                            Navigator.of(context).push(
                              buildFadeSlideRoute(
                                const AiIdleInvestmentScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _SuggestionCard(
                          iconBackground: const Color(0x33FE8983),
                          icon: Icons.warning_amber_rounded,
                          title: 'Cảnh báo hóa đơn',
                          description:
                              'Dự báo chi phí điện tháng tới tăng 20% dựa trên số liệu lịch sử.',
                          highlightText: '20%',
                          onTap: () {
                            Navigator.of(context).push(
                              buildFadeSlideRoute(const AiBillAlertScreen()),
                            );
                          },
                        ),
                        const SizedBox(height: 22),
                        _QuickActionCard(
                          title: 'Đặt giới hạn chi tiêu',
                          subtitle:
                              'Thiết lập hạn mức để AI nhắc nhở đúng lúc.',
                          buttonLabel: 'Mở hạn mức ngân sách',
                          onTap: () {
                            Navigator.of(context).push(
                              buildFadeSlideRoute(const BudgetOverviewScreen()),
                            );
                          },
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
                color: const Color(0xFF0F172A),
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

class _SmartAnalysisHero extends StatelessWidget {
  const _SmartAnalysisHero({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(32),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(32),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0053DB), Color(0xFF0048C1)],
            ),
            borderRadius: BorderRadius.circular(32),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 50,
                offset: Offset(0, 25),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -48,
                top: -48,
                child: Container(
                  width: 192,
                  height: 192,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Positioned(
                left: -48,
                bottom: -48,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBE1FF).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'PHÂN TÍCH THÔNG MINH',
                      style: GoogleFonts.inter(
                        color: const Color(0xFFF8F7FF),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text.rich(
                    TextSpan(
                      style: GoogleFonts.manrope(
                        color: const Color(0xFFF8F7FF),
                        fontSize: 30,
                        height: 1.35,
                        fontWeight: FontWeight.w300,
                      ),
                      children: [
                        const TextSpan(text: 'Bạn có thể tiết kiệm\nthêm '),
                        TextSpan(
                          text: '1.2tr',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFFF8F7FF),
                            fontSize: 30,
                            height: 1.35,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const TextSpan(text: ' tháng\nnày'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Dựa trên xu hướng chi tiêu 14 ngày qua của bạn.',
                    style: GoogleFonts.inter(
                      color: const Color(0xCCF8F7FF),
                      fontSize: 14,
                      height: 1.45,
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
}

class _SuggestionCard extends StatelessWidget {
  const _SuggestionCard({
    required this.iconBackground,
    required this.icon,
    required this.title,
    required this.description,
    required this.highlightText,
    required this.onTap,
  });

  final Color iconBackground;
  final IconData icon;
  final String title;
  final String description;
  final String highlightText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final highlightIndex = description.indexOf(highlightText);
    final spans = <TextSpan>[];
    if (highlightIndex >= 0) {
      spans.add(TextSpan(text: description.substring(0, highlightIndex)));
      spans.add(
        TextSpan(
          text: highlightText,
          style: GoogleFonts.inter(
            color: const Color(0xFF9F403D),
            fontSize: 13,
            height: 1.45,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
      spans.add(
        TextSpan(
          text: description.substring(highlightIndex + highlightText.length),
        ),
      );
    } else {
      spans.add(TextSpan(text: description));
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
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
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconBackground,
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
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        style: GoogleFonts.inter(
                          color: const Color(0xFF445D99),
                          fontSize: 13,
                          height: 1.45,
                        ),
                        children: spans,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1A98B1F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 13,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: onTap,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF0053DB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                buttonLabel,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: GoogleFonts.inter(
                  color: const Color(0xFFF8F7FF),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
