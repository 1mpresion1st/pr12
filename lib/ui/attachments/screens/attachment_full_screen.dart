import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../data/legacy/attachments_service.dart';
import '../../../../data/legacy/transactions_service.dart';
import '../stores/attachment_full_store.dart';
import '../../transactions/routes.dart' as transactions_routes;

class _AttachmentFullScreenContent extends StatefulWidget {
  const _AttachmentFullScreenContent({required this.store, super.key});

  final AttachmentFullStore store;

  @override
  State<_AttachmentFullScreenContent> createState() =>
      _AttachmentFullScreenContentState();
}

class _AttachmentFullScreenContentState
    extends State<_AttachmentFullScreenContent> {
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
    final store = widget.store;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Вложение'),
      ),
      body: Observer(
        builder: (_) {
          if (store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (store.errorMessage != null) {
            return Center(child: Text(store.errorMessage!));
          }

          final item = store.item;
          if (item == null) {
            return const Center(child: Text('Вложение не найдено'));
          }

          return Column(
            children: [
              Expanded(
                child: InteractiveViewer(
                  child: Image.file(
                    File(item.attachment.path),
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      item.transaction.category,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      'Сумма: ${item.transaction.amount.toStringAsFixed(2)}',
                    ),
                    Text(
                      'Дата: ${item.transaction.date.day.toString().padLeft(2, '0')}.${item.transaction.date.month.toString().padLeft(2, '0')}.${item.transaction.date.year}',
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.push(
                          transactions_routes.AppRoutes.transactionDetails,
                          extra: item.transaction.id,
                        );
                      },
                      icon: const Icon(Icons.receipt_long),
                      label: const Text('Открыть операцию'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class AttachmentFullScreen extends StatelessWidget {
  AttachmentFullScreen({
    super.key,
    required this.attachmentId,
  }) : store = AttachmentFullStore(
          GetIt.I<AttachmentsService>(),
          GetIt.I<TransactionsService>(),
          attachmentId,
        );

  final String attachmentId;
  final AttachmentFullStore store;

  @override
  Widget build(BuildContext context) {
    return _AttachmentFullScreenContent(store: store);
  }
}


