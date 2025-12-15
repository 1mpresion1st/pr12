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

