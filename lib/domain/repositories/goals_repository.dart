import '../entities/goal.dart';

abstract class GoalsRepository {
  Future<List<Goal>> getAllGoals();
  Future<Goal?> getGoalById(String id);
  Future<List<GoalSubtask>> getSubtasks(String goalId);
  Future<void> saveGoal({
    required Goal goal,
    required List<GoalSubtask> subtasks,
  });
  Future<void> deleteGoal(String id);
}

