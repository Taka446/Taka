enum EventType { spot, recurring }
enum RecurrenceInterval { monthly, yearly, custom }

class LifeEvent {
  final String id;
  final String name;
  final double amount; // 負=支出, 正=収入
  final DateTime date;
  final EventType type;
  final RecurrenceInterval? recurrenceInterval;
  final int? recurrenceMonths; // custom 間隔 (月数)
  final DateTime? recurrenceEndDate;
  final String? note;

  const LifeEvent({
    required this.id,
    required this.name,
    required this.amount,
    required this.date,
    required this.type,
    this.recurrenceInterval,
    this.recurrenceMonths,
    this.recurrenceEndDate,
    this.note,
  });

  bool get isExpense => amount < 0;

  LifeEvent copyWith({
    String? name,
    double? amount,
    DateTime? date,
    EventType? type,
    RecurrenceInterval? recurrenceInterval,
    int? recurrenceMonths,
    DateTime? recurrenceEndDate,
    String? note,
  }) =>
      LifeEvent(
        id: id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        type: type ?? this.type,
        recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
        recurrenceMonths: recurrenceMonths ?? this.recurrenceMonths,
        recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
        note: note ?? this.note,
      );
}
