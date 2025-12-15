import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../domain/entities/statistics.dart';

class BalanceLineChart extends StatelessWidget {
  const BalanceLineChart({
    super.key,
    required this.balancePoints,
  });

  final List<DailyBalancePoint> balancePoints;

  @override
  Widget build(BuildContext context) {
    if (balancePoints.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Нет данных для отображения динамики'),
        ),
      );
    }

    final minBalance = balancePoints.map((p) => p.balance).reduce((a, b) => a < b ? a : b);
    final maxBalance = balancePoints.map((p) => p.balance).reduce((a, b) => a > b ? a : b);
    final range = maxBalance - minBalance;
    final padding = range * 0.1;

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 50,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(0),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < balancePoints.length) {
                    final date = balancePoints[value.toInt()].date;
                    if (value.toInt() % (balancePoints.length ~/ 5 + 1) == 0 ||
                        value.toInt() == balancePoints.length - 1) {
                      return Text(
                        '${date.day}.${date.month}',
                        style: const TextStyle(fontSize: 10),
                      );
                    }
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
          minY: minBalance - padding,
          maxY: maxBalance + padding,
          lineBarsData: [
            LineChartBarData(
              spots: balancePoints.asMap().entries.map((entry) {
                return FlSpot(entry.key.toDouble(), entry.value.balance);
              }).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}


