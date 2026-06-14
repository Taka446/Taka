import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/goal.dart';
import '../providers/providers.dart';

const _uuid = Uuid();
final _fmt = NumberFormat('#,###', 'ja_JP');

const _goalColors = [
  Color(0xFF1E6FE8), Color(0xFF00A040), Color(0xFFF57C00),
  Color(0xFF9C27B0), Color(0xFFE91E63), Color(0xFF00897B),
];

const _categoryLabels = {
  GoalCategory.retirement: '老後',
  GoalCategory.housing: '住宅',
  GoalCategory.education: '教育',
  GoalCategory.travel: '旅行',
  GoalCategory.emergency: '緊急資金',
  GoalCategory.other: 'その他',
};

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goals = ref.watch(goalsProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('目標管理')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showGoalDialog(context, ref, null),
        child: const Icon(Icons.add),
      ),
      body: goals.isEmpty
          ? const Center(child: Text('目標がありません。+ から追加してください。',
              style: TextStyle(color: Colors.grey)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: goals.length,
              itemBuilder: (context, i) => _GoalCard(
                goal: goals[i],
                onEdit: () => _showGoalDialog(context, ref, goals[i]),
                onDelete: () =>
                    ref.read(goalRepoProvider).deleteGoal(goals[i].id),
              ),
            ),
    );
  }

  Future<void> _showGoalDialog(
      BuildContext context, WidgetRef ref, Goal? existing) async {
    await showDialog(
      context: context,
      builder: (_) => _GoalDialog(existing: existing, ref: ref),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final Goal goal;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _GoalCard(
      {required this.goal, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ListTile(
          leading: CircleAvatar(backgroundColor: goal.color, radius: 20),
          title: Text(goal.name,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(
              '¥${_fmt.format(goal.targetAmount)} · '
              '${DateFormat('yyyy年M月', 'ja_JP').format(goal.targetDate)}'),
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

class _GoalDialog extends StatefulWidget {
  final Goal? existing;
  final WidgetRef ref;
  const _GoalDialog({this.existing, required this.ref});

  @override
  State<_GoalDialog> createState() => _GoalDialogState();
}

class _GoalDialogState extends State<_GoalDialog> {
  late final _amountCtrl = TextEditingController(
      text: widget.existing?.targetAmount.toStringAsFixed(0));
  late GoalCategory _category =
      widget.existing?.category ?? GoalCategory.retirement;
  late Color _color = widget.existing?.color ?? _goalColors.first;
  int _targetAge = 100;

  @override
  void initState() {
    super.initState();
    _loadTargetAge();
  }

  Future<void> _loadTargetAge() async {
    final prefs = await SharedPreferences.getInstance();
    final currentAge = prefs.getInt('current_age') ?? 30;
    if (widget.existing != null) {
      final yearsLeft = widget.existing!.targetDate
          .difference(DateTime.now())
          .inDays ~/
          365;
      setState(() => _targetAge = currentAge + yearsLeft);
    } else {
      setState(() => _targetAge = 100);
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Text(widget.existing == null ? '目標を追加' : '目標を編集'),
        content: SingleChildScrollView(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: _amountCtrl,
              decoration: const InputDecoration(
                  labelText: '目標金額 (円)', prefixText: '¥'),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<GoalCategory>(
              value: _category,
              decoration: const InputDecoration(labelText: 'カテゴリ'),
              items: GoalCategory.values
                  .map((c) => DropdownMenuItem(
                        value: c,
                        child: Text(_categoryLabels[c]!),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 12),
            Row(children: [
              const Text('目標年齢'),
              const Spacer(),
              IconButton(
                onPressed: _targetAge > 1
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
            const SizedBox(height: 8),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('カラー', style: TextStyle(fontSize: 12))),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              children: _goalColors
                  .map((c) => GestureDetector(
                        onTap: () => setState(() => _color = c),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: c,
                          child: _color == c
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 16)
                              : null,
                        ),
                      ))
                  .toList(),
            ),
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
    final amount =
        double.tryParse(_amountCtrl.text.replaceAll(',', ''));
    if (amount == null) return;

    final prefs = await SharedPreferences.getInstance();
    final currentAge = prefs.getInt('current_age') ?? 30;
    final yearsTo = (_targetAge - currentAge).clamp(1, 200);
    final targetDate = DateTime(DateTime.now().year + yearsTo);
    final label = _categoryLabels[_category] ?? 'その他';

    final goal = Goal(
      id: widget.existing?.id ?? _uuid.v4(),
      name: '$_targetAge歳・$label',
      category: _category,
      targetAmount: amount,
      targetDate: targetDate,
      color: _color,
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
    );
    await widget.ref.read(goalRepoProvider).saveGoal(goal);
    if (mounted) Navigator.pop(context);
  }
}
