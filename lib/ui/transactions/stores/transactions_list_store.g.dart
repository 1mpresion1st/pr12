// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transactions_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TransactionsListStore on _TransactionsListStore, Store {
  Computed<List<Transaction>>? _$filteredTransactionsComputed;

  @override
  List<Transaction> get filteredTransactions =>
      (_$filteredTransactionsComputed ??= Computed<List<Transaction>>(
        () => super.filteredTransactions,
        name: '_TransactionsListStore.filteredTransactions',
      )).value;

  late final _$transactionsAtom = Atom(
    name: '_TransactionsListStore.transactions',
    context: context,
  );

  @override
  ObservableList<Transaction> get transactions {
    _$transactionsAtom.reportRead();
    return super.transactions;
  }

  @override
  set transactions(ObservableList<Transaction> value) {
    _$transactionsAtom.reportWrite(value, super.transactions, () {
      super.transactions = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_TransactionsListStore.isLoading',
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

  late final _$typeFilterAtom = Atom(
    name: '_TransactionsListStore.typeFilter',
    context: context,
  );

  @override
  TransactionType? get typeFilter {
    _$typeFilterAtom.reportRead();
    return super.typeFilter;
  }

  @override
  set typeFilter(TransactionType? value) {
    _$typeFilterAtom.reportWrite(value, super.typeFilter, () {
      super.typeFilter = value;
    });
  }

  late final _$categoryFilterAtom = Atom(
    name: '_TransactionsListStore.categoryFilter',
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
    name: '_TransactionsListStore.fromDate',
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
    name: '_TransactionsListStore.toDate',
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

  late final _$loadAsyncAction = AsyncAction(
    '_TransactionsListStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_TransactionsListStore.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$_TransactionsListStoreActionController = ActionController(
    name: '_TransactionsListStore',
    context: context,
  );

  @override
  void setTypeFilter(TransactionType? type) {
    final _$actionInfo = _$_TransactionsListStoreActionController.startAction(
      name: '_TransactionsListStore.setTypeFilter',
    );
    try {
      return super.setTypeFilter(type);
    } finally {
      _$_TransactionsListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCategoryFilter(String? category) {
    final _$actionInfo = _$_TransactionsListStoreActionController.startAction(
      name: '_TransactionsListStore.setCategoryFilter',
    );
    try {
      return super.setCategoryFilter(category);
    } finally {
      _$_TransactionsListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDateRange(DateTime? from, DateTime? to) {
    final _$actionInfo = _$_TransactionsListStoreActionController.startAction(
      name: '_TransactionsListStore.setDateRange',
    );
    try {
      return super.setDateRange(from, to);
    } finally {
      _$_TransactionsListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
transactions: ${transactions},
isLoading: ${isLoading},
typeFilter: ${typeFilter},
categoryFilter: ${categoryFilter},
fromDate: ${fromDate},
toDate: ${toDate},
filteredTransactions: ${filteredTransactions}
    ''';
  }
}
