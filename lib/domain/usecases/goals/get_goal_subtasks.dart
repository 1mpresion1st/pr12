import '../../entities/goal.dart';
import '../../repositories/goals_repository.dart';

class GetGoalSubtasks {
  final GoalsRepository repository;

  GetGoalSubtasks(this.repository);

  Future<List<GoalSubtask>> call(String goalId) {
    return repository.getSubtasks(goalId);
  }
}

