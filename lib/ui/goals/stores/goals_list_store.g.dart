// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GoalsListStore on _GoalsListStore, Store {
  Computed<List<GoalWithProgress>>? _$visibleGoalsComputed;

  @override
  List<GoalWithProgress> get visibleGoals =>
      (_$visibleGoalsComputed ??= Computed<List<GoalWithProgress>>(
        () => super.visibleGoals,
        name: '_GoalsListStore.visibleGoals',
      )).value;

  late final _$isLoadingAtom = Atom(
    name: '_GoalsListStore.isLoading',
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

  late final _$goalsAtom = Atom(
    name: '_GoalsListStore.goals',
    context: context,
  );

  @override
  ObservableList<GoalWithProgress> get goals {
    _$goalsAtom.reportRead();
    return super.goals;
  }

  @override
  set goals(ObservableList<GoalWithProgress> value) {
    _$goalsAtom.reportWrite(value, super.goals, () {
      super.goals = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_GoalsListStore.errorMessage',
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

  late final _$showOnlyActiveAtom = Atom(
    name: '_GoalsListStore.showOnlyActive',
    context: context,
  );

  @override
  bool get showOnlyActive {
    _$showOnlyActiveAtom.reportRead();
    return super.showOnlyActive;
  }

  @override
  set showOnlyActive(bool value) {
    _$showOnlyActiveAtom.reportWrite(value, super.showOnlyActive, () {
      super.showOnlyActive = value;
    });
  }

  late final _$loadAsyncAction = AsyncAction(
    '_GoalsListStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_GoalsListStore.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$_GoalsListStoreActionController = ActionController(
    name: '_GoalsListStore',
    context: context,
  );

  @override
  void setShowOnlyActive(bool value) {
    final _$actionInfo = _$_GoalsListStoreActionController.startAction(
      name: '_GoalsListStore.setShowOnlyActive',
    );
    try {
      return super.setShowOnlyActive(value);
    } finally {
      _$_GoalsListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
goals: ${goals},
errorMessage: ${errorMessage},
showOnlyActive: ${showOnlyActive},
visibleGoals: ${visibleGoals}
    ''';
  }
}
