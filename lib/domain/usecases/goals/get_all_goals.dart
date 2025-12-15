import '../../entities/goal.dart';
import '../../repositories/goals_repository.dart';

class GetAllGoals {
  final GoalsRepository repository;

  GetAllGoals(this.repository);

  Future<List<Goal>> call() {
    return repository.getAllGoals();
  }
}

