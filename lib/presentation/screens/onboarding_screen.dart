import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/asset_snapshot.dart';
import '../../data/models/goal.dart';
import '../providers/providers.dart';

const _uuid = Uuid();
final _fmt = NumberFormat('#,###', 'ja_JP');

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
  final _assetCtrl = TextEditingController();
  final _targetCtrl = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _assetCtrl.dispose();
    _targetCtrl.dispose();
    super.dispose();
  }

  void _next() {
    if (_page < 2) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    final currentAsset =
        double.tryParse(_assetCtrl.text.replaceAll(',', '')) ?? 0;
    final targetAsset =
        double.tryParse(_targetCtrl.text.replaceAll(',', '')) ?? 0;

    // 現在資産をスナップショットとして保存
    if (currentAsset > 0) {
      await ref.read(assetRepoProvider).saveSnapshot(AssetSnapshot(
            id: _uuid.v4(),
            date: DateTime.now(),
            totalAmount: currentAsset,
            source: AssetSource.manual,
            breakdown: {'初期入力': currentAsset},
          ));
    }

    // 100歳時の目標を作成
    final yearsTo100 = 100 - _currentAge;
    final targetDate = DateTime(DateTime.now().year + yearsTo100,
        DateTime.now().month, DateTime.now().day);

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

    // 初期設定完了フラグと年齢を保存
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    await prefs.setInt('current_age', _currentAge);
    await prefs.setInt('birth_year', DateTime.now().year - _currentAge);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/');
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
              padding: const EdgeInsets.all(20),
              child: Row(
                children: List.generate(3, (i) => Expanded(
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
                )),
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
                  _PageCurrentAsset(controller: _assetCtrl),
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
                  child: Text(_page < 2 ? '次へ' : '始める',
                      style: const TextStyle(fontSize: 16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    if (_page == 0) return true;
    if (_page == 1) {
      return double.tryParse(_assetCtrl.text.replaceAll(',', '')) != null;
    }
    return double.tryParse(_targetCtrl.text.replaceAll(',', '')) != null;
  }
}

// ── ページ1: 現在の年齢 ──────────────────────────────────

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
                    onPressed:
                        currentAge > 1 ? () => onChanged(currentAge - 1) : null,
                    icon: const Icon(Icons.remove),
                    iconSize: 28,
                  ),
                  const SizedBox(width: 24),
                  Column(
                    children: [
                      Text('$currentAge',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary)),
                      const Text('歳', style: TextStyle(fontSize: 18)),
                    ],
                  ),
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

// ── ページ2: 現在の総資産 ────────────────────────────────

class _PageCurrentAsset extends StatefulWidget {
  final TextEditingController controller;
  const _PageCurrentAsset({required this.controller});

  @override
  State<_PageCurrentAsset> createState() => _PageCurrentAssetState();
}

class _PageCurrentAssetState extends State<_PageCurrentAsset> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('現在の総資産を\n入力してください',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('貯金・投資・不動産など全資産の合計',
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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (widget.controller.text.isNotEmpty)
              Center(
                child: Text(
                  '¥ ${_fmt.format(double.tryParse(widget.controller.text.replaceAll(',', '')) ?? 0)}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16),
                ),
              ),
          ],
        ),
      );
}

// ── ページ3: 100歳時の目標資産 ───────────────────────────

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
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            if (widget.controller.text.isNotEmpty)
              Center(
                child: Text(
                  '¥ ${_fmt.format(double.tryParse(widget.controller.text.replaceAll(',', '')) ?? 0)}',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 16),
                ),
              ),
          ],
        ),
      );
}
