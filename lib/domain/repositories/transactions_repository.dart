import '../entities/transaction.dart';

abstract class TransactionsRepository {
  Future<List<Transaction>> getAllTransactions();
  Future<List<Transaction>> getTransactions({
    TransactionType? type,
    String? category,
    DateTime? from,
    DateTime? to,
    String? goalId,
  });
  Future<Transaction?> getById(String id);
  Future<void> addTransaction(Transaction transaction);
  Future<void> updateTransaction(Transaction transaction);
  Future<void> deleteTransaction(String id);
}

