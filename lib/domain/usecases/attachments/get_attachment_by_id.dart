import '../../entities/attachment.dart';
import '../../repositories/attachments_repository.dart';

class GetAttachmentById {
  final AttachmentsRepository repository;

  GetAttachmentById(this.repository);

  Future<Attachment?> call(String id) {
    return repository.getById(id);
  }
}

