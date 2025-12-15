import '../../../domain/entities/category_budget.dart';
import '../../models/category_budget_dto.dart';

abstract class CategoryBudgetsLocalDataSource {
  Future<List<CategoryBudget>> getAllBudgets();
  Future<CategoryBudget?> getBudgetById(String id);
  Future<void> saveBudget(CategoryBudget budget);
  Future<void> deleteBudget(String id);
}

class CategoryBudgetsLocalDataSourceImpl
    implements CategoryBudgetsLocalDataSource {
  final List<CategoryBudgetDto> _items = [];

  @override
  Future<List<CategoryBudget>> getAllBudgets() async {
    return _items.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<CategoryBudget?> getBudgetById(String id) async {
    try {
      final dto = _items.firstWhere((b) => b.id == id);
      return dto.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveBudget(CategoryBudget budget) async {
    final index = _items.indexWhere((b) => b.id == budget.id);
    if (index >= 0) {
      _items[index] = CategoryBudgetDto.fromEntity(budget);
    } else {
      _items.add(CategoryBudgetDto.fromEntity(budget));
    }
  }

  @override
  Future<void> deleteBudget(String id) async {
    _items.removeWhere((b) => b.id == id);
  }
}

