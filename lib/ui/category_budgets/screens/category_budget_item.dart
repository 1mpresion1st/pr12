import 'package:flutter/material.dart';
import '../../models/category_budget_with_progress.dart';
import 'budget_progress_bar.dart';

class CategoryBudgetItem extends StatelessWidget {
  const CategoryBudgetItem({
    super.key,
    required this.item,
    this.onTap,
  });

  final CategoryBudgetWithProgress item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isExceeded = item.isExceeded;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.budget.category,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isExceeded ? Colors.red : null,
                    ),
                  ),
                  if (isExceeded)
                    Icon(
                      Icons.warning,
                      color: Colors.red,
                      size: 20,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Потрачено: ${item.spentAmount.toStringAsFixed(2)} ₽ из ${item.budget.limitAmount.toStringAsFixed(2)} ₽',
                style: TextStyle(
                  fontSize: 14,
                  color: isExceeded ? Colors.red : Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              BudgetProgressBar(
                progress: item.progress,
                isExceeded: isExceeded,
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(item.progress * 100).toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: isExceeded ? Colors.red : Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

