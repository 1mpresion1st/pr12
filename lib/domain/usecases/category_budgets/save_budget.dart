import '../../entities/category_budget.dart';
import '../../repositories/category_budgets_repository.dart';

class SaveBudget {
  final CategoryBudgetsRepository repository;

  SaveBudget(this.repository);

  Future<void> call(CategoryBudget budget) {
    return repository.saveBudget(budget);
  }
}

