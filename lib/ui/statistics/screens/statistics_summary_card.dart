import 'package:flutter/material.dart';

class StatisticsSummaryCard extends StatelessWidget {
  const StatisticsSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.color,
  });

  final String title;
  final double value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${value.toStringAsFixed(2)} ₽',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


