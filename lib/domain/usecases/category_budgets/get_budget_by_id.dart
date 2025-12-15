import '../../entities/category_budget.dart';
import '../../repositories/category_budgets_repository.dart';

class GetBudgetById {
  final CategoryBudgetsRepository repository;

  GetBudgetById(this.repository);

  Future<CategoryBudget?> call(String id) {
    return repository.getBudgetById(id);
  }
}

