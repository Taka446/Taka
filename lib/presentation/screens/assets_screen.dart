import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/asset_snapshot.dart';
import '../providers/providers.dart';
import '../widgets/asset_chart.dart';

const _uuid = Uuid();
final _fmt = NumberFormat('#,###', 'ja_JP');

const _sourceLabels = {
  AssetSource.moneyforward: 'マネーフォワード',
  AssetSource.shinkinSbi: '住信SBI',
  AssetSource.smcc: '三井住友カード',
  AssetSource.manual: '手入力',
};

class AssetsScreen extends ConsumerWidget {
  const AssetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshots = ref.watch(snapshotsProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('資産推移')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          if (snapshots.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(height: 220, child: AssetChart(snapshots: snapshots)),
            ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: snapshots.length,
              itemBuilder: (ctx, i) {
                final s = snapshots[snapshots.length - 1 - i];
                return ListTile(
                  title: Text('¥${_fmt.format(s.totalAmount)}',
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                      '${DateFormat('yyyy/MM/dd').format(s.date)} · ${_sourceLabels[s.source]}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () =>
                        ref.read(assetRepoProvider).deleteSnapshot(s.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final amtCtrl = TextEditingController();
    DateTime date = DateTime.now();

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          title: const Text('資産を手入力'),
          content: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(
              controller: amtCtrl,
              decoration:
                  const InputDecoration(labelText: '総資産額 (円)', prefixText: '¥'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('日付'),
              subtitle: Text(DateFormat('yyyy/MM/dd').format(date)),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final d = await showDatePicker(
                    context: ctx,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now());
                if (d != null) setState(() => date = d);
              },
            ),
          ]),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('キャンセル')),
            FilledButton(
              onPressed: () async {
                final amount =
                    double.tryParse(amtCtrl.text.replaceAll(',', ''));
                if (amount == null) return;
                await ref.read(assetRepoProvider).saveSnapshot(AssetSnapshot(
                      id: _uuid.v4(),
                      date: date,
                      totalAmount: amount,
                      source: AssetSource.manual,
                      breakdown: {'手入力': amount},
                    ));
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('保存'),
            ),
          ],
        ),
      ),
    );
  }
}
