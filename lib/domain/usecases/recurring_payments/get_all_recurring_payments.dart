import '../../entities/recurring_payment.dart';
import '../../repositories/recurring_payments_repository.dart';

class GetAllRecurringPayments {
  final RecurringPaymentsRepository repository;

  GetAllRecurringPayments(this.repository);

  Future<List<RecurringPayment>> call() {
    return repository.getAll();
  }
}

