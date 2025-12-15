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
}

