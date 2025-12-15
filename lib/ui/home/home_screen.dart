import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/usecases/transactions/get_all_transactions.dart';
import '../transactions/routes.dart' as transactions_routes;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GetAllTransactions _getAllTransactions = GetIt.I<GetAllTransactions>();
  List<Transaction> _transactions = [];
  bool _isLoading = true;
  static bool _hasCheckedRecurringPayments = false;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    Future.microtask(() => _checkRecurringPayments(context));
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    try {
      final transactions = await _getAllTransactions();
      setState(() {
        _transactions = transactions;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkRecurringPayments(BuildContext context) async {
    if (_hasCheckedRecurringPayments) return;
    _hasCheckedRecurringPayments = true;
    // TODO: Implement recurring payments check with new architecture
  }

  double _totalBalance(List<Transaction> items) {
    final income = items.where((t) => t.type == TransactionType.income)
        .fold<double>(0, (sum, t) => sum + t.amount);
    final expense = items.where((t) => t.type == TransactionType.expense)
        .fold<double>(0, (sum, t) => sum + t.amount);
    return income - expense;
  }

  Map<String, double> _getCategoryTotals(List<Transaction> items) {
    final totals = <String, double>{};
    for (final t in items) {
      if (t.type == TransactionType.expense) {
        totals[t.category] = (totals[t.category] ?? 0) + t.amount;
      }
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ало бизнес? Да-да, деньги!')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final totals = _getCategoryTotals(_transactions);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ало бизнес? Да-да, деньги!'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Текущий баланс: ${_totalBalance(_transactions).toStringAsFixed(2)} ₽',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildWideButton(
                icon: Icons.add,
                text: 'Добавить операцию',
                onPressed: () async {
                  await context.push('/transactions/add');
                  _loadTransactions();
                },
              ),
              const SizedBox(height: 10),
              _buildWideButton(
                icon: Icons.photo_library,
                text: 'Галерея чеков и вложений',
                onPressed: () {
                  context.push(transactions_routes.AppRoutes.attachmentsGallery);
                },
              ),
              const SizedBox(height: 10),
              _buildWideButton(
                icon: Icons.list,
                text: 'Список операций',
                onPressed: () {
                  context.push('/transactions');
                },
              ),
              const SizedBox(height: 10),
              _buildWideButton(
                icon: Icons.pie_chart,
                text: 'Статистика расходов',
                onPressed: () {
                  context.push('/statistics');
                },
              ),
              const SizedBox(height: 10),
              _buildWideButton(
                icon: Icons.account_balance_wallet,
                text: 'Бюджеты по категориям',
                onPressed: () {
                  context.push('/category-budgets');
                },
              ),
              const SizedBox(height: 10),
              _buildWideButton(
                icon: Icons.flag,
                text: 'Финансовые цели',
                onPressed: () {
                  context.push('/goals');
                },
              ),
              const SizedBox(height: 10),
              _buildWideButton(
                icon: Icons.repeat,
                text: 'Регулярные платежи',
                onPressed: () {
                  context.push(transactions_routes.AppRoutes.recurringPaymentsList);
                },
              ),
              const SizedBox(height: 20),
              if (totals.isNotEmpty) ...[
                const Text(
                  'Быстрый обзор по категориям:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Column(
                  children: totals.entries.map((e) {
                    return ListTile(
                      leading: const Icon(Icons.attach_money_outlined),
                      title: Text(e.key),
                      trailing: Text('${e.value.toStringAsFixed(2)} ₽'),
                    );
                  }).toList(),
                ),
              ] else
                const Text('Пока нет расходов для анализа.'),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildWideButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 22),
        label: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          side: const BorderSide(color: Colors.deepPurple, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
      ),
    );
  }
}
