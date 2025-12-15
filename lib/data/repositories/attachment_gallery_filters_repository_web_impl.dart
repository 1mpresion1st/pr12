import '../../domain/entities/attachment_gallery_filters.dart';
import '../../domain/repositories/attachment_gallery_filters_repository.dart';

/// Web fallback implementation using in-memory storage
class AttachmentGalleryFiltersRepositoryWebImpl
    implements AttachmentGalleryFiltersRepository {
  AttachmentGalleryFilters? _cachedFilters;

  @override
  Future<AttachmentGalleryFilters?> getFilters() async {
    return _cachedFilters;
  }

  @override
  Future<void> saveFilters(AttachmentGalleryFilters filters) async {
    _cachedFilters = filters;
  }

  @override
  Future<void> clearFilters() async {
    _cachedFilters = null;
  }
}

