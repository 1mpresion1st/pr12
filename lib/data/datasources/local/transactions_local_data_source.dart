import '../../../domain/entities/transaction.dart';
import '../../models/transaction_dto.dart';

abstract class TransactionsLocalDataSource {
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
  Future<void> initializeWithDemoData(List<Transaction> transactions);
}

class TransactionsLocalDataSourceImpl implements TransactionsLocalDataSource {
  final List<TransactionDto> _transactions = [];

  @override
  Future<void> initializeWithDemoData(List<Transaction> transactions) async {
    _transactions.clear();
    _transactions.addAll(
      transactions.map((t) => TransactionDto.fromEntity(t)),
    );
  }

  @override
  Future<List<Transaction>> getAllTransactions() async {
    return _transactions.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Transaction>> getTransactions({
    TransactionType? type,
    String? category,
    DateTime? from,
    DateTime? to,
    String? goalId,
  }) async {
    var transactions = await getAllTransactions();

    if (type != null) {
      transactions = transactions.where((t) => t.type == type).toList();
    }

    if (category != null && category.isNotEmpty) {
      transactions = transactions.where((t) => t.category == category).toList();
    }

    if (from != null) {
      transactions = transactions
          .where((t) => t.date.isAfter(from) || t.date.isAtSameMomentAs(from))
          .toList();
    }

    if (to != null) {
      transactions = transactions
          .where((t) => t.date.isBefore(to) || t.date.isAtSameMomentAs(to))
          .toList();
    }

    if (goalId != null && goalId.isNotEmpty) {
      transactions = transactions.where((t) => t.goalId == goalId).toList();
    }

    return transactions;
  }

  @override
  Future<Transaction?> getById(String id) async {
    try {
      final dto = _transactions.firstWhere((t) => t.id == id);
      return dto.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addTransaction(Transaction transaction) async {
    _transactions.add(TransactionDto.fromEntity(transaction));
  }

  @override
  Future<void> updateTransaction(Transaction transaction) async {
    final index = _transactions.indexWhere((t) => t.id == transaction.id);
    if (index >= 0) {
      _transactions[index] = TransactionDto.fromEntity(transaction);
    }
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _transactions.removeWhere((t) => t.id == id);
  }
}

