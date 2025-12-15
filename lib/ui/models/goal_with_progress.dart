import '../../domain/entities/goal.dart' as domain;
import '../../data/legacy/goals_service.dart' as legacy;

class GoalWithProgress {
  final domain.Goal goal;
  final double totalContributed;

  GoalWithProgress({
    required this.goal,
    required this.totalContributed,
  });

  double get progress {
    if (goal.targetAmount <= 0) return 0;
    return (totalContributed / goal.targetAmount).clamp(0, 1);
  }

  double get remaining =>
      (goal.targetAmount - totalContributed).clamp(0, double.infinity);

  bool get isCompleted => totalContributed >= goal.targetAmount;
}

class GoalSubtaskWithProgress {
  final legacy.GoalSubtask subtask;
  final double contributedAmount;

  GoalSubtaskWithProgress({
    required this.subtask,
    required this.contributedAmount,
  });

  double get progress {
    if (subtask.targetAmount <= 0) return 0;
    return (contributedAmount / subtask.targetAmount).clamp(0, 1);
  }

  bool get isCompleted => contributedAmount >= subtask.targetAmount;
}

