import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../data/legacy/category_budgets_service.dart';
import '../../../../data/legacy/transactions_service.dart';
import '../stores/category_budgets_store.dart';
import 'category_budget_item.dart';
import '../../transactions/routes.dart' as transactions_routes;

class _CategoryBudgetsScreenContent extends StatefulWidget {
  const _CategoryBudgetsScreenContent({required this.store, super.key});

  final CategoryBudgetsStore store;

  @override
  State<_CategoryBudgetsScreenContent> createState() =>
      _CategoryBudgetsScreenContentState();
}

class _CategoryBudgetsScreenContentState
    extends State<_CategoryBudgetsScreenContent> {
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
        title: const Text('Бюджеты по категориям'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              final prevMonth = DateTime(
                widget.store.currentMonth.year,
                widget.store.currentMonth.month - 1,
              );
              widget.store.setMonth(prevMonth);
            },
            tooltip: 'Предыдущий месяц',
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                '${_getMonthName(widget.store.currentMonth.month)} ${widget.store.currentMonth.year}',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: () {
              final nextMonth = DateTime(
                widget.store.currentMonth.year,
                widget.store.currentMonth.month + 1,
              );
              if (nextMonth.isBefore(DateTime.now()) ||
                  nextMonth.year == DateTime.now().year &&
                      nextMonth.month == DateTime.now().month) {
                widget.store.setMonth(nextMonth);
              }
            },
            tooltip: 'Следующий месяц',
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.store.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => widget.store.load(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          if (widget.store.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Нет бюджетов',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Добавьте первый лимит по категории',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: widget.store.items.length,
            itemBuilder: (context, index) {
              final item = widget.store.items[index];
              return CategoryBudgetItem(
                item: item,
                onTap: () async {
                  final result = await context.push(
                    transactions_routes.AppRoutes.editCategoryBudget,
                    extra: item.budget,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(
            transactions_routes.AppRoutes.editCategoryBudget,
          );
          if (mounted) {
            await widget.store.refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return months[month - 1];
  }
}

class CategoryBudgetsScreen extends StatelessWidget {
  CategoryBudgetsScreen({super.key})
      : store = CategoryBudgetsStore(
          GetIt.I<CategoryBudgetsService>(),
          GetIt.I<TransactionsService>(),
        );

  final CategoryBudgetsStore store;

  @override
  Widget build(BuildContext context) {
    return _CategoryBudgetsScreenContent(store: store);
  }
}

