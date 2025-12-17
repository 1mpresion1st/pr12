import '../../entities/attachment_gallery_filters.dart';
import '../../repositories/attachment_gallery_filters_repository.dart';

class SaveAttachmentGalleryFilters {
  final AttachmentGalleryFiltersRepository repository;

  SaveAttachmentGalleryFilters(this.repository);

  Future<void> call(AttachmentGalleryFilters filters) {
    return repository.saveFilters(filters);
  }
}




