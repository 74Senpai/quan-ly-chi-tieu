import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/navigation/app_routes.dart';
import '../../../ai/presentation/screens/assistant_landing_screen.dart';
import '../../../calendar/presentation/screens/calendar_screen.dart';
import '../../../home/presentation/screens/dashboard_screen.dart';
import '../../../home/presentation/widgets/home_components.dart';
import '../../../settings/presentation/screens/settings_screen.dart';
import '../../data/wallet_demo_data.dart';

class WalletsScreen extends StatefulWidget {
  const WalletsScreen({super.key});

  @override
  State<WalletsScreen> createState() => _WalletsScreenState();
}

class _WalletsScreenState extends State<WalletsScreen> {
  final List<WalletItem> _wallets = WalletDemoData.initialWallets();

  int get _totalAssets => _wallets
      .where(
        (wallet) =>
            wallet.isConfigured &&
            wallet.type != WalletType.credit &&
            !wallet.isArchived,
      )
      .fold(0, (sum, wallet) => sum + wallet.balance);

  int get _creditDebt => _wallets
      .where(
        (wallet) =>
            wallet.isConfigured &&
            wallet.type == WalletType.credit &&
            !wallet.isArchived,
      )
      .fold(0, (sum, wallet) => sum + wallet.usedAmount);

  int get _availableAssets => _totalAssets - _creditDebt;

  List<WalletItem> _walletsForType(WalletType type) {
    return _wallets
        .where((wallet) => wallet.type == type && !wallet.isArchived)
        .toList();
  }

  Future<void> _openCreateWallet([WalletItem? wallet]) async {
    final result = await Navigator.of(context).push<_WalletEditorResult>(
      MaterialPageRoute(builder: (_) => WalletEditorScreen(wallet: wallet)),
    );
    if (!mounted || result == null) {
      return;
    }
    setState(() {
      if (result.deleteId != null) {
        _wallets.removeWhere((item) => item.id == result.deleteId);
        return;
      }
      if (result.wallet == null) {
        return;
      }
      final index = _wallets.indexWhere((item) => item.id == result.wallet!.id);
      if (index >= 0) {
        _wallets[index] = result.wallet!;
      } else {
        _wallets.add(result.wallet!);
      }
    });
  }

  Future<void> _openWallet(WalletItem wallet) async {
    if (!wallet.isConfigured) {
      await _openCreateWallet(wallet);
      return;
    }
    final result = await Navigator.of(context).push<_WalletEditorResult>(
      MaterialPageRoute(builder: (_) => WalletDetailScreen(wallet: wallet)),
    );
    if (!mounted || result == null) {
      return;
    }
    setState(() {
      if (result.deleteId != null) {
        _wallets.removeWhere((item) => item.id == result.deleteId);
        return;
      }
      if (result.wallet == null) {
        return;
      }
      final index = _wallets.indexWhere((item) => item.id == result.wallet!.id);
      if (index >= 0) {
        _wallets[index] = result.wallet!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final cashAndBank = [
      ..._walletsForType(WalletType.cash),
      ..._walletsForType(WalletType.bank),
      ..._walletsForType(WalletType.ewallet),
    ];
    final creditWallets = _walletsForType(WalletType.credit);

    return Scaffold(
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
                      Text(
                        'Ví của tôi',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF113069),
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => _openCreateWallet(),
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9E2FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Color(0xFF0053DB),
                          ),
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
                        _WalletHeroCard(
                          totalAssets: _totalAssets,
                          creditDebt: _creditDebt,
                          availableAssets: _availableAssets,
                        ),
                        const SizedBox(height: 32),
                        _WalletGroupSection(
                          title: 'Tiền mặt & Ngân hàng',
                          countLabel: '${cashAndBank.length} ví',
                          wallets: cashAndBank,
                          onTapWallet: _openWallet,
                          onAddWallet: _openCreateWallet,
                        ),
                        const SizedBox(height: 28),
                        _WalletGroupSection(
                          title: 'Thẻ tín dụng',
                          wallets: creditWallets,
                          onTapWallet: _openWallet,
                          onAddWallet: _openCreateWallet,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20,
            bottom: 112,
            child: FloatingActionButton(
              onPressed: () => _openCreateWallet(),
              backgroundColor: const Color(0xFF0053DB),
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class WalletDetailScreen extends StatefulWidget {
  const WalletDetailScreen({super.key, required this.wallet});

  final WalletItem wallet;

  @override
  State<WalletDetailScreen> createState() => _WalletDetailScreenState();
}

class _WalletDetailScreenState extends State<WalletDetailScreen> {
  int _periodIndex = 0;

  Future<void> _editWallet() async {
    final result = await Navigator.of(context).push<_WalletEditorResult>(
      MaterialPageRoute(
        builder: (_) => WalletEditorScreen(wallet: widget.wallet),
      ),
    );
    if (!mounted || result == null) {
      return;
    }
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final wallet = widget.wallet;
    final expenseTotal = wallet.transactions
        .where((item) => !item.positive)
        .fold(0, (sum, item) => sum + item.amount);
    final incomeTotal = wallet.transactions
        .where((item) => item.positive)
        .fold(0, (sum, item) => sum + item.amount);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 80, 24, 132),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _WalletBalanceCard(wallet: wallet),
                  const SizedBox(height: 24),
                  _DetailTabs(
                    index: _periodIndex,
                    onChanged: (value) => setState(() => _periodIndex = value),
                  ),
                  const SizedBox(height: 24),
                  if (wallet.transactions.isNotEmpty) ...[
                    _DetailGroup(
                      title: 'Hôm nay',
                      transactions: wallet.transactions.take(2).toList(),
                    ),
                    const SizedBox(height: 20),
                    _DetailGroup(
                      title: '14 Tháng 1',
                      transactions: wallet.transactions.skip(2).toList(),
                    ),
                    const SizedBox(height: 24),
                    _DetailSummaryCard(
                      income: incomeTotal,
                      expense: expenseTotal,
                    ),
                  ] else
                    _EmptyWalletCard(onTap: _editWallet),
                ],
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              top: 0,
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(12),
                    child: const SizedBox(
                      width: 24,
                      height: 24,
                      child: Icon(
                        Icons.arrow_back_rounded,
                        color: Color(0xFF0053DB),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      wallet.name,
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF113069),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _editWallet,
                    child: Text(
                      'Sửa ví',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF0053DB),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNavigation(
        activeTab: HomeTab.wallets,
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
        onAiTap: () {
          Navigator.of(
            context,
          ).push(buildFadeSlideRoute(const AssistantLandingScreen()));
        },
        onSettingsTap: () {
          Navigator.of(context).pushAndRemoveUntil(
            buildFadeSlideRoute(const SettingsScreen()),
            (_) => false,
          );
        },
      ),
    );
  }
}

class WalletEditorScreen extends StatefulWidget {
  const WalletEditorScreen({super.key, this.wallet});

  final WalletItem? wallet;

  @override
  State<WalletEditorScreen> createState() => _WalletEditorScreenState();
}

class _WalletEditorScreenState extends State<WalletEditorScreen> {
  late WalletType _type;
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late String _icon;
  late Color _color;
  late String _bankName;
  late bool _isConfigured;

  @override
  void initState() {
    super.initState();
    final wallet = widget.wallet;
    _type = wallet?.type ?? WalletType.bank;
    _nameController = TextEditingController(
      text: wallet?.isConfigured == true ? wallet!.name : '',
    );
    _balanceController = TextEditingController(
      text: wallet != null && wallet.balance > 0
          ? formatCurrency(wallet.balance)
          : '0',
    );
    _icon = wallet?.icon ?? '🏦';
    _color = wallet?.color ?? const Color(0xFF0053DB);
    _bankName = wallet?.bankName ?? WalletDemoData.bankNames.first;
    _isConfigured = wallet?.isConfigured ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: const Color(0x33FE8983),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Color(0xFF9F403D),
                size: 24,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Xóa ví?',
              style: GoogleFonts.manrope(
                color: const Color(0xFF113069),
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Ví này có 47 giao dịch. Dữ liệu sẽ bị xóa vĩnh viễn.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: const Color(0xFF445D99),
                fontSize: 14,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color(0xFF9F403D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'Xóa',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFFFFF7F6),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Hủy',
                style: GoogleFonts.manrope(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
    if (confirmed == true && mounted) {
      Navigator.of(
        context,
      ).pop(_WalletEditorResult(deleteId: widget.wallet?.id));
    }
  }

  void _saveWallet() {
    final cleanedBalance = _balanceController.text
        .replaceAll('.', '')
        .replaceAll(',', '')
        .trim();
    final balance = int.tryParse(cleanedBalance) ?? 0;
    final name = _nameController.text.trim().isEmpty
        ? (_type == WalletType.bank ? _bankName : _type.label)
        : _nameController.text.trim();
    final subtitle = switch (_type) {
      WalletType.cash => 'Ví tiêu dùng',
      WalletType.bank => 'Tài khoản chính',
      WalletType.ewallet => 'Thanh toán nhanh',
      WalletType.credit => 'Thanh toán sau',
    };

    final wallet =
        (widget.wallet ??
                WalletItem(
                  id: '${_type.name}-${DateTime.now().millisecondsSinceEpoch}',
                  type: _type,
                  name: name,
                  subtitle: subtitle,
                  balance: balance,
                  icon: _icon,
                  color: _color,
                  isConfigured: true,
                ))
            .copyWith(
              type: _type,
              name: name,
              subtitle: subtitle,
              balance: balance,
              icon: _icon,
              color: _color,
              isConfigured: _isConfigured,
              bankName: _type == WalletType.bank ? _bankName : null,
            );

    Navigator.of(context).pop(_WalletEditorResult(wallet: wallet));
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.wallet != null && widget.wallet!.isConfigured;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8FF),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 96, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Loại ví',
                    style: GoogleFonts.manrope(
                      color: const Color(0xB3445D99),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.35,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 176,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: WalletType.values.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final type = WalletType.values[index];
                        final selected = type == _type;
                        return InkWell(
                          onTap: () => setState(() => _type = type),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 144,
                            padding: const EdgeInsets.all(26),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0x4DDBE1FF)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? const Color(0xFF0053DB)
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? const Color(0xFF0053DB)
                                        : const Color(0xFFE2E7FF),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    type.icon,
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF445D99),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  type.label,
                                  style: GoogleFonts.manrope(
                                    color: selected
                                        ? const Color(0xFF0053DB)
                                        : const Color(0xFF113069),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _EditorField(
                    label: 'Tên ví',
                    child: TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Ví dụ: Chi tiêu chính',
                        border: InputBorder.none,
                      ),
                      style: GoogleFonts.inter(
                        color: const Color(0xFF113069),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _EditorField(
                    label: isEditing ? 'Số dư hiện tại' : 'Số dư ban đầu',
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _balanceController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                            ),
                            style: GoogleFonts.manrope(
                              color: const Color(0xFF113069),
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Text(
                          '₫',
                          style: GoogleFonts.manrope(
                            color: const Color(0xFF445D99),
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_type == WalletType.bank) ...[
                    const SizedBox(height: 24),
                    _EditorField(
                      label: 'Tên ngân hàng',
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _bankName,
                          isExpanded: true,
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF445D99),
                          ),
                          items: WalletDemoData.bankNames
                              .map(
                                (name) => DropdownMenuItem<String>(
                                  value: name,
                                  child: Text(
                                    name,
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFF113069),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _bankName = value);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BIỂU TƯỢNG',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.55,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: [
                            for (final icon in WalletDemoData.iconChoices)
                              InkWell(
                                onTap: () => setState(() => _icon = icon),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: _icon == icon
                                        ? const Color(0xFFD9E2FF)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: _icon == icon
                                          ? const Color(0xFF0053DB)
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    icon,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2F3FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MÀU SẮC CHỦ ĐẠO',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF445D99),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.55,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 17,
                          runSpacing: 16,
                          children: [
                            for (final color in WalletDemoData.colorChoices)
                              InkWell(
                                onTap: () => setState(() => _color = color),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: color,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: _color == color
                                          ? Colors.white
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    boxShadow: _color == color
                                        ? [
                                            BoxShadow(
                                              color: color,
                                              spreadRadius: 2,
                                            ),
                                          ]
                                        : null,
                                  ),
                                  child: _color == color
                                      ? const Icon(
                                          Icons.check_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        )
                                      : null,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  SwitchListTile.adaptive(
                    value: _isConfigured,
                    onChanged: (value) => setState(() => _isConfigured = value),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    title: Text(
                      'Đang sử dụng',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF113069),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      'Tắt để đưa ví về trạng thái chưa sử dụng.',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF445D99),
                        fontSize: 12,
                      ),
                    ),
                    activeThumbColor: const Color(0xFF0053DB),
                    activeTrackColor: const Color(0x660053DB),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 0,
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  borderRadius: BorderRadius.circular(12),
                  child: const SizedBox(
                    width: 24,
                    height: 24,
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF0053DB),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  isEditing ? 'Sửa Ví' : 'Thêm Ví',
                  style: GoogleFonts.manrope(
                    color: const Color(0xFF113069),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                if (isEditing)
                  TextButton(
                    onPressed: _confirmDelete,
                    child: Text(
                      'Xóa ví',
                      style: GoogleFonts.manrope(
                        color: const Color(0xFF0053DB),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0x00FAF8FF), Color(0xFFFAF8FF), Color(0xFFFAF8FF)],
          ),
        ),
        child: SizedBox(
          height: 65,
          child: FilledButton(
            onPressed: _saveWallet,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF0053DB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isEditing ? 'Lưu thay đổi' : 'Tạo Ví',
              style: GoogleFonts.manrope(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletEditorResult {
  const _WalletEditorResult({this.wallet, this.deleteId});

  final WalletItem? wallet;
  final String? deleteId;
}

class _WalletBalanceCard extends StatelessWidget {
  const _WalletBalanceCard({required this.wallet});

  final WalletItem wallet;

  @override
  Widget build(BuildContext context) {
    final limit = wallet.creditLimit ?? 10000000;
    final usedRatio = limit == 0
        ? 0.0
        : (wallet.usedAmount / limit).clamp(0.0, 1.0);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            wallet.color,
            wallet.color.withBlue(
              ((wallet.color.b * 255.0).round() - 12).clamp(0, 255),
            ),
          ],
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 22,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                  wallet.type == WalletType.bank
                      ? 'BANK ACCOUNT'
                      : wallet.type.label.toUpperCase(),
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                  ),
                ),
              ),
              const Spacer(),
              Text(wallet.icon, style: const TextStyle(fontSize: 24)),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Available Balance',
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${formatCurrency(wallet.balance)} ₫',
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 40,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 28),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Đã dùng ${formatCurrency(wallet.usedAmount)} ₫',
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                ),
              ),
              Text(
                'Hạn mức ${formatCurrency(limit)} ₫',
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: wallet.type == WalletType.credit ? usedRatio : 0,
              backgroundColor: Colors.white.withValues(alpha: 0.18),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF6FFBBE)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailTabs extends StatelessWidget {
  const _DetailTabs({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    const tabs = ['Tuần', 'Tháng', 'Tất cả'];
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F3FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          for (var i = 0; i < tabs.length; i++)
            Expanded(
              child: InkWell(
                onTap: () => onChanged(i),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: index == i ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: index == i
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
                    tabs[i],
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: index == i
                          ? const Color(0xFF0053DB)
                          : const Color(0xFF445D99),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DetailGroup extends StatelessWidget {
  const _DetailGroup({required this.title, required this.transactions});

  final String title;
  final List<WalletTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              color: const Color(0xFF445D99),
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        for (var index = 0; index < transactions.length; index++) ...[
          _WalletTransactionRow(transaction: transactions[index]),
          if (index != transactions.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _WalletTransactionRow extends StatelessWidget {
  const _WalletTransactionRow({required this.transaction});

  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: transaction.iconBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(transaction.icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF113069),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  transaction.timeLabel,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.positive ? '+' : '-'} ${formatCurrency(transaction.amount)} ₫',
                style: GoogleFonts.manrope(
                  color: transaction.positive
                      ? const Color(0xFF006D4A)
                      : const Color(0xFF9F403D),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                transaction.categoryLabel.toUpperCase(),
                style: GoogleFonts.inter(
                  color: const Color(0xFF445D99),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailSummaryCard extends StatelessWidget {
  const _DetailSummaryCard({required this.income, required this.expense});

  final int income;
  final int expense;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryMetric(
              label: 'Tổng thu',
              value: '${formatCurrency(income)} ₫',
              color: const Color(0xFF006D4A),
              alignEnd: false,
            ),
          ),
          Container(width: 1, height: 40, color: const Color(0x3398B1F2)),
          Expanded(
            child: _SummaryMetric(
              label: 'Tổng chi',
              value: '${formatCurrency(expense)} ₫',
              color: const Color(0xFF9F403D),
              alignEnd: true,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.color,
    required this.alignEnd,
  });

  final String label;
  final String value;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.inter(
            color: const Color(0xFF445D99),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.manrope(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}

class _EditorField extends StatelessWidget {
  const _EditorField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: const Color(0xFF445D99),
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF2F3FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: child,
        ),
      ],
    );
  }
}

class _WalletHeroCard extends StatelessWidget {
  const _WalletHeroCard({
    required this.totalAssets,
    required this.creditDebt,
    required this.availableAssets,
  });

  final int totalAssets;
  final int creditDebt;
  final int availableAssets;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0053DB), Color(0xFF0048C1)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x330053DB),
            blurRadius: 26,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng tài sản',
            style: GoogleFonts.inter(
              color: const Color(0xCCDBE1FF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${formatCurrency(totalAssets)} ₫',
            style: GoogleFonts.manrope(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.9,
            ),
          ),
          const SizedBox(height: 24),
          Container(height: 1, color: Colors.white.withValues(alpha: 0.1)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  icon: Icons.credit_card_rounded,
                  label: 'Nợ thẻ tín dụng',
                  value:
                      '${creditDebt == 0 ? '' : '-'}${formatCurrency(creditDebt)} ₫',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Khả dụng',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${formatCurrency(availableAssets)} ₫',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WalletGroupSection extends StatelessWidget {
  const _WalletGroupSection({
    required this.title,
    this.countLabel,
    required this.wallets,
    required this.onTapWallet,
    required this.onAddWallet,
  });

  final String title;
  final String? countLabel;
  final List<WalletItem> wallets;
  final ValueChanged<WalletItem> onTapWallet;
  final ValueChanged<WalletItem?> onAddWallet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.manrope(
                  color: const Color(0xFF113069),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (countLabel != null)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E7FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  countLabel!,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF445D99),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (wallets.isEmpty)
          _EmptyWalletCard(onTap: () => onAddWallet(null))
        else
          Column(
            children: [
              for (var index = 0; index < wallets.length; index++) ...[
                _WalletRow(
                  wallet: wallets[index],
                  onTap: () => onTapWallet(wallets[index]),
                ),
                if (index != wallets.length - 1) const SizedBox(height: 12),
              ],
            ],
          ),
      ],
    );
  }
}

class _EmptyWalletCard extends StatelessWidget {
  const _EmptyWalletCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x1A98B1F2)),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F3FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.add_rounded, color: Color(0xFF0053DB)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chưa có ví nào',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF113069),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Tạo ví mới để bắt đầu quản lý tài sản.',
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
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

class _WalletRow extends StatelessWidget {
  const _WalletRow({required this.wallet, required this.onTap});

  final WalletItem wallet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: wallet.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(wallet.icon, style: const TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wallet.name,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF113069),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    wallet.subtitle,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF445D99),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              wallet.isConfigured
                  ? '${formatCurrency(wallet.balance)} ₫'
                  : 'Chưa sử dụng',
              style: GoogleFonts.inter(
                color: const Color(0xFF113069),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatCurrency(int value) {
  final negative = value < 0;
  final digits = value.abs().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    final remaining = digits.length - i;
    buffer.write(digits[i]);
    if (remaining > 1 && remaining % 3 == 1) {
      buffer.write('.');
    }
  }
  return '${negative ? '-' : ''}$buffer';
}
