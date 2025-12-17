import '../../repositories/attachment_gallery_filters_repository.dart';

class ClearAttachmentGalleryFilters {
  final AttachmentGalleryFiltersRepository repository;

  ClearAttachmentGalleryFilters(this.repository);

  Future<void> call() {
    return repository.clearFilters();
  }
}




