import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../data/legacy/goals_service.dart';
import '../../../../domain/usecases/preferences/read_pref_string.dart';
import '../../../../domain/usecases/preferences/write_pref_string.dart';
import '../../../../domain/usecases/preferences/delete_pref_key.dart';
import '../stores/add_goal_store.dart';

class AddGoalScreen extends StatefulWidget {
  const AddGoalScreen({
    super.key,
    this.initialGoal,
  });

  final Goal? initialGoal;

  @override
  State<AddGoalScreen> createState() => _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  late final AddGoalStore store;
  late final TextEditingController nameController;
  late final TextEditingController amountController;
  late final TextEditingController iconController;
  late final TextEditingController descriptionController;
  List<TextEditingController> subtaskNameControllers = [];
  List<TextEditingController> subtaskAmountControllers = [];

  @override
  void initState() {
    super.initState();
    store = AddGoalStore(
      GetIt.I<GoalsService>(),
      GetIt.I<ReadPrefString>(),
      GetIt.I<WritePrefString>(),
      GetIt.I<DeletePrefKey>(),
      initialGoal: widget.initialGoal,
    );

    if (widget.initialGoal != null) {
      GetIt.I<GoalsService>()
          .getSubtasks(widget.initialGoal!.id)
          .then((subtasks) {
        if (mounted) {
          store.subtaskNames.clear();
          store.subtaskAmounts.clear();
          for (var subtask in subtasks) {
            store.subtaskNames.add(subtask.name);
            store.subtaskAmounts.add(subtask.targetAmount.toString());
          }
          _updateControllers();
        }
      });
    }

    nameController = TextEditingController(text: store.name);
    amountController = TextEditingController(text: store.targetAmountText);
    iconController = TextEditingController(text: store.icon ?? '');
    descriptionController = TextEditingController(text: store.description ?? '');
    _updateControllers();
    
    // Загружаем черновик из preferences после создания контроллеров
    _initPreferences();
  }

  Future<void> _initPreferences() async {
    await store.init();
    // Обновляем контроллеры после загрузки из preferences
    if (mounted) {
      nameController.text = store.name;
      descriptionController.text = store.description ?? '';
    }
  }

  void _updateControllers() {
    for (var i = 0; i < store.subtaskNames.length; i++) {
      if (i >= subtaskNameControllers.length) {
        subtaskNameControllers.add(TextEditingController());
        subtaskAmountControllers.add(TextEditingController());
      }
      subtaskNameControllers[i].text = store.subtaskNames[i];
      subtaskAmountControllers[i].text = store.subtaskAmounts[i];
    }
    while (subtaskNameControllers.length > store.subtaskNames.length) {
      subtaskNameControllers.removeLast().dispose();
      subtaskAmountControllers.removeLast().dispose();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    iconController.dispose();
    descriptionController.dispose();
    for (var c in subtaskNameControllers) {
      c.dispose();
    }
    for (var c in subtaskAmountControllers) {
      c.dispose();
    }
    store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditMode = widget.initialGoal != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditMode ? 'Редактирование цели' : 'Новая цель'),
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Удалить цель?'),
                        content: const Text(
                          'Вы уверены, что хотите удалить эту цель и все её подцели?',
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
                      labelText: 'Название цели',
                      hintText: 'Например, Новый ноутбук',
                      border: OutlineInputBorder(),
                    ),
                    controller: nameController,
                    onChanged: (value) {
                      store.setName(value);
                      nameController.value = TextEditingValue(
                        text: value,
                        selection: TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Целевая сумма',
                      hintText: 'Например, 120000',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    controller: amountController,
                    onChanged: (value) {
                      store.setTargetAmountText(value);
                      amountController.value = TextEditingValue(
                        text: value,
                        selection: TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          store.targetDate == null
                              ? 'Желаемая дата не выбрана'
                              : 'Желаемая дата: ${store.targetDate!.day.toString().padLeft(2, '0')}.${store.targetDate!.month.toString().padLeft(2, '0')}.${store.targetDate!.year}',
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final now = DateTime.now();
                          final initialDate = store.targetDate ??
                              now.add(const Duration(days: 30));
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: initialDate,
                            firstDate: now,
                            lastDate: DateTime(now.year + 10),
                          );
                          if (picked != null) {
                            store.setTargetDate(picked);
                          }
                        },
                        child: const Text('Выбрать дату'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Иконка (emoji)',
                      hintText: 'Например, 🎯',
                      border: OutlineInputBorder(),
                    ),
                    controller: iconController,
                    onChanged: (value) {
                      store.setIcon(value.isEmpty ? null : value);
                      iconController.value = TextEditingValue(
                        text: value,
                        selection: TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Описание (опционально)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    controller: descriptionController,
                    onChanged: (value) {
                      store.setDescription(value.isEmpty ? null : value);
                      descriptionController.value = TextEditingValue(
                        text: value,
                        selection: TextSelection.collapsed(offset: value.length),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Подцели / этапы',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Observer(
                    builder: (_) {
                      _updateControllers();
                      return Column(
                        children: [
                          for (var i = 0; i < store.subtaskNames.length; i++)
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Подцель',
                                      hintText: 'Например, Билеты',
                                      border: OutlineInputBorder(),
                                    ),
                                    controller: subtaskNameControllers[i],
                                    onChanged: (value) {
                                      store.setSubtaskName(i, value);
                                      subtaskNameControllers[i].value =
                                          TextEditingValue(
                                        text: value,
                                        selection: TextSelection.collapsed(
                                            offset: value.length),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Сумма',
                                      hintText: '40000',
                                      border: OutlineInputBorder(),
                                    ),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    controller: subtaskAmountControllers[i],
                                    onChanged: (value) {
                                      store.setSubtaskAmount(i, value);
                                      subtaskAmountControllers[i].value =
                                          TextEditingValue(
                                        text: value,
                                        selection: TextSelection.collapsed(
                                            offset: value.length),
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    store.removeSubtask(i);
                                    _updateControllers();
                                  },
                                ),
                              ],
                            ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                store.addSubtask();
                                _updateControllers();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Добавить подцель'),
                            ),
                          ),
                        ],
                      );
                    },
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
                          : Text(isEditMode ? 'Сохранить' : 'Создать цель'),
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

