import '../../domain/entities/recurring_payment.dart';
import '../../domain/repositories/recurring_payments_repository.dart';
import '../datasources/local/recurring_payments_local_data_source.dart';

class RecurringPaymentsRepositoryImpl
    implements RecurringPaymentsRepository {
  final RecurringPaymentsLocalDataSource localDataSource;

  RecurringPaymentsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<RecurringPayment>> getAll() {
    return localDataSource.getAll();
  }

  @override
  Future<RecurringPayment?> getById(String id) {
    return localDataSource.getById(id);
  }

  @override
  Future<void> save(RecurringPayment payment) {
    return localDataSource.save(payment);
  }

  @override
  Future<void> delete(String id) {
    return localDataSource.delete(id);
  }
}

