import '../../data/legacy/category_budgets_service.dart';

class CategoryBudgetWithProgress {
  final CategoryBudget budget;
  final double spentAmount;

  CategoryBudgetWithProgress({
    required this.budget,
    required this.spentAmount,
  });

  double get progress {
    if (budget.limitAmount <= 0) return 0;
    return spentAmount / budget.limitAmount;
  }

  bool get isExceeded => spentAmount > budget.limitAmount;
}

