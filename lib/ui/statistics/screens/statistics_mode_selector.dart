import 'package:flutter/material.dart';
import '../../../../domain/entities/statistics.dart';

class StatisticsModeSelector extends StatelessWidget {
  const StatisticsModeSelector({
    super.key,
    required this.currentMode,
    required this.onChanged,
  });

  final StatisticsMode currentMode;
  final ValueChanged<StatisticsMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<StatisticsMode>(
      segments: const [
        ButtonSegment(
          value: StatisticsMode.expensesByCategory,
          label: Text('Расходы'),
        ),
        ButtonSegment(
          value: StatisticsMode.incomeByCategory,
          label: Text('Доходы'),
        ),
        ButtonSegment(
          value: StatisticsMode.balanceDynamics,
          label: Text('Баланс'),
        ),
      ],
      selected: {currentMode},
      onSelectionChanged: (Set<StatisticsMode> newSelection) {
        onChanged(newSelection.first);
      },
    );
  }
}


