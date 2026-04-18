import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../home/presentation/widgets/home_components.dart';

class CategoryFilterScreen extends StatefulWidget {
  final List<String> initialSelected;
  const CategoryFilterScreen({super.key, this.initialSelected = const []});

  @override
  State<CategoryFilterScreen> createState() => _CategoryFilterScreenState();
}

class _CategoryFilterScreenState extends State<CategoryFilterScreen> {
  bool _isExpense = true;
  late final Set<String> _selectedCategories;

  @override
  void initState() {
    super.initState();
    _selectedCategories = Set.from(widget.initialSelected);
  }

  final _expenseCategories = [
    _CategoryItemData('Ăn uống', 'Nhà hàng, Cà phê, Siêu thị', Icons.fastfood_rounded, const Color(0xFFFFEDD5)),
    _CategoryItemData('Di chuyển', 'Xăng xe, Grab, Bảo dưỡng', Icons.directions_car_rounded, const Color(0xFFD9E2FF)),
    _CategoryItemData('Mua sắm', 'Quần áo, Đồ điện tử, Mỹ phẩm', Icons.shopping_bag_rounded, const Color(0xFFFCE7F3)),
    _CategoryItemData('Nhà cửa', 'Tiền thuê, Điện nước, Nội thất', Icons.home_rounded, const Color(0xFFDBEAFE)),
    _CategoryItemData('Giải trí', 'Xem phim, Du lịch, Concert', Icons.videogame_asset_rounded, const Color(0xFFF3E8FF)),
    _CategoryItemData('Hạng mục khác', 'Các chi phí không định danh', Icons.widgets_rounded, const Color(0xFFE0E7FF)),
  ];

  final _incomeCategories = [
    _CategoryItemData('Lương', '1 giao dịch trong tháng', Icons.payments_rounded, const Color(0xFFD1FAE5)),
    _CategoryItemData('Thưởng', '0 giao dịch', Icons.card_giftcard_rounded, const Color(0xFFF3E8FF)),
    _CategoryItemData('Đầu tư', '3 giao dịch trong tháng', Icons.trending_up_rounded, const Color(0xFFDBEAFE)),
  ];

  List<_CategoryItemData> get _currentList => _isExpense ? _expenseCategories : _incomeCategories;

  void _toggleCategory(String name) {
    setState(() {
      if (_selectedCategories.contains(name)) {
        _selectedCategories.remove(name);
      } else {
        _selectedCategories.add(name);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF113069)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Lọc theo Danh mục',
          style: GoogleFonts.manrope(
            color: const Color(0xFF113069),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Color(0xFF113069)),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm hạng mục chi tiêu...',
                    hintStyle: GoogleFonts.inter(color: const Color(0xFF445D99).withValues(alpha: 0.5)),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF445D99)),
                    filled: true,
                    fillColor: const Color(0xFFE2E7FF).withValues(alpha: 0.5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _TabButton(
                          label: 'Chi tiêu',
                          selected: _isExpense,
                          onTap: () => setState(() => _isExpense = true),
                        ),
                      ),
                      Expanded(
                        child: _TabButton(
                          label: 'Thu nhập',
                          selected: !_isExpense,
                          onTap: () => setState(() => _isExpense = false),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text(
                      'Tất cả danh mục',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.done_all, size: 18, color: Color(0xFF0053DB)),
                      label: Text(
                        'Chọn tất cả',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF0053DB),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 120),
                  itemCount: _currentList.length,
                  itemBuilder: (context, index) {
                    final item = _currentList[index];
                    final selected = _selectedCategories.contains(item.name);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _toggleCategory(item.name),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF2F3FF).withValues(alpha: 0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected ? const Color(0xFF0053DB) : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: item.color,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Icon(item.icon, color: const Color(0xFF113069)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: GoogleFonts.manrope(
                                        color: const Color(0xFF113069),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      item.subtitle,
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
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: selected ? const Color(0xFF0053DB) : const Color(0xFFD9E2FF),
                                    width: 2,
                                  ),
                                  color: selected ? const Color(0xFF0053DB) : Colors.transparent,
                                ),
                                child: selected ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 32,
            child: PrimaryBlueButton(
              label: 'Áp dụng bộ lọc',
              onTap: () => Navigator.of(context).pop(_selectedCategories.toList()),
              icon: Icons.filter_list_rounded,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF113069).withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.inter(
            color: selected ? const Color(0xFF0053DB) : const Color(0xFF445D99),
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _CategoryItemData {
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;

  _CategoryItemData(this.name, this.subtitle, this.icon, this.color);
}
