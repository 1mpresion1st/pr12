import '../../entities/statistics.dart';
import '../../entities/transaction.dart';
import '../../repositories/transactions_repository.dart';

class GetCategoryStats {
  final TransactionsRepository repository;

  GetCategoryStats(this.repository);

  Future<List<CategoryStats>> call({
    required StatisticsPeriod period,
    required TransactionType type,
  }) async {
    final now = DateTime.now();
    DateTime? from;
    DateTime? to = now;

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
        from = null;
        to = null;
        break;
    }

    final transactions = await repository.getTransactions(
      type: type,
      from: from,
      to: to,
    );

    final totals = <String, double>{};
    for (final t in transactions) {
      totals[t.category] = (totals[t.category] ?? 0) + t.amount;
    }

    final stats = totals.entries
        .map((e) => CategoryStats(category: e.key, totalAmount: e.value))
        .toList();

    stats.sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    return stats;
  }
}

