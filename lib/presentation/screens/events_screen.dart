import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/life_event.dart';
import '../providers/providers.dart';

const _uuid = Uuid();
final _fmt = NumberFormat('#,###', 'ja_JP');

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final events = ref.watch(eventsProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('ライフイベント')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showEventDialog(context, ref, null),
        child: const Icon(Icons.add),
      ),
      body: events.isEmpty
          ? const Center(
              child: Text('イベントがありません。+ から追加してください。',
                  style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (ctx, i) => _EventCard(
                event: events[i],
                onEdit: () => _showEventDialog(context, ref, events[i]),
                onDelete: () =>
                    ref.read(eventRepoProvider).deleteEvent(events[i].id),
              ),
            ),
    );
  }

  Future<void> _showEventDialog(
      BuildContext context, WidgetRef ref, LifeEvent? existing) async {
    await showDialog(
      context: context,
      builder: (_) => _EventDialog(existing: existing, ref: ref),
    );
  }
}

class _EventCard extends StatelessWidget {
  final LifeEvent event;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EventCard(
      {required this.event, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isExpense = event.amount < 0;
    final recLabel = event.type == EventType.recurring
        ? (event.recurrenceInterval == RecurrenceInterval.monthly
            ? '毎月'
            : event.recurrenceInterval == RecurrenceInterval.yearly
                ? '毎年'
                : '${event.recurrenceMonths}ヶ月ごと')
        : '一時';

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isExpense
              ? Colors.red.withOpacity(0.1)
              : Colors.green.withOpacity(0.1),
          child: Icon(isExpense ? Icons.arrow_downward : Icons.arrow_upward,
              color: isExpense ? Colors.red : Colors.green),
        ),
        title: Text(event.name,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
            '¥${_fmt.format(event.amount.abs())} · '
            '${DateFormat('yyyy/MM/dd').format(event.date)} · $recLabel'),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
          IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: onDelete,
              color: Colors.red),
        ]),
      ),
    );
  }
}

class _EventDialog extends StatefulWidget {
  final LifeEvent? existing;
  final WidgetRef ref;
  const _EventDialog({this.existing, required this.ref});

  @override
  State<_EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<_EventDialog> {
  late final _nameCtrl =
      TextEditingController(text: widget.existing?.name);
  late final _amountCtrl = TextEditingController(
      text: widget.existing?.amount.abs().toStringAsFixed(0));
  late bool _isExpense = widget.existing?.amount == null
      ? true
      : widget.existing!.amount < 0;
  late DateTime _date = widget.existing?.date ?? DateTime.now();
  late EventType _type = widget.existing?.type ?? EventType.spot;
  late RecurrenceInterval _interval =
      widget.existing?.recurrenceInterval ?? RecurrenceInterval.yearly;
  late final _monthsCtrl = TextEditingController(
      text: widget.existing?.recurrenceMonths?.toString() ?? '3');

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.existing == null ? 'イベントを追加' : 'イベントを編集'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: 'イベント名 (例: 車購入、介護費用)'),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _amountCtrl,
                  decoration:
                      const InputDecoration(labelText: '金額 (円)', prefixText: '¥'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(value: true, label: Text('支出')),
                  ButtonSegment(value: false, label: Text('収入')),
                ],
                selected: {_isExpense},
                onSelectionChanged: (s) =>
                    setState(() => _isExpense = s.first),
              ),
            ]),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('発生日'),
              subtitle: Text(DateFormat('yyyy/MM/dd').format(_date)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(
                    context: context,
                    initialDate: _date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100));
                if (d != null) setState(() => _date = d);
              },
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<EventType>(
              value: _type,
              decoration: const InputDecoration(labelText: 'イベント種別'),
              items: const [
                DropdownMenuItem(value: EventType.spot, child: Text('一時的 (単発)')),
                DropdownMenuItem(value: EventType.recurring, child: Text('定期的 (繰り返し)')),
              ],
              onChanged: (v) => setState(() => _type = v!),
            ),
            if (_type == EventType.recurring) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<RecurrenceInterval>(
                value: _interval,
                decoration: const InputDecoration(labelText: '繰り返し間隔'),
                items: const [
                  DropdownMenuItem(
                      value: RecurrenceInterval.monthly, child: Text('毎月')),
                  DropdownMenuItem(
                      value: RecurrenceInterval.yearly, child: Text('毎年')),
                  DropdownMenuItem(
                      value: RecurrenceInterval.custom, child: Text('カスタム')),
                ],
                onChanged: (v) => setState(() => _interval = v!),
              ),
              if (_interval == RecurrenceInterval.custom) ...[
                const SizedBox(height: 12),
                TextField(
                  controller: _monthsCtrl,
                  decoration:
                      const InputDecoration(labelText: 'カスタム間隔 (ヶ月)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ],
          ]),
        ),
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
      date: _date,
      type: _type,
      recurrenceInterval:
          _type == EventType.recurring ? _interval : null,
      recurrenceMonths: _type == EventType.recurring &&
              _interval == RecurrenceInterval.custom
          ? int.tryParse(_monthsCtrl.text)
          : null,
    );
    await widget.ref.read(eventRepoProvider).saveEvent(event);
    if (mounted) Navigator.pop(context);
  }
}
