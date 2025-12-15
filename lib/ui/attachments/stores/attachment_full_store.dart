import 'package:mobx/mobx.dart';
import '../../../../data/legacy/attachments_service.dart';
import '../../../../data/legacy/transactions_service.dart';
import '../../models/attachment_with_meta.dart';

part 'attachment_full_store.g.dart';

class AttachmentFullStore = _AttachmentFullStore with _$AttachmentFullStore;

abstract class _AttachmentFullStore with Store {
  _AttachmentFullStore(
    this._attachmentsService,
    this._transactionsService,
    this.attachmentId,
  );

  final AttachmentsService _attachmentsService;
  final TransactionsService _transactionsService;
  final String attachmentId;

  @observable
  AttachmentWithMeta? item;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;

    try {
      final attachment = await _attachmentsService.getById(attachmentId);
      if (attachment == null) {
        errorMessage = 'Вложение не найдено';
        return;
      }

      final tx = await _transactionsService.getById(attachment.transactionId);
      if (tx == null) {
        errorMessage = 'Операция для вложения не найдена';
        return;
      }

      item = AttachmentWithMeta(
        attachment: attachment,
        transaction: tx,
      );
    } catch (e) {
      errorMessage = 'Ошибка при загрузке вложения';
    } finally {
      isLoading = false;
    }
  }
}


