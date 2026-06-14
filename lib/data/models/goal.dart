import 'package:flutter/material.dart';

enum GoalCategory { retirement, housing, education, travel, emergency, other }

class Goal {
  final String id;
  final String name;
  final GoalCategory category;
  final double targetAmount;
  final DateTime targetDate;
  final Color color;
  final DateTime createdAt;

  const Goal({
    required this.id,
    required this.name,
    required this.category,
    required this.targetAmount,
    required this.targetDate,
    required this.color,
    required this.createdAt,
  });

  Goal copyWith({
    String? name,
    GoalCategory? category,
    double? targetAmount,
    DateTime? targetDate,
    Color? color,
  }) =>
      Goal(
        id: id,
        name: name ?? this.name,
        category: category ?? this.category,
        targetAmount: targetAmount ?? this.targetAmount,
        targetDate: targetDate ?? this.targetDate,
        color: color ?? this.color,
        createdAt: createdAt,
      );
}
