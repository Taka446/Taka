import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';
import '../widgets/asset_chart.dart';

final _fmt = NumberFormat('#,###', 'ja_JP');

class SimulationScreen extends ConsumerWidget {
  const SimulationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshots = ref.watch(snapshotsProvider).valueOrNull ?? [];
    final goals = ref.watch(goalsProvider).valueOrNull ?? [];
    final simulation = ref.watch(simulationProvider);

    if (snapshots.isEmpty) {
      return const Scaffold(
        body: Center(
            child: Text('資産データがありません。\nCSV をインポートするか手入力してください。',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey))),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('シミュレーション')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (simulation != null) ...[
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('月次平均成長率',
                        style: Theme.of(context).textTheme.labelMedium),
                    Text(
                        '${(simulation.monthlyGrowthRate * 100).toStringAsFixed(2)}% / 月',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    Text('過去データより算出',
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('5年間予測グラフ',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(
              height: 240,
              child: AssetChart(
                snapshots: snapshots,
                projected: simulation.projectedAssets,
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              _Legend(color: Theme.of(context).colorScheme.primary, label: '実績'),
              const SizedBox(width: 16),
              _Legend(color: Theme.of(context).colorScheme.tertiary, label: '予測 (破線)'),
            ]),
            const SizedBox(height: 24),
          ],
          if (goals.isNotEmpty) ...[
            Text('目標達成予測', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...goals.map((g) {
              DateTime? achieveDate;
              if (simulation != null) {
                for (final entry in simulation.projectedAssets) {
                  if (entry.value >= g.targetAmount) {
                    achieveDate = entry.key;
                    break;
                  }
                }
              }
              final currentAsset =
                  snapshots.isEmpty ? 0.0 : snapshots.last.totalAmount;
              final progress =
                  (currentAsset / g.targetAmount).clamp(0.0, 1.0);
              final onSchedule = achieveDate != null &&
                  !achieveDate.isAfter(g.targetDate);

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        CircleAvatar(
                            radius: 8, backgroundColor: g.color),
                        const SizedBox(width: 8),
                        Expanded(
                            child: Text(g.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600))),
                        if (achieveDate != null)
                          Chip(
                            label: Text(
                                onSchedule ? '達成見込み' : '期限超過見込み',
                                style: const TextStyle(fontSize: 11)),
                            backgroundColor: onSchedule
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            side: BorderSide(
                                color: onSchedule
                                    ? Colors.green
                                    : Colors.orange),
                          )
                        else
                          const Chip(
                            label: Text('達成困難', style: TextStyle(fontSize: 11)),
                            backgroundColor: Color(0x1FFF0000),
                            side: BorderSide(color: Colors.red),
                          ),
                      ]),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                          value: progress,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                          color: g.color),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              '目標: ¥${_fmt.format(g.targetAmount)}',
                              style: Theme.of(context).textTheme.bodySmall),
                          if (achieveDate != null)
                            Text(
                                '予測達成: ${DateFormat('yyyy年M月', 'ja_JP').format(achieveDate)}',
                                style: TextStyle(
                                    fontSize: 11,
                                    color: onSchedule
                                        ? Colors.green
                                        : Colors.orange)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 20, height: 3, color: color),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ]);
}
