import 'package:mobx/mobx.dart';
import '../../../../data/legacy/recurring_payments_service.dart';

part 'add_recurring_payment_store.g.dart';

class AddRecurringPaymentStore = _AddRecurringPaymentStore
    with _$AddRecurringPaymentStore;

abstract class _AddRecurringPaymentStore with Store {
  _AddRecurringPaymentStore(
    this._recurringPaymentsService, {
    RecurringPayment? initialPayment,
  }) : _initialPayment = initialPayment {
    if (initialPayment != null) {
      name = initialPayment.name;
      amountText = initialPayment.amount.toString();
      frequency = initialPayment.frequency;
      nextChargeDate = initialPayment.nextChargeDate;
      category = initialPayment.category;
      autoCreateTransaction = initialPayment.autoCreateTransaction;
      isActive = initialPayment.isActive;
    } else {
      nextChargeDate = DateTime.now();
      frequency = RecurringPaymentFrequency.monthly;
      autoCreateTransaction = true;
      isActive = true;
    }
  }

  final RecurringPaymentsService _recurringPaymentsService;
  final RecurringPayment? _initialPayment;

  @observable
  String name = '';

  @observable
  String amountText = '';

  @observable
  RecurringPaymentFrequency frequency = RecurringPaymentFrequency.monthly;

  @observable
  DateTime nextChargeDate = DateTime.now();

  @observable
  String category = '';

  @observable
  bool autoCreateTransaction = true;

  @observable
  bool isActive = true;

  @observable
  bool isSaving = false;

  @observable
  String? errorMessage;

  @computed
  bool get isEditMode => _initialPayment != null;

  @computed
  double? get amount {
    final value = double.tryParse(amountText.replaceAll(',', '.'));
    if (value == null || value <= 0) return null;
    return value;
  }

  @action
  void setName(String value) => name = value;

  @action
  void setAmountText(String value) => amountText = value;

  @action
  void setFrequency(RecurringPaymentFrequency value) => frequency = value;

  @action
  void setNextChargeDate(DateTime value) => nextChargeDate = value;

  @action
  void setCategory(String value) => category = value;

  @action
  void setAutoCreateTransaction(bool value) =>
      autoCreateTransaction = value;

  @action
  void setIsActive(bool value) => isActive = value;

  @action
  Future<bool> save() async {
    if (name.trim().isEmpty || amount == null || category.trim().isEmpty) {
      errorMessage = 'Заполните название, категорию и сумму > 0';
      return false;
    }

    isSaving = true;
    errorMessage = null;

    try {
      final id = _initialPayment?.id ??
          DateTime.now().millisecondsSinceEpoch.toString();

      final payment = RecurringPayment(
        id: id,
        name: name.trim(),
        amount: amount ?? 0.0,
        frequency: frequency,
        nextChargeDate: nextChargeDate,
        category: category.trim(),
        autoCreateTransaction: autoCreateTransaction,
        isActive: isActive,
        createdAt: _initialPayment?.createdAt ?? DateTime.now(),
      );

      await _recurringPaymentsService.save(payment);

      return true;
    } catch (e) {
      errorMessage = 'Ошибка при сохранении регулярного платежа';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> delete() async {
    if (_initialPayment == null) return false;

    isSaving = true;
    errorMessage = null;

    try {
      await _recurringPaymentsService.delete(_initialPayment.id);
      return true;
    } catch (e) {
      errorMessage = 'Ошибка при удалении регулярного платежа';
      return false;
    } finally {
      isSaving = false;
    }
  }
}

