enum GoalStatus {
  inProgress,
  completed,
}

class Goal {
  final String id;
  final String name;
  final double targetAmount;
  final DateTime? targetDate;
  final String? icon;
  final String? description;
  final DateTime createdAt;

  Goal({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.targetDate,
    this.icon,
    this.description,
    required this.createdAt,
  });
}

class GoalSubtask {
  final String id;
  final String goalId;
  final String name;
  final double targetAmount;
  final int order;

  GoalSubtask({
    required this.id,
    required this.goalId,
    required this.name,
    required this.targetAmount,
    required this.order,
  });
}

