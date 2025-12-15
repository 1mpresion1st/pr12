import '../../entities/recurring_payment.dart';
import '../../repositories/recurring_payments_repository.dart';

class GetRecurringPaymentById {
  final RecurringPaymentsRepository repository;

  GetRecurringPaymentById(this.repository);

  Future<RecurringPayment?> call(String id) {
    return repository.getById(id);
  }
}

