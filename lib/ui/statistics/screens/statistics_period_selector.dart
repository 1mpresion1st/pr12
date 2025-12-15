import 'package:flutter/material.dart';
import '../../../../domain/entities/statistics.dart';

class StatisticsPeriodSelector extends StatelessWidget {
  const StatisticsPeriodSelector({
    super.key,
    required this.currentPeriod,
    required this.onChanged,
  });

  final StatisticsPeriod currentPeriod;
  final ValueChanged<StatisticsPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<StatisticsPeriod>(
      segments: const [
        ButtonSegment(
          value: StatisticsPeriod.week,
          label: Text('Неделя'),
        ),
        ButtonSegment(
          value: StatisticsPeriod.month,
          label: Text('Месяц'),
        ),
        ButtonSegment(
          value: StatisticsPeriod.year,
          label: Text('Год'),
        ),
        ButtonSegment(
          value: StatisticsPeriod.all,
          label: Text('Все'),
        ),
      ],
      selected: {currentPeriod},
      onSelectionChanged: (Set<StatisticsPeriod> newSelection) {
        onChanged(newSelection.first);
      },
    );
  }
}


