import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/life_event.dart';
import '../providers/providers.dart';

const _uuid = Uuid();
final _fmt = NumberFormat('#,###', 'ja_JP');

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider).valueOrNull ?? [];
    final fixedEvents =
        events.where((e) => e.type == EventType.recurring).toList();
    final spotEvents =
        events.where((e) => e.type == EventType.spot).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── プロフィール ────────────────────────────────────
          const _SectionHeader(
              icon: Icons.person, title: 'プロフィール'),
          const SizedBox(height: 8),
          const _ProfileCard(),
          const SizedBox(height: 24),

          // ── 固定イベント ────────────────────────────────────
          Row(children: [
            const Expanded(
                child: _SectionHeader(
                    icon: Icons.repeat, title: '固定イベント（定期的な支出・収入）')),
            IconButton(
              icon: const Icon(Icons.add_circle),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () =>
                  _showFixedEventDialog(context, ref, null),
            ),
          ]),
          const SizedBox(height: 4),
          Text('毎月・毎年など定期的に発生するイベント',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          if (fixedEvents.isEmpty)
            _EmptyHint(
              label: '固定イベントを追加',
              onTap: () => _showFixedEventDialog(context, ref, null),
            )
          else
            ...fixedEvents.map((e) => _EventTile(
                  event: e,
                  onEdit: () => _showFixedEventDialog(context, ref, e),
                  onDelete: () =>
                      ref.read(eventRepoProvider).deleteEvent(e.id),
                )),

          const SizedBox(height: 24),

          // ── 変動イベント ────────────────────────────────────
          Row(children: [
            const Expanded(
                child: _SectionHeader(
                    icon: Icons.event_note,
                    title: '変動イベント（特定の年齢時の支出・収入）')),
            IconButton(
              icon: const Icon(Icons.add_circle),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () =>
                  _showSpotEventDialog(context, ref, null),
            ),
          ]),
          const SizedBox(height: 4),
          Text('車購入・介護費用など特定の年齢時に発生するイベント',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey)),
          const SizedBox(height: 8),
          if (spotEvents.isEmpty)
            _EmptyHint(
              label: '変動イベントを追加',
              onTap: () => _showSpotEventDialog(context, ref, null),
            )
          else
            ...spotEvents.map((e) => _EventTile(
                  event: e,
                  onEdit: () => _showSpotEventDialog(context, ref, e),
                  onDelete: () =>
                      ref.read(eventRepoProvider).deleteEvent(e.id),
                )),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _showFixedEventDialog(
      BuildContext context, WidgetRef ref, LifeEvent? existing) async {
    await showDialog(
      context: context,
      builder: (_) => _FixedEventDialog(existing: existing, ref: ref),
    );
  }

  Future<void> _showSpotEventDialog(
      BuildContext context, WidgetRef ref, LifeEvent? existing) async {
    await showDialog(
      context: context,
      builder: (_) => _SpotEventDialog(existing: existing, ref: ref),
    );
  }
}

// ── プロフィールカード ─────────────────────────────────────

class _ProfileCard extends StatefulWidget {
  const _ProfileCard();

  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> {
  int _age = 0;
  bool _hasChildren = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _age = prefs.getInt('current_age') ?? 0;
      _hasChildren = prefs.getBool('has_children') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            const Icon(Icons.account_circle, size: 48, color: Colors.grey),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('現在の年齢: $_age 歳',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text('お子さん: ${_hasChildren ? "あり" : "なし"}',
                    style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ]),
        ),
      );
}

// ── 共通ウィジェット ──────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(title,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary)),
        ),
      ]);
}

class _EmptyHint extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _EmptyHint({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(Icons.add),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size.fromHeight(48),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
}

class _EventTile extends StatelessWidget {
  final LifeEvent event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _EventTile(
      {required this.event, required this.onEdit, required this.onDelete});

  String get _subtitle {
    final amount = '¥${_fmt.format(event.amount.abs())}';
    if (event.type == EventType.recurring) {
      final period = event.recurrenceInterval == RecurrenceInterval.monthly
          ? '毎月'
          : event.recurrenceInterval == RecurrenceInterval.yearly
              ? '毎年'
              : '${event.recurrenceMonths}ヶ月ごと';
      return '$period · $amount';
    } else {
      return '${_dateToYear(event.date)}年 · $amount';
    }
  }

  String _dateToYear(DateTime date) => date.year.toString();

  @override
  Widget build(BuildContext context) {
    final isExpense = event.amount < 0;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isExpense
              ? Colors.red.withOpacity(0.1)
              : Colors.green.withOpacity(0.1),
          child: Icon(
              isExpense ? Icons.arrow_downward : Icons.arrow_upward,
              color: isExpense ? Colors.red : Colors.green,
              size: 18),
        ),
        title: Text(event.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(_subtitle),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(
              icon: const Icon(Icons.edit, size: 18), onPressed: onEdit),
          IconButton(
              icon: const Icon(Icons.delete_outline, size: 18),
              color: Colors.red,
              onPressed: onDelete),
        ]),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),
    );
  }
}

// ── 固定イベントダイアログ ────────────────────────────────

class _FixedEventDialog extends StatefulWidget {
  final LifeEvent? existing;
  final WidgetRef ref;
  const _FixedEventDialog({this.existing, required this.ref});

  @override
  State<_FixedEventDialog> createState() => _FixedEventDialogState();
}

class _FixedEventDialogState extends State<_FixedEventDialog> {
  late final _nameCtrl =
      TextEditingController(text: widget.existing?.name);
  late final _amountCtrl = TextEditingController(
      text: widget.existing?.amount.abs().toStringAsFixed(0));
  late bool _isExpense =
      widget.existing == null ? true : widget.existing!.amount < 0;
  late RecurrenceInterval _interval =
      widget.existing?.recurrenceInterval ?? RecurrenceInterval.monthly;

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.existing == null ? '固定イベントを追加' : '固定イベントを編集'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
                labelText: 'イベント名（例: 家賃、水道光熱費、給与）'),
            autofocus: true,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountCtrl,
            decoration: const InputDecoration(
                labelText: '金額（円）', prefixText: '¥'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('支出')),
              ButtonSegment(value: false, label: Text('収入')),
            ],
            selected: {_isExpense},
            onSelectionChanged: (s) => setState(() => _isExpense = s.first),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<RecurrenceInterval>(
            value: _interval,
            decoration: const InputDecoration(labelText: '周期'),
            items: const [
              DropdownMenuItem(
                  value: RecurrenceInterval.monthly, child: Text('毎月')),
              DropdownMenuItem(
                  value: RecurrenceInterval.yearly, child: Text('毎年')),
            ],
            onChanged: (v) => setState(() => _interval = v!),
          ),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル')),
          FilledButton(onPressed: _save, child: const Text('保存')),
        ],
      );

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final rawAmount =
        double.tryParse(_amountCtrl.text.replaceAll(',', ''));
    if (name.isEmpty || rawAmount == null) return;
    final amount = _isExpense ? -rawAmount.abs() : rawAmount.abs();

    final event = LifeEvent(
      id: widget.existing?.id ?? _uuid.v4(),
      name: name,
      amount: amount,
      date: DateTime.now(),
      type: EventType.recurring,
      recurrenceInterval: _interval,
    );
    await widget.ref.read(eventRepoProvider).saveEvent(event);
    if (mounted) Navigator.pop(context);
  }
}

// ── 変動イベントダイアログ ────────────────────────────────

class _SpotEventDialog extends StatefulWidget {
  final LifeEvent? existing;
  final WidgetRef ref;
  const _SpotEventDialog({this.existing, required this.ref});

  @override
  State<_SpotEventDialog> createState() => _SpotEventDialogState();
}

class _SpotEventDialogState extends State<_SpotEventDialog> {
  late final _nameCtrl =
      TextEditingController(text: widget.existing?.name);
  late final _amountCtrl = TextEditingController(
      text: widget.existing?.amount.abs().toStringAsFixed(0));
  late bool _isExpense =
      widget.existing == null ? true : widget.existing!.amount < 0;
  int _targetAge = 60;
  int _currentAge = 30;

  @override
  void initState() {
    super.initState();
    _loadAge();
  }

  Future<void> _loadAge() async {
    final prefs = await SharedPreferences.getInstance();
    final age = prefs.getInt('current_age') ?? 30;
    setState(() {
      _currentAge = age;
      if (widget.existing != null) {
        final yearsFromNow =
            widget.existing!.date.difference(DateTime.now()).inDays ~/ 365;
        _targetAge = (age + yearsFromNow).clamp(age + 1, 120);
      } else {
        _targetAge = (age + 10).clamp(age + 1, 120);
      }
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.existing == null ? '変動イベントを追加' : '変動イベントを編集'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(
            controller: _nameCtrl,
            decoration: const InputDecoration(
                labelText: 'イベント名（例: 車購入、介護費用、住宅リフォーム）'),
            autofocus: true,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _amountCtrl,
            decoration: const InputDecoration(
                labelText: '金額（円）', prefixText: '¥'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: true, label: Text('支出')),
              ButtonSegment(value: false, label: Text('収入')),
            ],
            selected: {_isExpense},
            onSelectionChanged: (s) => setState(() => _isExpense = s.first),
          ),
          const SizedBox(height: 12),
          Row(children: [
            const Text('発生年齢'),
            const Spacer(),
            IconButton(
              onPressed: _targetAge > _currentAge + 1
                  ? () => setState(() => _targetAge--)
                  : null,
              icon: const Icon(Icons.remove),
            ),
            Text('$_targetAge 歳',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            IconButton(
              onPressed: _targetAge < 120
                  ? () => setState(() => _targetAge++)
                  : null,
              icon: const Icon(Icons.add),
            ),
          ]),
          Text('現在 $_currentAge 歳 → あと ${_targetAge - _currentAge} 年後',
              style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ]),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('キャンセル')),
          FilledButton(onPressed: _save, child: const Text('保存')),
        ],
      );

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final rawAmount =
        double.tryParse(_amountCtrl.text.replaceAll(',', ''));
    if (name.isEmpty || rawAmount == null) return;
    final amount = _isExpense ? -rawAmount.abs() : rawAmount.abs();
    final yearsFromNow = (_targetAge - _currentAge).clamp(1, 200);
    final eventDate =
        DateTime(DateTime.now().year + yearsFromNow, DateTime.now().month);

    final event = LifeEvent(
      id: widget.existing?.id ?? _uuid.v4(),
      name: name,
      amount: amount,
      date: eventDate,
      type: EventType.spot,
    );
    await widget.ref.read(eventRepoProvider).saveEvent(event);
    if (mounted) Navigator.pop(context);
  }
}
