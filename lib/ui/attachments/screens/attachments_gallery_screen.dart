import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../data/legacy/attachments_service.dart';
import '../../../../data/legacy/transactions_service.dart';
import '../stores/attachments_gallery_store.dart';
import '../../transactions/routes.dart' as transactions_routes;

class _AttachmentsGalleryScreenContent extends StatefulWidget {
  const _AttachmentsGalleryScreenContent({required this.store, super.key});

  final AttachmentsGalleryStore store;

  @override
  State<_AttachmentsGalleryScreenContent> createState() =>
      _AttachmentsGalleryScreenContentState();
}

class _AttachmentsGalleryScreenContentState
    extends State<_AttachmentsGalleryScreenContent> {
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _isInitialized = true;
      widget.store.load();
    }
  }

  Future<void> _showFiltersBottomSheet(
    BuildContext context,
    AttachmentsGalleryStore store,
  ) async {
    String? selectedCategory = store.categoryFilter;
    AttachmentType? selectedType = store.typeFilter;
    DateTime? from = store.fromDate;
    DateTime? to = store.toDate;

    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Фильтры',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      decoration: const InputDecoration(
                        labelText: 'Категория',
                        hintText: 'Например, Еда',
                        border: OutlineInputBorder(),
                      ),
                      controller:
                          TextEditingController(text: selectedCategory ?? '')
                        ..selection = TextSelection.fromPosition(
                          TextPosition(
                            offset: (selectedCategory ?? '').length,
                          ),
                        ),
                      onChanged: (value) {
                        setModalState(() {
                          selectedCategory =
                              value.isEmpty ? null : value.trim();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<AttachmentType?>(
                      value: selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Тип вложения',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        const DropdownMenuItem<AttachmentType?>(
                          value: null,
                          child: Text('Все'),
                        ),
                        ...AttachmentType.values.map(
                          (t) => DropdownMenuItem<AttachmentType?>(
                            value: t,
                            child: Text(
                              t == AttachmentType.receipt
                                  ? 'Чек'
                                  : t == AttachmentType.productPhoto
                                      ? 'Фото товара'
                                      : 'Другое',
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setModalState(() {
                          selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            from == null
                                ? 'С: не выбрано'
                                : 'С: ${from!.day.toString().padLeft(2, '0')}.${from!.month.toString().padLeft(2, '0')}.${from!.year}',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final initial = from ?? now;
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: initial,
                              firstDate: DateTime(now.year - 5),
                              lastDate: DateTime(now.year + 5),
                            );
                            if (picked != null) {
                              setModalState(() {
                                from = picked;
                              });
                            }
                          },
                          child: const Text('Выбрать'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            to == null
                                ? 'По: не выбрано'
                                : 'По: ${to!.day.toString().padLeft(2, '0')}.${to!.month.toString().padLeft(2, '0')}.${to!.year}',
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            final now = DateTime.now();
                            final initial = to ?? now;
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: initial,
                              firstDate: DateTime(now.year - 5),
                              lastDate: DateTime(now.year + 5),
                            );
                            if (picked != null) {
                              setModalState(() {
                                to = picked;
                              });
                            }
                          },
                          child: const Text('Выбрать'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setModalState(() {
                                selectedCategory = null;
                                selectedType = null;
                                from = null;
                                to = null;
                              });
                            },
                            child: const Text('Сбросить'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              store.setCategoryFilter(selectedCategory);
                              store.setTypeFilter(selectedType);
                              store.setDateRange(from, to);
                              Navigator.of(context).pop();
                            },
                            child: const Text('Применить'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Галерея чеков и вложений'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () async {
              await _showFiltersBottomSheet(context, store);
            },
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          if (store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (store.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(store.errorMessage!),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: store.load,
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          final items = store.filteredAttachments;
          if (items.isEmpty) {
            return const Center(
              child: Text('Пока нет вложений. Добавьте чек к операции.'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return GestureDetector(
                onTap: () async {
                  await context.push(
                    transactions_routes.AppRoutes.attachmentFull,
                    extra: item.attachment.id,
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.file(
                          File(item.attachment.path),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${item.amount.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Text(
                              item.category,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${item.date.day.toString().padLeft(2, '0')}.${item.date.month.toString().padLeft(2, '0')}.${item.date.year}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class AttachmentsGalleryScreen extends StatelessWidget {
  AttachmentsGalleryScreen({super.key})
      : store = AttachmentsGalleryStore(
          GetIt.I<AttachmentsService>(),
          GetIt.I<TransactionsService>(),
        );

  final AttachmentsGalleryStore store;

  @override
  Widget build(BuildContext context) {
    return _AttachmentsGalleryScreenContent(store: store);
  }
}

