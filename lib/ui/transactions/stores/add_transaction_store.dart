import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/entities/attachment.dart';
import '../../../../domain/usecases/transactions/add_transaction.dart';
import '../../../../domain/usecases/attachments/add_attachment.dart';
import '../../../../domain/usecases/secure_storage/read_secure_value.dart';
import '../../../../domain/usecases/secure_storage/write_secure_value.dart';
import '../../../../domain/usecases/secure_storage/delete_secure_value.dart';

part 'add_transaction_store.g.dart';

class AddTransactionStore = _AddTransactionStore with _$AddTransactionStore;

abstract class _AddTransactionStore with Store {
  _AddTransactionStore(
    this._addTransaction,
    this._addAttachment,
    this._readSecureValue,
    this._writeSecureValue,
    this._deleteSecureValue,
  );

  final AddTransaction _addTransaction;
  final AddAttachment _addAttachment;
  final ReadSecureValue _readSecureValue;
  final WriteSecureValue _writeSecureValue;
  final DeleteSecureValue _deleteSecureValue;

  Timer? _amountDebounceTimer;
  Timer? _noteDebounceTimer;

  static const String _amountKey = 'pr12:add_transaction:amount';
  static const String _noteKey = 'pr12:add_transaction:note';

  @observable
  String amountText = '';

  @observable
  double? amount;

  @observable
  TransactionType type = TransactionType.expense;

  @observable
  String? category;

  @observable
  DateTime date = DateTime.now();

  @observable
  String noteText = '';

  @observable
  String? note;

  @observable
  String? goalId;

  @observable
  bool isSaving = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<String> pendingAttachmentPaths =
      ObservableList<String>.of([]);

  @action
  Future<void> init() async {
    try {
      final savedAmount = await _readSecureValue(_amountKey);
      final savedNote = await _readSecureValue(_noteKey);
      
      if (savedAmount != null && savedAmount.isNotEmpty) {
        amountText = savedAmount;
        amount = double.tryParse(savedAmount.replaceAll(',', '.'));
      }
      
      if (savedNote != null && savedNote.isNotEmpty) {
        noteText = savedNote;
        note = savedNote.isEmpty ? null : savedNote;
      }
    } catch (e) {
      // Игнорируем ошибки при чтении из secure storage
    }
  }

  @action
  void onAmountChanged(String value) {
    amountText = value;
    amount = double.tryParse(value.replaceAll(',', '.'));
    
    // Debounce сохранения в secure storage
    _amountDebounceTimer?.cancel();
    _amountDebounceTimer = Timer(const Duration(milliseconds: 400), () {
      _writeSecureValue(_amountKey, value).catchError((_) {
        // Игнорируем ошибки при записи в secure storage
      });
    });
  }

  @action
  void onNoteChanged(String value) {
    noteText = value;
    note = value.isEmpty ? null : value;
    
    // Debounce сохранения в secure storage
    _noteDebounceTimer?.cancel();
    _noteDebounceTimer = Timer(const Duration(milliseconds: 400), () {
      _writeSecureValue(_noteKey, value).catchError((_) {
        // Игнорируем ошибки при записи в secure storage
      });
    });
  }

  @action
  void setAmount(double? value) => amount = value;

  @action
  void setType(TransactionType value) => type = value;

  @action
  void setCategory(String? value) => category = value;

  @action
  void setDate(DateTime value) => date = value;

  @action
  void setNote(String? value) => note = value;

  @action
  void setGoalId(String? value) => goalId = value;

  @action
  void addPendingAttachmentPath(String path) {
    pendingAttachmentPaths.add(path);
  }

  @action
  void removePendingAttachmentPath(String path) {
    pendingAttachmentPaths.remove(path);
  }

  @action
  Future<void> onSavedSuccessfully() async {
    // Отменяем таймеры debounce перед очисткой
    _amountDebounceTimer?.cancel();
    _noteDebounceTimer?.cancel();
    
    try {
      await _deleteSecureValue(_amountKey);
      await _deleteSecureValue(_noteKey);
    } catch (e) {
      // Игнорируем ошибки при удалении из secure storage
    }
  }

  @action
  Future<bool> save() async {
    if (amount == null || amount! <= 0 || category == null || category!.isEmpty) {
      errorMessage = 'Заполните сумму и категорию';
      return false;
    }

    isSaving = true;
    errorMessage = null;
    try {
      final transaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount!,
        type: type,
        category: category!,
        date: date,
        note: note,
        goalId: goalId,
      );
      await _addTransaction(transaction);

      final transactionId = transaction.id;
      for (final path in pendingAttachmentPaths) {
        final attachment = Attachment(
          id: '${transactionId}_${DateTime.now().millisecondsSinceEpoch}',
          transactionId: transactionId,
          path: path,
          type: AttachmentType.receipt,
          createdAt: DateTime.now(),
        );
        await _addAttachment(attachment);
      }

      // Очищаем secure storage после успешного сохранения
      await onSavedSuccessfully();

      return true;
    } catch (e) {
      errorMessage = 'Ошибка при сохранении операции';
      return false;
    } finally {
      isSaving = false;
    }
  }

  void dispose() {
    _amountDebounceTimer?.cancel();
    _noteDebounceTimer?.cancel();
  }
}

