import '../../repositories/category_budgets_repository.dart';

class DeleteBudget {
  final CategoryBudgetsRepository repository;

  DeleteBudget(this.repository);

  Future<void> call(String id) {
    return repository.deleteBudget(id);
  }
}

