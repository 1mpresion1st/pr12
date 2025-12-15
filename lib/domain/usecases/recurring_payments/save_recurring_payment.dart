import '../../entities/recurring_payment.dart';
import '../../repositories/recurring_payments_repository.dart';

class SaveRecurringPayment {
  final RecurringPaymentsRepository repository;

  SaveRecurringPayment(this.repository);

  Future<void> call(RecurringPayment payment) {
    return repository.save(payment);
  }
}

