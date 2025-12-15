import 'package:mobx/mobx.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/entities/attachment.dart';
import '../../../../domain/usecases/transactions/get_transaction_by_id.dart';
import '../../../../domain/usecases/transactions/update_transaction.dart';
import '../../../../domain/usecases/transactions/delete_transaction.dart';
import '../../../../domain/usecases/attachments/get_all_attachments.dart';
import '../../../../domain/usecases/attachments/add_attachment.dart';
import '../../../../domain/usecases/attachments/delete_attachment.dart';

part 'transaction_details_store.g.dart';

class TransactionDetailsStore = _TransactionDetailsStore with _$TransactionDetailsStore;

abstract class _TransactionDetailsStore with Store {
  _TransactionDetailsStore(
    this._getTransactionById,
    this._updateTransaction,
    this._deleteTransaction,
    this._getAllAttachments,
    this._addAttachment,
    this._deleteAttachment,
    this.transactionId,
  );

  final GetTransactionById _getTransactionById;
  final UpdateTransaction _updateTransaction;
  final DeleteTransaction _deleteTransaction;
  final GetAllAttachments _getAllAttachments;
  final AddAttachment _addAttachment;
  final DeleteAttachment _deleteAttachment;
  final String transactionId;

  @observable
  Transaction? transaction;

  @observable
  bool isLoading = false;

  @observable
  bool isSaving = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<Attachment> attachments =
      ObservableList<Attachment>.of([]);

  @action
  Future<void> load() async {
    isLoading = true;
    try {
      transaction = await _getTransactionById(transactionId);
      final list = await _getAllAttachments();
      final filtered = list.where((a) => a.transactionId == transactionId).toList();
      attachments
        ..clear()
        ..addAll(filtered);
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> addAttachmentFromFile(
    String path, {
    AttachmentType type = AttachmentType.receipt,
  }) async {
    final tx = transaction;
    if (tx == null) return;

    final attachment = Attachment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      transactionId: tx.id,
      path: path,
      type: type,
      createdAt: DateTime.now(),
    );

    await _addAttachment(attachment);
    attachments.add(attachment);
  }

  @action
  Future<void> deleteAttachment(String attachmentId) async {
    await _deleteAttachment(attachmentId);
    attachments.removeWhere((a) => a.id == attachmentId);
  }

  @action
  void updateAmount(double value) {
    if (transaction == null) return;
    transaction = transaction!.copyWith(amount: value);
  }

  @action
  void updateType(TransactionType value) {
    if (transaction == null) return;
    transaction = transaction!.copyWith(type: value);
  }

  @action
  void updateCategory(String value) {
    if (transaction == null) return;
    transaction = transaction!.copyWith(category: value);
  }

  @action
  void updateDate(DateTime value) {
    if (transaction == null) return;
    transaction = transaction!.copyWith(date: value);
  }

  @action
  void updateNote(String? value) {
    if (transaction == null) return;
    transaction = transaction!.copyWith(note: value);
  }

  @action
  void updateGoalId(String? value) {
    if (transaction == null) return;
    transaction = transaction!.copyWith(goalId: value);
  }

  @action
  Future<bool> save() async {
    if (transaction == null) return false;
    isSaving = true;
    errorMessage = null;
    try {
      await _updateTransaction(transaction!);
      return true;
    } catch (e) {
      errorMessage = 'Ошибка при сохранении операции';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> delete() async {
    isSaving = true;
    errorMessage = null;
    try {
      await _deleteTransaction(transactionId);
      return true;
    } catch (e) {
      errorMessage = 'Ошибка при удалении операции';
      return false;
    } finally {
      isSaving = false;
    }
  }
}

