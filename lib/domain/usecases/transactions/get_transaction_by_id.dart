import '../../entities/transaction.dart';
import '../../repositories/transactions_repository.dart';

class GetTransactionById {
  final TransactionsRepository repository;

  GetTransactionById(this.repository);

  Future<Transaction?> call(String id) {
    return repository.getById(id);
  }
}

