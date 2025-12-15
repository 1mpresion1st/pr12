import 'package:mobx/mobx.dart';
import '../../../../data/legacy/category_budgets_service.dart';

part 'edit_category_budget_store.g.dart';

class EditCategoryBudgetStore = _EditCategoryBudgetStore
    with _$EditCategoryBudgetStore;

abstract class _EditCategoryBudgetStore with Store {
  _EditCategoryBudgetStore(
    this._categoryBudgetsService, {
    CategoryBudget? initialBudget,
  }) : _initialBudget = initialBudget {
    if (initialBudget != null) {
      category = initialBudget.category;
      limitText = initialBudget.limitAmount.toString();
      period = initialBudget.period;
    } else {
      period = BudgetPeriod.monthly;
    }
  }

  final CategoryBudgetsService _categoryBudgetsService;
  final CategoryBudget? _initialBudget;

  @observable
  String category = '';

  @observable
  String limitText = '';

  @observable
  BudgetPeriod period = BudgetPeriod.monthly;

  @observable
  bool isSaving = false;

  @observable
  String? errorMessage;

  @computed
  double? get limitAmount {
    final value = double.tryParse(limitText.replaceAll(',', '.'));
    if (value == null || value <= 0) return null;
    return value;
  }

  @computed
  bool get isEditMode => _initialBudget != null;

  @action
  void setCategory(String value) {
    category = value;
  }

  @action
  void setLimitText(String value) {
    limitText = value;
  }

  @action
  Future<bool> save() async {
    final amount = limitAmount;
    if (category.trim().isEmpty || amount == null) {
      errorMessage = 'Заполните категорию и положительный лимит';
      return false;
    }

    isSaving = true;
    errorMessage = null;

    try {
      final budget = CategoryBudget(
        id: _initialBudget?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        category: category.trim(),
        limitAmount: amount,
        period: period,
      );

      await _categoryBudgetsService.saveBudget(budget);
      return true;
    } catch (e) {
      errorMessage = 'Ошибка при сохранении бюджета';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> delete() async {
    final budget = _initialBudget;
    if (budget == null) return false;

    isSaving = true;
    errorMessage = null;

    try {
      await _categoryBudgetsService.deleteBudget(budget.id);
      return true;
    } catch (e) {
      errorMessage = 'Ошибка при удалении бюджета';
      return false;
    } finally {
      isSaving = false;
    }
  }
}

