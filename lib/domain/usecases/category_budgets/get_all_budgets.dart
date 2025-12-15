import '../../entities/category_budget.dart';
import '../../repositories/category_budgets_repository.dart';

class GetAllBudgets {
  final CategoryBudgetsRepository repository;

  GetAllBudgets(this.repository);

  Future<List<CategoryBudget>> call() {
    return repository.getAllBudgets();
  }
}

