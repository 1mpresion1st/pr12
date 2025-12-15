import '../../../domain/entities/recurring_payment.dart';
import '../../models/recurring_payment_dto.dart';

abstract class RecurringPaymentsLocalDataSource {
  Future<List<RecurringPayment>> getAll();
  Future<RecurringPayment?> getById(String id);
  Future<void> save(RecurringPayment payment);
  Future<void> delete(String id);
}

class RecurringPaymentsLocalDataSourceImpl
    implements RecurringPaymentsLocalDataSource {
  final List<RecurringPaymentDto> _items = [];

  @override
  Future<List<RecurringPayment>> getAll() async {
    return _items.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<RecurringPayment?> getById(String id) async {
    try {
      final dto = _items.firstWhere((p) => p.id == id);
      return dto.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> save(RecurringPayment payment) async {
    final index = _items.indexWhere((p) => p.id == payment.id);
    if (index != -1) {
      _items[index] = RecurringPaymentDto.fromEntity(payment);
    } else {
      _items.add(RecurringPaymentDto.fromEntity(payment));
    }
  }

  @override
  Future<void> delete(String id) async {
    _items.removeWhere((p) => p.id == id);
  }
}

