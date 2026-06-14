import 'dart:convert';
import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../models/asset_snapshot.dart';

class AssetRepository {
  final AppDatabase _db;
  AssetRepository(this._db);

  Stream<List<AssetSnapshot>> watchSnapshots() =>
      _db.watchSnapshots().map((rows) => rows.map(_fromRow).toList());

  Future<void> saveSnapshot(AssetSnapshot snapshot) =>
      _db.upsertSnapshot(AssetSnapshotsCompanion(
        id: Value(snapshot.id),
        date: Value(snapshot.date),
        totalAmount: Value(snapshot.totalAmount),
        source: Value(snapshot.source.name),
        breakdownJson: Value(jsonEncode(snapshot.breakdown)),
      ));

  Future<void> saveSnapshots(List<AssetSnapshot> snapshots) async {
    for (final s in snapshots) {
      await saveSnapshot(s);
    }
  }

  Future<void> deleteSnapshot(String id) => _db.deleteSnapshot(id);

  AssetSnapshot _fromRow(AssetSnapshotRow row) {
    final breakdown = Map<String, double>.from(
        (jsonDecode(row.breakdownJson) as Map).map(
            (k, v) => MapEntry(k.toString(), (v as num).toDouble())));
    return AssetSnapshot(
      id: row.id,
      date: row.date,
      totalAmount: row.totalAmount,
      source: AssetSource.values.firstWhere((e) => e.name == row.source,
          orElse: () => AssetSource.manual),
      breakdown: breakdown,
    );
  }
}
