import '../../repositories/recurring_payments_repository.dart';

class DeleteRecurringPayment {
  final RecurringPaymentsRepository repository;

  DeleteRecurringPayment(this.repository);

  Future<void> call(String id) {
    return repository.delete(id);
  }
}

