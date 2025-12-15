enum RecurringPaymentFrequency {
  weekly,
  monthly,
  yearly,
}

class RecurringPayment {
  final String id;
  final String name;
  final double amount;
  final RecurringPaymentFrequency frequency;
  final DateTime nextChargeDate;
  final String category;
  final bool autoCreateTransaction;
  final bool isActive;
  final DateTime createdAt;

  RecurringPayment({
    required this.id,
    required this.name,
    required this.amount,
    required this.frequency,
    required this.nextChargeDate,
    required this.category,
    required this.autoCreateTransaction,
    required this.isActive,
    required this.createdAt,
  });
}

