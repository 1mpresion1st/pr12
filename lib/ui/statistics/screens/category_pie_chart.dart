import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../domain/entities/statistics.dart';

class CategoryPieChart extends StatelessWidget {
  const CategoryPieChart({
    super.key,
    required this.categoryStats,
  });

  final List<CategoryStats> categoryStats;

  @override
  Widget build(BuildContext context) {
    if (categoryStats.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Нет данных за выбранный период'),
        ),
      );
    }

    final totalAmount = categoryStats.fold<double>(
      0.0,
      (sum, stat) => sum + stat.totalAmount,
    );

    final sections = categoryStats.asMap().entries.map((entry) {
      final index = entry.key;
      final stat = entry.value;
      final percent = (stat.totalAmount / totalAmount * 100).toStringAsFixed(1);

      return PieChartSectionData(
        color: Colors.primaries[index % Colors.primaries.length],
        value: stat.totalAmount,
        title: '${stat.category}\n$percent%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return SizedBox(
      height: 250,
      child: PieChart(
        PieChartData(
          sections: sections,
          centerSpaceRadius: 40,
          sectionsSpace: 2,
        ),
      ),
    );
  }
}


