// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_details_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$GoalDetailsStore on _GoalDetailsStore, Store {
  Computed<double>? _$totalContributedComputed;

  @override
  double get totalContributed =>
      (_$totalContributedComputed ??= Computed<double>(
        () => super.totalContributed,
        name: '_GoalDetailsStore.totalContributed',
      )).value;
  Computed<double>? _$progressComputed;

  @override
  double get progress => (_$progressComputed ??= Computed<double>(
    () => super.progress,
    name: '_GoalDetailsStore.progress',
  )).value;
  Computed<double>? _$remainingComputed;

  @override
  double get remaining => (_$remainingComputed ??= Computed<double>(
    () => super.remaining,
    name: '_GoalDetailsStore.remaining',
  )).value;
  Computed<bool>? _$isCompletedComputed;

  @override
  bool get isCompleted => (_$isCompletedComputed ??= Computed<bool>(
    () => super.isCompleted,
    name: '_GoalDetailsStore.isCompleted',
  )).value;
  Computed<List<GoalSubtaskWithProgress>>? _$subtasksWithProgressComputed;

  @override
  List<GoalSubtaskWithProgress> get subtasksWithProgress =>
      (_$subtasksWithProgressComputed ??=
              Computed<List<GoalSubtaskWithProgress>>(
                () => super.subtasksWithProgress,
                name: '_GoalDetailsStore.subtasksWithProgress',
              ))
          .value;

  late final _$goalAtom = Atom(
    name: '_GoalDetailsStore.goal',
    context: context,
  );

  @override
  Goal? get goal {
    _$goalAtom.reportRead();
    return super.goal;
  }

  @override
  set goal(Goal? value) {
    _$goalAtom.reportWrite(value, super.goal, () {
      super.goal = value;
    });
  }

  late final _$subtasksAtom = Atom(
    name: '_GoalDetailsStore.subtasks',
    context: context,
  );

  @override
  ObservableList<GoalSubtask> get subtasks {
    _$subtasksAtom.reportRead();
    return super.subtasks;
  }

  @override
  set subtasks(ObservableList<GoalSubtask> value) {
    _$subtasksAtom.reportWrite(value, super.subtasks, () {
      super.subtasks = value;
    });
  }

  late final _$contributionsAtom = Atom(
    name: '_GoalDetailsStore.contributions',
    context: context,
  );

  @override
  ObservableList<Transaction> get contributions {
    _$contributionsAtom.reportRead();
    return super.contributions;
  }

  @override
  set contributions(ObservableList<Transaction> value) {
    _$contributionsAtom.reportWrite(value, super.contributions, () {
      super.contributions = value;
    });
  }

  late final _$isLoadingAtom = Atom(
    name: '_GoalDetailsStore.isLoading',
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
    name: '_GoalDetailsStore.isSaving',
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
    name: '_GoalDetailsStore.errorMessage',
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

  late final _$loadAsyncAction = AsyncAction(
    '_GoalDetailsStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_GoalDetailsStore.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  @override
  String toString() {
    return '''
goal: ${goal},
subtasks: ${subtasks},
contributions: ${contributions},
isLoading: ${isLoading},
isSaving: ${isSaving},
errorMessage: ${errorMessage},
totalContributed: ${totalContributed},
progress: ${progress},
remaining: ${remaining},
isCompleted: ${isCompleted},
subtasksWithProgress: ${subtasksWithProgress}
    ''';
  }
}
