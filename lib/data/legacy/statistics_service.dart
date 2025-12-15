import '../../domain/entities/statistics.dart' as domain_entities;
import '../../domain/entities/transaction.dart' as domain_entities;
import 'transactions_service.dart';

class StatisticsPeriod {
  static const week = domain_entities.StatisticsPeriod.week;
  static const month = domain_entities.StatisticsPeriod.month;
  static const year = domain_entities.StatisticsPeriod.year;
  static const all = domain_entities.StatisticsPeriod.all;
}

class StatisticsMode {
  static const expensesByCategory = domain_entities.StatisticsMode.expensesByCategory;
  static const incomeByCategory = domain_entities.StatisticsMode.incomeByCategory;
  static const balanceDynamics = domain_entities.StatisticsMode.balanceDynamics;
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

class StatisticsService {
  StatisticsService(this._transactionsService);

  final TransactionsService _transactionsService;

  Future<List<Transaction>> getTransactionsForPeriod(domain_entities.StatisticsPeriod period) async {
    final now = DateTime.now();
    DateTime? from;
    DateTime? to = now;

    switch (period) {
      case domain_entities.StatisticsPeriod.week:
        from = now.subtract(const Duration(days: 7));
        break;
      case domain_entities.StatisticsPeriod.month:
        from = DateTime(now.year, now.month, 1);
        break;
      case domain_entities.StatisticsPeriod.year:
        from = DateTime(now.year, 1, 1);
        break;
      case domain_entities.StatisticsPeriod.all:
        from = null;
        to = null;
        break;
    }

    return await _transactionsService.getTransactions(
      from: from,
      to: to,
    );
  }

  Future<List<CategoryStats>> getCategoryStats({
    required domain_entities.StatisticsPeriod period,
    required TransactionType type,
  }) async {
    final transactions = await getTransactionsForPeriod(period);
    final filtered = transactions.where((t) => t.type == type).toList();

    final totals = <String, double>{};
    for (final t in filtered) {
      totals[t.category] = (totals[t.category] ?? 0) + t.amount;
    }

    final stats = totals.entries
        .map((e) => CategoryStats(category: e.key, totalAmount: e.value))
        .toList();

    stats.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    return stats;
  }

  Future<double> getTotalAmount({
    required domain_entities.StatisticsPeriod period,
    required TransactionType type,
  }) async {
    final transactions = await getTransactionsForPeriod(period);
    final filtered = transactions.where((t) => t.type == type).toList();
    return filtered.fold<double>(0.0, (sum, t) => sum + t.amount);
  }

  Future<double> getAverageDailyAmount({
    required domain_entities.StatisticsPeriod period,
    required TransactionType type,
  }) async {
    final total = await getTotalAmount(period: period, type: type);
    
    final now = DateTime.now();
    int days = 1;

    switch (period) {
      case domain_entities.StatisticsPeriod.week:
        days = 7;
        break;
      case domain_entities.StatisticsPeriod.month:
        final firstDay = DateTime(now.year, now.month, 1);
        days = now.difference(firstDay).inDays + 1;
        break;
      case domain_entities.StatisticsPeriod.year:
        final firstDay = DateTime(now.year, 1, 1);
        days = now.difference(firstDay).inDays + 1;
        break;
      case domain_entities.StatisticsPeriod.all:
        final transactions = await getTransactionsForPeriod(period);
        if (transactions.isEmpty) return 0.0;
        final firstDate = transactions.map((t) => t.date).reduce((a, b) => a.isBefore(b) ? a : b);
        days = now.difference(firstDate).inDays + 1;
        if (days <= 0) days = 1;
        break;
    }

    return days > 0 ? total / days : 0.0;
  }

  Future<List<DailyBalancePoint>> getBalanceDynamics({
    required domain_entities.StatisticsPeriod period,
  }) async {
    final now = DateTime.now();
    DateTime? from;

    switch (period) {
      case domain_entities.StatisticsPeriod.week:
        from = now.subtract(const Duration(days: 7));
        break;
      case domain_entities.StatisticsPeriod.month:
        from = DateTime(now.year, now.month, 1);
        break;
      case domain_entities.StatisticsPeriod.year:
        from = DateTime(now.year, 1, 1);
        break;
      case domain_entities.StatisticsPeriod.all:
        final allTransactions = await _transactionsService.getAllTransactions();
        if (allTransactions.isEmpty) return [];
        final firstDate = allTransactions.map((t) => t.date).reduce((a, b) => a.isBefore(b) ? a : b);
        from = firstDate;
        break;
    }

    final transactions = await _transactionsService.getTransactions(
      from: from,
      to: now,
    );

    if (transactions.isEmpty) return [];

    transactions.sort((a, b) => a.date.compareTo(b.date));

    final points = <DailyBalancePoint>[];
    double balance = 0.0;

    final dateMap = <DateTime, double>{};
    for (final t in transactions) {
      final dateKey = DateTime(t.date.year, t.date.month, t.date.day);
      dateMap[dateKey] = (dateMap[dateKey] ?? 0.0) + (t.type == TransactionType.income ? t.amount : -t.amount);
    }

    final sortedDates = dateMap.keys.toList()..sort();
    for (final date in sortedDates) {
      balance += dateMap[date]!;
      points.add(DailyBalancePoint(date: date, balance: balance));
    }

    return points;
  }
}

