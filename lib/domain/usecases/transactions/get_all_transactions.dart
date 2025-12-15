import '../../entities/transaction.dart';
import '../../repositories/transactions_repository.dart';

class GetAllTransactions {
  final TransactionsRepository repository;

  GetAllTransactions(this.repository);

  Future<List<Transaction>> call() {
    return repository.getAllTransactions();
  }
}

