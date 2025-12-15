import '../../domain/entities/goal.dart';
import '../../domain/repositories/goals_repository.dart';
import '../datasources/local/goals_local_data_source.dart';

class GoalsRepositoryImpl implements GoalsRepository {
  final GoalsLocalDataSource localDataSource;

  GoalsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Goal>> getAllGoals() {
    return localDataSource.getAllGoals();
  }

  @override
  Future<Goal?> getGoalById(String id) {
    return localDataSource.getGoalById(id);
  }

  @override
  Future<List<GoalSubtask>> getSubtasks(String goalId) {
    return localDataSource.getSubtasks(goalId);
  }

  @override
  Future<void> saveGoal({
    required Goal goal,
    required List<GoalSubtask> subtasks,
  }) {
    return localDataSource.saveGoal(goal: goal, subtasks: subtasks);
  }

  @override
  Future<void> deleteGoal(String id) {
    return localDataSource.deleteGoal(id);
  }
}

