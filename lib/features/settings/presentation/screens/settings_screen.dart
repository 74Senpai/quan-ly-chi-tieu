import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../ai/presentation/screens/assistant_landing_screen.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';
import '../../../home/presentation/screens/dashboard_screen.dart';
import '../../../home/presentation/widgets/home_components.dart';
import '../../../wallets/presentation/screens/wallets_screen.dart';
import '../../data/settings_demo_data.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, this.initialState});

  final SettingsStateData? initialState;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late SettingsStateData _settings;
  late List<ManagedCategory> _expenseCategories;
  late List<ManagedCategory> _incomeCategories;

  @override
  void initState() {
    super.initState();
    _settings = widget.initialState ?? SettingsDemoData.initial();
    _expenseCategories = SettingsDemoData.initialExpenseCategories();
    _incomeCategories = SettingsDemoData.initialIncomeCategories();
  }

  Future<void> _openGeneralSettings() async {
    final result = await Navigator.of(context).push<SettingsStateData>(
      buildFadeSlideRoute(GeneralSettingsScreen(settings: _settings)),
    );
    if (result != null && mounted) {
      setState(() => _settings = result);
    }
  }

  Future<void> _openSecuritySettings() async {
    final result = await Navigator.of(context).push<SettingsStateData>(
      buildFadeSlideRoute(SecuritySettingsScreen(settings: _settings)),
    );
    if (result != null && mounted) {
      setState(() => _settings = result);
    }
  }

  Future<void> _openCategoryManager() async {
    final result = await Navigator.of(context).push<CategoryManagerResult>(
      buildFadeSlideRoute(
        CategoryManagerScreen(
          expenseCategories: _expenseCategories,
          incomeCategories: _incomeCategories,
        ),
      ),
    );
    if (result != null && mounted) {
      setState(() {
        _expenseCategories = result.expenseCategories;
        _incomeCategories = result.incomeCategories;
      });
    }
  }

  void _showPlaceholderMessage(String label) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('$label đang ở chế độ demo giao diện.')),
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
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Row(
                    children: [
                      Text(
                        'Settings',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9E2FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.more_vert_rounded,
                          color: Color(0xFF6079B7),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 132),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SettingsProfileCard(settings: _settings),
                        const SizedBox(height: 24),
                        _SettingsSection(
                          title: 'Tùy chỉnh ứng dụng',
                          children: [
                            _SettingsRow(
                              icon: Icons.tune_rounded,
                              title: 'Cài đặt chung',
                              subtitle:
                                  '${_settings.language.label} • ${_settings.currency}',
                              color: const Color(0xFFE2E7FF),
                              onTap: _openGeneralSettings,
                            ),
                            _SettingsRow(
                              icon: Icons.grid_view_rounded,
                              title: 'Quản lý Danh mục',
                              subtitle:
                                  '${_expenseCategories.length + _incomeCategories.length} danh mục • thêm và xóa',
                              color: const Color(0xFFE9F8EF),
                              onTap: _openCategoryManager,
                            ),
                            _SettingsRow(
                              icon: Icons.auto_awesome_mosaic_rounded,
                              title: 'Giao diện',
                              subtitle: 'Theme sáng, mật độ hiển thị',
                              color: const Color(0xFFFFF2D9),
                              onTap: () => _showPlaceholderMessage('Giao diện'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _SettingsSection(
                          title: 'Bảo mật & dữ liệu',
                          children: [
                            _SettingsRow(
                              icon: Icons.shield_outlined,
                              title: 'Bảo mật',
                              subtitle: _settings.hasPin
                                  ? 'PIN đã bật • ${_settings.autoLockLabel}'
                                  : 'Thiết lập mã PIN và khóa ứng dụng',
                              color: const Color(0xFFDBE1FF),
                              onTap: _openSecuritySettings,
                            ),
                            _SettingsRow(
                              icon: Icons.cloud_sync_outlined,
                              title: 'Sao lưu & Khôi phục',
                              subtitle: 'Google Drive, iCloud, xuất dữ liệu',
                              color: const Color(0xFFE8EDFF),
                              onTap: () => _showPlaceholderMessage(
                                'Sao lưu & Khôi phục',
                              ),
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
        ],
      ),
    );
  }
}

class CategoryEditorResult {
  const CategoryEditorResult({this.category, this.deleteId});

  final ManagedCategory? category;
  final String? deleteId;
}

class CategoryEditorScreen extends StatefulWidget {
  const CategoryEditorScreen({
    super.key,
    required this.initialType,
    this.category,
  });

  final ManagedCategoryType initialType;
  final ManagedCategory? category;

  @override
  State<CategoryEditorScreen> createState() => _CategoryEditorScreenState();
}

class _CategoryEditorScreenState extends State<CategoryEditorScreen> {
  late ManagedCategoryType _type;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  late String _emoji;
  late Color _color;

  bool get _isEditing => widget.category != null;

  @override
  void initState() {
    super.initState();
    _type = widget.category?.type ?? widget.initialType;
    _emoji = widget.category?.emoji ?? SettingsDemoData.iconChoices.first;
    _color = _resolveBaseColor(
      widget.category?.color ?? SettingsDemoData.colorChoices.first,
    );
    _nameController.text = widget.category?.name ?? '';
    _limitController.text = widget.category?.monthlyLimit?.toString() ?? '';
    _nameController.addListener(() => setState(() {}));
    _limitController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  int? get _monthlyLimit {
    final cleaned = _limitController.text.replaceAll('.', '').trim();
    return cleaned.isEmpty ? null : int.tryParse(cleaned);
  }

  String get _namePreview => _nameController.text.trim().isEmpty
      ? 'Tên danh mục'
      : _nameController.text.trim();

  Color _resolveBaseColor(Color source) {
    for (final option in SettingsDemoData.colorChoices) {
      if (option.toARGB32() == source.toARGB32()) {
        return option;
      }
    }
    return Color(source.toARGB32());
  }

  void _submit() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập tên danh mục trước khi lưu.')),
      );
      return;
    }
    Navigator.of(context).pop(
      CategoryEditorResult(
        category: ManagedCategory(
          id:
              widget.category?.id ??
              '${_type.name}-${DateTime.now().millisecondsSinceEpoch}',
          name: _nameController.text.trim(),
          emoji: _emoji,
          count: widget.category?.count ?? 0,
          color: _color.withValues(alpha: 0.18),
          type: _type,
          monthlyLimit: _type == ManagedCategoryType.expense
              ? _monthlyLimit
              : null,
          locked: widget.category?.locked ?? false,
        ),
      ),
    );
  }

  Future<void> _deleteCategory() async {
    if (widget.category == null || widget.category!.locked) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          'Xóa danh mục?',
          style: GoogleFonts.manrope(fontWeight: FontWeight.w800),
        ),
        content: Text(
          'Danh mục "${widget.category!.name}" sẽ bị xóa khỏi danh sách demo.',
          style: GoogleFonts.inter(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Hủy', style: GoogleFonts.manrope()),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFF43F5E),
            ),
            child: Text('Xóa', style: GoogleFonts.manrope()),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.of(
        context,
      ).pop(CategoryEditorResult(deleteId: widget.category!.id));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF0053DB),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        _isEditing ? 'Edit Category' : 'Thêm danh mục',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      if (_isEditing)
                        TextButton(
                          onPressed: _submit,
                          child: Text(
                            'Save',
                            style: GoogleFonts.manrope(
                              color: const Color(0xFF2563EB),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_isEditing)
                          _EditPreviewCard(
                            emoji: _emoji,
                            name: _namePreview,
                            color: _color,
                          )
                        else
                          _AddPreviewCard(
                            emoji: _emoji,
                            name: _namePreview,
                            type: _type,
                            color: _color,
                            monthlyLimit: _monthlyLimit,
                          ),
                        const SizedBox(height: 32),
                        _InputLabel(
                          label: 'Tên danh mục',
                          trailing:
                              '${_nameController.text.characters.length}/20',
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          maxLength: 20,
                          decoration: _editorInputDecoration(
                            hint: 'Ví dụ: Ăn uống, Di chuyển...',
                          ).copyWith(counterText: ''),
                        ),
                        if (!_isEditing) ...[
                          const SizedBox(height: 24),
                          _InputLabel(label: 'Loại danh mục'),
                          const SizedBox(height: 8),
                          Row(
                            children: ManagedCategoryType.values.map((type) {
                              final active = type == _type;
                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    right: type == ManagedCategoryType.expense
                                        ? 8
                                        : 0,
                                  ),
                                  child: InkWell(
                                    onTap: () => setState(() => _type = type),
                                    borderRadius: BorderRadius.circular(14),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: active
                                            ? const Color(0xFF0053DB)
                                            : const Color(0xFFF2F3FF),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Text(
                                        type.label,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.inter(
                                          color: active
                                              ? Colors.white
                                              : const Color(0xFF445D99),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                        const SizedBox(height: 24),
                        _InputLabel(label: 'Chọn biểu tượng'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: SettingsDemoData.iconChoices.map((emoji) {
                            final active = emoji == _emoji;
                            return InkWell(
                              onTap: () => setState(() => _emoji = emoji),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F3FF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: active
                                      ? Border.all(
                                          color: const Color(0xFF002BFF),
                                        )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 26),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        _InputLabel(
                          label: _isEditing ? 'Chọn màu sắc' : 'Bảng màu nền',
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: SettingsDemoData.colorChoices.map((color) {
                            final active = color == _color;
                            return InkWell(
                              onTap: () => setState(() => _color = color),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: active
                                      ? const [
                                          BoxShadow(
                                            color: Colors.white,
                                            spreadRadius: 2,
                                          ),
                                          BoxShadow(
                                            color: Color(0x332563EB),
                                            spreadRadius: 6,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        if (_type == ManagedCategoryType.expense) ...[
                          const SizedBox(height: 24),
                          _InputLabel(label: 'Hạn mức ngân sách (tùy chọn)'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _limitController,
                            keyboardType: TextInputType.number,
                            decoration: _editorInputDecoration(
                              hint: 'Nhập số tiền',
                              suffix: '/ tháng',
                            ),
                          ),
                        ],
                        if (_isEditing &&
                            widget.category != null &&
                            !widget.category!.locked) ...[
                          const SizedBox(height: 28),
                          Center(
                            child: FilledButton.icon(
                              onPressed: _deleteCategory,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFF43F5E),
                                foregroundColor: Colors.black,
                                minimumSize: const Size(220, 46),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(23),
                                ),
                              ),
                              icon: const Icon(
                                Icons.delete_outline_rounded,
                                size: 18,
                              ),
                              label: Text(
                                'Xóa danh mục',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    0,
                    24,
                    MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 32,
                  ),
                  child: PrimaryBlueButton(
                    label: _isEditing ? 'Lưu thay đổi' : 'Thêm Danh mục',
                    onTap: _submit,
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

class _AddPreviewCard extends StatelessWidget {
  const _AddPreviewCard({
    required this.emoji,
    required this.name,
    required this.type,
    required this.color,
    this.monthlyLimit,
  });

  final String emoji;
  final String name;
  final ManagedCategoryType type;
  final Color color;
  final int? monthlyLimit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THẺ XEM TRƯỚC',
          style: GoogleFonts.inter(
            color: const Color(0xFF7C95C8),
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: const Color(0x1498B1F2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F113069),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      type.label,
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '0 ₫',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF0053DB),
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Hạn mức: ${monthlyLimit ?? '--'}',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _EditPreviewCard extends StatelessWidget {
  const _EditPreviewCard({
    required this.emoji,
    required this.name,
    required this.color,
  });

  final String emoji;
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A113069),
            blurRadius: 40,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 36)),
          ),
          const SizedBox(height: 16),
          Text(
            'PREVIEW',
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 16,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: GoogleFonts.manrope(
              color: const Color(0xFF113069),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class GeneralSettingsScreen extends StatefulWidget {
  const GeneralSettingsScreen({super.key, required this.settings});

  final SettingsStateData settings;

  @override
  State<GeneralSettingsScreen> createState() => _GeneralSettingsScreenState();
}

class _GeneralSettingsScreenState extends State<GeneralSettingsScreen> {
  late SettingsStateData _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  Future<void> _openLanguagePicker() async {
    final result = await Navigator.of(context).push<AppLanguage>(
      buildFadeSlideRoute(LanguageSettingsScreen(current: _settings.language)),
    );
    if (result != null) {
      setState(() => _settings = _settings.copyWith(language: result));
    }
  }

  Future<void> _pickCurrency() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChoiceSheet<String>(
        title: 'Chọn tiền tệ',
        values: SettingsDemoData.currencies,
        selected: _settings.currency,
        labelBuilder: (value) => value,
      ),
    );
    if (result != null) {
      setState(() => _settings = _settings.copyWith(currency: result));
    }
  }

  Future<void> _pickDecimals() async {
    final result = await showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChoiceSheet<int>(
        title: 'Số chữ số thập phân',
        values: SettingsDemoData.decimalOptions,
        selected: _settings.decimals,
        labelBuilder: (value) => '$value chữ số',
      ),
    );
    if (result != null) {
      setState(() => _settings = _settings.copyWith(decimals: result));
    }
  }

  void _saveAndClose() {
    Navigator.of(context).pop(_settings);
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Cài đặt chung',
      onBack: _saveAndClose,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 132),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cài đặt chung',
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            _SettingsCard(
              child: Column(
                children: [
                  _SettingsRow(
                    icon: Icons.language_rounded,
                    title: 'Ngôn ngữ',
                    subtitle: _settings.language.label,
                    color: const Color(0xFFE2E7FF),
                    onTap: _openLanguagePicker,
                  ),
                  const SizedBox(height: 12),
                  _SettingsRow(
                    icon: Icons.currency_exchange_rounded,
                    title: 'Tiền tệ',
                    subtitle: _settings.currency,
                    color: const Color(0xFFE8EDFF),
                    onTap: _pickCurrency,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SettingsCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Định dạng ngày',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: DateFormatOption.values.map((option) {
                      final active = option == _settings.dateFormat;
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                            right: option == DateFormatOption.ddmmyyyy ? 8 : 0,
                          ),
                          child: InkWell(
                            onTap: () => setState(
                              () => _settings = _settings.copyWith(
                                dateFormat: option,
                              ),
                            ),
                            borderRadius: BorderRadius.circular(14),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 220),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: active
                                    ? const Color(0xFF0053DB)
                                    : const Color(0xFFF2F3FF),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                option.label,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  color: active
                                      ? Colors.white
                                      : const Color(0xFF445D99),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SettingsCard(
              child: Column(
                children: [
                  _ToggleTile(
                    title: 'Hiện số dư',
                    subtitle: 'Cho phép dashboard hiển thị số dư tổng',
                    value: _settings.showBalance,
                    onChanged: (value) => setState(
                      () => _settings = _settings.copyWith(showBalance: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ToggleTile(
                    title: 'Làm tròn số',
                    subtitle: 'Hiển thị giá trị gọn hơn trong báo cáo',
                    value: _settings.roundNumbers,
                    onChanged: (value) => setState(
                      () => _settings = _settings.copyWith(roundNumbers: value),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingsRow(
                    icon: Icons.pin_outlined,
                    title: 'Số lẻ hiển thị',
                    subtitle: '${_settings.decimals} chữ số',
                    color: const Color(0xFFD9E2FF),
                    onTap: _pickDecimals,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF113069),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.tips_and_updates_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Ngôn ngữ và định dạng sẽ áp dụng ngay cho toàn bộ giao diện demo.',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key, required this.settings});

  final SettingsStateData settings;

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  late SettingsStateData _settings;

  @override
  void initState() {
    super.initState();
    _settings = widget.settings;
  }

  Future<void> _openPinSetup() async {
    final result = await Navigator.of(context).push<SettingsStateData>(
      buildFadeSlideRoute(PinSetupScreen(settings: _settings)),
    );
    if (result != null && mounted) {
      setState(() => _settings = result);
    }
  }

  Future<void> _pickAutoLock() async {
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _ChoiceSheet<String>(
        title: 'Khóa tự động',
        values: SettingsDemoData.autoLockOptions,
        selected: _settings.autoLockLabel,
        labelBuilder: (value) => value,
      ),
    );
    if (result != null) {
      setState(() => _settings = _settings.copyWith(autoLockLabel: result));
    }
  }

  void _saveAndClose() {
    Navigator.of(context).pop(_settings);
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Bảo mật',
      onBack: _saveAndClose,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 132),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0053DB), Color(0xFF327AF0)],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.shield_moon_outlined,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bảo vệ ứng dụng',
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'PIN và sinh trắc học giúp khóa dữ liệu chi tiêu cá nhân.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SettingsCard(
              child: Column(
                children: [
                  _ToggleTile(
                    title: 'Khóa ứng dụng',
                    subtitle: 'Yêu cầu xác thực khi mở app',
                    value: _settings.appLockEnabled,
                    onChanged: (value) => setState(
                      () => _settings = _settings.copyWith(
                        appLockEnabled: value,
                        biometricEnabled: value
                            ? _settings.biometricEnabled
                            : false,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingsRow(
                    icon: Icons.pin_outlined,
                    title: 'Mã PIN',
                    subtitle: _settings.hasPin ? 'Đã thiết lập' : 'Thiết lập',
                    color: const Color(0xFFDBE1FF),
                    onTap: _openPinSetup,
                  ),
                  const SizedBox(height: 12),
                  _ToggleTile(
                    title: 'Face ID / Touch ID',
                    subtitle: 'Mở khóa nhanh bằng sinh trắc học',
                    value: _settings.biometricEnabled,
                    onChanged: _settings.appLockEnabled
                        ? (value) => setState(
                            () => _settings = _settings.copyWith(
                              biometricEnabled: value,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  _SettingsRow(
                    icon: Icons.lock_clock_outlined,
                    title: 'Khóa tự động',
                    subtitle: _settings.autoLockLabel,
                    color: const Color(0xFFE2E7FF),
                    onTap: _pickAutoLock,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _SettingsCard(
              child: Column(
                children: [
                  _ToggleTile(
                    title: 'Ẩn số dư khi khóa',
                    subtitle: 'Che số dư trên màn hình khóa và đa nhiệm',
                    value: _settings.hideBalanceWhenLocked,
                    onChanged: (value) => setState(
                      () => _settings = _settings.copyWith(
                        hideBalanceWhenLocked: value,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _ToggleTile(
                    title: 'Ẩn thông báo nhạy cảm',
                    subtitle: 'Không hiện số tiền trong thông báo nhắc nhở',
                    value: _settings.hideSensitiveNotifications,
                    onChanged: (value) => setState(
                      () => _settings = _settings.copyWith(
                        hideSensitiveNotifications: value,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3FF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.verified_user_outlined,
                      color: Color(0xFF0053DB),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Mã PIN, khóa ứng dụng và thông báo riêng tư đang là ba lớp bảo mật chính cho bản demo này.',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 13,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key, required this.current});

  final AppLanguage current;

  @override
  State<LanguageSettingsScreen> createState() => _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  late AppLanguage _selected;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selected = widget.current;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<AppLanguage> get _languages {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) {
      return AppLanguage.values;
    }
    return AppLanguage.values.where((language) {
      return language.label.toLowerCase().contains(query) ||
          language.subtitle.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Cài đặt chung',
      onBack: () => Navigator.of(context).pop(_selected),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ngôn ngữ',
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 48,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: -2.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Chọn ngôn ngữ hiển thị ưu tiên của bạn.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6079B7),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    controller: _searchController,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm ngôn ngữ...',
                      hintStyle: GoogleFonts.inter(
                        color: const Color(0x996079B7),
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Color(0xFF6079B7),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFE2E7FF),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                  ),
                  const SizedBox(height: 24),
                  for (final language in _languages) ...[
                    _LanguageRow(
                      language: language,
                      selected: language == _selected,
                      onTap: () => setState(() => _selected = language),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(24, 0, 24, 120),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF113069),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4D113069),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.restart_alt_rounded,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Khởi động lại app để áp dụng toàn bộ ngôn ngữ demo.',
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(_selected),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF113069),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Áp dụng',
                    style: GoogleFonts.inter(fontWeight: FontWeight.w700),
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

class PinSetupScreen extends StatefulWidget {
  const PinSetupScreen({super.key, required this.settings});

  final SettingsStateData settings;

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String _pin = '';
  bool _submitting = false;

  void _appendDigit(String digit) {
    if (_pin.length >= 6 || _submitting) {
      return;
    }
    setState(() => _pin += digit);
    if (_pin.length == 6) {
      _completePin();
    }
  }

  void _removeDigit() {
    if (_pin.isEmpty || _submitting) {
      return;
    }
    setState(() => _pin = _pin.substring(0, _pin.length - 1));
  }

  Future<void> _completePin() async {
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 550));
    if (!mounted) {
      return;
    }
    final updated = widget.settings.copyWith(
      pinCode: _pin,
      appLockEnabled: true,
    );
    final result = await Navigator.of(context).push<SettingsStateData>(
      buildFadeSlideRoute(PinSuccessScreen(settings: updated)),
    );
    if (result != null && mounted) {
      Navigator.of(context).pop(result);
    } else if (mounted) {
      setState(() {
        _submitting = false;
        _pin = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(widget.settings),
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF0053DB),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Thiết lập PIN',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Nhập mã PIN mới',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48),
                  child: Text(
                    'Mã PIN gồm 6 chữ số để bảo vệ dữ liệu chi tiêu của bạn.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF6079B7),
                      fontSize: 15,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(6, (index) {
                    final active = index < _pin.length;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: active
                            ? const Color(0xFF0053DB)
                            : const Color(0xFFD9E2FF),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                ),
                if (_submitting) ...[
                  const SizedBox(height: 20),
                  const CircularProgressIndicator(
                    color: Color(0xFF0053DB),
                    strokeWidth: 3,
                  ),
                ],
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 110),
                  child: Column(
                    children: [
                      for (final row in const [
                        ['1', '2', '3'],
                        ['4', '5', '6'],
                        ['7', '8', '9'],
                      ]) ...[
                        Row(
                          children: [
                            for (final digit in row)
                              Expanded(
                                child: _PinKey(
                                  label: digit,
                                  onTap: () => _appendDigit(digit),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                      Row(
                        children: [
                          const Expanded(child: SizedBox()),
                          Expanded(
                            child: _PinKey(
                              label: '0',
                              onTap: () => _appendDigit('0'),
                            ),
                          ),
                          Expanded(
                            child: _PinKey(
                              icon: Icons.backspace_outlined,
                              onTap: _removeDigit,
                            ),
                          ),
                        ],
                      ),
                    ],
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

class PinSuccessScreen extends StatefulWidget {
  const PinSuccessScreen({super.key, required this.settings});

  final SettingsStateData settings;

  @override
  State<PinSuccessScreen> createState() => _PinSuccessScreenState();
}

class _PinSuccessScreenState extends State<PinSuccessScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 2), _finish);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _finish() {
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop(widget.settings);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6FFBBE),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x29006D4A),
                        blurRadius: 30,
                        offset: Offset(0, 16),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF006D4A),
                    size: 56,
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Mã PIN đã được thiết lập',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: Text(
                    'Tài khoản của bạn hiện đã được bảo mật. Bạn sẽ quay lại cài đặt trong giây lát.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.security_rounded,
                          color: Color(0xFF0053DB),
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bảo mật cấp độ cao',
                              style: GoogleFonts.manrope(
                                color: const Color(0xFF113069),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Mã hóa 256-bit AES đã kích hoạt',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF445D99),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: PrimaryBlueButton(
                    label: 'Về trang Bảo mật',
                    onTap: _finish,
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

class CategoryManagerScreen extends StatefulWidget {
  const CategoryManagerScreen({
    super.key,
    required this.expenseCategories,
    required this.incomeCategories,
  });

  final List<ManagedCategory> expenseCategories;
  final List<ManagedCategory> incomeCategories;

  @override
  State<CategoryManagerScreen> createState() => _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends State<CategoryManagerScreen> {
  late List<ManagedCategory> _expenseCategories;
  late List<ManagedCategory> _incomeCategories;
  ManagedCategoryType _activeType = ManagedCategoryType.expense;

  @override
  void initState() {
    super.initState();
    _expenseCategories = List.of(widget.expenseCategories);
    _incomeCategories = List.of(widget.incomeCategories);
  }

  List<ManagedCategory> get _activeCategories =>
      _activeType == ManagedCategoryType.expense
      ? _expenseCategories
      : _incomeCategories;

  String get _sectionTitle => _activeType == ManagedCategoryType.expense
      ? 'Tất cả danh mục'
      : 'Danh mục thu nhập';

  String? get _sectionSubtitle => _activeType == ManagedCategoryType.expense
      ? null
      : 'Theo dõi và tùy chỉnh các nguồn thu của bạn để quản lý dòng tiền hiệu quả hơn.';

  Future<void> _openAddCategory() async {
    final result = await Navigator.of(context).push<CategoryEditorResult>(
      buildFadeSlideRoute(CategoryEditorScreen(initialType: _activeType)),
    );
    if (result == null || result.category == null || !mounted) {
      return;
    }
    setState(() {
      final category = result.category!;
      final target = category.type == ManagedCategoryType.expense
          ? _expenseCategories
          : _incomeCategories;
      target.insert(0, category);
      _activeType = category.type;
    });
  }

  Future<void> _openEditCategory(ManagedCategory category) async {
    final result = await Navigator.of(context).push<CategoryEditorResult>(
      buildFadeSlideRoute(
        CategoryEditorScreen(initialType: category.type, category: category),
      ),
    );
    if (result == null || !mounted) {
      return;
    }
    setState(() {
      final target = category.type == ManagedCategoryType.expense
          ? _expenseCategories
          : _incomeCategories;
      if (result.deleteId != null) {
        target.removeWhere((item) => item.id == result.deleteId);
        return;
      }
      if (result.category == null) {
        return;
      }
      final index = target.indexWhere((item) => item.id == result.category!.id);
      if (index >= 0) {
        target[index] = result.category!;
      }
    });
  }

  Future<void> _confirmDelete(ManagedCategory category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0x33FE8983),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFF9F403D),
                size: 28,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Xóa danh mục?',
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Danh mục "${category.name}" sẽ bị gỡ khỏi danh sách quản lý demo.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 14,
                height: 1.55,
              ),
            ),
          ],
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Hủy',
              style: GoogleFonts.manrope(
                color: const Color(0xFF445D99),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF9F403D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: Text(
              'Xóa',
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      setState(() {
        final target = category.type == ManagedCategoryType.expense
            ? _expenseCategories
            : _incomeCategories;
        target.removeWhere((item) => item.id == category.id);
      });
    }
  }

  void _closeWithResult() {
    Navigator.of(context).pop(
      CategoryManagerResult(
        expenseCategories: _expenseCategories,
        incomeCategories: _incomeCategories,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _SettingsScaffold(
      title: 'Quản lý Danh mục',
      onBack: _closeWithResult,
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: ManagedCategoryType.values.map((type) {
                      final active = type == _activeType;
                      return Expanded(
                        child: InkWell(
                          onTap: () => setState(() => _activeType = type),
                          borderRadius: BorderRadius.circular(12),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 220),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: active ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: active
                                  ? const [
                                      BoxShadow(
                                        color: Color(0x0D000000),
                                        blurRadius: 2,
                                        offset: Offset(0, 1),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              type.label,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                color: active
                                    ? const Color(0xFF0053DB)
                                    : const Color(0xFF445D99),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      _sectionTitle,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: _activeType == ManagedCategoryType.expense
                            ? 24
                            : 30,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    if (_activeType == ManagedCategoryType.expense)
                      Text(
                        '${_activeCategories.length} DANH MỤC',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF445D99),
                          fontSize: 12,
                          letterSpacing: 1.2,
                        ),
                      ),
                  ],
                ),
                if (_sectionSubtitle != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _sectionSubtitle!,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                for (final category in _activeCategories) ...[
                  _ManagedCategoryTile(
                    category: category,
                    mode: _activeType == ManagedCategoryType.expense
                        ? CategoryTileAction.delete
                        : CategoryTileAction.edit,
                    onTap: () => _openEditCategory(category),
                    onAction: category.locked
                        ? null
                        : () => _activeType == ManagedCategoryType.expense
                              ? _confirmDelete(category)
                              : _openEditCategory(category),
                  ),
                  const SizedBox(height: 16),
                ],
                if (_activeType == ManagedCategoryType.expense)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDBE1FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mẹo nhỏ',
                                style: GoogleFonts.manrope(
                                  color: const Color(0xFF0048BF),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Phân loại giao dịch chính xác giúp bạn theo dõi chi tiêu hiệu quả hơn 25% mỗi tháng.',
                                style: GoogleFonts.inter(
                                  color: const Color(0xCC0048BF),
                                  fontSize: 14,
                                  height: 1.6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.lightbulb_outline_rounded,
                          color: Color(0xFF0053DB),
                          size: 34,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            bottom: 116,
            child: FloatingActionButton(
              onPressed: _openAddCategory,
              backgroundColor: const Color(0xFF0053DB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
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

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key, required this.initialType});

  final ManagedCategoryType initialType;

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  late ManagedCategoryType _type;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  late String _emoji;
  late Color _color;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _emoji = SettingsDemoData.iconChoices.first;
    _color = SettingsDemoData.colorChoices.first;
    _nameController.addListener(() => setState(() {}));
    _limitController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  int? get _monthlyLimit {
    final cleaned = _limitController.text.replaceAll('.', '').trim();
    return cleaned.isEmpty ? null : int.tryParse(cleaned);
  }

  String get _namePreview => _nameController.text.trim().isEmpty
      ? 'Tên danh mục'
      : _nameController.text.trim();

  void _submit() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nhập tên danh mục trước khi lưu.')),
      );
      return;
    }
    Navigator.of(context).pop(
      ManagedCategory(
        id: '${_type.name}-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        emoji: _emoji,
        count: 0,
        color: _color.withValues(alpha: 0.18),
        type: _type,
        monthlyLimit: _monthlyLimit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF0053DB),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Thêm danh mục',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'THẺ XEM TRƯỚC',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF7C95C8),
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(color: const Color(0x1498B1F2)),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x0F113069),
                                blurRadius: 30,
                                offset: Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: _color.withValues(alpha: 0.18),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  _emoji,
                                  style: const TextStyle(fontSize: 28),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _namePreview,
                                      style: GoogleFonts.manrope(
                                        color: const Color(0xFF113069),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      _type.label,
                                      style: GoogleFonts.inter(
                                        color: const Color(0xFF445D99),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '0 ₫',
                                    style: GoogleFonts.manrope(
                                      color: const Color(0xFF0053DB),
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Hạn mức: ${_monthlyLimit ?? '--'}',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF445D99),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        _InputLabel(
                          label: 'Tên danh mục',
                          trailing:
                              '${_nameController.text.characters.length}/20',
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _nameController,
                          maxLength: 20,
                          decoration: _editorInputDecoration(
                            hint: 'Ví dụ: Ăn uống, Di chuyển...',
                          ).copyWith(counterText: ''),
                        ),
                        const SizedBox(height: 24),
                        _InputLabel(label: 'Loại danh mục'),
                        const SizedBox(height: 8),
                        Row(
                          children: ManagedCategoryType.values.map((type) {
                            final active = type == _type;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: type == ManagedCategoryType.expense
                                      ? 8
                                      : 0,
                                ),
                                child: InkWell(
                                  onTap: () => setState(() => _type = type),
                                  borderRadius: BorderRadius.circular(14),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 14,
                                    ),
                                    decoration: BoxDecoration(
                                      color: active
                                          ? const Color(0xFF0053DB)
                                          : const Color(0xFFF2F3FF),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Text(
                                      type.label,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.inter(
                                        color: active
                                            ? Colors.white
                                            : const Color(0xFF445D99),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        _InputLabel(label: 'Chọn biểu tượng'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: SettingsDemoData.iconChoices.map((emoji) {
                            final active = emoji == _emoji;
                            return InkWell(
                              onTap: () => setState(() => _emoji = emoji),
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF2F3FF),
                                  borderRadius: BorderRadius.circular(16),
                                  border: active
                                      ? Border.all(
                                          color: const Color(0xFF002BFF),
                                        )
                                      : null,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  emoji,
                                  style: const TextStyle(fontSize: 26),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        _InputLabel(label: 'Bảng màu nền'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: SettingsDemoData.colorChoices.map((color) {
                            final active = color == _color;
                            return InkWell(
                              onTap: () => setState(() => _color = color),
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 42,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: active
                                      ? const [
                                          BoxShadow(
                                            color: Color(0xFFFFFFFF),
                                            spreadRadius: 2,
                                          ),
                                          BoxShadow(
                                            color: Color(0x332563EB),
                                            spreadRadius: 6,
                                          ),
                                        ]
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        _InputLabel(label: 'Hạn mức ngân sách (tùy chọn)'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _limitController,
                          keyboardType: TextInputType.number,
                          decoration: _editorInputDecoration(
                            hint: 'Nhập số tiền',
                            suffix: '/ tháng',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    24,
                    0,
                    24,
                    MediaQuery.of(context).viewInsets.bottom > 0 ? 16 : 32,
                  ),
                  child: PrimaryBlueButton(
                    label: 'Thêm Danh mục',
                    onTap: _submit,
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

class _SettingsScaffold extends StatelessWidget {
  const _SettingsScaffold({
    required this.title,
    required this.child,
    required this.onBack,
  });

  final String title;
  final Widget child;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: Stack(
        children: [
          const Positioned.fill(child: HomeBackground()),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: onBack,
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                          child: Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF0053DB),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.more_vert_rounded,
                          color: Color(0xFF6079B7),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: child),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: HomeBottomNavigation(
              activeTab: HomeTab.settings,
              onDashboardTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  buildFadeSlideRoute(const DashboardScreen()),
                  (_) => false,
                );
              },
              onCalendarTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  buildFadeSlideRoute(const CalendarScreen()),
                  (_) => false,
                );
              },
              onWalletsTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  buildFadeSlideRoute(const WalletsScreen()),
                  (_) => false,
                );
              },
              onAiTap: () {
                Navigator.of(
                  context,
                ).push(buildFadeSlideRoute(const AssistantLandingScreen()));
              },
            ),
          ),
        ],
      ),
    );
  }
}

enum CategoryTileAction { delete, edit }

class _ManagedCategoryTile extends StatelessWidget {
  const _ManagedCategoryTile({
    required this.category,
    required this.mode,
    this.onTap,
    this.onAction,
  });

  final ManagedCategory category;
  final CategoryTileAction mode;
  final VoidCallback? onTap;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final content = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: category.locked ? const Color(0x80F2F3FF) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: mode == CategoryTileAction.edit
                  ? const Color(0xFFE2E7FF)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: category.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Text(
                  category.emoji,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          category.name,
                          style: GoogleFonts.manrope(
                            color: category.locked
                                ? const Color(0x99113069)
                                : const Color(0xFF113069),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (category.locked) ...[
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.lock_outline_rounded,
                            color: Color(0x99445D99),
                            size: 15,
                          ),
                        ],
                      ],
                    ),
                    if (mode == CategoryTileAction.edit)
                      Text(
                        '${category.count} giao dịch${category.count > 0 ? ' trong tháng' : ''}',
                        style: GoogleFonts.inter(
                          color: const Color(0xFF445D99),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
              if (mode == CategoryTileAction.delete)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: category.locked
                        ? const Color(0xFFEAEDFF)
                        : const Color(0xFFE2E7FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${category.count}',
                    style: GoogleFonts.inter(
                      color: category.locked
                          ? const Color(0x80445D99)
                          : const Color(0xFF445D99),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF8AA8FF),
                ),
            ],
          ),
        ),
      ),
    );

    if (onAction == null) {
      return content;
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Dismissible(
        key: ValueKey('${category.id}-${mode.name}'),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) async {
          onAction?.call();
          return false;
        },
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 26),
          decoration: BoxDecoration(
            color: mode == CategoryTileAction.delete
                ? const Color(0xFF9F403D)
                : const Color(0xFF0053DB),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            mode == CategoryTileAction.delete
                ? Icons.delete_outline_rounded
                : Icons.edit_outlined,
            color: Colors.white,
          ),
        ),
        child: content,
      ),
    );
  }
}

class _InputLabel extends StatelessWidget {
  const _InputLabel({required this.label, this.trailing});

  final String label;
  final String? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.manrope(
            color: const Color(0xFF113069),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        if (trailing != null)
          Text(
            trailing!,
            style: GoogleFonts.inter(
              color: const Color(0x80445D99),
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

InputDecoration _editorInputDecoration({required String hint, String? suffix}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.manrope(
      color: const Color(0x66445D99),
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    suffixText: suffix,
    suffixStyle: GoogleFonts.manrope(
      color: const Color(0xFF445D99),
      fontSize: 14,
      fontWeight: FontWeight.w700,
    ),
    filled: true,
    fillColor: const Color(0xFFE2E7FF),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: Color(0xFF0053DB), width: 1.6),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
  );
}

class _SettingsProfileCard extends StatelessWidget {
  const _SettingsProfileCard({required this.settings});

  final SettingsStateData settings;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF113069), Color(0xFF1B4A9B)],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33113069),
            blurRadius: 28,
            offset: Offset(0, 18),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trang Nguyễn',
                  style: GoogleFonts.manrope(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${settings.language.label} • Bảo mật ${settings.hasPin ? 'đã bật' : 'chưa bật'}',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontSize: 13,
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

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: const Color(0xFF6079B7),
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        _SettingsCard(
          child: Column(
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x1498B1F2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A113069),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color,
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
                    subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF6079B7)),
          ],
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
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
        const SizedBox(width: 12),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.white,
          activeTrackColor: const Color(0xFF0053DB),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: const Color(0xFFD9E2FF),
        ),
      ],
    );
  }
}

class _LanguageRow extends StatelessWidget {
  const _LanguageRow({
    required this.language,
    required this.selected,
    required this.onTap,
  });

  final AppLanguage language;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFFF2F3FF),
          borderRadius: BorderRadius.circular(18),
          border: selected ? Border.all(color: const Color(0x1498B1F2)) : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: Text(language.flag, style: const TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    language.label,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF113069),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    language.subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF0053DB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PinKey extends StatelessWidget {
  const _PinKey({this.label, this.icon, required this.onTap});

  final String? label;
  final IconData? icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: Ink(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F3FF),
            borderRadius: BorderRadius.circular(36),
          ),
          child: Center(
            child: label != null
                ? Text(
                    label!,
                    style: GoogleFonts.manrope(
                      color: const Color(0xFF113069),
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : Icon(icon, color: const Color(0xFF113069)),
          ),
        ),
      ),
    );
  }
}

class _ChoiceSheet<T> extends StatelessWidget {
  const _ChoiceSheet({
    required this.title,
    required this.values,
    required this.selected,
    required this.labelBuilder,
  });

  final String title;
  final List<T> values;
  final T selected;
  final String Function(T value) labelBuilder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26113069),
                blurRadius: 30,
                offset: Offset(0, -10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color(0x33445D99),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                title,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 18),
              for (var index = 0; index < values.length; index++) ...[
                ListTile(
                  onTap: () => Navigator.of(context).pop(values[index]),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  tileColor: values[index] == selected
                      ? const Color(0xFFF2F3FF)
                      : null,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  title: Text(
                    labelBuilder(values[index]),
                    style: GoogleFonts.inter(
                      color: const Color(0xFF113069),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: values[index] == selected
                      ? const Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF0053DB),
                        )
                      : null,
                ),
                if (index != values.length - 1) const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
