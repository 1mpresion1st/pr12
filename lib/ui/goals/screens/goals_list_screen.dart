import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../domain/usecases/goals/get_all_goals.dart';
import '../../../../domain/usecases/transactions/get_transactions.dart';
import '../stores/goals_list_store.dart';
import '../../transactions/routes.dart' as transactions_routes;

class _GoalsListScreenContent extends StatefulWidget {
  const _GoalsListScreenContent({required this.store, super.key});

  final GoalsListStore store;

  @override
  State<_GoalsListScreenContent> createState() =>
      _GoalsListScreenContentState();
}

class _GoalsListScreenContentState extends State<_GoalsListScreenContent> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      widget.store.load();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Финансовые цели'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(transactions_routes.AppRoutes.addGoal);
          if (mounted) {
            await widget.store.refresh();
          }
        },
        child: const Icon(Icons.add),
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

          final items = widget.store.visibleGoals;

          if (items.isEmpty) {
            return const Center(
              child: Text('Пока нет целей. Создайте свою первую цель.'),
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Text(
                  item.goal.icon ?? '🎯',
                  style: const TextStyle(fontSize: 24),
                ),
                title: Text(item.goal.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Отложено: ${item.totalContributed.toStringAsFixed(2)} из ${item.goal.targetAmount.toStringAsFixed(2)}',
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: item.progress,
                    ),
                  ],
                ),
                trailing: item.isCompleted
                    ? const Icon(Icons.check_circle, color: Colors.green)
                    : null,
                onTap: () async {
                  final result = await context.push(
                    transactions_routes.AppRoutes.goalDetails,
                    extra: item.goal.id,
                  );
                  if (mounted) {
                    await widget.store.refresh();
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}

class GoalsListScreen extends StatelessWidget {
  GoalsListScreen({super.key})
      : store = GoalsListStore(
          GetIt.I<GetAllGoals>(),
          GetIt.I<GetTransactions>(),
        );

  final GoalsListStore store;

  @override
  Widget build(BuildContext context) {
    return _GoalsListScreenContent(store: store);
  }
}

