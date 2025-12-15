import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../domain/entities/transaction.dart';
import '../stores/transactions_list_store.dart';
import 'transaction_item.dart';
import '../routes.dart';

class TransactionsListScreen extends StatelessWidget {
  TransactionsListScreen({super.key})
      : store = TransactionsListStore(GetIt.I());

  final TransactionsListStore store;

  @override
  Widget build(BuildContext context) {
    Future.microtask(() => store.load());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Операции'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final transactions = store.filteredTransactions;

          if (transactions.isEmpty) {
            return const Center(child: Text('Нет операций'));
          }

          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return TransactionItem(
                transaction: transaction,
                onTap: () async {
                  final result = await context.push(
                    AppRoutes.transactionDetails,
                    extra: transaction.id,
                  );
                  if (result == true) {
                    await store.refresh();
                  }
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(AppRoutes.addTransaction);
          if (result == true) {
            await store.refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Observer(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Фильтры',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const Text('Тип операции:'),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Все'),
                        selected: store.typeFilter == null,
                        onSelected: (selected) {
                          if (selected) store.setTypeFilter(null);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Доходы'),
                        selected: store.typeFilter == TransactionType.income,
                        onSelected: (selected) {
                          if (selected) store.setTypeFilter(TransactionType.income);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Расходы'),
                        selected: store.typeFilter == TransactionType.expense,
                        onSelected: (selected) {
                          if (selected) store.setTypeFilter(TransactionType.expense);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    final DateTimeRange? picked = await showDateRangePicker(
                      context: context,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                      initialDateRange: store.fromDate != null && store.toDate != null
                          ? DateTimeRange(start: store.fromDate!, end: store.toDate!)
                          : null,
                    );
                    if (picked != null) {
                      store.setDateRange(picked.start, picked.end);
                    }
                  },
                  child: const Text('Выбрать диапазон дат'),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Применить'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

