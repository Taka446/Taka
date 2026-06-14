// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $GoalsTable extends Goals with TableInfo<$GoalsTable, GoalRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetAmountMeta =
      const VerificationMeta('targetAmount');
  @override
  late final GeneratedColumn<double> targetAmount = GeneratedColumn<double>(
      'target_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _targetDateMeta =
      const VerificationMeta('targetDate');
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
      'target_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _colorValueMeta =
      const VerificationMeta('colorValue');
  @override
  late final GeneratedColumn<int> colorValue = GeneratedColumn<int>(
      'color_value', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, category, targetAmount, targetDate, colorValue, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(Insertable<GoalRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
          _targetAmountMeta,
          targetAmount.isAcceptableOrUnknown(
              data['target_amount']!, _targetAmountMeta));
    } else if (isInserting) {
      context.missing(_targetAmountMeta);
    }
    if (data.containsKey('target_date')) {
      context.handle(
          _targetDateMeta,
          targetDate.isAcceptableOrUnknown(
              data['target_date']!, _targetDateMeta));
    } else if (isInserting) {
      context.missing(_targetDateMeta);
    }
    if (data.containsKey('color_value')) {
      context.handle(
          _colorValueMeta,
          colorValue.isAcceptableOrUnknown(
              data['color_value']!, _colorValueMeta));
    } else if (isInserting) {
      context.missing(_colorValueMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      targetAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}target_amount'])!,
      targetDate: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}target_date'])!,
      colorValue: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}color_value'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class GoalRow extends DataClass implements Insertable<GoalRow> {
  final String id;
  final String name;
  final String category;
  final double targetAmount;
  final DateTime targetDate;
  final int colorValue;
  final DateTime createdAt;
  const GoalRow(
      {required this.id,
      required this.name,
      required this.category,
      required this.targetAmount,
      required this.targetDate,
      required this.colorValue,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['target_amount'] = Variable<double>(targetAmount);
    map['target_date'] = Variable<DateTime>(targetDate);
    map['color_value'] = Variable<int>(colorValue);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      targetAmount: Value(targetAmount),
      targetDate: Value(targetDate),
      colorValue: Value(colorValue),
      createdAt: Value(createdAt),
    );
  }

  factory GoalRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      targetAmount: serializer.fromJson<double>(json['targetAmount']),
      targetDate: serializer.fromJson<DateTime>(json['targetDate']),
      colorValue: serializer.fromJson<int>(json['colorValue']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'targetAmount': serializer.toJson<double>(targetAmount),
      'targetDate': serializer.toJson<DateTime>(targetDate),
      'colorValue': serializer.toJson<int>(colorValue),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GoalRow copyWith(
          {String? id,
          String? name,
          String? category,
          double? targetAmount,
          DateTime? targetDate,
          int? colorValue,
          DateTime? createdAt}) =>
      GoalRow(
        id: id ?? this.id,
        name: name ?? this.name,
        category: category ?? this.category,
        targetAmount: targetAmount ?? this.targetAmount,
        targetDate: targetDate ?? this.targetDate,
        colorValue: colorValue ?? this.colorValue,
        createdAt: createdAt ?? this.createdAt,
      );
  GoalRow copyWithCompanion(GoalsCompanion data) {
    return GoalRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      targetDate:
          data.targetDate.present ? data.targetDate.value : this.targetDate,
      colorValue:
          data.colorValue.present ? data.colorValue.value : this.colorValue,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('colorValue: $colorValue, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, category, targetAmount, targetDate, colorValue, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.targetAmount == this.targetAmount &&
          other.targetDate == this.targetDate &&
          other.colorValue == this.colorValue &&
          other.createdAt == this.createdAt);
}

class GoalsCompanion extends UpdateCompanion<GoalRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> category;
  final Value<double> targetAmount;
  final Value<DateTime> targetDate;
  final Value<int> colorValue;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.colorValue = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String name,
    required String category,
    required double targetAmount,
    required DateTime targetDate,
    required int colorValue,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        category = Value(category),
        targetAmount = Value(targetAmount),
        targetDate = Value(targetDate),
        colorValue = Value(colorValue),
        createdAt = Value(createdAt);
  static Insertable<GoalRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<double>? targetAmount,
    Expression<DateTime>? targetDate,
    Expression<int>? colorValue,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (targetDate != null) 'target_date': targetDate,
      if (colorValue != null) 'color_value': colorValue,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? category,
      Value<double>? targetAmount,
      Value<DateTime>? targetDate,
      Value<int>? colorValue,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return GoalsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      targetAmount: targetAmount ?? this.targetAmount,
      targetDate: targetDate ?? this.targetDate,
      colorValue: colorValue ?? this.colorValue,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<double>(targetAmount.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (colorValue.present) {
      map['color_value'] = Variable<int>(colorValue.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('colorValue: $colorValue, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AssetSnapshotsTable extends AssetSnapshots
    with TableInfo<$AssetSnapshotsTable, AssetSnapshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AssetSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _totalAmountMeta =
      const VerificationMeta('totalAmount');
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
      'total_amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _breakdownJsonMeta =
      const VerificationMeta('breakdownJson');
  @override
  late final GeneratedColumn<String> breakdownJson = GeneratedColumn<String>(
      'breakdown_json', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, date, totalAmount, source, breakdownJson];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'asset_snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<AssetSnapshotRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('total_amount')) {
      context.handle(
          _totalAmountMeta,
          totalAmount.isAcceptableOrUnknown(
              data['total_amount']!, _totalAmountMeta));
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('breakdown_json')) {
      context.handle(
          _breakdownJsonMeta,
          breakdownJson.isAcceptableOrUnknown(
              data['breakdown_json']!, _breakdownJsonMeta));
    } else if (isInserting) {
      context.missing(_breakdownJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AssetSnapshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AssetSnapshotRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      totalAmount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total_amount'])!,
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      breakdownJson: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}breakdown_json'])!,
    );
  }

  @override
  $AssetSnapshotsTable createAlias(String alias) {
    return $AssetSnapshotsTable(attachedDatabase, alias);
  }
}

class AssetSnapshotRow extends DataClass
    implements Insertable<AssetSnapshotRow> {
  final String id;
  final DateTime date;
  final double totalAmount;
  final String source;
  final String breakdownJson;
  const AssetSnapshotRow(
      {required this.id,
      required this.date,
      required this.totalAmount,
      required this.source,
      required this.breakdownJson});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['date'] = Variable<DateTime>(date);
    map['total_amount'] = Variable<double>(totalAmount);
    map['source'] = Variable<String>(source);
    map['breakdown_json'] = Variable<String>(breakdownJson);
    return map;
  }

  AssetSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return AssetSnapshotsCompanion(
      id: Value(id),
      date: Value(date),
      totalAmount: Value(totalAmount),
      source: Value(source),
      breakdownJson: Value(breakdownJson),
    );
  }

  factory AssetSnapshotRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AssetSnapshotRow(
      id: serializer.fromJson<String>(json['id']),
      date: serializer.fromJson<DateTime>(json['date']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      source: serializer.fromJson<String>(json['source']),
      breakdownJson: serializer.fromJson<String>(json['breakdownJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'date': serializer.toJson<DateTime>(date),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'source': serializer.toJson<String>(source),
      'breakdownJson': serializer.toJson<String>(breakdownJson),
    };
  }

  AssetSnapshotRow copyWith(
          {String? id,
          DateTime? date,
          double? totalAmount,
          String? source,
          String? breakdownJson}) =>
      AssetSnapshotRow(
        id: id ?? this.id,
        date: date ?? this.date,
        totalAmount: totalAmount ?? this.totalAmount,
        source: source ?? this.source,
        breakdownJson: breakdownJson ?? this.breakdownJson,
      );
  AssetSnapshotRow copyWithCompanion(AssetSnapshotsCompanion data) {
    return AssetSnapshotRow(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      source: data.source.present ? data.source.value : this.source,
      breakdownJson: data.breakdownJson.present
          ? data.breakdownJson.value
          : this.breakdownJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AssetSnapshotRow(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('source: $source, ')
          ..write('breakdownJson: $breakdownJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, totalAmount, source, breakdownJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AssetSnapshotRow &&
          other.id == this.id &&
          other.date == this.date &&
          other.totalAmount == this.totalAmount &&
          other.source == this.source &&
          other.breakdownJson == this.breakdownJson);
}

class AssetSnapshotsCompanion extends UpdateCompanion<AssetSnapshotRow> {
  final Value<String> id;
  final Value<DateTime> date;
  final Value<double> totalAmount;
  final Value<String> source;
  final Value<String> breakdownJson;
  final Value<int> rowid;
  const AssetSnapshotsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.source = const Value.absent(),
    this.breakdownJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AssetSnapshotsCompanion.insert({
    required String id,
    required DateTime date,
    required double totalAmount,
    required String source,
    required String breakdownJson,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        date = Value(date),
        totalAmount = Value(totalAmount),
        source = Value(source),
        breakdownJson = Value(breakdownJson);
  static Insertable<AssetSnapshotRow> custom({
    Expression<String>? id,
    Expression<DateTime>? date,
    Expression<double>? totalAmount,
    Expression<String>? source,
    Expression<String>? breakdownJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (source != null) 'source': source,
      if (breakdownJson != null) 'breakdown_json': breakdownJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AssetSnapshotsCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? date,
      Value<double>? totalAmount,
      Value<String>? source,
      Value<String>? breakdownJson,
      Value<int>? rowid}) {
    return AssetSnapshotsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      totalAmount: totalAmount ?? this.totalAmount,
      source: source ?? this.source,
      breakdownJson: breakdownJson ?? this.breakdownJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (breakdownJson.present) {
      map['breakdown_json'] = Variable<String>(breakdownJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AssetSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('source: $source, ')
          ..write('breakdownJson: $breakdownJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LifeEventsTable extends LifeEvents
    with TableInfo<$LifeEventsTable, LifeEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LifeEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
      'amount', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
      'date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recurrenceIntervalMeta =
      const VerificationMeta('recurrenceInterval');
  @override
  late final GeneratedColumn<String> recurrenceInterval =
      GeneratedColumn<String>('recurrence_interval', aliasedName, true,
          type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceMonthsMeta =
      const VerificationMeta('recurrenceMonths');
  @override
  late final GeneratedColumn<int> recurrenceMonths = GeneratedColumn<int>(
      'recurrence_months', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _recurrenceEndDateMeta =
      const VerificationMeta('recurrenceEndDate');
  @override
  late final GeneratedColumn<DateTime> recurrenceEndDate =
      GeneratedColumn<DateTime>('recurrence_end_date', aliasedName, true,
          type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
      'note', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        name,
        amount,
        date,
        type,
        recurrenceInterval,
        recurrenceMonths,
        recurrenceEndDate,
        note
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'life_events';
  @override
  VerificationContext validateIntegrity(Insertable<LifeEventRow> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(_amountMeta,
          amount.isAcceptableOrUnknown(data['amount']!, _amountMeta));
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
          _dateMeta, date.isAcceptableOrUnknown(data['date']!, _dateMeta));
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('recurrence_interval')) {
      context.handle(
          _recurrenceIntervalMeta,
          recurrenceInterval.isAcceptableOrUnknown(
              data['recurrence_interval']!, _recurrenceIntervalMeta));
    }
    if (data.containsKey('recurrence_months')) {
      context.handle(
          _recurrenceMonthsMeta,
          recurrenceMonths.isAcceptableOrUnknown(
              data['recurrence_months']!, _recurrenceMonthsMeta));
    }
    if (data.containsKey('recurrence_end_date')) {
      context.handle(
          _recurrenceEndDateMeta,
          recurrenceEndDate.isAcceptableOrUnknown(
              data['recurrence_end_date']!, _recurrenceEndDateMeta));
    }
    if (data.containsKey('note')) {
      context.handle(
          _noteMeta, note.isAcceptableOrUnknown(data['note']!, _noteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LifeEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LifeEventRow(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      amount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}amount'])!,
      date: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}date'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      recurrenceInterval: attachedDatabase.typeMapping.read(
          DriftSqlType.string, data['${effectivePrefix}recurrence_interval']),
      recurrenceMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}recurrence_months']),
      recurrenceEndDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}recurrence_end_date']),
      note: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}note']),
    );
  }

  @override
  $LifeEventsTable createAlias(String alias) {
    return $LifeEventsTable(attachedDatabase, alias);
  }
}

class LifeEventRow extends DataClass implements Insertable<LifeEventRow> {
  final String id;
  final String name;
  final double amount;
  final DateTime date;
  final String type;
  final String? recurrenceInterval;
  final int? recurrenceMonths;
  final DateTime? recurrenceEndDate;
  final String? note;
  const LifeEventRow(
      {required this.id,
      required this.name,
      required this.amount,
      required this.date,
      required this.type,
      this.recurrenceInterval,
      this.recurrenceMonths,
      this.recurrenceEndDate,
      this.note});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['amount'] = Variable<double>(amount);
    map['date'] = Variable<DateTime>(date);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || recurrenceInterval != null) {
      map['recurrence_interval'] = Variable<String>(recurrenceInterval);
    }
    if (!nullToAbsent || recurrenceMonths != null) {
      map['recurrence_months'] = Variable<int>(recurrenceMonths);
    }
    if (!nullToAbsent || recurrenceEndDate != null) {
      map['recurrence_end_date'] = Variable<DateTime>(recurrenceEndDate);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  LifeEventsCompanion toCompanion(bool nullToAbsent) {
    return LifeEventsCompanion(
      id: Value(id),
      name: Value(name),
      amount: Value(amount),
      date: Value(date),
      type: Value(type),
      recurrenceInterval: recurrenceInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceInterval),
      recurrenceMonths: recurrenceMonths == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceMonths),
      recurrenceEndDate: recurrenceEndDate == null && nullToAbsent
          ? const Value.absent()
          : Value(recurrenceEndDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory LifeEventRow.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LifeEventRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      amount: serializer.fromJson<double>(json['amount']),
      date: serializer.fromJson<DateTime>(json['date']),
      type: serializer.fromJson<String>(json['type']),
      recurrenceInterval:
          serializer.fromJson<String?>(json['recurrenceInterval']),
      recurrenceMonths: serializer.fromJson<int?>(json['recurrenceMonths']),
      recurrenceEndDate:
          serializer.fromJson<DateTime?>(json['recurrenceEndDate']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'amount': serializer.toJson<double>(amount),
      'date': serializer.toJson<DateTime>(date),
      'type': serializer.toJson<String>(type),
      'recurrenceInterval': serializer.toJson<String?>(recurrenceInterval),
      'recurrenceMonths': serializer.toJson<int?>(recurrenceMonths),
      'recurrenceEndDate': serializer.toJson<DateTime?>(recurrenceEndDate),
      'note': serializer.toJson<String?>(note),
    };
  }

  LifeEventRow copyWith(
          {String? id,
          String? name,
          double? amount,
          DateTime? date,
          String? type,
          Value<String?> recurrenceInterval = const Value.absent(),
          Value<int?> recurrenceMonths = const Value.absent(),
          Value<DateTime?> recurrenceEndDate = const Value.absent(),
          Value<String?> note = const Value.absent()}) =>
      LifeEventRow(
        id: id ?? this.id,
        name: name ?? this.name,
        amount: amount ?? this.amount,
        date: date ?? this.date,
        type: type ?? this.type,
        recurrenceInterval: recurrenceInterval.present
            ? recurrenceInterval.value
            : this.recurrenceInterval,
        recurrenceMonths: recurrenceMonths.present
            ? recurrenceMonths.value
            : this.recurrenceMonths,
        recurrenceEndDate: recurrenceEndDate.present
            ? recurrenceEndDate.value
            : this.recurrenceEndDate,
        note: note.present ? note.value : this.note,
      );
  LifeEventRow copyWithCompanion(LifeEventsCompanion data) {
    return LifeEventRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      amount: data.amount.present ? data.amount.value : this.amount,
      date: data.date.present ? data.date.value : this.date,
      type: data.type.present ? data.type.value : this.type,
      recurrenceInterval: data.recurrenceInterval.present
          ? data.recurrenceInterval.value
          : this.recurrenceInterval,
      recurrenceMonths: data.recurrenceMonths.present
          ? data.recurrenceMonths.value
          : this.recurrenceMonths,
      recurrenceEndDate: data.recurrenceEndDate.present
          ? data.recurrenceEndDate.value
          : this.recurrenceEndDate,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LifeEventRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('recurrenceInterval: $recurrenceInterval, ')
          ..write('recurrenceMonths: $recurrenceMonths, ')
          ..write('recurrenceEndDate: $recurrenceEndDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, amount, date, type,
      recurrenceInterval, recurrenceMonths, recurrenceEndDate, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LifeEventRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.amount == this.amount &&
          other.date == this.date &&
          other.type == this.type &&
          other.recurrenceInterval == this.recurrenceInterval &&
          other.recurrenceMonths == this.recurrenceMonths &&
          other.recurrenceEndDate == this.recurrenceEndDate &&
          other.note == this.note);
}

class LifeEventsCompanion extends UpdateCompanion<LifeEventRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> amount;
  final Value<DateTime> date;
  final Value<String> type;
  final Value<String?> recurrenceInterval;
  final Value<int?> recurrenceMonths;
  final Value<DateTime?> recurrenceEndDate;
  final Value<String?> note;
  final Value<int> rowid;
  const LifeEventsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.amount = const Value.absent(),
    this.date = const Value.absent(),
    this.type = const Value.absent(),
    this.recurrenceInterval = const Value.absent(),
    this.recurrenceMonths = const Value.absent(),
    this.recurrenceEndDate = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LifeEventsCompanion.insert({
    required String id,
    required String name,
    required double amount,
    required DateTime date,
    required String type,
    this.recurrenceInterval = const Value.absent(),
    this.recurrenceMonths = const Value.absent(),
    this.recurrenceEndDate = const Value.absent(),
    this.note = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        amount = Value(amount),
        date = Value(date),
        type = Value(type);
  static Insertable<LifeEventRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? amount,
    Expression<DateTime>? date,
    Expression<String>? type,
    Expression<String>? recurrenceInterval,
    Expression<int>? recurrenceMonths,
    Expression<DateTime>? recurrenceEndDate,
    Expression<String>? note,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (amount != null) 'amount': amount,
      if (date != null) 'date': date,
      if (type != null) 'type': type,
      if (recurrenceInterval != null) 'recurrence_interval': recurrenceInterval,
      if (recurrenceMonths != null) 'recurrence_months': recurrenceMonths,
      if (recurrenceEndDate != null) 'recurrence_end_date': recurrenceEndDate,
      if (note != null) 'note': note,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LifeEventsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? amount,
      Value<DateTime>? date,
      Value<String>? type,
      Value<String?>? recurrenceInterval,
      Value<int?>? recurrenceMonths,
      Value<DateTime?>? recurrenceEndDate,
      Value<String?>? note,
      Value<int>? rowid}) {
    return LifeEventsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      recurrenceInterval: recurrenceInterval ?? this.recurrenceInterval,
      recurrenceMonths: recurrenceMonths ?? this.recurrenceMonths,
      recurrenceEndDate: recurrenceEndDate ?? this.recurrenceEndDate,
      note: note ?? this.note,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (recurrenceInterval.present) {
      map['recurrence_interval'] = Variable<String>(recurrenceInterval.value);
    }
    if (recurrenceMonths.present) {
      map['recurrence_months'] = Variable<int>(recurrenceMonths.value);
    }
    if (recurrenceEndDate.present) {
      map['recurrence_end_date'] = Variable<DateTime>(recurrenceEndDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LifeEventsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('amount: $amount, ')
          ..write('date: $date, ')
          ..write('type: $type, ')
          ..write('recurrenceInterval: $recurrenceInterval, ')
          ..write('recurrenceMonths: $recurrenceMonths, ')
          ..write('recurrenceEndDate: $recurrenceEndDate, ')
          ..write('note: $note, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $AssetSnapshotsTable assetSnapshots = $AssetSnapshotsTable(this);
  late final $LifeEventsTable lifeEvents = $LifeEventsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [goals, assetSnapshots, lifeEvents];
}

typedef $$GoalsTableCreateCompanionBuilder = GoalsCompanion Function({
  required String id,
  required String name,
  required String category,
  required double targetAmount,
  required DateTime targetDate,
  required int colorValue,
  required DateTime createdAt,
  Value<int> rowid,
});
typedef $$GoalsTableUpdateCompanionBuilder = GoalsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> category,
  Value<double> targetAmount,
  Value<DateTime> targetDate,
  Value<int> colorValue,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$GoalsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $GoalsTable,
    GoalRow,
    $$GoalsTableFilterComposer,
    $$GoalsTableOrderingComposer,
    $$GoalsTableCreateCompanionBuilder,
    $$GoalsTableUpdateCompanionBuilder> {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$GoalsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$GoalsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<double> targetAmount = const Value.absent(),
            Value<DateTime> targetDate = const Value.absent(),
            Value<int> colorValue = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion(
            id: id,
            name: name,
            category: category,
            targetAmount: targetAmount,
            targetDate: targetDate,
            colorValue: colorValue,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required String category,
            required double targetAmount,
            required DateTime targetDate,
            required int colorValue,
            required DateTime createdAt,
            Value<int> rowid = const Value.absent(),
          }) =>
              GoalsCompanion.insert(
            id: id,
            name: name,
            category: category,
            targetAmount: targetAmount,
            targetDate: targetDate,
            colorValue: colorValue,
            createdAt: createdAt,
            rowid: rowid,
          ),
        ));
}

class $$GoalsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get targetAmount => $state.composableBuilder(
      column: $state.table.targetAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get targetDate => $state.composableBuilder(
      column: $state.table.targetDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get colorValue => $state.composableBuilder(
      column: $state.table.colorValue,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$GoalsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get category => $state.composableBuilder(
      column: $state.table.category,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get targetAmount => $state.composableBuilder(
      column: $state.table.targetAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get targetDate => $state.composableBuilder(
      column: $state.table.targetDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get colorValue => $state.composableBuilder(
      column: $state.table.colorValue,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get createdAt => $state.composableBuilder(
      column: $state.table.createdAt,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$AssetSnapshotsTableCreateCompanionBuilder = AssetSnapshotsCompanion
    Function({
  required String id,
  required DateTime date,
  required double totalAmount,
  required String source,
  required String breakdownJson,
  Value<int> rowid,
});
typedef $$AssetSnapshotsTableUpdateCompanionBuilder = AssetSnapshotsCompanion
    Function({
  Value<String> id,
  Value<DateTime> date,
  Value<double> totalAmount,
  Value<String> source,
  Value<String> breakdownJson,
  Value<int> rowid,
});

class $$AssetSnapshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AssetSnapshotsTable,
    AssetSnapshotRow,
    $$AssetSnapshotsTableFilterComposer,
    $$AssetSnapshotsTableOrderingComposer,
    $$AssetSnapshotsTableCreateCompanionBuilder,
    $$AssetSnapshotsTableUpdateCompanionBuilder> {
  $$AssetSnapshotsTableTableManager(
      _$AppDatabase db, $AssetSnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$AssetSnapshotsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$AssetSnapshotsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<double> totalAmount = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> breakdownJson = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AssetSnapshotsCompanion(
            id: id,
            date: date,
            totalAmount: totalAmount,
            source: source,
            breakdownJson: breakdownJson,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime date,
            required double totalAmount,
            required String source,
            required String breakdownJson,
            Value<int> rowid = const Value.absent(),
          }) =>
              AssetSnapshotsCompanion.insert(
            id: id,
            date: date,
            totalAmount: totalAmount,
            source: source,
            breakdownJson: breakdownJson,
            rowid: rowid,
          ),
        ));
}

class $$AssetSnapshotsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $AssetSnapshotsTable> {
  $$AssetSnapshotsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get totalAmount => $state.composableBuilder(
      column: $state.table.totalAmount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get source => $state.composableBuilder(
      column: $state.table.source,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get breakdownJson => $state.composableBuilder(
      column: $state.table.breakdownJson,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$AssetSnapshotsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $AssetSnapshotsTable> {
  $$AssetSnapshotsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get totalAmount => $state.composableBuilder(
      column: $state.table.totalAmount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get source => $state.composableBuilder(
      column: $state.table.source,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get breakdownJson => $state.composableBuilder(
      column: $state.table.breakdownJson,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

typedef $$LifeEventsTableCreateCompanionBuilder = LifeEventsCompanion Function({
  required String id,
  required String name,
  required double amount,
  required DateTime date,
  required String type,
  Value<String?> recurrenceInterval,
  Value<int?> recurrenceMonths,
  Value<DateTime?> recurrenceEndDate,
  Value<String?> note,
  Value<int> rowid,
});
typedef $$LifeEventsTableUpdateCompanionBuilder = LifeEventsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<double> amount,
  Value<DateTime> date,
  Value<String> type,
  Value<String?> recurrenceInterval,
  Value<int?> recurrenceMonths,
  Value<DateTime?> recurrenceEndDate,
  Value<String?> note,
  Value<int> rowid,
});

class $$LifeEventsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $LifeEventsTable,
    LifeEventRow,
    $$LifeEventsTableFilterComposer,
    $$LifeEventsTableOrderingComposer,
    $$LifeEventsTableCreateCompanionBuilder,
    $$LifeEventsTableUpdateCompanionBuilder> {
  $$LifeEventsTableTableManager(_$AppDatabase db, $LifeEventsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          filteringComposer:
              $$LifeEventsTableFilterComposer(ComposerState(db, table)),
          orderingComposer:
              $$LifeEventsTableOrderingComposer(ComposerState(db, table)),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> amount = const Value.absent(),
            Value<DateTime> date = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String?> recurrenceInterval = const Value.absent(),
            Value<int?> recurrenceMonths = const Value.absent(),
            Value<DateTime?> recurrenceEndDate = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LifeEventsCompanion(
            id: id,
            name: name,
            amount: amount,
            date: date,
            type: type,
            recurrenceInterval: recurrenceInterval,
            recurrenceMonths: recurrenceMonths,
            recurrenceEndDate: recurrenceEndDate,
            note: note,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            required double amount,
            required DateTime date,
            required String type,
            Value<String?> recurrenceInterval = const Value.absent(),
            Value<int?> recurrenceMonths = const Value.absent(),
            Value<DateTime?> recurrenceEndDate = const Value.absent(),
            Value<String?> note = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              LifeEventsCompanion.insert(
            id: id,
            name: name,
            amount: amount,
            date: date,
            type: type,
            recurrenceInterval: recurrenceInterval,
            recurrenceMonths: recurrenceMonths,
            recurrenceEndDate: recurrenceEndDate,
            note: note,
            rowid: rowid,
          ),
        ));
}

class $$LifeEventsTableFilterComposer
    extends FilterComposer<_$AppDatabase, $LifeEventsTable> {
  $$LifeEventsTableFilterComposer(super.$state);
  ColumnFilters<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get recurrenceInterval => $state.composableBuilder(
      column: $state.table.recurrenceInterval,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<int> get recurrenceMonths => $state.composableBuilder(
      column: $state.table.recurrenceMonths,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<DateTime> get recurrenceEndDate => $state.composableBuilder(
      column: $state.table.recurrenceEndDate,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));

  ColumnFilters<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnFilters(column, joinBuilders: joinBuilders));
}

class $$LifeEventsTableOrderingComposer
    extends OrderingComposer<_$AppDatabase, $LifeEventsTable> {
  $$LifeEventsTableOrderingComposer(super.$state);
  ColumnOrderings<String> get id => $state.composableBuilder(
      column: $state.table.id,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get name => $state.composableBuilder(
      column: $state.table.name,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<double> get amount => $state.composableBuilder(
      column: $state.table.amount,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get date => $state.composableBuilder(
      column: $state.table.date,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get type => $state.composableBuilder(
      column: $state.table.type,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get recurrenceInterval => $state.composableBuilder(
      column: $state.table.recurrenceInterval,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<int> get recurrenceMonths => $state.composableBuilder(
      column: $state.table.recurrenceMonths,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<DateTime> get recurrenceEndDate => $state.composableBuilder(
      column: $state.table.recurrenceEndDate,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));

  ColumnOrderings<String> get note => $state.composableBuilder(
      column: $state.table.note,
      builder: (column, joinBuilders) =>
          ColumnOrderings(column, joinBuilders: joinBuilders));
}

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$AssetSnapshotsTableTableManager get assetSnapshots =>
      $$AssetSnapshotsTableTableManager(_db, _db.assetSnapshots);
  $$LifeEventsTableTableManager get lifeEvents =>
      $$LifeEventsTableTableManager(_db, _db.lifeEvents);
}
