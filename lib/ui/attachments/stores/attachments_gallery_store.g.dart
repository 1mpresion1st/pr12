// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachments_gallery_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AttachmentsGalleryStore on _AttachmentsGalleryStore, Store {
  Computed<List<AttachmentWithMeta>>? _$filteredAttachmentsComputed;

  @override
  List<AttachmentWithMeta> get filteredAttachments =>
      (_$filteredAttachmentsComputed ??= Computed<List<AttachmentWithMeta>>(
        () => super.filteredAttachments,
        name: '_AttachmentsGalleryStore.filteredAttachments',
      )).value;

  late final _$isLoadingAtom = Atom(
    name: '_AttachmentsGalleryStore.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AttachmentsGalleryStore.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$attachmentsAtom = Atom(
    name: '_AttachmentsGalleryStore.attachments',
    context: context,
  );

  @override
  ObservableList<AttachmentWithMeta> get attachments {
    _$attachmentsAtom.reportRead();
    return super.attachments;
  }

  @override
  set attachments(ObservableList<AttachmentWithMeta> value) {
    _$attachmentsAtom.reportWrite(value, super.attachments, () {
      super.attachments = value;
    });
  }

  late final _$categoryFilterAtom = Atom(
    name: '_AttachmentsGalleryStore.categoryFilter',
    context: context,
  );

  @override
  String? get categoryFilter {
    _$categoryFilterAtom.reportRead();
    return super.categoryFilter;
  }

  @override
  set categoryFilter(String? value) {
    _$categoryFilterAtom.reportWrite(value, super.categoryFilter, () {
      super.categoryFilter = value;
    });
  }

  late final _$fromDateAtom = Atom(
    name: '_AttachmentsGalleryStore.fromDate',
    context: context,
  );

  @override
  DateTime? get fromDate {
    _$fromDateAtom.reportRead();
    return super.fromDate;
  }

  @override
  set fromDate(DateTime? value) {
    _$fromDateAtom.reportWrite(value, super.fromDate, () {
      super.fromDate = value;
    });
  }

  late final _$toDateAtom = Atom(
    name: '_AttachmentsGalleryStore.toDate',
    context: context,
  );

  @override
  DateTime? get toDate {
    _$toDateAtom.reportRead();
    return super.toDate;
  }

  @override
  set toDate(DateTime? value) {
    _$toDateAtom.reportWrite(value, super.toDate, () {
      super.toDate = value;
    });
  }

  late final _$typeFilterAtom = Atom(
    name: '_AttachmentsGalleryStore.typeFilter',
    context: context,
  );

  @override
  AttachmentType? get typeFilter {
    _$typeFilterAtom.reportRead();
    return super.typeFilter;
  }

  @override
  set typeFilter(AttachmentType? value) {
    _$typeFilterAtom.reportWrite(value, super.typeFilter, () {
      super.typeFilter = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    '_AttachmentsGalleryStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_AttachmentsGalleryStore.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$_AttachmentsGalleryStoreActionController = ActionController(
    name: '_AttachmentsGalleryStore',
    context: context,
  );

  @override
  void setCategoryFilter(String? value) {
    final _$actionInfo = _$_AttachmentsGalleryStoreActionController.startAction(
      name: '_AttachmentsGalleryStore.setCategoryFilter',
    );
    try {
      return super.setCategoryFilter(value);
    } finally {
      _$_AttachmentsGalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTypeFilter(AttachmentType? value) {
    final _$actionInfo = _$_AttachmentsGalleryStoreActionController.startAction(
      name: '_AttachmentsGalleryStore.setTypeFilter',
    );
    try {
      return super.setTypeFilter(value);
    } finally {
      _$_AttachmentsGalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDateRange(DateTime? from, DateTime? to) {
    final _$actionInfo = _$_AttachmentsGalleryStoreActionController.startAction(
      name: '_AttachmentsGalleryStore.setDateRange',
    );
    try {
      return super.setDateRange(from, to);
    } finally {
      _$_AttachmentsGalleryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
errorMessage: ${errorMessage},
attachments: ${attachments},
categoryFilter: ${categoryFilter},
fromDate: ${fromDate},
toDate: ${toDate},
typeFilter: ${typeFilter},
filteredAttachments: ${filteredAttachments}
    ''';
  }
}
