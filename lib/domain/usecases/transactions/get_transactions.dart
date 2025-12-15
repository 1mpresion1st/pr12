import '../../entities/transaction.dart';
import '../../repositories/transactions_repository.dart';

class GetTransactions {
  final TransactionsRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call({
    TransactionType? type,
    String? category,
    DateTime? from,
    DateTime? to,
    String? goalId,
  }) {
    return repository.getTransactions(
      type: type,
      category: category,
      from: from,
      to: to,
      goalId: goalId,
    );
  }
}

