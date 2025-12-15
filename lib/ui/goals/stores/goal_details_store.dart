import 'package:mobx/mobx.dart';
import '../../../../data/legacy/goals_service.dart';
import '../../../../data/legacy/transactions_service.dart';
import '../../models/goal_with_progress.dart';

part 'goal_details_store.g.dart';

class GoalDetailsStore = _GoalDetailsStore with _$GoalDetailsStore;

abstract class _GoalDetailsStore with Store {
  _GoalDetailsStore(
    this._goalsService,
    this._transactionsService,
    this.goalId,
  );

  final GoalsService _goalsService;
  final TransactionsService _transactionsService;
  final String goalId;

  @observable
  Goal? goal;

  @observable
  ObservableList<GoalSubtask> subtasks = ObservableList<GoalSubtask>.of([]);

  @observable
  ObservableList<Transaction> contributions =
      ObservableList<Transaction>.of([]);

  @observable
  bool isLoading = false;

  @observable
  bool isSaving = false;

  @observable
  String? errorMessage;

  @computed
  double get totalContributed =>
      contributions.fold(0.0, (prev, t) => prev + t.amount);

  @computed
  double get progress {
    if (goal == null || goal!.targetAmount <= 0) return 0;
    return (totalContributed / goal!.targetAmount).clamp(0, 1);
  }

  @computed
  double get remaining {
    if (goal == null) return 0;
    return (goal!.targetAmount - totalContributed).clamp(0, double.infinity);
  }

  @computed
  bool get isCompleted =>
      goal != null && totalContributed >= goal!.targetAmount;

  @computed
  List<GoalSubtaskWithProgress> get subtasksWithProgress {
    double remainingForSubtasks = totalContributed;
    final sorted = subtasks.toList()
      ..sort((a, b) => a.order.compareTo(b.order));

    return sorted.map((subtask) {
      final contributedForThis = remainingForSubtasks <= 0
          ? 0.0
          : remainingForSubtasks >= subtask.targetAmount
              ? subtask.targetAmount
              : remainingForSubtasks;

      remainingForSubtasks =
          (remainingForSubtasks - contributedForThis).clamp(0, double.infinity);

      return GoalSubtaskWithProgress(
        subtask: subtask,
        contributedAmount: contributedForThis,
      );
    }).toList();
  }

  @action
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;

    try {
      goal = await _goalsService.getGoalById(goalId);
      if (goal == null) {
        errorMessage = 'Цель не найдена';
        return;
      }

      final subtasksList = await _goalsService.getSubtasks(goalId);
      subtasks
        ..clear()
        ..addAll(subtasksList);

      final txs = await _transactionsService.getTransactions(
        type: TransactionType.income,
        goalId: goalId,
      );

      contributions
        ..clear()
        ..addAll(txs);
    } catch (e) {
      errorMessage = 'Ошибка при загрузке данных цели';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> refresh() async {
    await load();
  }
}


