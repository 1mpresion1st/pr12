import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/entities/goal.dart';
import '../../../../domain/entities/attachment.dart';
import '../../../../domain/usecases/goals/get_all_goals.dart';
import '../../../../domain/usecases/transactions/get_transaction_by_id.dart';
import '../../../../domain/usecases/transactions/update_transaction.dart';
import '../../../../domain/usecases/transactions/delete_transaction.dart';
import '../../../../domain/usecases/attachments/get_all_attachments.dart';
import '../../../../domain/usecases/attachments/add_attachment.dart';
import '../../../../domain/usecases/attachments/delete_attachment.dart';
import '../stores/transaction_details_store.dart';
import '../../goals/stores/goals_list_store.dart';
import '../routes.dart' as transactions_routes;

class _TransactionDetailsScreenState extends StatefulWidget {
  final TransactionDetailsStore store;

  const _TransactionDetailsScreenState({required this.store});

  @override
  State<_TransactionDetailsScreenState> createState() =>
      _TransactionDetailsScreenStateState();
}

class _TransactionDetailsScreenStateState
    extends State<_TransactionDetailsScreenState> {
  List<Goal>? _goals;
  bool _goalsLoading = false;

  @override
  void initState() {
    super.initState();
    widget.store.load();
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
        await widget.store.addAttachmentFromFile(picked.path);
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
        title: const Text('Детали операции'),
      ),
      body: Observer(
        builder: (_) {
          if (widget.store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.store.transaction == null) {
            return const Center(child: Text('Операция не найдена'));
          }

          final transaction = widget.store.transaction!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
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
                  selected: {transaction.type},
                  onSelectionChanged: (Set<TransactionType> newSelection) {
                    widget.store.updateType(newSelection.first);
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: 'Сумма',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: transaction.amount.toStringAsFixed(2),
                  ),
                  onChanged: (value) {
                    final amount = double.tryParse(value);
                    if (amount != null) {
                      widget.store.updateAmount(amount);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Категория',
                    border: OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: transaction.category),
                  onChanged: (value) => widget.store.updateCategory(value),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: transaction.date,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now(),
                    );
                    if (picked != null) {
                      widget.store.updateDate(picked);
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Дата',
                      border: OutlineInputBorder(),
                    ),
                    child: Observer(
                      builder: (_) => Text(
                        '${widget.store.transaction!.date.day.toString().padLeft(2, '0')}.${widget.store.transaction!.date.month.toString().padLeft(2, '0')}.${widget.store.transaction!.date.year}',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (!_goalsLoading && _goals != null)
                  Observer(
                    builder: (_) {
                      final currentGoalId = widget.store.transaction?.goalId;
                      return DropdownButtonFormField<String>(
                        value: currentGoalId,
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
                        onChanged: (value) => widget.store.updateGoalId(value),
                      );
                    },
                  ),
                const SizedBox(height: 12),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Комментарий',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  controller: TextEditingController(text: transaction.note ?? ''),
                  onChanged: (value) => widget.store.updateNote(value.isEmpty ? null : value),
                ),
                const SizedBox(height: 20),
                Observer(
                  builder: (_) {
                    if (transaction.type != TransactionType.expense) {
                      return const SizedBox.shrink();
                    }
                    final attachments = widget.store.attachments;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Вложения',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
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
                                final a = attachments[index];
                                return GestureDetector(
                                  onTap: () {
                                    context.push(
                                      transactions_routes.AppRoutes.attachmentFull,
                                      extra: a.id,
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          File(a.path),
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
                                          onTap: () async {
                                            await widget.store.deleteAttachment(a.id);
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
                                  ),
                                );
                              },
                            ),
                          ),
                        const SizedBox(height: 20),
                      ],
                    );
                  },
                ),
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
                            } else if (widget.store.errorMessage != null && context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(widget.store.errorMessage!)),
                              );
                            }
                          },
                    child: widget.store.isSaving
                        ? const CircularProgressIndicator()
                        : const Text('Сохранить'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: widget.store.isSaving
                        ? null
                        : () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Удалить операцию?'),
                                content: const Text('Вы уверены, что хотите удалить эту операцию?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Отмена'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              ),
                            );

                            if (confirmed == true) {
                              final success = await widget.store.delete();
                              if (success) {
                                if (context.mounted) {
                                  context.pop(true);
                                }
                              } else if (widget.store.errorMessage != null && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(widget.store.errorMessage!)),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: widget.store.isSaving
                        ? const CircularProgressIndicator()
                        : const Text('Удалить'),
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

class TransactionDetailsScreen extends StatelessWidget {
  TransactionDetailsScreen({
    required this.transactionId,
    super.key,
  }) : store = TransactionDetailsStore(
          GetIt.I<GetTransactionById>(),
          GetIt.I<UpdateTransaction>(),
          GetIt.I<DeleteTransaction>(),
          GetIt.I<GetAllAttachments>(),
          GetIt.I<AddAttachment>(),
          GetIt.I<DeleteAttachment>(),
          transactionId,
        );

  final String transactionId;
  final TransactionDetailsStore store;

  @override
  Widget build(BuildContext context) {
    return _TransactionDetailsScreenState(store: store);
  }
}

