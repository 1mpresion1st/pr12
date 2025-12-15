import '../../domain/entities/recurring_payment.dart';

class RecurringPaymentDto {
  final String id;
  final String name;
  final double amount;
  final RecurringPaymentFrequency frequency;
  final DateTime nextChargeDate;
  final String category;
  final bool autoCreateTransaction;
  final bool isActive;
  final DateTime createdAt;

  RecurringPaymentDto({
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'frequency': frequency.name,
      'nextChargeDate': nextChargeDate.toIso8601String(),
      'category': category,
      'autoCreateTransaction': autoCreateTransaction,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory RecurringPaymentDto.fromJson(Map<String, dynamic> json) {
    return RecurringPaymentDto(
      id: json['id'] as String,
      name: json['name'] as String,
      amount: (json['amount'] as num).toDouble(),
      frequency: RecurringPaymentFrequency.values.firstWhere(
        (e) => e.name == json['frequency'],
        orElse: () => RecurringPaymentFrequency.monthly,
      ),
      nextChargeDate: DateTime.parse(json['nextChargeDate'] as String),
      category: json['category'] as String,
      autoCreateTransaction: json['autoCreateTransaction'] as bool,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  RecurringPayment toEntity() {
    return RecurringPayment(
      id: id,
      name: name,
      amount: amount,
      frequency: frequency,
      nextChargeDate: nextChargeDate,
      category: category,
      autoCreateTransaction: autoCreateTransaction,
      isActive: isActive,
      createdAt: createdAt,
    );
  }

  factory RecurringPaymentDto.fromEntity(RecurringPayment entity) {
    return RecurringPaymentDto(
      id: entity.id,
      name: entity.name,
      amount: entity.amount,
      frequency: entity.frequency,
      nextChargeDate: entity.nextChargeDate,
      category: entity.category,
      autoCreateTransaction: entity.autoCreateTransaction,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
    );
  }
}

