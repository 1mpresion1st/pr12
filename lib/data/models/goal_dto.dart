import '../../domain/entities/goal.dart';

class GoalDto {
  final String id;
  final String name;
  final double targetAmount;
  final DateTime? targetDate;
  final String? icon;
  final String? description;
  final DateTime createdAt;

  GoalDto({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.targetDate,
    this.icon,
    this.description,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetAmount': targetAmount,
      'targetDate': targetDate?.toIso8601String(),
      'icon': icon,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory GoalDto.fromJson(Map<String, dynamic> json) {
    return GoalDto(
      id: json['id'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      targetDate: json['targetDate'] != null
          ? DateTime.parse(json['targetDate'] as String)
          : null,
      icon: json['icon'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Goal toEntity() {
    return Goal(
      id: id,
      name: name,
      targetAmount: targetAmount,
      targetDate: targetDate,
      icon: icon,
      description: description,
      createdAt: createdAt,
    );
  }

  factory GoalDto.fromEntity(Goal entity) {
    return GoalDto(
      id: entity.id,
      name: entity.name,
      targetAmount: entity.targetAmount,
      targetDate: entity.targetDate,
      icon: entity.icon,
      description: entity.description,
      createdAt: entity.createdAt,
    );
  }
}

class GoalSubtaskDto {
  final String id;
  final String goalId;
  final String name;
  final double targetAmount;
  final int order;

  GoalSubtaskDto({
    required this.id,
    required this.goalId,
    required this.name,
    required this.targetAmount,
    required this.order,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'goalId': goalId,
      'name': name,
      'targetAmount': targetAmount,
      'order': order,
    };
  }

  factory GoalSubtaskDto.fromJson(Map<String, dynamic> json) {
    return GoalSubtaskDto(
      id: json['id'] as String,
      goalId: json['goalId'] as String,
      name: json['name'] as String,
      targetAmount: (json['targetAmount'] as num).toDouble(),
      order: json['order'] as int,
    );
  }

  GoalSubtask toEntity() {
    return GoalSubtask(
      id: id,
      goalId: goalId,
      name: name,
      targetAmount: targetAmount,
      order: order,
    );
  }

  factory GoalSubtaskDto.fromEntity(GoalSubtask entity) {
    return GoalSubtaskDto(
      id: entity.id,
      goalId: entity.goalId,
      name: entity.name,
      targetAmount: entity.targetAmount,
      order: entity.order,
    );
  }
}

