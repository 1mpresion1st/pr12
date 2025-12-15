import '../../repositories/transactions_repository.dart';

class DeleteTransaction {
  final TransactionsRepository repository;

  DeleteTransaction(this.repository);

  Future<void> call(String id) {
    return repository.deleteTransaction(id);
  }
}

