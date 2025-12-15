import 'package:mobx/mobx.dart';
import '../../../../domain/entities/statistics.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/usecases/statistics/get_category_stats.dart';
import '../../../../domain/usecases/statistics/get_balance_dynamics.dart';
import '../../../../domain/usecases/statistics/get_total_amount.dart';

part 'statistics_store.g.dart';

class StatisticsStore = _StatisticsStore with _$StatisticsStore;

abstract class _StatisticsStore with Store {
  _StatisticsStore(
    this._getCategoryStats,
    this._getBalanceDynamics,
    this._getTotalAmount,
  );

  final GetCategoryStats _getCategoryStats;
  final GetBalanceDynamics _getBalanceDynamics;
  final GetTotalAmount _getTotalAmount;

  @observable
  bool isLoading = false;

  @observable
  StatisticsPeriod period = StatisticsPeriod.month;

  @observable
  StatisticsMode mode = StatisticsMode.expensesByCategory;

  @observable
  ObservableList<CategoryStats> categoryStats = ObservableList.of([]);

  @observable
  ObservableList<DailyBalancePoint> balancePoints = ObservableList.of([]);

  @observable
  double totalIncome = 0;

  @observable
  double totalExpense = 0;

  @observable
  double averageDailyExpense = 0;

  @observable
  double averageDailyIncome = 0;

  @observable
  String? errorMessage;

  @action
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;

    try {
      await _loadSummaryMetrics();
      await _loadModeSpecificData();
    } catch (e) {
      errorMessage = 'Ошибка при загрузке статистики';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> refresh() async {
    await load();
  }

  @action
  void setPeriod(StatisticsPeriod value) {
    period = value;
    load();
  }

  @action
  void setMode(StatisticsMode value) {
    mode = value;
    _loadModeSpecificData();
  }

  @action
  Future<void> _loadSummaryMetrics() async {
    totalIncome = await _getTotalAmount(
      period: period,
      type: TransactionType.income,
    );

    totalExpense = await _getTotalAmount(
      period: period,
      type: TransactionType.expense,
    );

    // Calculate average daily amounts
    final now = DateTime.now();
    int days = 1;

    switch (period) {
      case StatisticsPeriod.week:
        days = 7;
        break;
      case StatisticsPeriod.month:
        final firstDay = DateTime(now.year, now.month, 1);
        days = now.difference(firstDay).inDays + 1;
        break;
      case StatisticsPeriod.year:
        final firstDay = DateTime(now.year, 1, 1);
        days = now.difference(firstDay).inDays + 1;
        break;
      case StatisticsPeriod.all:
        // For "all" period, we'd need to get the first transaction date
        // For now, use a default
        days = 30;
        break;
    }

    averageDailyIncome = days > 0 ? totalIncome / days : 0.0;
    averageDailyExpense = days > 0 ? totalExpense / days : 0.0;
  }

  @action
  Future<void> _loadModeSpecificData() async {
    switch (mode) {
      case StatisticsMode.expensesByCategory:
        final stats = await _getCategoryStats(
          period: period,
          type: TransactionType.expense,
        );
        categoryStats
          ..clear()
          ..addAll(stats);
        balancePoints.clear();
        break;

      case StatisticsMode.incomeByCategory:
        final stats = await _getCategoryStats(
          period: period,
          type: TransactionType.income,
        );
        categoryStats
          ..clear()
          ..addAll(stats);
        balancePoints.clear();
        break;

      case StatisticsMode.balanceDynamics:
        final points = await _getBalanceDynamics(
          period: period,
        );
        balancePoints
          ..clear()
          ..addAll(points);
        categoryStats.clear();
        break;
    }
  }
}

