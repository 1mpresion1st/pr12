import '../../entities/attachment.dart';
import '../../repositories/attachments_repository.dart';

class GetAllAttachments {
  final AttachmentsRepository repository;

  GetAllAttachments(this.repository);

  Future<List<Attachment>> call({
    String? category,
    DateTime? from,
    DateTime? to,
  }) {
    return repository.getAll(
      category: category,
      from: from,
      to: to,
    );
  }
}

