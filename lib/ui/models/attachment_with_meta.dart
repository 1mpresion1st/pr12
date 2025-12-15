import '../../data/legacy/attachments_service.dart';
import '../../data/legacy/transactions_service.dart';

class AttachmentWithMeta {
  final Attachment attachment;
  final Transaction transaction;

  AttachmentWithMeta({
    required this.attachment,
    required this.transaction,
  });

  String get category => transaction.category;
  double get amount => transaction.amount;
  DateTime get date => transaction.date;
  AttachmentType get type => attachment.type;
}

