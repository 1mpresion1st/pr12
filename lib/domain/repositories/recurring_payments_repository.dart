import '../entities/recurring_payment.dart';

abstract class RecurringPaymentsRepository {
  Future<List<RecurringPayment>> getAll();
  Future<RecurringPayment?> getById(String id);
  Future<void> save(RecurringPayment payment);
  Future<void> delete(String id);
}

