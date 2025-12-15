import '../../entities/goal.dart';
import '../../repositories/goals_repository.dart';

class SaveGoal {
  final GoalsRepository repository;

  SaveGoal(this.repository);

  Future<void> call({
    required Goal goal,
    required List<GoalSubtask> subtasks,
  }) {
    return repository.saveGoal(goal: goal, subtasks: subtasks);
  }
}

