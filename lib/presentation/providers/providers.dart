import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/db/app_database.dart';
import '../../data/models/asset_snapshot.dart';
import '../../data/models/goal.dart';
import '../../data/models/life_event.dart';
import '../../data/repositories/asset_repository.dart';
import '../../data/repositories/event_repository.dart';
import '../../data/repositories/goal_repository.dart';

// ── DB ───────────────────────────────────────────────────
final dbProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ── Repositories ─────────────────────────────────────────
final assetRepoProvider = Provider<AssetRepository>(
    (ref) => AssetRepository(ref.watch(dbProvider)));

final goalRepoProvider = Provider<GoalRepository>(
    (ref) => GoalRepository(ref.watch(dbProvider)));

final eventRepoProvider = Provider<EventRepository>(
    (ref) => EventRepository(ref.watch(dbProvider)));

// ── Streams ───────────────────────────────────────────────
final snapshotsProvider = StreamProvider<List<AssetSnapshot>>(
    (ref) => ref.watch(assetRepoProvider).watchSnapshots());

final goalsProvider = StreamProvider<List<Goal>>(
    (ref) => ref.watch(goalRepoProvider).watchGoals());

final eventsProvider = StreamProvider<List<LifeEvent>>(
    (ref) => ref.watch(eventRepoProvider).watchEvents());

// ── Simulation ───────────────────────────────────────────
final simulationProvider = Provider<SimulationResult?>((ref) {
  final snapshots = ref.watch(snapshotsProvider).valueOrNull ?? [];
  final events = ref.watch(eventsProvider).valueOrNull ?? [];
  if (snapshots.isEmpty) return null;
  return SimulationService.run(snapshots, events);
});

// ── Simulation service ───────────────────────────────────
class SimulationResult {
  final List<MapEntry<DateTime, double>> projectedAssets; // 月別予測
  final double monthlyGrowthRate; // 月次平均増加率

  const SimulationResult({
    required this.projectedAssets,
    required this.monthlyGrowthRate,
  });
}

class SimulationService {
  static SimulationResult run(
      List<AssetSnapshot> snapshots, List<LifeEvent> events) {
    snapshots.sort((a, b) => a.date.compareTo(b.date));

    // 月次成長率を過去データから算出
    double growthRate = 0;
    if (snapshots.length >= 2) {
      final first = snapshots.first.totalAmount;
      final last = snapshots.last.totalAmount;
      final months = snapshots.last.date
              .difference(snapshots.first.date)
              .inDays /
          30.44;
      if (first > 0 && months > 0) {
        growthRate = (last / first).clamp(0.0, 10.0);
        growthRate = months > 0
            ? (growthRate == 0 ? 0 : (growthRate - 1) / months)
            : 0;
      }
    }
    growthRate = growthRate.clamp(-0.05, 0.05); // ±5%/月 でクランプ

    // 今後5年間の月別予測
    final now = DateTime.now();
    double current = snapshots.last.totalAmount;
    final projected = <MapEntry<DateTime, double>>[];

    // 将来イベントのマップ (年月 → 合計影響額)
    final eventImpact = <String, double>{};
    for (final e in events) {
      _expandEvent(e, now, now.add(const Duration(days: 365 * 5)))
          .forEach((date, amount) {
        final key = '${date.year}-${date.month}';
        eventImpact[key] = (eventImpact[key] ?? 0) + amount;
      });
    }

    for (int i = 0; i <= 60; i++) {
      final date = DateTime(now.year, now.month + i, 1);
      final key = '${date.year}-${date.month}';
      current = current * (1 + growthRate) + (eventImpact[key] ?? 0);
      projected.add(MapEntry(date, current.clamp(0, double.infinity)));
    }

    return SimulationResult(
        projectedAssets: projected, monthlyGrowthRate: growthRate);
  }

  static Map<DateTime, double> _expandEvent(
      LifeEvent event, DateTime from, DateTime to) {
    final result = <DateTime, double>{};
    if (event.type == EventType.spot) {
      if (!event.date.isBefore(from) && !event.date.isAfter(to)) {
        result[DateTime(event.date.year, event.date.month)] = event.amount;
      }
    } else {
      final interval = event.recurrenceInterval;
      final monthStep = interval == RecurrenceInterval.monthly
          ? 1
          : interval == RecurrenceInterval.yearly
              ? 12
              : (event.recurrenceMonths ?? 1);
      var cur = event.date;
      final end = event.recurrenceEndDate ?? to;
      while (!cur.isAfter(end) && !cur.isAfter(to)) {
        if (!cur.isBefore(from)) {
          result[DateTime(cur.year, cur.month)] =
              (result[DateTime(cur.year, cur.month)] ?? 0) + event.amount;
        }
        cur = DateTime(cur.year, cur.month + monthStep, cur.day);
      }
    }
    return result;
  }
}
