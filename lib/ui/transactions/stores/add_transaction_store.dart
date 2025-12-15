import 'package:mobx/mobx.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/entities/attachment.dart';
import '../../../../domain/usecases/transactions/add_transaction.dart';
import '../../../../domain/usecases/attachments/add_attachment.dart';

part 'add_transaction_store.g.dart';

class AddTransactionStore = _AddTransactionStore with _$AddTransactionStore;

abstract class _AddTransactionStore with Store {
  _AddTransactionStore(
    this._addTransaction,
    this._addAttachment,
  );

  final AddTransaction _addTransaction;
  final AddAttachment _addAttachment;

  @observable
  double? amount;

  @observable
  TransactionType type = TransactionType.expense;

  @observable
  String? category;

  @observable
  DateTime date = DateTime.now();

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

      return true;
    } catch (e) {
      errorMessage = 'Ошибка при сохранении операции';
      return false;
    } finally {
      isSaving = false;
    }
  }
}

