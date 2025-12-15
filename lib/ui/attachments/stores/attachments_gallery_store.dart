import 'package:mobx/mobx.dart';
import '../../../../data/legacy/attachments_service.dart';
import '../../../../data/legacy/transactions_service.dart';
import '../../models/attachment_with_meta.dart';

part 'attachments_gallery_store.g.dart';

class AttachmentsGalleryStore = _AttachmentsGalleryStore
    with _$AttachmentsGalleryStore;

abstract class _AttachmentsGalleryStore with Store {
  _AttachmentsGalleryStore(
    this._attachmentsService,
    this._transactionsService,
  );

  final AttachmentsService _attachmentsService;
  final TransactionsService _transactionsService;

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  ObservableList<AttachmentWithMeta> attachments =
      ObservableList<AttachmentWithMeta>.of([]);

  @observable
  String? categoryFilter;

  @observable
  DateTime? fromDate;

  @observable
  DateTime? toDate;

  @observable
  AttachmentType? typeFilter;

  @computed
  List<AttachmentWithMeta> get filteredAttachments {
    return attachments.where((item) {
      if (categoryFilter != null &&
          categoryFilter!.isNotEmpty &&
          item.category != categoryFilter) {
        return false;
      }

      if (typeFilter != null && item.type != typeFilter) {
        return false;
      }

      if (fromDate != null && item.date.isBefore(fromDate!)) {
        return false;
      }

      if (toDate != null && item.date.isAfter(toDate!)) {
        return false;
      }

      return true;
    }).toList();
  }

  @action
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;

    try {
      final attachmentsList = await _attachmentsService.getAll();

      final List<AttachmentWithMeta> result = [];
      for (final attachment in attachmentsList) {
        final tx = await _transactionsService.getById(attachment.transactionId);
        if (tx == null) {
          continue;
        }
        result.add(AttachmentWithMeta(
          attachment: attachment,
          transaction: tx,
        ));
      }

      attachments
        ..clear()
        ..addAll(result);
    } catch (e) {
      errorMessage = 'Ошибка при загрузке вложений';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> refresh() async {
    await load();
  }

  @action
  void setCategoryFilter(String? value) {
    categoryFilter = value;
  }

  @action
  void setTypeFilter(AttachmentType? value) {
    typeFilter = value;
  }

  @action
  void setDateRange(DateTime? from, DateTime? to) {
    fromDate = from;
    toDate = to;
  }
}

