import '../../domain/entities/attachment.dart';
import '../../domain/repositories/attachments_repository.dart';
import '../datasources/local/attachments_local_data_source.dart';

class AttachmentsRepositoryImpl implements AttachmentsRepository {
  final AttachmentsLocalDataSource localDataSource;

  AttachmentsRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Attachment>> getAll({
    String? category,
    DateTime? from,
    DateTime? to,
  }) {
    return localDataSource.getAll(
      category: category,
      from: from,
      to: to,
    );
  }

  @override
  Future<List<Attachment>> getByTransactionId(String transactionId) {
    return localDataSource.getByTransactionId(transactionId);
  }

  @override
  Future<Attachment?> getById(String id) {
    return localDataSource.getById(id);
  }

  @override
  Future<void> addAttachment(Attachment attachment) {
    return localDataSource.addAttachment(attachment);
  }

  @override
  Future<void> deleteAttachment(String id) {
    return localDataSource.deleteAttachment(id);
  }
}

