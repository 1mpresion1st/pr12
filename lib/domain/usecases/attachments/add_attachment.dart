import '../../entities/attachment.dart';
import '../../repositories/attachments_repository.dart';

class AddAttachment {
  final AttachmentsRepository repository;

  AddAttachment(this.repository);

  Future<void> call(Attachment attachment) {
    return repository.addAttachment(attachment);
  }
}

