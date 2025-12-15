// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StatisticsStore on _StatisticsStore, Store {
  late final _$isLoadingAtom = Atom(
    name: '_StatisticsStore.isLoading',
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

  late final _$periodAtom = Atom(
    name: '_StatisticsStore.period',
    context: context,
  );

  @override
  StatisticsPeriod get period {
    _$periodAtom.reportRead();
    return super.period;
  }

  @override
  set period(StatisticsPeriod value) {
    _$periodAtom.reportWrite(value, super.period, () {
      super.period = value;
    });
  }

  late final _$modeAtom = Atom(name: '_StatisticsStore.mode', context: context);

  @override
  StatisticsMode get mode {
    _$modeAtom.reportRead();
    return super.mode;
  }

  @override
  set mode(StatisticsMode value) {
    _$modeAtom.reportWrite(value, super.mode, () {
      super.mode = value;
    });
  }

  late final _$categoryStatsAtom = Atom(
    name: '_StatisticsStore.categoryStats',
    context: context,
  );

  @override
  ObservableList<CategoryStats> get categoryStats {
    _$categoryStatsAtom.reportRead();
    return super.categoryStats;
  }

  @override
  set categoryStats(ObservableList<CategoryStats> value) {
    _$categoryStatsAtom.reportWrite(value, super.categoryStats, () {
      super.categoryStats = value;
    });
  }

  late final _$balancePointsAtom = Atom(
    name: '_StatisticsStore.balancePoints',
    context: context,
  );

  @override
  ObservableList<DailyBalancePoint> get balancePoints {
    _$balancePointsAtom.reportRead();
    return super.balancePoints;
  }

  @override
  set balancePoints(ObservableList<DailyBalancePoint> value) {
    _$balancePointsAtom.reportWrite(value, super.balancePoints, () {
      super.balancePoints = value;
    });
  }

  late final _$totalIncomeAtom = Atom(
    name: '_StatisticsStore.totalIncome',
    context: context,
  );

  @override
  double get totalIncome {
    _$totalIncomeAtom.reportRead();
    return super.totalIncome;
  }

  @override
  set totalIncome(double value) {
    _$totalIncomeAtom.reportWrite(value, super.totalIncome, () {
      super.totalIncome = value;
    });
  }

  late final _$totalExpenseAtom = Atom(
    name: '_StatisticsStore.totalExpense',
    context: context,
  );

  @override
  double get totalExpense {
    _$totalExpenseAtom.reportRead();
    return super.totalExpense;
  }

  @override
  set totalExpense(double value) {
    _$totalExpenseAtom.reportWrite(value, super.totalExpense, () {
      super.totalExpense = value;
    });
  }

  late final _$averageDailyExpenseAtom = Atom(
    name: '_StatisticsStore.averageDailyExpense',
    context: context,
  );

  @override
  double get averageDailyExpense {
    _$averageDailyExpenseAtom.reportRead();
    return super.averageDailyExpense;
  }

  @override
  set averageDailyExpense(double value) {
    _$averageDailyExpenseAtom.reportWrite(value, super.averageDailyExpense, () {
      super.averageDailyExpense = value;
    });
  }

  late final _$averageDailyIncomeAtom = Atom(
    name: '_StatisticsStore.averageDailyIncome',
    context: context,
  );

  @override
  double get averageDailyIncome {
    _$averageDailyIncomeAtom.reportRead();
    return super.averageDailyIncome;
  }

  @override
  set averageDailyIncome(double value) {
    _$averageDailyIncomeAtom.reportWrite(value, super.averageDailyIncome, () {
      super.averageDailyIncome = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_StatisticsStore.errorMessage',
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
    '_StatisticsStore.load',
    context: context,
  );

  @override
  Future<void> load() {
    return _$loadAsyncAction.run(() => super.load());
  }

  late final _$refreshAsyncAction = AsyncAction(
    '_StatisticsStore.refresh',
    context: context,
  );

  @override
  Future<void> refresh() {
    return _$refreshAsyncAction.run(() => super.refresh());
  }

  late final _$_loadSummaryMetricsAsyncAction = AsyncAction(
    '_StatisticsStore._loadSummaryMetrics',
    context: context,
  );

  @override
  Future<void> _loadSummaryMetrics() {
    return _$_loadSummaryMetricsAsyncAction.run(
      () => super._loadSummaryMetrics(),
    );
  }

  late final _$_loadModeSpecificDataAsyncAction = AsyncAction(
    '_StatisticsStore._loadModeSpecificData',
    context: context,
  );

  @override
  Future<void> _loadModeSpecificData() {
    return _$_loadModeSpecificDataAsyncAction.run(
      () => super._loadModeSpecificData(),
    );
  }

  late final _$_StatisticsStoreActionController = ActionController(
    name: '_StatisticsStore',
    context: context,
  );

  @override
  void setPeriod(StatisticsPeriod value) {
    final _$actionInfo = _$_StatisticsStoreActionController.startAction(
      name: '_StatisticsStore.setPeriod',
    );
    try {
      return super.setPeriod(value);
    } finally {
      _$_StatisticsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setMode(StatisticsMode value) {
    final _$actionInfo = _$_StatisticsStoreActionController.startAction(
      name: '_StatisticsStore.setMode',
    );
    try {
      return super.setMode(value);
    } finally {
      _$_StatisticsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
period: ${period},
mode: ${mode},
categoryStats: ${categoryStats},
balancePoints: ${balancePoints},
totalIncome: ${totalIncome},
totalExpense: ${totalExpense},
averageDailyExpense: ${averageDailyExpense},
averageDailyIncome: ${averageDailyIncome},
errorMessage: ${errorMessage}
    ''';
  }
}
