// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_transaction_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AddTransactionStore on _AddTransactionStore, Store {
  late final _$amountTextAtom = Atom(
    name: '_AddTransactionStore.amountText',
    context: context,
  );

  @override
  String get amountText {
    _$amountTextAtom.reportRead();
    return super.amountText;
  }

  @override
  set amountText(String value) {
    _$amountTextAtom.reportWrite(value, super.amountText, () {
      super.amountText = value;
    });
  }

  late final _$amountAtom = Atom(
    name: '_AddTransactionStore.amount',
    context: context,
  );

  @override
  double? get amount {
    _$amountAtom.reportRead();
    return super.amount;
  }

  @override
  set amount(double? value) {
    _$amountAtom.reportWrite(value, super.amount, () {
      super.amount = value;
    });
  }

  late final _$typeAtom = Atom(
    name: '_AddTransactionStore.type',
    context: context,
  );

  @override
  TransactionType get type {
    _$typeAtom.reportRead();
    return super.type;
  }

  @override
  set type(TransactionType value) {
    _$typeAtom.reportWrite(value, super.type, () {
      super.type = value;
    });
  }

  late final _$categoryAtom = Atom(
    name: '_AddTransactionStore.category',
    context: context,
  );

  @override
  String? get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(String? value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  late final _$dateAtom = Atom(
    name: '_AddTransactionStore.date',
    context: context,
  );

  @override
  DateTime get date {
    _$dateAtom.reportRead();
    return super.date;
  }

  @override
  set date(DateTime value) {
    _$dateAtom.reportWrite(value, super.date, () {
      super.date = value;
    });
  }

  late final _$noteTextAtom = Atom(
    name: '_AddTransactionStore.noteText',
    context: context,
  );

  @override
  String get noteText {
    _$noteTextAtom.reportRead();
    return super.noteText;
  }

  @override
  set noteText(String value) {
    _$noteTextAtom.reportWrite(value, super.noteText, () {
      super.noteText = value;
    });
  }

  late final _$noteAtom = Atom(
    name: '_AddTransactionStore.note',
    context: context,
  );

  @override
  String? get note {
    _$noteAtom.reportRead();
    return super.note;
  }

  @override
  set note(String? value) {
    _$noteAtom.reportWrite(value, super.note, () {
      super.note = value;
    });
  }

  late final _$goalIdAtom = Atom(
    name: '_AddTransactionStore.goalId',
    context: context,
  );

  @override
  String? get goalId {
    _$goalIdAtom.reportRead();
    return super.goalId;
  }

  @override
  set goalId(String? value) {
    _$goalIdAtom.reportWrite(value, super.goalId, () {
      super.goalId = value;
    });
  }

  late final _$isSavingAtom = Atom(
    name: '_AddTransactionStore.isSaving',
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
    name: '_AddTransactionStore.errorMessage',
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

  late final _$pendingAttachmentPathsAtom = Atom(
    name: '_AddTransactionStore.pendingAttachmentPaths',
    context: context,
  );

  @override
  ObservableList<String> get pendingAttachmentPaths {
    _$pendingAttachmentPathsAtom.reportRead();
    return super.pendingAttachmentPaths;
  }

  @override
  set pendingAttachmentPaths(ObservableList<String> value) {
    _$pendingAttachmentPathsAtom.reportWrite(
      value,
      super.pendingAttachmentPaths,
      () {
        super.pendingAttachmentPaths = value;
      },
    );
  }

  late final _$initAsyncAction = AsyncAction(
    '_AddTransactionStore.init',
    context: context,
  );

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$onSavedSuccessfullyAsyncAction = AsyncAction(
    '_AddTransactionStore.onSavedSuccessfully',
    context: context,
  );

  @override
  Future<void> onSavedSuccessfully() {
    return _$onSavedSuccessfullyAsyncAction.run(
      () => super.onSavedSuccessfully(),
    );
  }

  late final _$saveAsyncAction = AsyncAction(
    '_AddTransactionStore.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$_AddTransactionStoreActionController = ActionController(
    name: '_AddTransactionStore',
    context: context,
  );

  @override
  void onAmountChanged(String value) {
    final _$actionInfo = _$_AddTransactionStoreActionController.startAction(
      name: '_AddTransactionStore.onAmountChanged',
    );
    try {
      return super.onAmountChanged(value);
    } finally {
      _$_AddTransactionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onNoteChanged(String value) {
    final _$actionInfo = _$_AddTransactionStoreActionController.startAction(
      name: '_AddTransactionStore.onNoteChanged',
    );
    try {
      return super.onNoteChanged(value);
    } finally {
      _$_AddTransactionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAmount(double? value) {
    final _$actionInfo = _$_AddTransactionStoreActionController.startAction(
      name: '_AddTransactionStore.setAmount',
    );
    try {
      return super.setAmount(value);
    } finally {
      _$_AddTransactionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setType(TransactionType value) {
    final _$actionInfo = _$_AddTransactionStoreActionController.startAction(
      name: '_AddTransactionStore.setType',
    );
    try {
      return super.setType(value);
    } finally {
      _$_AddTransactionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCategory(String? value) {
    final _$actionInfo = _$_AddTransactionStoreActionController.startAction(
      name: '_AddTransactionStore.setCategory',
    );
    try {
      return super.setCategory(value);
    } finally {
      _$_AddTransactionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDate(DateTime value) {
    final _$actionInfo = _$_AddTransactionStoreActionController.startAction(
      name: '_AddTransactionStore.setDate',
    );
    try {
      return super.setDate(value);
    } finally {
      _$_AddTransactionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNote(String? value) {
    final _$actionInfo = _$_AddTransactionStoreActionController.startAction(
      name: '_AddTransactionStore.setNote',
    );
    try {
      return super.setNote(value);
    } finally {
      _$_AddTransactionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setGoalId(String? value) {
    final _$actionInfo = _$_AddTransactionStoreActionController.startAction(
      name: '_AddTransactionStore.setGoalId',
    );
    try {
      return super.setGoalId(value);
    } finally {
      _$_AddTransactionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addPendingAttachmentPath(String path) {
    final _$actionInfo = _$_AddTransactionStoreActionController.startAction(
      name: '_AddTransactionStore.addPendingAttachmentPath',
    );
    try {
      return super.addPendingAttachmentPath(path);
    } finally {
      _$_AddTransactionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removePendingAttachmentPath(String path) {
    final _$actionInfo = _$_AddTransactionStoreActionController.startAction(
      name: '_AddTransactionStore.removePendingAttachmentPath',
    );
    try {
      return super.removePendingAttachmentPath(path);
    } finally {
      _$_AddTransactionStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
amountText: ${amountText},
amount: ${amount},
type: ${type},
category: ${category},
date: ${date},
noteText: ${noteText},
note: ${note},
goalId: ${goalId},
isSaving: ${isSaving},
errorMessage: ${errorMessage},
pendingAttachmentPaths: ${pendingAttachmentPaths}
    ''';
  }
}
