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
}

