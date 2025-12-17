import '../../data/legacy/attachments_service.dart';

class AttachmentGalleryFilters {
  final String? categoryFilter;
  final AttachmentType? typeFilter;
  final DateTime? fromDate;
  final DateTime? toDate;
  final DateTime updatedAt;

  AttachmentGalleryFilters({
    this.categoryFilter,
    this.typeFilter,
    this.fromDate,
    this.toDate,
    required this.updatedAt,
  });

  AttachmentGalleryFilters copyWith({
    String? categoryFilter,
    AttachmentType? typeFilter,
    DateTime? fromDate,
    DateTime? toDate,
    DateTime? updatedAt,
  }) {
    return AttachmentGalleryFilters(
      categoryFilter: categoryFilter ?? this.categoryFilter,
      typeFilter: typeFilter ?? this.typeFilter,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}




