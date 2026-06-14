import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../providers/providers.dart';
import '../widgets/asset_chart.dart';

final _fmt = NumberFormat('#,###', 'ja_JP');

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final snapshots = ref.watch(snapshotsProvider).valueOrNull ?? [];
    final goals = ref.watch(goalsProvider).valueOrNull ?? [];
    final simulation = ref.watch(simulationProvider);
    final latestAsset = snapshots.isEmpty ? 0.0 : snapshots.last.totalAmount;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('資産トラッカー'),
        actions: [
          IconButton(
            icon: const Icon(Icons.file_upload_outlined),
            tooltip: 'CSV インポート',
            onPressed: () => context.go('/import'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 総資産カード
          Card(
            color: scheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('現在の総資産',
                      style: TextStyle(color: scheme.onPrimaryContainer)),
                  const SizedBox(height: 4),
                  Text('¥${_fmt.format(latestAsset)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: scheme.onPrimaryContainer,
                          fontWeight: FontWeight.bold)),
                  if (snapshots.length >= 2) ...[
                    const SizedBox(height: 4),
                    _MoMChange(snapshots),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          // 資産推移グラフ
          if (snapshots.isNotEmpty) ...[
            Text('資産推移', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            SizedBox(height: 200, child: AssetChart(snapshots: snapshots)),
            const SizedBox(height: 16),
          ],
          // 目標達成率カード一覧
          if (goals.isNotEmpty) ...[
            Text('目標達成率', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...goals.map((g) => _GoalProgressCard(
                  goal: g,
                  currentAsset: latestAsset,
                  projectedAssets: simulation?.projectedAssets ?? [],
                )),
          ] else
            _EmptyState(
              icon: Icons.flag_outlined,
              message: '目標を設定してください',
              action: '目標を追加',
              onTap: () => context.go('/goals'),
            ),
        ],
      ),
    );
  }
}

class _MoMChange extends StatelessWidget {
  final List snapshots;
  const _MoMChange(this.snapshots);

  @override
  Widget build(BuildContext context) {
    final prev = (snapshots[snapshots.length - 2] as dynamic).totalAmount as double;
    final current = (snapshots.last as dynamic).totalAmount as double;
    final diff = current - prev;
    final isPos = diff >= 0;
    return Row(children: [
      Icon(isPos ? Icons.arrow_upward : Icons.arrow_downward,
          size: 14, color: isPos ? Colors.green : Colors.red),
      Text(' 先月比 ¥${_fmt.format(diff.abs())}',
          style: TextStyle(
              fontSize: 12, color: isPos ? Colors.green : Colors.red)),
    ]);
  }
}

class _GoalProgressCard extends StatelessWidget {
  final dynamic goal;
  final double currentAsset;
  final List projectedAssets;

  const _GoalProgressCard({
    required this.goal,
    required this.currentAsset,
    required this.projectedAssets,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (currentAsset / (goal.targetAmount as double)).clamp(0.0, 1.0);
    final remaining = (goal.targetAmount as double) - currentAsset;
    final daysLeft = (goal.targetDate as DateTime).difference(DateTime.now()).inDays;

    // 予測で達成できるか確認
    DateTime? achieveDate;
    for (final entry in projectedAssets) {
      if ((entry.value as double) >= (goal.targetAmount as double)) {
        achieveDate = entry.key as DateTime;
        break;
      }
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(
                  radius: 8, backgroundColor: goal.color as Color),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(goal.name as String,
                      style: const TextStyle(fontWeight: FontWeight.w600))),
              Text('${(progress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold)),
            ]),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('残り ¥${_fmt.format(remaining.clamp(0, double.infinity))}',
                    style: Theme.of(context).textTheme.bodySmall),
                if (achieveDate != null)
                  Text(
                      '予測達成: ${DateFormat('yyyy年M月', 'ja_JP').format(achieveDate)}',
                      style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.tertiary))
                else if (daysLeft > 0)
                  Text('期限まで $daysLeft 日',
                      style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String action;
  final VoidCallback onTap;

  const _EmptyState({
    required this.icon,
    required this.message,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 32),
            Icon(icon, size: 48, color: Colors.grey),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            FilledButton(onPressed: onTap, child: Text(action)),
          ],
        ),
      );
}
