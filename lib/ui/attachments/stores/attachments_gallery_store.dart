import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../../../data/legacy/attachments_service.dart';
import '../../../../data/legacy/transactions_service.dart';
import '../../../../domain/entities/attachment_gallery_filters.dart';
import '../../../../domain/usecases/attachment_gallery_filters/get_attachment_gallery_filters.dart';
import '../../../../domain/usecases/attachment_gallery_filters/save_attachment_gallery_filters.dart';
import '../../../../domain/usecases/attachment_gallery_filters/clear_attachment_gallery_filters.dart';
import '../../models/attachment_with_meta.dart';

part 'attachments_gallery_store.g.dart';

class AttachmentsGalleryStore = _AttachmentsGalleryStore
    with _$AttachmentsGalleryStore;

abstract class _AttachmentsGalleryStore with Store {
  _AttachmentsGalleryStore(
    this._attachmentsService,
    this._transactionsService,
    this._getFilters,
    this._saveFilters,
    this._clearFilters,
  );

  final AttachmentsService _attachmentsService;
  final TransactionsService _transactionsService;
  final GetAttachmentGalleryFilters _getFilters;
  final SaveAttachmentGalleryFilters _saveFilters;
  final ClearAttachmentGalleryFilters _clearFilters;

  Timer? _saveFiltersDebounceTimer;

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
  Future<void> init() async {
    try {
      final savedFilters = await _getFilters();
      if (savedFilters != null) {
        categoryFilter = savedFilters.categoryFilter;
        typeFilter = savedFilters.typeFilter;
        fromDate = savedFilters.fromDate;
        toDate = savedFilters.toDate;
      }
    } catch (e) {
      // Игнорируем ошибки при загрузке фильтров
    }
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

  void _saveFiltersDebounced() {
    _saveFiltersDebounceTimer?.cancel();
    _saveFiltersDebounceTimer = Timer(const Duration(milliseconds: 400), () {
      final filters = AttachmentGalleryFilters(
        categoryFilter: categoryFilter,
        typeFilter: typeFilter,
        fromDate: fromDate,
        toDate: toDate,
        updatedAt: DateTime.now(),
      );
      _saveFilters(filters).catchError((_) {
        // Игнорируем ошибки при сохранении фильтров
      });
    });
  }

  @action
  void setCategoryFilter(String? value) {
    categoryFilter = value;
    _saveFiltersDebounced();
  }

  @action
  void setTypeFilter(AttachmentType? value) {
    typeFilter = value;
    _saveFiltersDebounced();
  }

  @action
  void setDateRange(DateTime? from, DateTime? to) {
    fromDate = from;
    toDate = to;
    _saveFiltersDebounced();
  }

  @action
  Future<void> clearFilters() async {
    categoryFilter = null;
    typeFilter = null;
    fromDate = null;
    toDate = null;
    _saveFiltersDebounceTimer?.cancel();
    try {
      await _clearFilters();
    } catch (e) {
      // Игнорируем ошибки при очистке фильтров
    }
  }
}

