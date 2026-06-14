import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import '../db/app_database.dart';
import '../models/goal.dart';

class GoalRepository {
  final AppDatabase _db;

  GoalRepository(this._db);

  Stream<List<Goal>> watchGoals() =>
      _db.watchGoals().map((rows) => rows.map(_fromRow).toList());

  Future<void> saveGoal(Goal goal) => _db.upsertGoal(GoalsCompanion(
        id: Value(goal.id),
        name: Value(goal.name),
        category: Value(goal.category.name),
        targetAmount: Value(goal.targetAmount),
        targetDate: Value(goal.targetDate),
        colorValue: Value(goal.color.value),
        createdAt: Value(goal.createdAt),
      ));

  Future<void> deleteGoal(String id) => _db.deleteGoal(id);

  Goal _fromRow(GoalRow row) => Goal(
        id: row.id,
        name: row.name,
        category: GoalCategory.values
            .firstWhere((e) => e.name == row.category, orElse: () => GoalCategory.other),
        targetAmount: row.targetAmount,
        targetDate: row.targetDate,
        color: Color(row.colorValue),
        createdAt: row.createdAt,
      );
}
