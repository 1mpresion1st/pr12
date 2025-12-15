import '../../entities/goal.dart';
import '../../repositories/goals_repository.dart';

class GetGoalById {
  final GoalsRepository repository;

  GetGoalById(this.repository);

  Future<Goal?> call(String id) {
    return repository.getGoalById(id);
  }
}

