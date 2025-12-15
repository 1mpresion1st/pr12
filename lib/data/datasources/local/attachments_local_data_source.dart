import '../../../domain/entities/attachment.dart';
import '../../models/attachment_dto.dart';

abstract class AttachmentsLocalDataSource {
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

class AttachmentsLocalDataSourceImpl implements AttachmentsLocalDataSource {
  final List<AttachmentDto> _items = [];

  @override
  Future<List<Attachment>> getAll({
    String? category,
    DateTime? from,
    DateTime? to,
  }) async {
    return _items.map((dto) => dto.toEntity()).toList();
  }

  @override
  Future<List<Attachment>> getByTransactionId(String transactionId) async {
    return _items
        .where((a) => a.transactionId == transactionId)
        .map((dto) => dto.toEntity())
        .toList();
  }

  @override
  Future<Attachment?> getById(String id) async {
    try {
      final dto = _items.firstWhere((a) => a.id == id);
      return dto.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> addAttachment(Attachment attachment) async {
    _items.add(AttachmentDto.fromEntity(attachment));
  }

  @override
  Future<void> deleteAttachment(String id) async {
    _items.removeWhere((a) => a.id == id);
  }
}

