import 'package:drift/drift.dart';
import '../db/app_database.dart';
import '../models/life_event.dart';

class EventRepository {
  final AppDatabase _db;

  EventRepository(this._db);

  Stream<List<LifeEvent>> watchEvents() =>
      _db.watchEvents().map((rows) => rows.map(_fromRow).toList());

  Future<void> saveEvent(LifeEvent event) =>
      _db.upsertEvent(LifeEventsCompanion(
        id: Value(event.id),
        name: Value(event.name),
        amount: Value(event.amount),
        date: Value(event.date),
        type: Value(event.type.name),
        recurrenceInterval: Value(event.recurrenceInterval?.name),
        recurrenceMonths: Value(event.recurrenceMonths),
        recurrenceEndDate: Value(event.recurrenceEndDate),
        note: Value(event.note),
      ));

  Future<void> deleteEvent(String id) => _db.deleteEvent(id);

  LifeEvent _fromRow(LifeEventRow row) => LifeEvent(
        id: row.id,
        name: row.name,
        amount: row.amount,
        date: row.date,
        type: EventType.values.firstWhere((e) => e.name == row.type),
        recurrenceInterval: row.recurrenceInterval != null
            ? RecurrenceInterval.values
                .firstWhere((e) => e.name == row.recurrenceInterval)
            : null,
        recurrenceMonths: row.recurrenceMonths,
        recurrenceEndDate: row.recurrenceEndDate,
        note: row.note,
      );
}
