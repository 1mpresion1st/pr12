// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_payments_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RecurringPaymentsListStore on _RecurringPaymentsListStore, Store {
  Computed<double>? _$totalMonthlyCostComputed;

  @override
  double get totalMonthlyCost =>
      (_$totalMonthlyCostComputed ??= Computed<double>(
        () => super.totalMonthlyCost,
        name: '_RecurringPaymentsListStore.totalMonthlyCost',
      )).value;

  late final _$isLoadingAtom = Atom(
    name: '_RecurringPaymentsListStore.isLoading',
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

  late final _$itemsAtom = Atom(
    name: '_RecurringPaymentsListStore.items',
    context: context,
  );

  @override
  ObservableList<RecurringPayment> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(ObservableList<RecurringPayment> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_RecurringPaymentsListStore.errorMessage',
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

  late final _$duePaymentsAtom = Atom(
    name: '_RecurringPaymentsListStore.duePayments',
    context: context,
  );

  @override
  ObservableList<RecurringPayment> get duePayments {
    _$duePaymentsAtom.reportRead();
    return super.duePayments;
  }

  @override
  set duePayments(ObservableList<RecurringPayment> value) {
    _$duePaymentsAtom.reportWrite(value, super.duePayments, () {
      super.duePayments = value;
    });
  }

  late final _$hasShownDueDialogAtom = Atom(
    name: '_RecurringPaymentsListStore.hasShownDueDialog',
    context: context,
  );

  @override
  bool get hasShownDueDialog {
    _$hasShownDueDialogAtom.reportRead();
    return super.hasShownDueDialog;
  }

  @override
  set hasShownDueDialog(bool value) {
    _$hasShownDueDialogAtom.reportWrite(value, super.hasShownDueDialog, () {
      super.hasShownDueDialog = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    '_RecurringPaymentsListStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_RecurringPaymentsListStore.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$checkDuePaymentsAsyncAction = AsyncAction(
    '_RecurringPaymentsListStore.checkDuePayments',
    context: context,
  );

  @override
  Future<void> checkDuePayments() {
    return _$checkDuePaymentsAsyncAction.run(() => super.checkDuePayments());
  }

  late final _$createTransactionsForDuePaymentsAsyncAction = AsyncAction(
    '_RecurringPaymentsListStore.createTransactionsForDuePayments',
    context: context,
  );

  @override
  Future<bool> createTransactionsForDuePayments() {
    return _$createTransactionsForDuePaymentsAsyncAction.run(
      () => super.createTransactionsForDuePayments(),
    );
  }

  late final _$_RecurringPaymentsListStoreActionController = ActionController(
    name: '_RecurringPaymentsListStore',
    context: context,
  );

  @override
  void _updateDuePayments() {
    final _$actionInfo = _$_RecurringPaymentsListStoreActionController
        .startAction(name: '_RecurringPaymentsListStore._updateDuePayments');
    try {
      return super._updateDuePayments();
    } finally {
      _$_RecurringPaymentsListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
items: ${items},
errorMessage: ${errorMessage},
duePayments: ${duePayments},
hasShownDueDialog: ${hasShownDueDialog},
totalMonthlyCost: ${totalMonthlyCost}
    ''';
  }
}
