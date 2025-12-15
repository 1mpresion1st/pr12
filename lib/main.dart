import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'UI/home/home_screen.dart';
import 'UI/transactions/screens/transactions_list_screen.dart';
import 'UI/transactions/screens/add_transaction_screen.dart';
import 'UI/transactions/screens/transaction_details_screen.dart';
import 'UI/statistics/screens/statistics_screen.dart';
import 'UI/category_budgets/screens/category_budgets_screen.dart';
import 'UI/category_budgets/screens/edit_category_budget_screen.dart';
import 'data/legacy/category_budgets_service.dart';
import 'UI/goals/screens/goals_list_screen.dart';
import 'UI/goals/screens/goal_details_screen.dart';
import 'UI/goals/screens/add_goal_screen.dart';
import 'data/legacy/goals_service.dart';
import 'UI/recurring_payments/screens/recurring_payments_list_screen.dart';
import 'UI/recurring_payments/screens/add_recurring_payment_screen.dart';
import 'data/legacy/recurring_payments_service.dart';
import 'UI/attachments/screens/attachments_gallery_screen.dart';
import 'UI/attachments/screens/attachment_full_screen.dart';
import 'UI/transactions/routes.dart' as transactions_routes;

import 'core/di/injection_container.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDI();
  runApp(BudgetPlannerApp());
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.transactionsList,
      builder: (context, state) => TransactionsListScreen(),
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.addTransaction,
      builder: (context, state) => AddTransactionScreen(),
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.transactionDetails,
      builder: (context, state) {
        final transactionId = state.extra as String;
        return TransactionDetailsScreen(transactionId: transactionId);
      },
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.statistics,
      builder: (context, state) => StatisticsScreen(),
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.categoryBudgets,
      builder: (context, state) => CategoryBudgetsScreen(),
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.editCategoryBudget,
      builder: (context, state) {
        final budget = state.extra as CategoryBudget?;
        return EditCategoryBudgetScreen(initialBudget: budget);
      },
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.goalsList,
      builder: (context, state) => GoalsListScreen(),
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.addGoal,
      builder: (context, state) {
        final extra = state.extra;
        if (extra is Goal) {
          return AddGoalScreen(initialGoal: extra);
        }
        return const AddGoalScreen();
      },
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.goalDetails,
      builder: (context, state) {
        final goalId = state.extra as String;
        return GoalDetailsScreen(goalId: goalId);
      },
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.recurringPaymentsList,
      builder: (context, state) => RecurringPaymentsListScreen(),
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.addRecurringPayment,
      builder: (context, state) {
        final payment = state.extra as RecurringPayment?;
        return AddRecurringPaymentScreen(initialPayment: payment);
      },
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.attachmentsGallery,
      builder: (context, state) => AttachmentsGalleryScreen(),
    ),
    GoRoute(
      path: transactions_routes.AppRoutes.attachmentFull,
      builder: (context, state) {
        final attachmentId = state.extra as String;
        return AttachmentFullScreen(attachmentId: attachmentId);
      },
    ),
  ],
);

class BudgetPlannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Планировщик бюджета',
      theme: ThemeData(primarySwatch: Colors.green),
      routerConfig: _router,
    );
  }
}
