import '../../domain/entities/category_budget.dart';

class CategoryBudgetDto {
  final String id;
  final String category;
  final double limitAmount;
  final BudgetPeriod period;

  CategoryBudgetDto({
    required this.id,
    required this.category,
    required this.limitAmount,
    required this.period,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'limitAmount': limitAmount,
      'period': period.name,
    };
  }

  factory CategoryBudgetDto.fromJson(Map<String, dynamic> json) {
    return CategoryBudgetDto(
      id: json['id'] as String,
      category: json['category'] as String,
      limitAmount: (json['limitAmount'] as num).toDouble(),
      period: BudgetPeriod.values.firstWhere(
        (e) => e.name == json['period'],
        orElse: () => BudgetPeriod.monthly,
      ),
    );
  }

  CategoryBudget toEntity() {
    return CategoryBudget(
      id: id,
      category: category,
      limitAmount: limitAmount,
      period: period,
    );
  }

  factory CategoryBudgetDto.fromEntity(CategoryBudget entity) {
    return CategoryBudgetDto(
      id: entity.id,
      category: entity.category,
      limitAmount: entity.limitAmount,
      period: entity.period,
    );
  }
}

