import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../data/legacy/category_budgets_service.dart';
import '../stores/edit_category_budget_store.dart';

class EditCategoryBudgetScreen extends StatefulWidget {
  const EditCategoryBudgetScreen({
    super.key,
    this.initialBudget,
  });

  final CategoryBudget? initialBudget;

  @override
  State<EditCategoryBudgetScreen> createState() =>
      _EditCategoryBudgetScreenState();
}

class _EditCategoryBudgetScreenState extends State<EditCategoryBudgetScreen> {
  late final EditCategoryBudgetStore store;
  late final TextEditingController categoryController;
  late final TextEditingController limitController;

  @override
  void initState() {
    super.initState();
    store = EditCategoryBudgetStore(
      GetIt.I<CategoryBudgetsService>(),
      initialBudget: widget.initialBudget,
    );
    categoryController = TextEditingController(text: store.category);
    limitController = TextEditingController(text: store.limitText);
  }

  @override
  void dispose() {
    categoryController.dispose();
    limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.initialBudget != null;

    return Scaffold(
        appBar: AppBar(
          title: Text(isEditMode ? 'Редактирование бюджета' : 'Новый бюджет'),
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Удалить бюджет?'),
                        content: const Text(
                          'Вы уверены, что хотите удалить этот бюджет?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Отмена'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
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
                      labelText: 'Категория',
                      hintText: 'Например, Еда',
                      border: OutlineInputBorder(),
                    ),
                    controller: categoryController,
                    onChanged: (value) {
                      store.setCategory(value);
                      categoryController.value = TextEditingValue(
                        text: value,
                        selection: TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Месячный лимит',
                      hintText: 'Например, 20000',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: limitController,
                    onChanged: (value) {
                      store.setLimitText(value);
                      limitController.value = TextEditingValue(
                        text: value,
                        selection: TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Период: месяц',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
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
                    height: 48,
                    child: ElevatedButton(
                      onPressed: store.isSaving
                          ? null
                          : () async {
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
                      child: store.isSaving
                          ? const CircularProgressIndicator()
                          : Text(store.isEditMode ? 'Сохранить' : 'Создать'),
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
}

