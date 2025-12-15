import '../../domain/entities/attachment.dart';

class AttachmentDto {
  final String id;
  final String transactionId;
  final String path;
  final AttachmentType type;
  final DateTime createdAt;

  AttachmentDto({
    required this.id,
    required this.transactionId,
    required this.path,
    required this.type,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'path': path,
      'type': type.name,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AttachmentDto.fromJson(Map<String, dynamic> json) {
    return AttachmentDto(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      path: json['path'] as String,
      type: AttachmentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AttachmentType.other,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Attachment toEntity() {
    return Attachment(
      id: id,
      transactionId: transactionId,
      path: path,
      type: type,
      createdAt: createdAt,
    );
  }

  factory AttachmentDto.fromEntity(Attachment entity) {
    return AttachmentDto(
      id: entity.id,
      transactionId: entity.transactionId,
      path: entity.path,
      type: entity.type,
      createdAt: entity.createdAt,
    );
  }
}

