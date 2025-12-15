import '../../domain/entities/transaction.dart' as domain_entities;
import '../../domain/repositories/transactions_repository.dart';
import 'package:get_it/get_it.dart';

// Legacy model for backward compatibility
enum TransactionType {
  income,
  expense,
}

class Transaction {
  final String id;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String? note;
  final String? goalId;
  final String? budgetId;
  final String? attachmentId;

  Transaction({
    required this.id,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
    this.note,
    this.goalId,
    this.budgetId,
    this.attachmentId,
  });

  Transaction copyWith({
    String? id,
    double? amount,
    DateTime? date,
    TransactionType? type,
    String? category,
    String? note,
    String? goalId,
    String? budgetId,
    String? attachmentId,
  }) {
    return Transaction(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      type: type ?? this.type,
      category: category ?? this.category,
      note: note ?? this.note,
      goalId: goalId ?? this.goalId,
      budgetId: budgetId ?? this.budgetId,
      attachmentId: attachmentId ?? this.attachmentId,
    );
  }
}

class TransactionsService {
  TransactionsService();

  TransactionsRepository get _repository => GetIt.I<TransactionsRepository>();

  Future<List<Transaction>> getAllTransactions() async {
    final domainTransactions = await _repository.getAllTransactions();
    return domainTransactions.map(_toLegacyModel).toList();
  }

  Future<List<Transaction>> getTransactions({
    TransactionType? type,
    String? category,
    DateTime? from,
    DateTime? to,
    String? goalId,
  }) async {
    final domainType = type != null ? _toDomainType(type) : null;
    final domainTransactions = await _repository.getTransactions(
      type: domainType,
      category: category,
      from: from,
      to: to,
      goalId: goalId,
    );
    return domainTransactions.map(_toLegacyModel).toList();
  }

  Future<Transaction?> getById(String id) async {
    final domainTransaction = await _repository.getById(id);
    return domainTransaction != null ? _toLegacyModel(domainTransaction) : null;
  }

  Future<void> addTransaction(Transaction transaction) async {
    final domainTransaction = _toDomainEntity(transaction);
    await _repository.addTransaction(domainTransaction);
  }

  Future<void> updateTransaction(Transaction transaction) async {
    final domainTransaction = _toDomainEntity(transaction);
    await _repository.updateTransaction(domainTransaction);
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
  }

  Transaction _toLegacyModel(domain_entities.Transaction domain) {
    return Transaction(
      id: domain.id,
      amount: domain.amount,
      date: domain.date,
      type: _toLegacyType(domain.type),
      category: domain.category,
      note: domain.note,
      goalId: domain.goalId,
      budgetId: domain.budgetId,
      attachmentId: domain.attachmentId,
    );
  }

  domain_entities.Transaction _toDomainEntity(Transaction legacy) {
    return domain_entities.Transaction(
      id: legacy.id,
      amount: legacy.amount,
      date: legacy.date,
      type: _toDomainType(legacy.type),
      category: legacy.category,
      note: legacy.note,
      goalId: legacy.goalId,
      budgetId: legacy.budgetId,
      attachmentId: legacy.attachmentId,
    );
  }

  domain_entities.TransactionType _toDomainType(TransactionType legacy) {
    return legacy == TransactionType.income
        ? domain_entities.TransactionType.income
        : domain_entities.TransactionType.expense;
  }

  TransactionType _toLegacyType(domain_entities.TransactionType domain) {
    return domain == domain_entities.TransactionType.income
        ? TransactionType.income
        : TransactionType.expense;
  }
}

