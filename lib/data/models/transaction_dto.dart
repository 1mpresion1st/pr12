import '../../domain/entities/transaction.dart';

class TransactionDto {
  final String id;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final String category;
  final String? note;
  final String? goalId;
  final String? budgetId;
  final String? attachmentId;

  TransactionDto({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'date': date.toIso8601String(),
      'type': type.name,
      'category': category,
      'note': note,
      'goalId': goalId,
      'budgetId': budgetId,
      'attachmentId': attachmentId,
    };
  }

  factory TransactionDto.fromJson(Map<String, dynamic> json) {
    return TransactionDto(
      id: json['id'] as String,
      amount: (json['amount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      type: TransactionType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => TransactionType.expense,
      ),
      category: json['category'] as String,
      note: json['note'] as String?,
      goalId: json['goalId'] as String?,
      budgetId: json['budgetId'] as String?,
      attachmentId: json['attachmentId'] as String?,
    );
  }

  Transaction toEntity() {
    return Transaction(
      id: id,
      amount: amount,
      date: date,
      type: type,
      category: category,
      note: note,
      goalId: goalId,
      budgetId: budgetId,
      attachmentId: attachmentId,
    );
  }

  factory TransactionDto.fromEntity(Transaction entity) {
    return TransactionDto(
      id: entity.id,
      amount: entity.amount,
      date: entity.date,
      type: entity.type,
      category: entity.category,
      note: entity.note,
      goalId: entity.goalId,
      budgetId: entity.budgetId,
      attachmentId: entity.attachmentId,
    );
  }
}

