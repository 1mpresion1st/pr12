import 'recurring_payment.dart';

extension RecurringPaymentExtensions on RecurringPayment {
  /// Приводим стоимость к "в месяц" для отображения суммарного расхода.
  double get monthlyCost {
    switch (frequency) {
      case RecurringPaymentFrequency.weekly:
        // грубо: 52 недели / 12 месяцев
        return amount * (52 / 12);
      case RecurringPaymentFrequency.monthly:
        return amount;
      case RecurringPaymentFrequency.yearly:
        return amount / 12;
    }
  }
}

