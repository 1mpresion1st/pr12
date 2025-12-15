import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/entities/goal.dart';
import '../../../../domain/usecases/goals/get_all_goals.dart';
import '../../../../domain/usecases/transactions/add_transaction.dart';
import '../../../../domain/usecases/attachments/add_attachment.dart';
import '../stores/add_transaction_store.dart';
import '../../goals/stores/goals_list_store.dart';

class _AddTransactionScreenState extends StatefulWidget {
  final AddTransactionStore store;

  const _AddTransactionScreenState({required this.store});

  @override
  State<_AddTransactionScreenState> createState() =>
      _AddTransactionScreenStateState();
}

class _AddTransactionScreenStateState
    extends State<_AddTransactionScreenState> {
  List<Goal>? _goals;
  bool _goalsLoading = false;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    setState(() => _goalsLoading = true);
    try {
      final getAllGoals = GetIt.I<GetAllGoals>();
      final goals = await getAllGoals();
      setState(() {
        _goals = goals;
        _goalsLoading = false;
      });
    } catch (e) {
      setState(() => _goalsLoading = false);
    }
  }

  Future<void> _pickAttachment(BuildContext context) async {
    final picker = ImagePicker();
    final isWindows = !kIsWeb && Platform.isWindows;

    ImageSource? source;
    if (isWindows) {
      source = ImageSource.gallery;
    } else {
      source = await showModalBottomSheet<ImageSource>(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Сделать фото'),
                  onTap: () => Navigator.of(context).pop(ImageSource.camera),
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: const Text('Выбрать из галереи'),
                  onTap: () => Navigator.of(context).pop(ImageSource.gallery),
                ),
              ],
            ),
          );
        },
      );
    }

    if (source == null) return;

    try {
      final picked = await picker.pickImage(source: source);
      if (picked != null) {
        widget.store.addPendingAttachmentPath(picked.path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка при выборе изображения: ${e.toString()}'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая операция'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Observer(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Тип операции:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                SegmentedButton<TransactionType>(
                  segments: const [
                    ButtonSegment(
                      value: TransactionType.income,
                      label: Text('Доход'),
                      icon: Icon(Icons.arrow_downward),
                    ),
                    ButtonSegment(
                      value: TransactionType.expense,
                      label: Text('Расход'),
                      icon: Icon(Icons.arrow_upward),
                    ),
                  ],
                  selected: {widget.store.type},
                  onSelectionChanged: (Set<TransactionType> newSelection) {
                    widget.store.setType(newSelection.first);
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Сумма',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    final amount = double.tryParse(value);
                    widget.store.setAmount(amount);
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Категория',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => widget.store.setCategory(value),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: widget.store.date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      widget.store.setDate(picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Дата',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(
                      '${widget.store.date.day.toString().padLeft(2, '0')}.${widget.store.date.month.toString().padLeft(2, '0')}.${widget.store.date.year}',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (!_goalsLoading && _goals != null)
                  Observer(
                    builder: (_) => DropdownButtonFormField<String>(
                      value: widget.store.goalId,
                      decoration: const InputDecoration(
                        labelText: 'Цель (опционально)',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('Не выбрано'),
                        ),
                        ..._goals!.map(
                          (g) => DropdownMenuItem<String>(
                            value: g.id,
                            child: Text(g.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => widget.store.setGoalId(value),
                    ),
                  ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Комментарий',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) =>
                      widget.store.setNote(value.isEmpty ? null : value),
                ),
                const SizedBox(height: 20),
                Text(
                  'Вложения',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Observer(
                  builder: (_) {
                    final attachments = widget.store.pendingAttachmentPaths;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => _pickAttachment(context),
                          icon: const Icon(Icons.add_a_photo),
                          label: const Text('Добавить чек'),
                        ),
                        const SizedBox(height: 8),
                        if (attachments.isEmpty)
                          Text(
                            'Нет вложений',
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        else
                          SizedBox(
                            height: 100,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: attachments.length,
                              separatorBuilder: (_, __) => const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final path = attachments[index];
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        File(path),
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Center(child: Icon(Icons.broken_image)),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 4,
                                      right: 4,
                                      child: GestureDetector(
                                        onTap: () {
                                          widget.store.removePendingAttachmentPath(path);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black54,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          padding: const EdgeInsets.all(2),
                                          child: const Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),
                if (widget.store.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      widget.store.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: widget.store.isSaving
                        ? null
                        : () async {
                            final success = await widget.store.save();
                            if (success) {
                              if (context.mounted) {
                                context.pop(true);
                              }
                            } else if (widget.store.errorMessage != null &&
                                context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(widget.store.errorMessage!)),
                              );
                            }
                          },
                    child: widget.store.isSaving
                        ? const CircularProgressIndicator()
                        : const Text('Сохранить'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class AddTransactionScreen extends StatelessWidget {
  AddTransactionScreen({super.key})
      : store = AddTransactionStore(
          GetIt.I<AddTransaction>(),
          GetIt.I<AddAttachment>(),
        );

  final AddTransactionStore store;

  @override
  Widget build(BuildContext context) {
    return _AddTransactionScreenState(store: store);
  }
}

