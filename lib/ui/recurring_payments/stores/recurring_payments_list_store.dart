import 'package:mobx/mobx.dart';
import '../../../../data/legacy/recurring_payments_service.dart';
import '../../../../data/legacy/transactions_service.dart';

part 'recurring_payments_list_store.g.dart';

class RecurringPaymentsListStore = _RecurringPaymentsListStore
    with _$RecurringPaymentsListStore;

abstract class _RecurringPaymentsListStore with Store {
  _RecurringPaymentsListStore(
    this._recurringPaymentsService,
    this._transactionsService,
  );

  final RecurringPaymentsService _recurringPaymentsService;
  final TransactionsService _transactionsService;

  @observable
  bool isLoading = false;

  @observable
  ObservableList<RecurringPayment> items =
      ObservableList<RecurringPayment>.of([]);

  @observable
  String? errorMessage;

  /// Платежи, которые "должны были списаться" к текущей дате
  @observable
  ObservableList<RecurringPayment> duePayments =
      ObservableList<RecurringPayment>.of([]);

  /// Флаг, чтобы не показывать диалог о просроченных платежах многократно
  @observable
  bool hasShownDueDialog = false;

  @computed
  double get totalMonthlyCost {
    return items.fold<double>(
      0.0,
      (prev, p) {
        if (!p.isActive) return prev;
        switch (p.frequency) {
          case RecurringPaymentFrequency.weekly:
            return prev + (p.amount * 4.33); // ~4.33 weeks per month
          case RecurringPaymentFrequency.monthly:
            return prev + p.amount;
          case RecurringPaymentFrequency.yearly:
            return prev + (p.amount / 12);
        }
      },
    );
  }

  @action
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;

    try {
      final all = await _recurringPaymentsService.getAll();
      items
        ..clear()
        ..addAll(all);

      _updateDuePayments();
    } catch (e) {
      errorMessage = 'Ошибка при загрузке регулярных платежей';
      // Не очищаем items при ошибке, оставляем предыдущие данные
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> refresh() async {
    await load();
  }

  @action
  void _updateDuePayments() {
    final now = DateTime.now();
    final list = items
        .where(
          (p) =>
              p.isActive &&
              !p.nextChargeDate.isAfter(
                DateTime(now.year, now.month, now.day, 23, 59, 59),
              ),
        )
        .toList();

    duePayments
      ..clear()
      ..addAll(list);
  }

  /// Вызывается при входе на экран или из HomeScreen, чтобы проверить,
  /// есть ли платежи, по которым нужно предложить создать операции.
  @action
  Future<void> checkDuePayments() async {
    // предполагаем, что items уже загружены (load() вызвали до этого)
    _updateDuePayments();
  }

  /// Создать операции Transaction для всех платежей из duePayments.
  /// Возвращает true, если операции созданы без ошибок.
  @action
  Future<bool> createTransactionsForDuePayments() async {
    if (duePayments.isEmpty) return true;

    try {
      for (final payment in duePayments) {
        if (!payment.autoCreateTransaction) {
          continue;
        }

        final t = Transaction(
          id: DateTime.now().millisecondsSinceEpoch.toString() +
              payment.id,
          amount: payment.amount,
          type: TransactionType.expense,
          category: payment.category,
          date: DateTime.now(),
          note: payment.name,
        );

        await _transactionsService.addTransaction(t);

        // обновляем nextChargeDate
        final updated = payment.copyWith(
          nextChargeDate: _calculateNextChargeDate(payment),
        );
        await _recurringPaymentsService.save(updated);

        // также обновляем его в локальном списке
        final index = items.indexWhere((p) => p.id == payment.id);
        if (index != -1) {
          items[index] = updated;
        }
      }

      // После генерации операций пересчитываем duePayments
      _updateDuePayments();
      return true;
    } catch (e) {
      errorMessage = 'Ошибка при создании операций для регулярных платежей';
      return false;
    }
  }

  DateTime _calculateNextChargeDate(RecurringPayment payment) {
    switch (payment.frequency) {
      case RecurringPaymentFrequency.weekly:
        return payment.nextChargeDate.add(const Duration(days: 7));
      case RecurringPaymentFrequency.monthly:
        return DateTime(
          payment.nextChargeDate.year,
          payment.nextChargeDate.month + 1,
          payment.nextChargeDate.day,
        );
      case RecurringPaymentFrequency.yearly:
        return DateTime(
          payment.nextChargeDate.year + 1,
          payment.nextChargeDate.month,
          payment.nextChargeDate.day,
        );
    }
  }
}

