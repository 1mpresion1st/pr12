import '../../domain/entities/category_budget.dart' as domain_entities;
import '../../domain/repositories/category_budgets_repository.dart';
import 'package:get_it/get_it.dart';

// Legacy model for backward compatibility
enum BudgetPeriod {
  monthly,
}

class CategoryBudget {
  final String id;
  final String category;
  final double limitAmount;
  final BudgetPeriod period;

  CategoryBudget({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.period,
  });

  CategoryBudget copyWith({
    String? id,
    String? category,
    double? limitAmount,
    BudgetPeriod? period,
  }) {
    return CategoryBudget(
      id: id ?? this.id,
      category: category ?? this.category,
      limitAmount: limitAmount ?? this.limitAmount,
      period: period ?? this.period,
    );
  }
}

class CategoryBudgetsService {
  CategoryBudgetsService();

  CategoryBudgetsRepository get _repository => GetIt.I<CategoryBudgetsRepository>();

  Future<List<CategoryBudget>> getAllBudgets() async {
    final domainBudgets = await _repository.getAllBudgets();
    return domainBudgets.map(_toLegacyModel).toList();
  }

  Future<CategoryBudget?> getBudgetById(String id) async {
    final domainBudget = await _repository.getBudgetById(id);
    return domainBudget != null ? _toLegacyModel(domainBudget) : null;
  }

  Future<void> saveBudget(CategoryBudget budget) async {
    final domainBudget = _toDomainEntity(budget);
    await _repository.saveBudget(domainBudget);
  }

  Future<void> deleteBudget(String id) async {
    await _repository.deleteBudget(id);
  }

  CategoryBudget _toLegacyModel(domain_entities.CategoryBudget domain) {
    return CategoryBudget(
      id: domain.id,
      category: domain.category,
      limitAmount: domain.limitAmount,
      period: _toLegacyPeriod(domain.period),
    );
  }

  domain_entities.CategoryBudget _toDomainEntity(CategoryBudget legacy) {
    return domain_entities.CategoryBudget(
      id: legacy.id,
      category: legacy.category,
      limitAmount: legacy.limitAmount,
      period: _toDomainPeriod(legacy.period),
    );
  }

  BudgetPeriod _toLegacyPeriod(domain_entities.BudgetPeriod domain) {
    return domain == domain_entities.BudgetPeriod.monthly
        ? BudgetPeriod.monthly
        : BudgetPeriod.monthly;
  }

  domain_entities.BudgetPeriod _toDomainPeriod(BudgetPeriod legacy) {
    return legacy == BudgetPeriod.monthly
        ? domain_entities.BudgetPeriod.monthly
        : domain_entities.BudgetPeriod.monthly;
  }
}

