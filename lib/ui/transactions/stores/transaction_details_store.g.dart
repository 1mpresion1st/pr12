// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TransactionDetailsStore on _TransactionDetailsStore, Store {
  late final _$transactionAtom = Atom(
    name: '_TransactionDetailsStore.transaction',
    context: context,
  );

  @override
  Transaction? get transaction {
    _$transactionAtom.reportRead();
    return super.transaction;
  }

  @override
  set transaction(Transaction? value) {
    _$transactionAtom.reportWrite(value, super.transaction, () {
      super.transaction = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_TransactionDetailsStore.isLoading',
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

  late final _$isSavingAtom = Atom(
    name: '_TransactionDetailsStore.isSaving',
    context: context,
  );

  @override
  bool get isSaving {
    _$isSavingAtom.reportRead();
    return super.isSaving;
  }

  @override
  set isSaving(bool value) {
    _$isSavingAtom.reportWrite(value, super.isSaving, () {
      super.isSaving = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_TransactionDetailsStore.errorMessage',
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
    name: '_TransactionDetailsStore.attachments',
    context: context,
  );

  @override
  ObservableList<Attachment> get attachments {
    _$attachmentsAtom.reportRead();
    return super.attachments;
  }

  @override
  set attachments(ObservableList<Attachment> value) {
    _$attachmentsAtom.reportWrite(value, super.attachments, () {
      super.attachments = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    '_TransactionDetailsStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$addAttachmentFromFileAsyncAction = AsyncAction(
    '_TransactionDetailsStore.addAttachmentFromFile',
    context: context,
  );

  @override
  Future<void> addAttachmentFromFile(
    String path, {
    AttachmentType type = AttachmentType.receipt,
  }) {
    return _$addAttachmentFromFileAsyncAction.run(
      () => super.addAttachmentFromFile(path, type: type),
    );
  }

  late final _$deleteAttachmentAsyncAction = AsyncAction(
    '_TransactionDetailsStore.deleteAttachment',
    context: context,
  );

  @override
  Future<void> deleteAttachment(String attachmentId) {
    return _$deleteAttachmentAsyncAction.run(
      () => super.deleteAttachment(attachmentId),
    );
  }

  late final _$saveAsyncAction = AsyncAction(
    '_TransactionDetailsStore.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$deleteAsyncAction = AsyncAction(
    '_TransactionDetailsStore.delete',
    context: context,
  );

  @override
  Future<bool> delete() {
    return _$deleteAsyncAction.run(() => super.delete());
  }

  late final _$_TransactionDetailsStoreActionController = ActionController(
    name: '_TransactionDetailsStore',
    context: context,
  );

  @override
  void updateAmount(double value) {
    final _$actionInfo = _$_TransactionDetailsStoreActionController.startAction(
      name: '_TransactionDetailsStore.updateAmount',
    );
    try {
      return super.updateAmount(value);
    } finally {
      _$_TransactionDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateType(TransactionType value) {
    final _$actionInfo = _$_TransactionDetailsStoreActionController.startAction(
      name: '_TransactionDetailsStore.updateType',
    );
    try {
      return super.updateType(value);
    } finally {
      _$_TransactionDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateCategory(String value) {
    final _$actionInfo = _$_TransactionDetailsStoreActionController.startAction(
      name: '_TransactionDetailsStore.updateCategory',
    );
    try {
      return super.updateCategory(value);
    } finally {
      _$_TransactionDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateDate(DateTime value) {
    final _$actionInfo = _$_TransactionDetailsStoreActionController.startAction(
      name: '_TransactionDetailsStore.updateDate',
    );
    try {
      return super.updateDate(value);
    } finally {
      _$_TransactionDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateNote(String? value) {
    final _$actionInfo = _$_TransactionDetailsStoreActionController.startAction(
      name: '_TransactionDetailsStore.updateNote',
    );
    try {
      return super.updateNote(value);
    } finally {
      _$_TransactionDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateGoalId(String? value) {
    final _$actionInfo = _$_TransactionDetailsStoreActionController.startAction(
      name: '_TransactionDetailsStore.updateGoalId',
    );
    try {
      return super.updateGoalId(value);
    } finally {
      _$_TransactionDetailsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
transaction: ${transaction},
isLoading: ${isLoading},
isSaving: ${isSaving},
errorMessage: ${errorMessage},
attachments: ${attachments}
    ''';
  }
}
