import 'package:flutter/material.dart';

class BudgetProgressBar extends StatelessWidget {
  const BudgetProgressBar({
    super.key,
    required this.progress,
    this.isExceeded = false,
  });

  final double progress;
  final bool isExceeded;

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    final exceededProgress = isExceeded ? (progress - 1.0).clamp(0.0, 1.0) : 0.0;

    return SizedBox(
      height: 8,
      child: Stack(
        children: [
          LinearProgressIndicator(
            value: clampedProgress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              isExceeded ? Colors.orange : Colors.blue,
            ),
          ),
          if (isExceeded && exceededProgress > 0)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FractionallySizedBox(
                  widthFactor: exceededProgress,
                  alignment: Alignment.centerRight,
                  child: Container(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}


