class FieldData {
  const FieldData({required this.label, required this.value});

  final String label;
  final String value;
}

class ReceiptItemData {
  const ReceiptItemData({
    required this.title,
    required this.category,
    required this.price,
  });

  final String title;
  final String category;
  final String price;
}

class AiDemoData {
  const AiDemoData._();

  static const assistantGreeting =
      'Xin chào, tôi là trợ lý AI quản lý chi tiêu, tôi có thể giúp gì cho bạn ?';
  static const voiceTranscript = 'Ăn trưa 50k bằng ví tiền mặt';
  static const voiceConfirmation =
      'Đã hiểu! Tôi đã ghi nhận 50,000₫ cho mục Ăn uống từ Ví tiền mặt.';
  static const receiptSummary =
      'Tôi đã ghi nhận hóa đơn 458.000VND và cập nhật vào khoản chi các danh mục sau:\n• Ăn Uống: 272.000VND\n• Đồ gia dụng: 165.000VND';

  static const voiceFields = [
    FieldData(label: 'Số tiền', value: '50,000₫'),
    FieldData(label: 'Hạng mục', value: 'Ăn uống'),
    FieldData(label: 'Ví thanh toán', value: 'Tiền mặt'),
  ];

  static const ocrFields = [
    FieldData(label: 'Số tiền', value: '458.000₫'),
    FieldData(label: 'Hạng mục', value: 'Ăn uống, Đồ gia dụng'),
    FieldData(label: 'Ví thanh toán', value: 'Tiền mặt'),
  ];

  static const ocrItems = [
    ReceiptItemData(
      title: 'Sữa tươi TH True Milk (1L)',
      category: 'Thực phẩm & Đồ uống',
      price: '32.000',
    ),
    ReceiptItemData(
      title: 'Bánh mì hoa cúc Harrys',
      category: 'Thực phẩm & Đồ uống',
      price: '125.000',
    ),
    ReceiptItemData(
      title: 'Dầu ăn Simply 2L',
      category: 'Gia vị & Nấu ăn',
      price: '115.000',
    ),
    ReceiptItemData(
      title: 'Bột giặt Ariel 3.5kg',
      category: 'Đồ gia dụng',
      price: '165.000',
    ),
  ];
}
