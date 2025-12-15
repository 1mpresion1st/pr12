// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_recurring_payment_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AddRecurringPaymentStore on _AddRecurringPaymentStore, Store {
  Computed<bool>? _$isEditModeComputed;

  @override
  bool get isEditMode => (_$isEditModeComputed ??= Computed<bool>(
    () => super.isEditMode,
    name: '_AddRecurringPaymentStore.isEditMode',
  )).value;
  Computed<double?>? _$amountComputed;

  @override
  double? get amount => (_$amountComputed ??= Computed<double?>(
    () => super.amount,
    name: '_AddRecurringPaymentStore.amount',
  )).value;

  late final _$nameAtom = Atom(
    name: '_AddRecurringPaymentStore.name',
    context: context,
  );

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, super.name, () {
      super.name = value;
    });
  }

  late final _$amountTextAtom = Atom(
    name: '_AddRecurringPaymentStore.amountText',
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

  late final _$frequencyAtom = Atom(
    name: '_AddRecurringPaymentStore.frequency',
    context: context,
  );

  @override
  RecurringPaymentFrequency get frequency {
    _$frequencyAtom.reportRead();
    return super.frequency;
  }

  @override
  set frequency(RecurringPaymentFrequency value) {
    _$frequencyAtom.reportWrite(value, super.frequency, () {
      super.frequency = value;
    });
  }

  late final _$nextChargeDateAtom = Atom(
    name: '_AddRecurringPaymentStore.nextChargeDate',
    context: context,
  );

  @override
  DateTime get nextChargeDate {
    _$nextChargeDateAtom.reportRead();
    return super.nextChargeDate;
  }

  @override
  set nextChargeDate(DateTime value) {
    _$nextChargeDateAtom.reportWrite(value, super.nextChargeDate, () {
      super.nextChargeDate = value;
    });
  }

  late final _$categoryAtom = Atom(
    name: '_AddRecurringPaymentStore.category',
    context: context,
  );

  @override
  String get category {
    _$categoryAtom.reportRead();
    return super.category;
  }

  @override
  set category(String value) {
    _$categoryAtom.reportWrite(value, super.category, () {
      super.category = value;
    });
  }

  late final _$autoCreateTransactionAtom = Atom(
    name: '_AddRecurringPaymentStore.autoCreateTransaction',
    context: context,
  );

  @override
  bool get autoCreateTransaction {
    _$autoCreateTransactionAtom.reportRead();
    return super.autoCreateTransaction;
  }

  @override
  set autoCreateTransaction(bool value) {
    _$autoCreateTransactionAtom.reportWrite(
      value,
      super.autoCreateTransaction,
      () {
        super.autoCreateTransaction = value;
      },
    );
  }

  late final _$isActiveAtom = Atom(
    name: '_AddRecurringPaymentStore.isActive',
    context: context,
  );

  @override
  bool get isActive {
    _$isActiveAtom.reportRead();
    return super.isActive;
  }

  @override
  set isActive(bool value) {
    _$isActiveAtom.reportWrite(value, super.isActive, () {
      super.isActive = value;
    });
  }

  late final _$isSavingAtom = Atom(
    name: '_AddRecurringPaymentStore.isSaving',
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
    name: '_AddRecurringPaymentStore.errorMessage',
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

  late final _$saveAsyncAction = AsyncAction(
    '_AddRecurringPaymentStore.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$deleteAsyncAction = AsyncAction(
    '_AddRecurringPaymentStore.delete',
    context: context,
  );

  @override
  Future<bool> delete() {
    return _$deleteAsyncAction.run(() => super.delete());
  }

  late final _$_AddRecurringPaymentStoreActionController = ActionController(
    name: '_AddRecurringPaymentStore',
    context: context,
  );

  @override
  void setName(String value) {
    final _$actionInfo = _$_AddRecurringPaymentStoreActionController
        .startAction(name: '_AddRecurringPaymentStore.setName');
    try {
      return super.setName(value);
    } finally {
      _$_AddRecurringPaymentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAmountText(String value) {
    final _$actionInfo = _$_AddRecurringPaymentStoreActionController
        .startAction(name: '_AddRecurringPaymentStore.setAmountText');
    try {
      return super.setAmountText(value);
    } finally {
      _$_AddRecurringPaymentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setFrequency(RecurringPaymentFrequency value) {
    final _$actionInfo = _$_AddRecurringPaymentStoreActionController
        .startAction(name: '_AddRecurringPaymentStore.setFrequency');
    try {
      return super.setFrequency(value);
    } finally {
      _$_AddRecurringPaymentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setNextChargeDate(DateTime value) {
    final _$actionInfo = _$_AddRecurringPaymentStoreActionController
        .startAction(name: '_AddRecurringPaymentStore.setNextChargeDate');
    try {
      return super.setNextChargeDate(value);
    } finally {
      _$_AddRecurringPaymentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCategory(String value) {
    final _$actionInfo = _$_AddRecurringPaymentStoreActionController
        .startAction(name: '_AddRecurringPaymentStore.setCategory');
    try {
      return super.setCategory(value);
    } finally {
      _$_AddRecurringPaymentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setAutoCreateTransaction(bool value) {
    final _$actionInfo = _$_AddRecurringPaymentStoreActionController
        .startAction(
          name: '_AddRecurringPaymentStore.setAutoCreateTransaction',
        );
    try {
      return super.setAutoCreateTransaction(value);
    } finally {
      _$_AddRecurringPaymentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIsActive(bool value) {
    final _$actionInfo = _$_AddRecurringPaymentStoreActionController
        .startAction(name: '_AddRecurringPaymentStore.setIsActive');
    try {
      return super.setIsActive(value);
    } finally {
      _$_AddRecurringPaymentStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
amountText: ${amountText},
frequency: ${frequency},
nextChargeDate: ${nextChargeDate},
category: ${category},
autoCreateTransaction: ${autoCreateTransaction},
isActive: ${isActive},
isSaving: ${isSaving},
errorMessage: ${errorMessage},
isEditMode: ${isEditMode},
amount: ${amount}
    ''';
  }
}
