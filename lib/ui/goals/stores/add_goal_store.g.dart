// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_goal_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AddGoalStore on _AddGoalStore, Store {
  Computed<bool>? _$isEditModeComputed;

  @override
  bool get isEditMode => (_$isEditModeComputed ??= Computed<bool>(
    () => super.isEditMode,
    name: '_AddGoalStore.isEditMode',
  )).value;
  Computed<double?>? _$targetAmountComputed;

  @override
  double? get targetAmount => (_$targetAmountComputed ??= Computed<double?>(
    () => super.targetAmount,
    name: '_AddGoalStore.targetAmount',
  )).value;
  Computed<List<double?>>? _$subtaskAmountValuesComputed;

  @override
  List<double?> get subtaskAmountValues =>
      (_$subtaskAmountValuesComputed ??= Computed<List<double?>>(
        () => super.subtaskAmountValues,
        name: '_AddGoalStore.subtaskAmountValues',
      )).value;

  late final _$nameAtom = Atom(name: '_AddGoalStore.name', context: context);

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

  late final _$targetAmountTextAtom = Atom(
    name: '_AddGoalStore.targetAmountText',
    context: context,
  );

  @override
  String get targetAmountText {
    _$targetAmountTextAtom.reportRead();
    return super.targetAmountText;
  }

  @override
  set targetAmountText(String value) {
    _$targetAmountTextAtom.reportWrite(value, super.targetAmountText, () {
      super.targetAmountText = value;
    });
  }

  late final _$targetDateAtom = Atom(
    name: '_AddGoalStore.targetDate',
    context: context,
  );

  @override
  DateTime? get targetDate {
    _$targetDateAtom.reportRead();
    return super.targetDate;
  }

  @override
  set targetDate(DateTime? value) {
    _$targetDateAtom.reportWrite(value, super.targetDate, () {
      super.targetDate = value;
    });
  }

  late final _$iconAtom = Atom(name: '_AddGoalStore.icon', context: context);

  @override
  String? get icon {
    _$iconAtom.reportRead();
    return super.icon;
  }

  @override
  set icon(String? value) {
    _$iconAtom.reportWrite(value, super.icon, () {
      super.icon = value;
    });
  }

  late final _$descriptionAtom = Atom(
    name: '_AddGoalStore.description',
    context: context,
  );

  @override
  String? get description {
    _$descriptionAtom.reportRead();
    return super.description;
  }

  @override
  set description(String? value) {
    _$descriptionAtom.reportWrite(value, super.description, () {
      super.description = value;
    });
  }

  late final _$subtaskNamesAtom = Atom(
    name: '_AddGoalStore.subtaskNames',
    context: context,
  );

  @override
  ObservableList<String> get subtaskNames {
    _$subtaskNamesAtom.reportRead();
    return super.subtaskNames;
  }

  @override
  set subtaskNames(ObservableList<String> value) {
    _$subtaskNamesAtom.reportWrite(value, super.subtaskNames, () {
      super.subtaskNames = value;
    });
  }

  late final _$subtaskAmountsAtom = Atom(
    name: '_AddGoalStore.subtaskAmounts',
    context: context,
  );

  @override
  ObservableList<String> get subtaskAmounts {
    _$subtaskAmountsAtom.reportRead();
    return super.subtaskAmounts;
  }

  @override
  set subtaskAmounts(ObservableList<String> value) {
    _$subtaskAmountsAtom.reportWrite(value, super.subtaskAmounts, () {
      super.subtaskAmounts = value;
    });
  }

  late final _$isSavingAtom = Atom(
    name: '_AddGoalStore.isSaving',
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
    name: '_AddGoalStore.errorMessage',
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

  late final _$initAsyncAction = AsyncAction(
    '_AddGoalStore.init',
    context: context,
  );

  @override
  Future<void> init() {
    return _$initAsyncAction.run(() => super.init());
  }

  late final _$saveAsyncAction = AsyncAction(
    '_AddGoalStore.save',
    context: context,
  );

  @override
  Future<bool> save() {
    return _$saveAsyncAction.run(() => super.save());
  }

  late final _$deleteAsyncAction = AsyncAction(
    '_AddGoalStore.delete',
    context: context,
  );

  @override
  Future<bool> delete() {
    return _$deleteAsyncAction.run(() => super.delete());
  }

  late final _$clearDraftAsyncAction = AsyncAction(
    '_AddGoalStore.clearDraft',
    context: context,
  );

  @override
  Future<void> clearDraft() {
    return _$clearDraftAsyncAction.run(() => super.clearDraft());
  }

  late final _$_AddGoalStoreActionController = ActionController(
    name: '_AddGoalStore',
    context: context,
  );

  @override
  void setName(String value) {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.setName',
    );
    try {
      return super.setName(value);
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onNameChanged(String value) {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.onNameChanged',
    );
    try {
      return super.onNameChanged(value);
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTargetAmountText(String value) {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.setTargetAmountText',
    );
    try {
      return super.setTargetAmountText(value);
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setTargetDate(DateTime? value) {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.setTargetDate',
    );
    try {
      return super.setTargetDate(value);
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setIcon(String? value) {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.setIcon',
    );
    try {
      return super.setIcon(value);
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setDescription(String? value) {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.setDescription',
    );
    try {
      return super.setDescription(value);
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onDescriptionChanged(String value) {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.onDescriptionChanged',
    );
    try {
      return super.onDescriptionChanged(value);
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSubtask() {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.addSubtask',
    );
    try {
      return super.addSubtask();
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeSubtask(int index) {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.removeSubtask',
    );
    try {
      return super.removeSubtask(index);
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSubtaskName(int index, String value) {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.setSubtaskName',
    );
    try {
      return super.setSubtaskName(index, value);
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSubtaskAmount(int index, String value) {
    final _$actionInfo = _$_AddGoalStoreActionController.startAction(
      name: '_AddGoalStore.setSubtaskAmount',
    );
    try {
      return super.setSubtaskAmount(index, value);
    } finally {
      _$_AddGoalStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name},
targetAmountText: ${targetAmountText},
targetDate: ${targetDate},
icon: ${icon},
description: ${description},
subtaskNames: ${subtaskNames},
subtaskAmounts: ${subtaskAmounts},
isSaving: ${isSaving},
errorMessage: ${errorMessage},
isEditMode: ${isEditMode},
targetAmount: ${targetAmount},
subtaskAmountValues: ${subtaskAmountValues}
    ''';
  }
}
