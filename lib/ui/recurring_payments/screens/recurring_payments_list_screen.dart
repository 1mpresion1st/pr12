import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../data/legacy/recurring_payments_service.dart';
import '../../../../data/legacy/transactions_service.dart';
import '../stores/recurring_payments_list_store.dart';
import '../../transactions/routes.dart' as transactions_routes;

class _RecurringPaymentsListScreenContent extends StatefulWidget {
  const _RecurringPaymentsListScreenContent({required this.store, super.key});

  final RecurringPaymentsListStore store;

  @override
  State<_RecurringPaymentsListScreenContent> createState() =>
      _RecurringPaymentsListScreenContentState();
}

class _RecurringPaymentsListScreenContentState
    extends State<_RecurringPaymentsListScreenContent> {
  bool _isInitialized = false;
  bool _hasCheckedDue = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      widget.store.load().then((_) {
        if (mounted) {
          widget.store.checkDuePayments().then((_) {
            if (mounted && !_hasCheckedDue) {
              _hasCheckedDue = true;
              _showDuePaymentsDialogIfNeeded();
            }
          });
        }
      });
    }
  }

  void _showDuePaymentsDialogIfNeeded() {
    if (widget.store.duePayments.isNotEmpty &&
        !widget.store.hasShownDueDialog) {
      widget.store.hasShownDueDialog = true;
      showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Регулярные платежи'),
          content: Text(
            'Обнаружены регулярные платежи, дата списания которых наступила. Создать операции по ним?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Нет'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Да'),
            ),
          ],
        ),
      ).then((shouldCreate) async {
        if (shouldCreate == true && mounted) {
          final success =
              await widget.store.createTransactionsForDuePayments();
          if (!success &&
              widget.store.errorMessage != null &&
              mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(widget.store.errorMessage!)),
            );
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Регулярные платежи'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.push(transactions_routes.AppRoutes.addRecurringPayment);
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

          final items = widget.store.items;

          return Column(
            children: [
              // Блок с суммарной месячной стоимостью
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Всего в месяц на подписки:',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Text(
                      widget.store.totalMonthlyCost.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text(
                          'Пока нет регулярных платежей. Добавьте свою первую подписку.',
                        ),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final payment = items[index];
                          return ListTile(
                            leading: Icon(
                              payment.isActive
                                  ? Icons.repeat
                                  : Icons.pause_circle_filled,
                            ),
                            title: Text(payment.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Сумма: ${payment.amount.toStringAsFixed(2)} • ${_frequencyLabel(payment.frequency)}',
                                ),
                                Text(
                                  'Следующее списание: ${payment.nextChargeDate.day.toString().padLeft(2, '0')}.${payment.nextChargeDate.month.toString().padLeft(2, '0')}.${payment.nextChargeDate.year}',
                                ),
                              ],
                            ),
                            trailing: Switch(
                              value: payment.isActive,
                              onChanged: (value) async {
                                final updated =
                                    payment.copyWith(isActive: value);
                                await GetIt.I<RecurringPaymentsService>()
                                    .save(updated);
                                await widget.store.refresh();
                              },
                            ),
                            onTap: () async {
                              final result = await context.push(
                                transactions_routes.AppRoutes.addRecurringPayment,
                                extra: payment,
                              );
                              if (mounted) {
                                await widget.store.refresh();
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _frequencyLabel(RecurringPaymentFrequency frequency) {
    switch (frequency) {
      case RecurringPaymentFrequency.weekly:
        return 'еженедельно';
      case RecurringPaymentFrequency.monthly:
        return 'ежемесячно';
      case RecurringPaymentFrequency.yearly:
        return 'ежегодно';
    }
  }
}

class RecurringPaymentsListScreen extends StatelessWidget {
  RecurringPaymentsListScreen({super.key})
      : store = RecurringPaymentsListStore(
          GetIt.I<RecurringPaymentsService>(),
          GetIt.I<TransactionsService>(),
        );

  final RecurringPaymentsListStore store;

  @override
  Widget build(BuildContext context) {
    return _RecurringPaymentsListScreenContent(store: store);
  }
}

