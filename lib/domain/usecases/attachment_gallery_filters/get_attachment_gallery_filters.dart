import '../../entities/attachment_gallery_filters.dart';
import '../../repositories/attachment_gallery_filters_repository.dart';

class GetAttachmentGalleryFilters {
  final AttachmentGalleryFiltersRepository repository;

  GetAttachmentGalleryFilters(this.repository);

  Future<AttachmentGalleryFilters?> call() {
    return repository.getFilters();
  }
}

