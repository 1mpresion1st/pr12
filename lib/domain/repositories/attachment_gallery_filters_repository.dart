import '../entities/attachment_gallery_filters.dart';

abstract class AttachmentGalleryFiltersRepository {
  Future<AttachmentGalleryFilters?> getFilters();
  Future<void> saveFilters(AttachmentGalleryFilters filters);
  Future<void> clearFilters();
}

