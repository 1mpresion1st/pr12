import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../data/legacy/goals_service.dart';
import '../../../../data/legacy/transactions_service.dart';
import '../stores/goal_details_store.dart';
import '../../transactions/routes.dart' as transactions_routes;

class _GoalDetailsScreenState extends StatefulWidget {
  final GoalDetailsStore store;

  const _GoalDetailsScreenState({required this.store});

  @override
  State<_GoalDetailsScreenState> createState() =>
      _GoalDetailsScreenStateState();
}

class _GoalDetailsScreenStateState extends State<_GoalDetailsScreenState> {
  @override
  void initState() {
    super.initState();
    widget.store.load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !widget.store.isLoading) {
        widget.store.refresh();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Цель'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final currentGoal = widget.store.goal;
              if (currentGoal == null) return;

              final result = await context.push(
                transactions_routes.AppRoutes.addGoal,
                extra: currentGoal,
              );
              if (mounted) {
                await widget.store.refresh();
              }
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (widget.store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.store.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(widget.store.errorMessage!),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: widget.store.load,
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          final goal = widget.store.goal;
          if (goal == null) {
            return const Center(child: Text('Цель не найдена'));
          }

          final subtasks = widget.store.subtasksWithProgress;
          final contributions = widget.store.contributions;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  goal.icon ?? '🎯',
                  style: const TextStyle(fontSize: 40),
                ),
                const SizedBox(height: 8),
                Text(
                  goal.name,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (goal.description != null && goal.description!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(goal.description!),
                  ),
                const SizedBox(height: 16),
                Text(
                  'Цель: ${goal.targetAmount.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                if (goal.targetDate != null)
                  Text(
                    'К дате: ${goal.targetDate!.day.toString().padLeft(2, '0')}.${goal.targetDate!.month.toString().padLeft(2, '0')}.${goal.targetDate!.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                const SizedBox(height: 16),
                Text(
                  'Отложено: ${widget.store.totalContributed.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Осталось: ${widget.store.remaining.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: widget.store.progress),
                const SizedBox(height: 24),
                Text(
                  'Подцели',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (subtasks.isEmpty)
                  const Text('Подцели не заданы')
                else
                  Column(
                    children: subtasks.map((s) {
                      return ListTile(
                        title: Text(s.subtask.name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Цель: ${s.subtask.targetAmount.toStringAsFixed(2)}',
                            ),
                            Text(
                              'Отложено: ${s.contributedAmount.toStringAsFixed(2)}',
                            ),
                            const SizedBox(height: 4),
                            LinearProgressIndicator(
                              value: s.progress,
                            ),
                          ],
                        ),
                        trailing: s.isCompleted
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : null,
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 24),
                Text(
                  'Операции по цели',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (contributions.isEmpty)
                  const Text('Пока нет операций, связанных с этой целью.')
                else
                  Column(
                    children: contributions.map((t) {
                      return ListTile(
                        title: Text(t.category),
                        subtitle: Text(
                          '${t.date.day.toString().padLeft(2, '0')}.${t.date.month.toString().padLeft(2, '0')}.${t.date.year} • ${t.note ?? ''}',
                        ),
                        trailing: Text(
                          t.amount.toStringAsFixed(2),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GoalDetailsScreen extends StatelessWidget {
  GoalDetailsScreen({
    super.key,
    required this.goalId,
  }) : store = GoalDetailsStore(
          GetIt.I<GoalsService>(),
          GetIt.I<TransactionsService>(),
          goalId,
        );

  final String goalId;
  final GoalDetailsStore store;

  @override
  Widget build(BuildContext context) {
    return _GoalDetailsScreenState(store: store);
  }
}

