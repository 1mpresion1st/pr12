import '../entities/category_budget.dart';

abstract class CategoryBudgetsRepository {
  Future<List<CategoryBudget>> getAllBudgets();
  Future<CategoryBudget?> getBudgetById(String id);
  Future<void> saveBudget(CategoryBudget budget);
  Future<void> deleteBudget(String id);
}

