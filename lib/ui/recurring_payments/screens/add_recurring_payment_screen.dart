import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../data/legacy/recurring_payments_service.dart';
import '../stores/add_recurring_payment_store.dart';

class AddRecurringPaymentScreen extends StatelessWidget {
  AddRecurringPaymentScreen({
    super.key,
    this.initialPayment,
  }) : store = AddRecurringPaymentStore(
          GetIt.I<RecurringPaymentsService>(),
          initialPayment: initialPayment,
        );

  final RecurringPayment? initialPayment;
  final AddRecurringPaymentStore store;

  @override
  Widget build(BuildContext context) {
    final isEditMode = initialPayment != null;

    return Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Редактирование платежа' : 'Новый платеж'),
          actions: [
            if (isEditMode)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  final confirmed = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Удалить платеж?'),
                          content: const Text(
                            'Вы уверены, что хотите удалить этот регулярный платеж?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(false),
                              child: const Text('Отмена'),
                            ),
                            TextButton(
                              onPressed: () =>
                                  Navigator.of(context).pop(true),
                              child: const Text('Удалить'),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                  if (!confirmed) return;

                  final success = await store.delete();
                  if (success) {
                    if (context.mounted) {
                      context.pop(true);
                    }
                  } else if (store.errorMessage != null && context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(store.errorMessage!)),
                    );
                  }
                },
              ),
          ],
        ),
        body: Observer(
          builder: (_) {
            return AbsorbPointer(
              absorbing: store.isSaving,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Название платежа',
                        hintText: 'Например, Netflix',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: store.name)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: store.name.length),
                        ),
                      onChanged: store.setName,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Сумма',
                        hintText: 'Например, 999',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      controller: TextEditingController(text: store.amountText)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: store.amountText.length),
                        ),
                      onChanged: store.setAmountText,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Категория',
                        hintText: 'Например, Подписки',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: store.category)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(offset: store.category.length),
                        ),
                      onChanged: store.setCategory,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Text('Периодичность:'),
                        const SizedBox(width: 16),
                        DropdownButton<RecurringPaymentFrequency>(
                          value: store.frequency,
                          onChanged: (value) {
                            if (value != null) {
                              store.setFrequency(value);
                            }
                          },
                          items: RecurringPaymentFrequency.values
                              .map(
                                (f) => DropdownMenuItem(
                                  value: f,
                                  child: Text(_frequencyLabel(f)),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Следующее списание: ${store.nextChargeDate.day.toString().padLeft(2, '0')}.${store.nextChargeDate.month.toString().padLeft(2, '0')}.${store.nextChargeDate.year}',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: store.nextChargeDate,
                              firstDate: DateTime(now.year - 1),
                              lastDate: DateTime(now.year + 5),
                            );
                            if (picked != null) {
                              store.setNextChargeDate(picked);
                            }
                          },
                          child: const Text('Выбрать дату'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Автоматически создавать операции'),
                      value: store.autoCreateTransaction,
                      onChanged: store.setAutoCreateTransaction,
                    ),
                    SwitchListTile(
                      title: const Text('Активен'),
                      value: store.isActive,
                      onChanged: store.setIsActive,
                    ),
                    const SizedBox(height: 24),
                    if (store.errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Text(
                          store.errorMessage!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          final success = await store.save();
                          if (success) {
                            if (context.mounted) {
                              context.pop(true);
                            }
                          } else if (store.errorMessage != null &&
                              context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(store.errorMessage!)),
                            );
                          }
                        },
                        child: Text(
                          isEditMode ? 'Сохранить' : 'Создать платеж',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
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

