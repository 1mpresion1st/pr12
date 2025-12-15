import 'package:mobx/mobx.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/usecases/goals/get_all_goals.dart';
import '../../../../domain/usecases/transactions/get_transactions.dart';
import '../../models/goal_with_progress.dart';

part 'goals_list_store.g.dart';

class GoalsListStore = _GoalsListStore with _$GoalsListStore;

abstract class _GoalsListStore with Store {
  _GoalsListStore(
    this._getAllGoals,
    this._getTransactions,
  );

  final GetAllGoals _getAllGoals;
  final GetTransactions _getTransactions;

  @observable
  bool isLoading = false;

  @observable
  ObservableList<GoalWithProgress> goals =
      ObservableList<GoalWithProgress>.of([]);

  @observable
  String? errorMessage;

  @observable
  bool showOnlyActive = false;

  @computed
  List<GoalWithProgress> get visibleGoals {
    if (!showOnlyActive) return goals.toList();
    return goals.where((g) => !g.isCompleted).toList();
  }

  @action
  void setShowOnlyActive(bool value) {
    showOnlyActive = value;
  }

  @action
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;

    try {
      final allGoals = await _getAllGoals();

      final allTransactions = await _getTransactions(
        type: TransactionType.income,
      );

      final Map<String, double> sumByGoalId = {};
      for (final t in allTransactions) {
        final goalId = t.goalId;
        if (goalId == null) continue;
        sumByGoalId[goalId] = (sumByGoalId[goalId] ?? 0) + t.amount;
      }

      final list = allGoals.map((goal) {
        final totalContributed = sumByGoalId[goal.id] ?? 0.0;
        return GoalWithProgress(
          goal: goal,
          totalContributed: totalContributed,
        );
      }).toList();

      goals
        ..clear()
        ..addAll(list);
    } catch (e) {
      errorMessage = 'Ошибка при загрузке целей';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> refresh() async {
    await load();
  }
}

