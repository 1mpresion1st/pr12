import '../../domain/entities/category_budget.dart';
import '../../domain/repositories/category_budgets_repository.dart';
import '../datasources/local/category_budgets_local_data_source.dart';

class CategoryBudgetsRepositoryImpl implements CategoryBudgetsRepository {
  final CategoryBudgetsLocalDataSource localDataSource;

  CategoryBudgetsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<CategoryBudget>> getAllBudgets() {
    return localDataSource.getAllBudgets();
  }

  @override
  Future<CategoryBudget?> getBudgetById(String id) {
    return localDataSource.getBudgetById(id);
  }

  @override
  Future<void> saveBudget(CategoryBudget budget) {
    return localDataSource.saveBudget(budget);
  }

  @override
  Future<void> deleteBudget(String id) {
    return localDataSource.deleteBudget(id);
  }
}

