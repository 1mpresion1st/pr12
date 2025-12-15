import '../../entities/transaction.dart';
import '../../repositories/transactions_repository.dart';

class UpdateTransaction {
  final TransactionsRepository repository;

  UpdateTransaction(this.repository);

  Future<void> call(Transaction transaction) {
    return repository.updateTransaction(transaction);
  }
}

