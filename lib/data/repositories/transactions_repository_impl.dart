import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../datasources/local/transactions_local_data_source.dart';

class TransactionsRepositoryImpl implements TransactionsRepository {
  final TransactionsLocalDataSource localDataSource;

  TransactionsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Transaction>> getAllTransactions() {
    return localDataSource.getAllTransactions();
  }

  @override
  Future<List<Transaction>> getTransactions({
    TransactionType? type,
    String? category,
    DateTime? from,
    DateTime? to,
    String? goalId,
  }) {
    return localDataSource.getTransactions(
      type: type,
      category: category,
      from: from,
      to: to,
      goalId: goalId,
    );
  }

  @override
  Future<Transaction?> getById(String id) {
    return localDataSource.getById(id);
  }

  @override
  Future<void> addTransaction(Transaction transaction) {
    return localDataSource.addTransaction(transaction);
  }

  @override
  Future<void> updateTransaction(Transaction transaction) {
    return localDataSource.updateTransaction(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) {
    return localDataSource.deleteTransaction(id);
  }
}

