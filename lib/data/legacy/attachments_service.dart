import '../../domain/entities/attachment.dart' as domain_entities;
import '../../domain/repositories/attachments_repository.dart';
import 'package:get_it/get_it.dart';

// Legacy model for backward compatibility
enum AttachmentType {
  receipt,
  productPhoto,
  other,
}

class Attachment {
  final String id;
  final String transactionId;
  final String path;
  final AttachmentType type;
  final DateTime createdAt;

  Attachment({
    required this.id,
    required this.transactionId,
    required this.path,
    required this.type,
    required this.createdAt,
  });

  Attachment copyWith({
    String? id,
    String? transactionId,
    String? path,
    AttachmentType? type,
    DateTime? createdAt,
  }) {
    return Attachment(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      path: path ?? this.path,
      type: type ?? this.type,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AttachmentsService {
  AttachmentsService();

  AttachmentsRepository get _repository => GetIt.I<AttachmentsRepository>();

  Future<List<Attachment>> getAll({
    String? category,
    DateTime? from,
    DateTime? to,
  }) async {
    final domainAttachments = await _repository.getAll(
      category: category,
      from: from,
      to: to,
    );
    return domainAttachments.map(_toLegacyModel).toList();
  }

  Future<List<Attachment>> getByTransactionId(String transactionId) async {
    final domainAttachments = await _repository.getByTransactionId(transactionId);
    return domainAttachments.map(_toLegacyModel).toList();
  }

  Future<Attachment?> getById(String id) async {
    final domainAttachment = await _repository.getById(id);
    return domainAttachment != null ? _toLegacyModel(domainAttachment) : null;
  }

  Future<void> addAttachment(Attachment attachment) async {
    final domainAttachment = _toDomainEntity(attachment);
    await _repository.addAttachment(domainAttachment);
  }

  Future<void> deleteAttachment(String id) async {
    await _repository.deleteAttachment(id);
  }

  Attachment _toLegacyModel(domain_entities.Attachment domain) {
    return Attachment(
      id: domain.id,
      transactionId: domain.transactionId,
      path: domain.path,
      type: _toLegacyType(domain.type),
      createdAt: domain.createdAt,
    );
  }

  domain_entities.Attachment _toDomainEntity(Attachment legacy) {
    return domain_entities.Attachment(
      id: legacy.id,
      transactionId: legacy.transactionId,
      path: legacy.path,
      type: _toDomainType(legacy.type),
      createdAt: legacy.createdAt,
    );
  }

  AttachmentType _toLegacyType(domain_entities.AttachmentType domain) {
    switch (domain) {
      case domain_entities.AttachmentType.receipt:
        return AttachmentType.receipt;
      case domain_entities.AttachmentType.productPhoto:
        return AttachmentType.productPhoto;
      case domain_entities.AttachmentType.other:
        return AttachmentType.other;
    }
  }

  domain_entities.AttachmentType _toDomainType(AttachmentType legacy) {
    switch (legacy) {
      case AttachmentType.receipt:
        return domain_entities.AttachmentType.receipt;
      case AttachmentType.productPhoto:
        return domain_entities.AttachmentType.productPhoto;
      case AttachmentType.other:
        return domain_entities.AttachmentType.other;
    }
  }
}

