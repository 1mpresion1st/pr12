import '../../domain/entities/goal.dart' as domain_entities;
import '../../domain/repositories/goals_repository.dart';
import 'package:get_it/get_it.dart';

// Legacy model for backward compatibility
class Goal {
  final String id;
  final String name;
  final double targetAmount;
  final DateTime? targetDate;
  final String? icon;
  final String? description;
  final DateTime createdAt;

  Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.targetDate,
    this.icon,
    this.description,
    required this.createdAt,
  });

  Goal copyWith({
    String? id,
    String? name,
    double? targetAmount,
    DateTime? targetDate,
    String? icon,
    String? description,
    DateTime? createdAt,
  }) {
    return Goal(
      id: id ?? this.id,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      targetDate: targetDate ?? this.targetDate,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GoalSubtask {
  final String id;
  final String goalId;
  final String name;
  final double targetAmount;
  final int order;

  GoalSubtask({
    required this.id,
    required this.goalId,
    required this.name,
    required this.targetAmount,
    required this.order,
  });
}

class GoalsService {
  GoalsService();

  GoalsRepository get _repository => GetIt.I<GoalsRepository>();

  Future<List<Goal>> getAllGoals() async {
    final domainGoals = await _repository.getAllGoals();
    return domainGoals.map(_toLegacyModel).toList();
  }

  Future<Goal?> getGoalById(String id) async {
    final domainGoal = await _repository.getGoalById(id);
    return domainGoal != null ? _toLegacyModel(domainGoal) : null;
  }

  Future<List<GoalSubtask>> getSubtasks(String goalId) async {
    final domainSubtasks = await _repository.getSubtasks(goalId);
    return domainSubtasks.map(_toLegacySubtask).toList();
  }

  Future<void> saveGoal({
    required Goal goal,
    required List<GoalSubtask> subtasks,
  }) async {
    final domainGoal = _toDomainEntity(goal);
    final domainSubtasks = subtasks.map(_toDomainSubtask).toList();
    await _repository.saveGoal(goal: domainGoal, subtasks: domainSubtasks);
  }

  Future<void> deleteGoal(String id) async {
    await _repository.deleteGoal(id);
  }

  Goal _toLegacyModel(domain_entities.Goal domain) {
    return Goal(
      id: domain.id,
      name: domain.name,
      targetAmount: domain.targetAmount,
      targetDate: domain.targetDate,
      icon: domain.icon,
      description: domain.description,
      createdAt: domain.createdAt,
    );
  }

  domain_entities.Goal _toDomainEntity(Goal legacy) {
    return domain_entities.Goal(
      id: legacy.id,
      name: legacy.name,
      targetAmount: legacy.targetAmount,
      targetDate: legacy.targetDate,
      icon: legacy.icon,
      description: legacy.description,
      createdAt: legacy.createdAt,
    );
  }

  GoalSubtask _toLegacySubtask(domain_entities.GoalSubtask domain) {
    return GoalSubtask(
      id: domain.id,
      goalId: domain.goalId,
      name: domain.name,
      targetAmount: domain.targetAmount,
      order: domain.order,
    );
  }

  domain_entities.GoalSubtask _toDomainSubtask(GoalSubtask legacy) {
    return domain_entities.GoalSubtask(
      id: legacy.id,
      goalId: legacy.goalId,
      name: legacy.name,
      targetAmount: legacy.targetAmount,
      order: legacy.order,
    );
  }
}

