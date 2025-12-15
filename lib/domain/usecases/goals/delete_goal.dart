import '../../repositories/goals_repository.dart';

class DeleteGoal {
  final GoalsRepository repository;

  DeleteGoal(this.repository);

  Future<void> call(String id) {
    return repository.deleteGoal(id);
  }
}

