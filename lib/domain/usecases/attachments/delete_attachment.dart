import '../../repositories/attachments_repository.dart';

class DeleteAttachment {
  final AttachmentsRepository repository;

  DeleteAttachment(this.repository);

  Future<void> call(String id) {
    return repository.deleteAttachment(id);
  }
}

