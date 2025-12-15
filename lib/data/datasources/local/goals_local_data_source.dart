import '../../../domain/entities/goal.dart';
import '../../models/goal_dto.dart';

abstract class GoalsLocalDataSource {
  Future<List<Goal>> getAllGoals();
  Future<Goal?> getGoalById(String id);
  Future<List<GoalSubtask>> getSubtasks(String goalId);
  Future<void> saveGoal({
    required Goal goal,
    required List<GoalSubtask> subtasks,
  });
  Future<void> deleteGoal(String id);
}

class GoalsLocalDataSourceImpl implements GoalsLocalDataSource {
  final List<GoalDto> _goals = [];
  final Map<String, List<GoalSubtaskDto>> _subtasks = {};

  @override
  Future<List<Goal>> getAllGoals() async {
    return _goals.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<Goal?> getGoalById(String id) async {
    try {
      final dto = _goals.firstWhere((g) => g.id == id);
      return dto.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<GoalSubtask>> getSubtasks(String goalId) async {
    final subtasks = _subtasks[goalId] ?? [];
    final sorted = List<GoalSubtaskDto>.from(subtasks);
    sorted.sort((a, b) => a.order.compareTo(b.order));
    return sorted.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<void> saveGoal({
    required Goal goal,
    required List<GoalSubtask> subtasks,
  }) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index >= 0) {
      _goals[index] = GoalDto.fromEntity(goal);
    } else {
      _goals.add(GoalDto.fromEntity(goal));
    }

    _subtasks[goal.id] =
        subtasks.map((s) => GoalSubtaskDto.fromEntity(s)).toList();
  }

  @override
  Future<void> deleteGoal(String id) async {
    _goals.removeWhere((g) => g.id == id);
    _subtasks.remove(id);
  }
}

