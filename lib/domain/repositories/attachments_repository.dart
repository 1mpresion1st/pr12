import '../entities/attachment.dart';

abstract class AttachmentsRepository {
  Future<List<Attachment>> getAll({
    String? category,
    DateTime? from,
    DateTime? to,
  });
  Future<List<Attachment>> getByTransactionId(String transactionId);
  Future<Attachment?> getById(String id);
  Future<void> addAttachment(Attachment attachment);
  Future<void> deleteAttachment(String id);
}

