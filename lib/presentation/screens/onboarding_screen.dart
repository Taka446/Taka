import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/models/asset_snapshot.dart';
import '../../data/models/goal.dart';
import '../../data/csv_parsers/moneyforward_parser.dart';
import '../../data/csv_parsers/shinkin_sbi_parser.dart';
import '../../data/csv_parsers/smcc_parser.dart';
import '../../data/csv_parsers/sbi_securities_parser.dart';
import '../providers/providers.dart';

const _uuid = Uuid();
final _fmt = NumberFormat('#,###', 'ja_JP');

enum ChildrenStatus { none, have }

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;

  // 入力値
  int _currentAge = 30;
  ChildrenStatus _childrenStatus = ChildrenStatus.none;
  final _assetCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();
  // CSVインポートで取得した資産スナップショット（複数ソース）
  final List<AssetSnapshot> _importedSnapshots = [];

  static const _totalPages = 4;

  @override
  void dispose() {
    _pageController.dispose();
    _assetCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < _totalPages - 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    // CSVインポートで取得したスナップショットを保存
    if (_importedSnapshots.isNotEmpty) {
      await ref.read(assetRepoProvider).saveSnapshots(_importedSnapshots);
    } else {
      // 手入力の場合
      final currentAsset =
          double.tryParse(_assetCtrl.text.replaceAll(',', '')) ?? 0;
      if (currentAsset > 0) {
        await ref.read(assetRepoProvider).saveSnapshot(AssetSnapshot(
              id: _uuid.v4(),
              date: DateTime.now(),
              totalAmount: currentAsset,
              source: AssetSource.manual,
              breakdown: {'初期入力': currentAsset},
            ));
      }
    }

    final targetAsset =
        double.tryParse(_targetCtrl.text.replaceAll(',', '')) ?? 0;

    // 100歳時の目標を作成
    final yearsTo100 = 100 - _currentAge;
    final targetDate = DateTime(
        DateTime.now().year + yearsTo100,
        DateTime.now().month,
        DateTime.now().day);

    if (targetAsset > 0) {
      await ref.read(goalRepoProvider).saveGoal(Goal(
            id: _uuid.v4(),
            name: '100歳時の目標資産',
            category: GoalCategory.retirement,
            targetAmount: targetAsset,
            targetDate: targetDate,
            color: const Color(0xFF1E6FE8),
            createdAt: DateTime.now(),
          ));
    }

    // 設定を保存
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    await prefs.setInt('current_age', _currentAge);
    await prefs.setInt('birth_year', DateTime.now().year - _currentAge);
    await prefs.setBool(
        'has_children', _childrenStatus == ChildrenStatus.have);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
    }
  }

  bool _canProceed() {
    switch (_page) {
      case 0:
        return true; // 年齢は常に有効
      case 1:
        return true; // 子供の有無は選択済みで常に有効
      case 2:
        return _importedSnapshots.isNotEmpty ||
            (double.tryParse(_assetCtrl.text.replaceAll(',', '')) != null &&
                _assetCtrl.text.isNotEmpty);
      case 3:
        return double.tryParse(_targetCtrl.text.replaceAll(',', '')) != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // プログレスインジケーター
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: List.generate(
                  _totalPages,
                  (i) => Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: i <= _page
                            ? scheme.primary
                            : scheme.surfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _PageAge(
                    currentAge: _currentAge,
                    onChanged: (v) => setState(() => _currentAge = v),
                  ),
                  _PageChildren(
                    value: _childrenStatus,
                    onChanged: (v) => setState(() => _childrenStatus = v),
                  ),
                  _PageCurrentAsset(
                    controller: _assetCtrl,
                    importedSnapshots: _importedSnapshots,
                    onImported: (snapshots) {
                      setState(() {
                        _importedSnapshots
                          ..clear()
                          ..addAll(snapshots);
                      });
                    },
                  ),
                  _PageTargetAsset(
                    controller: _targetCtrl,
                    currentAge: _currentAge,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _canProceed() ? _next : null,
                  style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16)),
                  child: Text(
                    _page < _totalPages - 1 ? '次へ' : '始める',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── ページ1: 年齢 ─────────────────────────────────────────

class _PageAge extends StatelessWidget {
  final int currentAge;
  final ValueChanged<int> onChanged;
  const _PageAge({required this.currentAge, required this.onChanged});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('現在の年齢を\n教えてください',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('100歳までの資産計画を作成します',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey)),
            const SizedBox(height: 48),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton.filledTonal(
                    onPressed: currentAge > 1
                        ? () => onChanged(currentAge - 1)
                        : null,
                    icon: const Icon(Icons.remove),
                    iconSize: 28,
                  ),
                  const SizedBox(width: 24),
                  Column(children: [
                    Text(
                      '$currentAge',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    const Text('歳', style: TextStyle(fontSize: 18)),
                  ]),
                  const SizedBox(width: 24),
                  IconButton.filledTonal(
                    onPressed: currentAge < 99
                        ? () => onChanged(currentAge + 1)
                        : null,
                    icon: const Icon(Icons.add),
                    iconSize: 28,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                '目標年齢: 100歳 (あと ${100 - currentAge} 年)',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      );
}

// ── ページ2: 子供の有無 ───────────────────────────────────

class _PageChildren extends StatelessWidget {
  final ChildrenStatus value;
  final ValueChanged<ChildrenStatus> onChanged;
  const _PageChildren({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('お子さんは\nいらっしゃいますか？',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('教育費などのイベント計算に使用します',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey)),
          const SizedBox(height: 48),
          _ChoiceCard(
            icon: Icons.family_restroom,
            label: 'いる',
            selected: value == ChildrenStatus.have,
            onTap: () => onChanged(ChildrenStatus.have),
          ),
          const SizedBox(height: 16),
          _ChoiceCard(
            icon: Icons.person,
            label: 'いない',
            selected: value == ChildrenStatus.none,
            onTap: () => onChanged(ChildrenStatus.none),
          ),
        ],
      ),
    );
  }
}

class _ChoiceCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ChoiceCard(
      {required this.icon,
      required this.label,
      required this.selected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? scheme.primary : scheme.outlineVariant,
            width: selected ? 2 : 1,
          ),
          color: selected
              ? scheme.primaryContainer.withOpacity(0.4)
              : scheme.surface,
        ),
        child: Row(children: [
          Icon(icon,
              size: 32,
              color: selected ? scheme.primary : scheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Text(label,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      selected ? FontWeight.bold : FontWeight.normal,
                  color: selected ? scheme.primary : null)),
          const Spacer(),
          if (selected)
            Icon(Icons.check_circle, color: scheme.primary),
        ]),
      ),
    );
  }
}

// ── ページ3: 現在の総資産（CSVインポート） ──────────────────

class _PageCurrentAsset extends StatefulWidget {
  final TextEditingController controller;
  final List<AssetSnapshot> importedSnapshots;
  final ValueChanged<List<AssetSnapshot>> onImported;

  const _PageCurrentAsset({
    required this.controller,
    required this.importedSnapshots,
    required this.onImported,
  });

  @override
  State<_PageCurrentAsset> createState() => _PageCurrentAssetState();
}

class _PageCurrentAssetState extends State<_PageCurrentAsset> {
  bool _loading = false;
  String? _errorMsg;
  bool _showManual = false;

  double get _importedTotal =>
      widget.importedSnapshots.fold(0, (s, e) => s + e.totalAmount);

  Future<void> _importCsv(_ImportSourceOnboarding source) async {
    setState(() {
      _loading = true;
      _errorMsg = null;
    });
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'CSV'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) {
        setState(() => _loading = false);
        return;
      }
      final bytes = result.files.first.bytes!;
      String content;
      try {
        content = utf8.decode(bytes);
      } catch (_) {
        content = latin1.decode(bytes);
      }

      List<AssetSnapshot> snapshots;
      switch (source) {
        case _ImportSourceOnboarding.moneyforward:
          snapshots = MoneyForwardParser.parse(content);
        case _ImportSourceOnboarding.shinkinSbi:
          snapshots = ShinkinSBIParser.parse(content);
        case _ImportSourceOnboarding.smcc:
          snapshots = SmccParser.parse(content);
        case _ImportSourceOnboarding.sbiSecurities:
          snapshots = SbiSecuritiesParser.parse(content);
      }

      if (snapshots.isEmpty) {
        setState(() {
          _loading = false;
          _errorMsg = 'データが見つかりませんでした。CSV形式を確認してください。';
        });
        return;
      }

      final merged = List<AssetSnapshot>.from(widget.importedSnapshots)
        ..removeWhere((s) => s.source == snapshots.first.source)
        ..addAll(snapshots);
      widget.onImported(merged);
      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _loading = false;
        _errorMsg = 'エラー: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasImported = widget.importedSnapshots.isNotEmpty;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('現在の総資産を\n取り込みましょう',
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('CSVファイルをインポートするか、手入力で入力できます',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Colors.grey)),
          const SizedBox(height: 24),

          // インポートボタン群
          _OnboardingImportTile(
            label: 'マネーフォワード ME',
            icon: Icons.account_balance,
            color: const Color(0xFF0066CC),
            imported: widget.importedSnapshots
                .any((s) => s.source == AssetSource.moneyforward),
            onTap: () => _importCsv(_ImportSourceOnboarding.moneyforward),
          ),
          const SizedBox(height: 10),
          _OnboardingImportTile(
            label: '住信SBIネット銀行',
            icon: Icons.savings,
            color: const Color(0xFF004B87),
            imported: widget.importedSnapshots
                .any((s) => s.source == AssetSource.shinkinSbi),
            onTap: () => _importCsv(_ImportSourceOnboarding.shinkinSbi),
          ),
          const SizedBox(height: 10),
          _OnboardingImportTile(
            label: '三井住友カード',
            icon: Icons.credit_card,
            color: const Color(0xFF00A040),
            imported: widget.importedSnapshots
                .any((s) => s.source == AssetSource.smcc),
            onTap: () => _importCsv(_ImportSourceOnboarding.smcc),
          ),
          const SizedBox(height: 10),
          _OnboardingImportTile(
            label: 'SBI証券',
            icon: Icons.show_chart,
            color: const Color(0xFFE65100),
            imported: widget.importedSnapshots
                .any((s) => s.source == AssetSource.sbiSecurities),
            onTap: () => _importCsv(_ImportSourceOnboarding.sbiSecurities),
          ),

          if (_loading) ...[
            const SizedBox(height: 16),
            const Center(child: CircularProgressIndicator()),
          ],
          if (_errorMsg != null) ...[
            const SizedBox(height: 12),
            Text(_errorMsg!, style: const TextStyle(color: Colors.red)),
          ],

          // インポート合計表示
          if (hasImported) ...[
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Icon(Icons.check_circle, color: scheme.primary, size: 18),
                    const SizedBox(width: 8),
                    Text('インポート完了',
                        style: TextStyle(
                            color: scheme.primary,
                            fontWeight: FontWeight.bold)),
                  ]),
                  const SizedBox(height: 8),
                  ...widget.importedSnapshots.map((s) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(children: [
                          Text(_sourceLabel(s.source),
                              style: const TextStyle(fontSize: 13)),
                          const Spacer(),
                          Text('¥${_fmt.format(s.totalAmount)}',
                              style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600)),
                        ]),
                      )),
                  const Divider(height: 16),
                  Row(children: [
                    const Text('合計',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text('¥${_fmt.format(_importedTotal)}',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: scheme.primary)),
                  ]),
                ],
              ),
            ),
          ],

          // 手入力オプション
          const SizedBox(height: 16),
          TextButton.icon(
            onPressed: () => setState(() => _showManual = !_showManual),
            icon: Icon(_showManual ? Icons.keyboard_arrow_up : Icons.edit),
            label: Text(_showManual ? '手入力を閉じる' : '手入力で入力する'),
          ),
          if (_showManual) ...[
            const SizedBox(height: 8),
            TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: '¥ ',
                prefixStyle: TextStyle(
                    fontSize: 22, color: scheme.primary),
                hintText: '0',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ],
        ],
      ),
    );
  }

  String _sourceLabel(AssetSource source) {
    switch (source) {
      case AssetSource.moneyforward:
        return 'マネーフォワード ME';
      case AssetSource.shinkinSbi:
        return '住信SBIネット銀行';
      case AssetSource.smcc:
        return '三井住友カード';
      case AssetSource.sbiSecurities:
        return 'SBI証券';
      case AssetSource.manual:
        return '手入力';
    }
  }
}

enum _ImportSourceOnboarding { moneyforward, shinkinSbi, smcc, sbiSecurities }

class _OnboardingImportTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool imported;
  final VoidCallback onTap;

  const _OnboardingImportTile({
    required this.label,
    required this.icon,
    required this.color,
    required this.imported,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(
            color: imported
                ? Colors.green
                : Theme.of(context).colorScheme.outlineVariant),
        backgroundColor: imported
            ? Colors.green.withOpacity(0.05)
            : null,
      ),
      child: Row(children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withOpacity(0.12),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface))),
        if (imported)
          const Icon(Icons.check_circle, color: Colors.green, size: 20)
        else
          const Icon(Icons.upload_file, size: 20),
      ]),
    );
  }
}

// ── ページ4: 目標資産 ─────────────────────────────────────

class _PageTargetAsset extends StatefulWidget {
  final TextEditingController controller;
  final int currentAge;
  const _PageTargetAsset(
      {required this.controller, required this.currentAge});

  @override
  State<_PageTargetAsset> createState() => _PageTargetAssetState();
}

class _PageTargetAssetState extends State<_PageTargetAsset> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('100歳時点での\n目標資産を設定します',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('あと ${100 - widget.currentAge} 年後に達成したい金額',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.grey)),
            const SizedBox(height: 48),
            TextField(
              controller: widget.controller,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                prefixText: '¥ ',
                prefixStyle: TextStyle(
                    fontSize: 28,
                    color: Theme.of(context).colorScheme.primary),
                hintText: '0',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => setState(() {}),
            ),
            if (widget.controller.text.isNotEmpty) ...[
              const SizedBox(height: 12),
              Center(
                child: Text(
                  '¥ ${_fmt.format(double.tryParse(widget.controller.text.replaceAll(',', '')) ?? 0)}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      );
}
