import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_assets.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../data/ai_demo_data.dart';
import '../widgets/assistant_components.dart';
import 'camera_capture_demo_screen.dart';
import 'ocr_confirmation_screen.dart';

class OcrResultScreen extends StatelessWidget {
  const OcrResultScreen({super.key});

  void _showDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              AppAssets.receiptPreview,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                color: Colors.white,
                padding: const EdgeInsets.all(24),
                child: const Text('Không tải được ảnh hóa đơn.'),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AppBackground()),
          SafeArea(
            child: Column(
              children: [
                const AssistantHeader(title: 'Trợ lý AI'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.receipt_long_rounded,
                              color: Color(0xFF445D99),
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Kết quả quét OCR',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF445D99),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tổng cộng chi tiêu',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 6),
                        RichText(
                          text: TextSpan(
                            style: GoogleFonts.manrope(
                              color: const Color(0xFF113069),
                            ),
                            children: const [
                              TextSpan(
                                text: '458.000',
                                style: TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -2.4,
                                  height: 1,
                                ),
                              ),
                              TextSpan(
                                text: ' VND',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0x99113069),
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0x4D6FFBBE),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0x1A006D4A)),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Color(0xFF005E3F),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Đã xác minh chính xác',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF005E3F),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: cardDecoration(),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  20,
                                  18,
                                  20,
                                  16,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Danh sách chi tiết',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF113069),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '6 MẶT HÀNG',
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF6079B7),
                                        fontSize: 12,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(
                                height: 1,
                                color: Color(0xFFF2F3FF),
                              ),
                              for (final item in AiDemoData.ocrItems)
                                ReceiptItem(item: item),
                              InkWell(
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Thêm thủ công chưa được dựng trong demo này.',
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(18),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.add_circle_outline_rounded,
                                        color: Color(0xFF0053DB),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Thêm mặt hàng thủ công',
                                        style: GoogleFonts.inter(
                                          color: const Color(0xFF0053DB),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F3FF),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0x1A98B1F2)),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'ẢNH HÓA ĐƠN GỐC',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF6079B7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () => _showDialog(context),
                                    child: const Text('Phóng to'),
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 320,
                                      width: double.infinity,
                                      child: Image.network(
                                        AppAssets.receiptPreview,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, _, _) =>
                                            const ColoredBox(
                                              color: Color(0xFFEAEFFF),
                                              child: SizedBox.expand(),
                                            ),
                                      ),
                                    ),
                                    Container(
                                      width: 86,
                                      height: 86,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: const Icon(
                                        Icons.document_scanner_rounded,
                                        color: Color(0xFF0053DB),
                                        size: 34,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              buildFadeSlideRoute(
                                const OcrConfirmationScreen(),
                              ),
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF0053DB),
                            minimumSize: const Size.fromHeight(56),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Xác nhận',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              buildFadeSlideRoute(
                                const CameraCaptureDemoScreen(),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(56),
                            side: const BorderSide(color: Color(0xFF6079B7)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Hủy & Quét lại',
                            style: GoogleFonts.inter(
                              color: const Color(0xFF113069),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAEFFF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Thời gian quét:',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF445D99),
                                  fontSize: 14,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '14:32, 24/05/2024',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFF113069),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
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
