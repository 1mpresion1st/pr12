import '../../domain/entities/attachment_gallery_filters.dart';
import '../../data/legacy/attachments_service.dart';

class AttachmentGalleryFiltersDto {
  final String? categoryFilter;
  final String? typeFilter;
  final int? fromDate;
  final int? toDate;
  final int updatedAt;

  AttachmentGalleryFiltersDto({
    this.categoryFilter,
    this.typeFilter,
    this.fromDate,
    this.toDate,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_filter': categoryFilter,
      'type_filter': typeFilter,
      'from_date': fromDate,
      'to_date': toDate,
      'updated_at': updatedAt,
    };
  }

  factory AttachmentGalleryFiltersDto.fromMap(Map<String, dynamic> map) {
    return AttachmentGalleryFiltersDto(
      categoryFilter: map['category_filter'] as String?,
      typeFilter: map['type_filter'] as String?,
      fromDate: map['from_date'] as int?,
      toDate: map['to_date'] as int?,
      updatedAt: map['updated_at'] as int,
    );
  }

  AttachmentGalleryFilters toEntity() {
    return AttachmentGalleryFilters(
      categoryFilter: categoryFilter,
      typeFilter: typeFilter != null
          ? AttachmentType.values.firstWhere(
              (e) => e.name == typeFilter,
              orElse: () => AttachmentType.receipt,
            )
          : null,
      fromDate: fromDate != null ? DateTime.fromMillisecondsSinceEpoch(fromDate!) : null,
      toDate: toDate != null ? DateTime.fromMillisecondsSinceEpoch(toDate!) : null,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
    );
  }

  factory AttachmentGalleryFiltersDto.fromEntity(AttachmentGalleryFilters entity) {
    return AttachmentGalleryFiltersDto(
      categoryFilter: entity.categoryFilter,
      typeFilter: entity.typeFilter?.name,
      fromDate: entity.fromDate?.millisecondsSinceEpoch,
      toDate: entity.toDate?.millisecondsSinceEpoch,
      updatedAt: entity.updatedAt.millisecondsSinceEpoch,
    );
  }
}

