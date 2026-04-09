class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.descriptionLines,
    required this.buttonText,
    required this.progressIndex,
  });

  final String title;
  final List<String> descriptionLines;
  final String buttonText;
  final int progressIndex;
}

class HomeDemoData {
  const HomeDemoData._();

  static const splashTitle = 'Wallet Manager';
  static const splashSubtitle = 'YOUR DIGITAL PRIVATE BANK';
  static const splashLoadingLabel = 'SECURING WORKSPACE';

  static const offlinePage = OnboardingPageData(
    title: 'Vua Chi Tiêu',
    descriptionLines: [
      'Dữ liệu của bạn luôn an toàn',
      'ngay cả khi không có kết nối',
      'mạng.',
    ],
    buttonText: 'Tiếp tục',
    progressIndex: 0,
  );

  static const calendarPage = OnboardingPageData(
    title: 'Lịch & Biểu đồ Thông\nminh',
    descriptionLines: [
      'Kiểm soát dòng tiền và chi tiêu qua',
      'giao diện lịch trực quan.',
    ],
    buttonText: 'Tiếp tục',
    progressIndex: 1,
  );

  static const aiPage = OnboardingPageData(
    title: 'Trợ lý AI Thông minh',
    descriptionLines: [
      'Nhập liệu bằng giọng nói nhanh',
      'chóng và nhận phân tích tài chính',
      'thông minh.',
    ],
    buttonText: 'Khám phá ngay',
    progressIndex: 2,
  );
}
