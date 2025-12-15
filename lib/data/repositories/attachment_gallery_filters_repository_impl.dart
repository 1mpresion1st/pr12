import '../../domain/entities/attachment_gallery_filters.dart';
import '../../domain/repositories/attachment_gallery_filters_repository.dart';
import '../datasources/local/sqlite/app_database.dart';
import '../models/attachment_gallery_filters_dto.dart';

class AttachmentGalleryFiltersRepositoryImpl
    implements AttachmentGalleryFiltersRepository {
  @override
  Future<AttachmentGalleryFilters?> getFilters() async {
    try {
      final data = await AppDatabase.getFilters();
      if (data == null) return null;
      final dto = AttachmentGalleryFiltersDto.fromMap(data);
      return dto.toEntity();
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveFilters(AttachmentGalleryFilters filters) async {
    final dto = AttachmentGalleryFiltersDto.fromEntity(filters);
    await AppDatabase.saveFilters(dto.toMap());
  }

  @override
  Future<void> clearFilters() async {
    await AppDatabase.clearFilters();
  }
}

