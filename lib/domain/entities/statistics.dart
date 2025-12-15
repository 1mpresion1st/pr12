enum StatisticsPeriod {
  week,
  month,
  year,
  all,
}

enum StatisticsMode {
  expensesByCategory,
  incomeByCategory,
  balanceDynamics,
}

class CategoryStats {
  final String category;
  final double totalAmount;

  CategoryStats({
    required this.category,
    required this.totalAmount,
  });
}

class DailyBalancePoint {
  final DateTime date;
  final double balance;

  DailyBalancePoint({
    required this.date,
    required this.balance,
  });
}

