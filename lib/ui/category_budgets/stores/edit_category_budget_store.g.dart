// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_category_budget_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EditCategoryBudgetStore on _EditCategoryBudgetStore, Store {
  Computed<double?>? _$limitAmountComputed;

  @override
  double? get limitAmount => (_$limitAmountComputed ??= Computed<double?>(
    () => super.limitAmount,
    name: '_EditCategoryBudgetStore.limitAmount',
  )).value;
  Computed<bool>? _$isEditModeComputed;

  @override
  bool get isEditMode => (_$isEditModeComputed ??= Computed<bool>(
    () => super.isEditMode,
    name: '_EditCategoryBudgetStore.isEditMode',
  )).value;

  late final _$categoryAtom = Atom(
    name: '_EditCategoryBudgetStore.category',
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

  late final _$limitTextAtom = Atom(
    name: '_EditCategoryBudgetStore.limitText',
    context: context,
  );

  @override
  String get limitText {
    _$limitTextAtom.reportRead();
    return super.limitText;
  }

  @override
  set limitText(String value) {
    _$limitTextAtom.reportWrite(value, super.limitText, () {
      super.limitText = value;
    });
  }

  late final _$periodAtom = Atom(
    name: '_EditCategoryBudgetStore.period',
    context: context,
  );

  @override
  BudgetPeriod get period {
    _$periodAtom.reportRead();
    return super.period;
  }

  @override
  set period(BudgetPeriod value) {
    _$periodAtom.reportWrite(value, super.period, () {
      super.period = value;
    });
  }

  late final _$isSavingAtom = Atom(
    name: '_EditCategoryBudgetStore.isSaving',
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
    name: '_EditCategoryBudgetStore.errorMessage',
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
    '_EditCategoryBudgetStore.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$deleteAsyncAction = AsyncAction(
    '_EditCategoryBudgetStore.delete',
    context: context,
  );

  @override
  Future<bool> delete() {
    return _$deleteAsyncAction.run(() => super.delete());
  }

  late final _$_EditCategoryBudgetStoreActionController = ActionController(
    name: '_EditCategoryBudgetStore',
    context: context,
  );

  @override
  void setCategory(String value) {
    final _$actionInfo = _$_EditCategoryBudgetStoreActionController.startAction(
      name: '_EditCategoryBudgetStore.setCategory',
    );
    try {
      return super.setCategory(value);
    } finally {
      _$_EditCategoryBudgetStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setLimitText(String value) {
    final _$actionInfo = _$_EditCategoryBudgetStoreActionController.startAction(
      name: '_EditCategoryBudgetStore.setLimitText',
    );
    try {
      return super.setLimitText(value);
    } finally {
      _$_EditCategoryBudgetStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
category: ${category},
limitText: ${limitText},
period: ${period},
isSaving: ${isSaving},
errorMessage: ${errorMessage},
limitAmount: ${limitAmount},
isEditMode: ${isEditMode}
    ''';
  }
}
