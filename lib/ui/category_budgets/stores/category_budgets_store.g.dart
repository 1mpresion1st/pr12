// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_budgets_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CategoryBudgetsStore on _CategoryBudgetsStore, Store {
  Computed<DateTime>? _$monthStartComputed;

  @override
  DateTime get monthStart => (_$monthStartComputed ??= Computed<DateTime>(
    () => super.monthStart,
    name: '_CategoryBudgetsStore.monthStart',
  )).value;
  Computed<DateTime>? _$monthEndComputed;

  @override
  DateTime get monthEnd => (_$monthEndComputed ??= Computed<DateTime>(
    () => super.monthEnd,
    name: '_CategoryBudgetsStore.monthEnd',
  )).value;

  late final _$isLoadingAtom = Atom(
    name: '_CategoryBudgetsStore.isLoading',
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
    name: '_CategoryBudgetsStore.items',
    context: context,
  );

  @override
  ObservableList<CategoryBudgetWithProgress> get items {
    _$itemsAtom.reportRead();
    return super.items;
  }

  @override
  set items(ObservableList<CategoryBudgetWithProgress> value) {
    _$itemsAtom.reportWrite(value, super.items, () {
      super.items = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_CategoryBudgetsStore.errorMessage',
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

  late final _$currentMonthAtom = Atom(
    name: '_CategoryBudgetsStore.currentMonth',
    context: context,
  );

  @override
  DateTime get currentMonth {
    _$currentMonthAtom.reportRead();
    return super.currentMonth;
  }

  @override
  set currentMonth(DateTime value) {
    _$currentMonthAtom.reportWrite(value, super.currentMonth, () {
      super.currentMonth = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    '_CategoryBudgetsStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_CategoryBudgetsStore.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$_CategoryBudgetsStoreActionController = ActionController(
    name: '_CategoryBudgetsStore',
    context: context,
  );

  @override
  void setMonth(DateTime month) {
    final _$actionInfo = _$_CategoryBudgetsStoreActionController.startAction(
      name: '_CategoryBudgetsStore.setMonth',
    );
    try {
      return super.setMonth(month);
    } finally {
      _$_CategoryBudgetsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
items: ${items},
errorMessage: ${errorMessage},
currentMonth: ${currentMonth},
monthStart: ${monthStart},
monthEnd: ${monthEnd}
    ''';
  }
}
