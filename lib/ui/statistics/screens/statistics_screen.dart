import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../../domain/entities/statistics.dart';
import '../../../../domain/usecases/statistics/get_category_stats.dart';
import '../../../../domain/usecases/statistics/get_balance_dynamics.dart';
import '../../../../domain/usecases/statistics/get_total_amount.dart';
import '../stores/statistics_store.dart';
import 'statistics_period_selector.dart';
import 'statistics_mode_selector.dart';
import 'statistics_summary_card.dart';
import 'category_pie_chart.dart';
import 'balance_line_chart.dart';

class _StatisticsScreenState extends StatefulWidget {
  final StatisticsStore store;

  const _StatisticsScreenState({required this.store});

  @override
  State<_StatisticsScreenState> createState() => _StatisticsScreenStateState();
}

class _StatisticsScreenStateState extends State<_StatisticsScreenState> {
  @override
  void initState() {
    super.initState();
    widget.store.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: Observer(
        builder: (_) {
          if (widget.store.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.store.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.store.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => widget.store.load(),
                    child: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Период:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                StatisticsPeriodSelector(
                  currentPeriod: widget.store.period,
                  onChanged: (period) => widget.store.setPeriod(period),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Режим:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                StatisticsModeSelector(
                  currentMode: widget.store.mode,
                  onChanged: (mode) => widget.store.setMode(mode),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Ключевые метрики:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.5,
                  children: [
                    StatisticsSummaryCard(
                      title: 'Всего доход',
                      value: widget.store.totalIncome,
                      color: Colors.green,
                    ),
                    StatisticsSummaryCard(
                      title: 'Всего расход',
                      value: widget.store.totalExpense,
                      color: Colors.red,
                    ),
                    StatisticsSummaryCard(
                      title: 'Средний дневной доход',
                      value: widget.store.averageDailyIncome,
                      color: Colors.green.shade300,
                    ),
                    StatisticsSummaryCard(
                      title: 'Средний дневной расход',
                      value: widget.store.averageDailyExpense,
                      color: Colors.red.shade300,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                if (widget.store.mode == StatisticsMode.expensesByCategory ||
                    widget.store.mode == StatisticsMode.incomeByCategory) ...[
                  Text(
                    widget.store.mode == StatisticsMode.expensesByCategory
                        ? 'Расходы по категориям:'
                        : 'Доходы по категориям:',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CategoryPieChart(
                    categoryStats: widget.store.categoryStats,
                  ),
                  const SizedBox(height: 20),
                  if (widget.store.categoryStats.isNotEmpty) ...[
                    const Text(
                      'Суммы по категориям:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.store.categoryStats.length,
                      itemBuilder: (context, index) {
                        final stat = widget.store.categoryStats[index];
                        return ListTile(
                          leading: const Icon(Icons.attach_money_outlined),
                          title: Text(stat.category),
                          trailing: Text(
                            '${stat.totalAmount.toStringAsFixed(2)} ₽',
                          ),
                        );
                      },
                    ),
                  ],
                ] else if (widget.store.mode == StatisticsMode.balanceDynamics) ...[
                  const Text(
                    'Динамика баланса:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  BalanceLineChart(
                    balancePoints: widget.store.balancePoints,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  StatisticsScreen({super.key})
      : store = StatisticsStore(
          GetIt.I<GetCategoryStats>(),
          GetIt.I<GetBalanceDynamics>(),
          GetIt.I<GetTotalAmount>(),
        );

  final StatisticsStore store;

  @override
  Widget build(BuildContext context) {
    return _StatisticsScreenState(store: store);
  }
}


