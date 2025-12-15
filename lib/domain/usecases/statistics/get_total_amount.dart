import '../../entities/statistics.dart';
import '../../entities/transaction.dart';
import '../../repositories/transactions_repository.dart';

class GetTotalAmount {
  final TransactionsRepository repository;

  GetTotalAmount(this.repository);

  Future<double> call({
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

    return transactions.fold<double>(0.0, (sum, t) => sum + t.amount);
  }
}

