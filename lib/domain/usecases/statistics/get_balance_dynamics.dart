import '../../entities/statistics.dart';
import '../../entities/transaction.dart';
import '../../repositories/transactions_repository.dart';

class GetBalanceDynamics {
  final TransactionsRepository repository;

  GetBalanceDynamics(this.repository);

  Future<List<DailyBalancePoint>> call({
    required StatisticsPeriod period,
  }) async {
    final now = DateTime.now();
    DateTime? from;

    switch (period) {
      case StatisticsPeriod.week:
        from = now.subtract(const Duration(days: 7));
        break;
      case StatisticsPeriod.month:
        from = DateTime(now.year, now.month, 1);
        break;
      case StatisticsPeriod.year:
        from = DateTime(now.year, 1, 1);
        break;
      case StatisticsPeriod.all:
        final allTransactions = await repository.getAllTransactions();
        if (allTransactions.isEmpty) return [];
        final firstDate = allTransactions
            .map((t) => t.date)
            .reduce((a, b) => a.isBefore(b) ? a : b);
        from = firstDate;
        break;
    }

    final transactions = await repository.getTransactions(
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
      dateMap[dateKey] = (dateMap[dateKey] ?? 0.0) +
          (t.type == TransactionType.income ? t.amount : -t.amount);
    }

    final sortedDates = dateMap.keys.toList()..sort();
    for (final date in sortedDates) {
      balance += dateMap[date]!;
      points.add(DailyBalancePoint(date: date, balance: balance));
    }

    return points;
  }
}

