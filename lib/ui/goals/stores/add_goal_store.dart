import 'dart:async';
import 'package:mobx/mobx.dart';
import '../../../../data/legacy/goals_service.dart';
import '../../../../domain/usecases/preferences/read_pref_string.dart';
import '../../../../domain/usecases/preferences/write_pref_string.dart';
import '../../../../domain/usecases/preferences/delete_pref_key.dart';

part 'add_goal_store.g.dart';

class AddGoalStore = _AddGoalStore with _$AddGoalStore;

abstract class _AddGoalStore with Store {
  _AddGoalStore(
    this._goalsService,
    this._readPrefString,
    this._writePrefString,
    this._deletePrefKey, {
    Goal? initialGoal,
    List<GoalSubtask>? initialSubtasks,
  }) : _initialGoal = initialGoal {
    if (initialGoal != null) {
      name = initialGoal.name;
      targetAmountText = initialGoal.targetAmount.toString();
      targetDate = initialGoal.targetDate;
      icon = initialGoal.icon;
      description = initialGoal.description;
    }

    final subtasks = initialSubtasks ?? [];
    for (final s in subtasks) {
      subtaskNames.add(s.name);
      subtaskAmounts.add(s.targetAmount.toString());
    }
  }

  final GoalsService _goalsService;
  final ReadPrefString _readPrefString;
  final WritePrefString _writePrefString;
  final DeletePrefKey _deletePrefKey;
  final Goal? _initialGoal;

  Timer? _nameDebounceTimer;
  Timer? _descriptionDebounceTimer;

  static const String _nameKey = 'pr12:add_goal:name';
  static const String _descriptionKey = 'pr12:add_goal:description';

  @observable
  String name = '';

  @observable
  String targetAmountText = '';

  @observable
  DateTime? targetDate;

  @observable
  String? icon;

  @observable
  String? description;

  @observable
  ObservableList<String> subtaskNames = ObservableList.of([]);

  @observable
  ObservableList<String> subtaskAmounts = ObservableList.of([]);

  @observable
  bool isSaving = false;

  @observable
  String? errorMessage;

  @computed
  bool get isEditMode => _initialGoal != null;

  @computed
  double? get targetAmount {
    final value = double.tryParse(targetAmountText.replaceAll(',', '.'));
    if (value == null || value <= 0) return null;
    return value;
  }

  @computed
  List<double?> get subtaskAmountValues =>
      subtaskAmounts
          .map((t) => double.tryParse(t.replaceAll(',', '.')))
          .toList();

  @action
  Future<void> init() async {
    // Не загружаем черновик в режиме редактирования
    if (isEditMode) return;

    try {
      final savedName = await _readPrefString(_nameKey);
      final savedDescription = await _readPrefString(_descriptionKey);

      if (savedName != null && savedName.isNotEmpty) {
        name = savedName;
      }

      if (savedDescription != null && savedDescription.isNotEmpty) {
        description = savedDescription;
      }
    } catch (e) {
      // Игнорируем ошибки при чтении из preferences
    }
  }

  @action
  void setName(String value) {
    name = value;
    // Сохраняем только если не в режиме редактирования
    if (!isEditMode) {
      onNameChanged(value);
    }
  }

  @action
  void onNameChanged(String value) {
    // Debounce сохранения в preferences
    _nameDebounceTimer?.cancel();
    _nameDebounceTimer = Timer(const Duration(milliseconds: 400), () {
      _writePrefString(_nameKey, value).catchError((_) {
        // Игнорируем ошибки при записи в preferences
      });
    });
  }

  @action
  void setTargetAmountText(String value) => targetAmountText = value;

  @action
  void setTargetDate(DateTime? value) => targetDate = value;

  @action
  void setIcon(String? value) => icon = value;

  @action
  void setDescription(String? value) {
    description = value;
    // Сохраняем только если не в режиме редактирования
    if (!isEditMode) {
      onDescriptionChanged(value ?? '');
    }
  }

  @action
  void onDescriptionChanged(String value) {
    // Debounce сохранения в preferences
    _descriptionDebounceTimer?.cancel();
    _descriptionDebounceTimer = Timer(const Duration(milliseconds: 400), () {
      _writePrefString(_descriptionKey, value).catchError((_) {
        // Игнорируем ошибки при записи в preferences
      });
    });
  }

  @action
  void addSubtask() {
    subtaskNames.add('');
    subtaskAmounts.add('');
  }

  @action
  void removeSubtask(int index) {
    if (index < 0 || index >= subtaskNames.length) return;
    subtaskNames.removeAt(index);
    subtaskAmounts.removeAt(index);
  }

  @action
  void setSubtaskName(int index, String value) {
    if (index < 0 || index >= subtaskNames.length) return;
    subtaskNames[index] = value;
  }

  @action
  void setSubtaskAmount(int index, String value) {
    if (index < 0 || index >= subtaskAmounts.length) return;
    subtaskAmounts[index] = value;
  }

  @action
  Future<bool> save() async {
    final amount = targetAmount;
    if (name.trim().isEmpty || amount == null) {
      errorMessage = 'Заполните название цели и положительную сумму';
      return false;
    }

    final parsedSubtasks = <GoalSubtask>[];
    for (var i = 0; i < subtaskNames.length; i++) {
      final subName = subtaskNames[i].trim();
      final amountStr = subtaskAmounts[i];
      final amount = double.tryParse(amountStr.replaceAll(',', '.'));

      if (subName.isEmpty && (amount == null || amount <= 0)) {
        continue;
      }

      if (subName.isEmpty || amount == null || amount <= 0) {
        errorMessage =
            'Заполните имя и сумму для каждой подцели или оставьте строки пустыми';
        return false;
      }

      parsedSubtasks.add(
        GoalSubtask(
          id:
              '${_initialGoal?.id ?? DateTime.now().millisecondsSinceEpoch}_$i',
          goalId: _initialGoal?.id ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          name: subName,
          targetAmount: amount,
          order: i,
        ),
      );
    }

    isSaving = true;
    errorMessage = null;

    try {
      final goalId =
          _initialGoal?.id ?? DateTime.now().millisecondsSinceEpoch.toString();

      final goal = Goal(
        id: goalId,
        name: name.trim(),
        targetAmount: amount,
        targetDate: targetDate,
        icon: icon,
        description: description,
        createdAt: _initialGoal?.createdAt ?? DateTime.now(),
      );

      final subtasks = parsedSubtasks
          .map((s) => GoalSubtask(
                id: s.id,
                goalId: goalId,
                name: s.name,
                targetAmount: s.targetAmount,
                order: s.order,
              ))
          .toList();

      await _goalsService.saveGoal(
        goal: goal,
        subtasks: subtasks,
      );

      // Очищаем черновик после успешного сохранения
      await clearDraft();

      return true;
    } catch (e) {
      errorMessage = 'Ошибка при сохранении цели';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<bool> delete() async {
    final goal = _initialGoal;
    if (goal == null) return false;

    isSaving = true;
    errorMessage = null;

    try {
      await _goalsService.deleteGoal(goal.id);
      return true;
    } catch (e) {
      errorMessage = 'Ошибка при удалении цели';
      return false;
    } finally {
      isSaving = false;
    }
  }

  @action
  Future<void> clearDraft() async {
    // Отменяем таймеры debounce перед очисткой
    _nameDebounceTimer?.cancel();
    _descriptionDebounceTimer?.cancel();

    try {
      await _deletePrefKey(_nameKey);
      await _deletePrefKey(_descriptionKey);
    } catch (e) {
      // Игнорируем ошибки при удалении из preferences
    }
  }

  void dispose() {
    _nameDebounceTimer?.cancel();
    _descriptionDebounceTimer?.cancel();
  }
}


