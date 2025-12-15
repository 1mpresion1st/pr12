import '../../entities/transaction.dart';
import '../../repositories/transactions_repository.dart';

class AddTransaction {
  final TransactionsRepository repository;

  AddTransaction(this.repository);

  Future<void> call(Transaction transaction) {
    return repository.addTransaction(transaction);
  }
}

