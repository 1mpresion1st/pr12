import 'package:mobx/mobx.dart';
import '../../../../data/legacy/category_budgets_service.dart';
import '../../../../data/legacy/transactions_service.dart';
import '../../models/category_budget_with_progress.dart';

part 'category_budgets_store.g.dart';

class CategoryBudgetsStore = _CategoryBudgetsStore with _$CategoryBudgetsStore;

abstract class _CategoryBudgetsStore with Store {
  _CategoryBudgetsStore(
    this._categoryBudgetsService,
    this._transactionsService,
  );

  final CategoryBudgetsService _categoryBudgetsService;
  final TransactionsService _transactionsService;

  @observable
  bool isLoading = false;

  @observable
  ObservableList<CategoryBudgetWithProgress> items =
      ObservableList<CategoryBudgetWithProgress>.of([]);

  @observable
  String? errorMessage;

  @observable
  DateTime currentMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @computed
  DateTime get monthStart => DateTime(currentMonth.year, currentMonth.month, 1);

  @computed
  DateTime get monthEnd {
    final nextMonth = DateTime(currentMonth.year, currentMonth.month + 1, 1);
    return nextMonth.subtract(const Duration(days: 1));
  }

  @action
  Future<void> load() async {
    isLoading = true;
    errorMessage = null;

    try {
      final budgets = await _categoryBudgetsService.getAllBudgets();

      final transactions = await _transactionsService.getTransactions(
        type: TransactionType.expense,
        from: monthStart,
        to: monthEnd,
      );

      final Map<String, double> spentByCategory = {};
      for (final t in transactions) {
        spentByCategory[t.category] =
            (spentByCategory[t.category] ?? 0) + t.amount;
      }

      final result = budgets.map((budget) {
        final spentAmount = spentByCategory[budget.category] ?? 0.0;
        return CategoryBudgetWithProgress(
          budget: budget,
          spentAmount: spentAmount,
        );
      }).toList();

      items
        ..clear()
        ..addAll(result);
    } catch (e) {
      errorMessage = 'Ошибка при загрузке бюджетов';
      // Не очищаем items при ошибке, оставляем предыдущие данные
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> refresh() async {
    await load();
  }

  @action
  void setMonth(DateTime month) {
    currentMonth = DateTime(month.year, month.month);
    load();
  }
}

