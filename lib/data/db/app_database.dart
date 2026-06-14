import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'app_database.g.dart';

// ── Tables ──────────────────────────────────────────────

@DataClassName('GoalRow')
class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  RealColumn get targetAmount => real()();
  DateTimeColumn get targetDate => dateTime()();
  IntColumn get colorValue => integer()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('AssetSnapshotRow')
class AssetSnapshots extends Table {
  TextColumn get id => text()();
  DateTimeColumn get date => dateTime()();
  RealColumn get totalAmount => real()();
  TextColumn get source => text()();
  TextColumn get breakdownJson => text()(); // JSON encoded map

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LifeEventRow')
class LifeEvents extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get amount => real()();
  DateTimeColumn get date => dateTime()();
  TextColumn get type => text()();
  TextColumn get recurrenceInterval => text().nullable()();
  IntColumn get recurrenceMonths => integer().nullable()();
  DateTimeColumn get recurrenceEndDate => dateTime().nullable()();
  TextColumn get note => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

// ── Database ─────────────────────────────────────────────

@DriftDatabase(tables: [Goals, AssetSnapshots, LifeEvents])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Goals
  Future<List<GoalRow>> allGoals() => select(goals).get();
  Stream<List<GoalRow>> watchGoals() => select(goals).watch();
  Future<void> upsertGoal(GoalsCompanion g) =>
      into(goals).insertOnConflictUpdate(g);
  Future<void> deleteGoal(String id) =>
      (delete(goals)..where((t) => t.id.equals(id))).go();

  // AssetSnapshots
  Stream<List<AssetSnapshotRow>> watchSnapshots() =>
      (select(assetSnapshots)..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .watch();
  Future<void> upsertSnapshot(AssetSnapshotsCompanion s) =>
      into(assetSnapshots).insertOnConflictUpdate(s);
  Future<void> deleteSnapshot(String id) =>
      (delete(assetSnapshots)..where((t) => t.id.equals(id))).go();

  // LifeEvents
  Stream<List<LifeEventRow>> watchEvents() =>
      (select(lifeEvents)..orderBy([(t) => OrderingTerm.asc(t.date)]))
          .watch();
  Future<void> upsertEvent(LifeEventsCompanion e) =>
      into(lifeEvents).insertOnConflictUpdate(e);
  Future<void> deleteEvent(String id) =>
      (delete(lifeEvents)..where((t) => t.id.equals(id))).go();
}

LazyDatabase _openConnection() => LazyDatabase(() async {
      final dir = await getApplicationSupportDirectory();
      final file = File(p.join(dir.path, 'asset_tracker.db'));
      return NativeDatabase.createInBackground(file);
    });
