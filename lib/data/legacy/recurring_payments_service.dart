import '../../domain/entities/recurring_payment.dart' as domain_entities;
import '../../domain/repositories/recurring_payments_repository.dart';
import 'package:get_it/get_it.dart';

// Legacy model for backward compatibility
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

  RecurringPayment copyWith({
    String? id,
    String? name,
    double? amount,
    RecurringPaymentFrequency? frequency,
    DateTime? nextChargeDate,
    String? category,
    bool? autoCreateTransaction,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return RecurringPayment(
      id: id ?? this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      frequency: frequency ?? this.frequency,
      nextChargeDate: nextChargeDate ?? this.nextChargeDate,
      category: category ?? this.category,
      autoCreateTransaction: autoCreateTransaction ?? this.autoCreateTransaction,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class RecurringPaymentsService {
  RecurringPaymentsService();

  RecurringPaymentsRepository get _repository => GetIt.I<RecurringPaymentsRepository>();

  Future<List<RecurringPayment>> getAll() async {
    final domainPayments = await _repository.getAll();
    return domainPayments.map(_toLegacyModel).toList();
  }

  Future<RecurringPayment?> getById(String id) async {
    final domainPayment = await _repository.getById(id);
    return domainPayment != null ? _toLegacyModel(domainPayment) : null;
  }

  Future<void> save(RecurringPayment payment) async {
    final domainPayment = _toDomainEntity(payment);
    await _repository.save(domainPayment);
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
  }

  RecurringPayment _toLegacyModel(domain_entities.RecurringPayment domain) {
    return RecurringPayment(
      id: domain.id,
      name: domain.name,
      amount: domain.amount,
      frequency: _toLegacyFrequency(domain.frequency),
      nextChargeDate: domain.nextChargeDate,
      category: domain.category,
      autoCreateTransaction: domain.autoCreateTransaction,
      isActive: domain.isActive,
      createdAt: domain.createdAt,
    );
  }

  domain_entities.RecurringPayment _toDomainEntity(RecurringPayment legacy) {
    return domain_entities.RecurringPayment(
      id: legacy.id,
      name: legacy.name,
      amount: legacy.amount,
      frequency: _toDomainFrequency(legacy.frequency),
      nextChargeDate: legacy.nextChargeDate,
      category: legacy.category,
      autoCreateTransaction: legacy.autoCreateTransaction,
      isActive: legacy.isActive,
      createdAt: legacy.createdAt,
    );
  }

  RecurringPaymentFrequency _toLegacyFrequency(domain_entities.RecurringPaymentFrequency domain) {
    switch (domain) {
      case domain_entities.RecurringPaymentFrequency.weekly:
        return RecurringPaymentFrequency.weekly;
      case domain_entities.RecurringPaymentFrequency.monthly:
        return RecurringPaymentFrequency.monthly;
      case domain_entities.RecurringPaymentFrequency.yearly:
        return RecurringPaymentFrequency.yearly;
    }
  }

  domain_entities.RecurringPaymentFrequency _toDomainFrequency(RecurringPaymentFrequency legacy) {
    switch (legacy) {
      case RecurringPaymentFrequency.weekly:
        return domain_entities.RecurringPaymentFrequency.weekly;
      case RecurringPaymentFrequency.monthly:
        return domain_entities.RecurringPaymentFrequency.monthly;
      case RecurringPaymentFrequency.yearly:
        return domain_entities.RecurringPaymentFrequency.yearly;
    }
  }
}

