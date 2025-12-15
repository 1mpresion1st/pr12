import 'package:get_it/get_it.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/local/transactions_local_data_source.dart';
import '../../data/datasources/local/goals_local_data_source.dart';
import '../../data/datasources/local/category_budgets_local_data_source.dart';
import '../../data/datasources/local/recurring_payments_local_data_source.dart';
import '../../data/datasources/local/attachments_local_data_source.dart';
import '../../data/repositories/transactions_repository_impl.dart';
import '../../data/repositories/goals_repository_impl.dart';
import '../../data/repositories/category_budgets_repository_impl.dart';
import '../../data/repositories/recurring_payments_repository_impl.dart';
import '../../data/repositories/attachments_repository_impl.dart';
import '../../data/repositories/secure_storage_repository_impl.dart';
import '../../data/repositories/preferences_repository_impl.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../../domain/repositories/goals_repository.dart';
import '../../domain/repositories/category_budgets_repository.dart';
import '../../domain/repositories/recurring_payments_repository.dart';
import '../../domain/repositories/attachments_repository.dart';
import '../../domain/repositories/secure_storage_repository.dart';
import '../../domain/repositories/preferences_repository.dart';
import '../../domain/usecases/transactions/get_all_transactions.dart';
import '../../domain/usecases/transactions/get_transactions.dart';
import '../../domain/usecases/transactions/get_transaction_by_id.dart';
import '../../domain/usecases/transactions/add_transaction.dart';
import '../../domain/usecases/transactions/update_transaction.dart';
import '../../domain/usecases/transactions/delete_transaction.dart';
import '../../domain/usecases/goals/get_all_goals.dart';
import '../../domain/usecases/goals/get_goal_by_id.dart';
import '../../domain/usecases/goals/get_goal_subtasks.dart';
import '../../domain/usecases/goals/save_goal.dart';
import '../../domain/usecases/goals/delete_goal.dart';
import '../../domain/usecases/category_budgets/get_all_budgets.dart';
import '../../domain/usecases/category_budgets/get_budget_by_id.dart';
import '../../domain/usecases/category_budgets/save_budget.dart';
import '../../domain/usecases/category_budgets/delete_budget.dart';
import '../../domain/usecases/recurring_payments/get_all_recurring_payments.dart';
import '../../domain/usecases/recurring_payments/get_recurring_payment_by_id.dart';
import '../../domain/usecases/recurring_payments/save_recurring_payment.dart';
import '../../domain/usecases/recurring_payments/delete_recurring_payment.dart';
import '../../domain/usecases/attachments/get_all_attachments.dart';
import '../../domain/usecases/attachments/get_attachment_by_id.dart';
import '../../domain/usecases/attachments/add_attachment.dart';
import '../../domain/usecases/attachments/delete_attachment.dart';
import '../../domain/usecases/statistics/get_category_stats.dart';
import '../../domain/usecases/statistics/get_balance_dynamics.dart';
import '../../domain/usecases/statistics/get_total_amount.dart';
import '../../domain/usecases/secure_storage/read_secure_value.dart';
import '../../domain/usecases/secure_storage/write_secure_value.dart';
import '../../domain/usecases/secure_storage/delete_secure_value.dart';
import '../../domain/usecases/preferences/read_pref_string.dart';
import '../../domain/usecases/preferences/write_pref_string.dart';
import '../../domain/usecases/preferences/delete_pref_key.dart';
import '../../domain/repositories/attachment_gallery_filters_repository.dart';
import '../../domain/usecases/attachment_gallery_filters/get_attachment_gallery_filters.dart';
import '../../domain/usecases/attachment_gallery_filters/save_attachment_gallery_filters.dart';
import '../../domain/usecases/attachment_gallery_filters/clear_attachment_gallery_filters.dart';
import '../../data/repositories/attachment_gallery_filters_repository_impl.dart';
import '../../data/repositories/attachment_gallery_filters_repository_web_impl.dart';
import '../../data/demo_data.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// Legacy services for backward compatibility (temporary, will be removed)
import '../../data/legacy/transactions_service.dart';
import '../../data/legacy/goals_service.dart';
import '../../data/legacy/category_budgets_service.dart';
import '../../data/legacy/recurring_payments_service.dart';
import '../../data/legacy/attachments_service.dart';
import '../../data/legacy/statistics_service.dart';

final getIt = GetIt.instance;

Future<void> setupDI() async {
  // Data Sources
  getIt.registerLazySingleton<TransactionsLocalDataSource>(
    () => TransactionsLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<GoalsLocalDataSource>(
    () => GoalsLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<CategoryBudgetsLocalDataSource>(
    () => CategoryBudgetsLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<RecurringPaymentsLocalDataSource>(
    () => RecurringPaymentsLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<AttachmentsLocalDataSource>(
    () => AttachmentsLocalDataSourceImpl(),
  );

  // Secure Storage
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);

  // Repositories
  getIt.registerLazySingleton<TransactionsRepository>(
    () => TransactionsRepositoryImpl(
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<GoalsRepository>(
    () => GoalsRepositoryImpl(
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<CategoryBudgetsRepository>(
    () => CategoryBudgetsRepositoryImpl(
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<RecurringPaymentsRepository>(
    () => RecurringPaymentsRepositoryImpl(
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<AttachmentsRepository>(
    () => AttachmentsRepositoryImpl(
      localDataSource: getIt(),
    ),
  );
  getIt.registerLazySingleton<SecureStorageRepository>(
    () => SecureStorageRepositoryImpl(
      getIt(),
    ),
  );
  getIt.registerLazySingleton<PreferencesRepository>(
    () => PreferencesRepositoryImpl(
      getIt(),
    ),
  );

  // Use Cases - Transactions
  getIt.registerLazySingleton<GetAllTransactions>(
    () => GetAllTransactions(getIt()),
  );
  getIt.registerLazySingleton<GetTransactions>(
    () => GetTransactions(getIt()),
  );
  getIt.registerLazySingleton<GetTransactionById>(
    () => GetTransactionById(getIt()),
  );
  getIt.registerLazySingleton<AddTransaction>(
    () => AddTransaction(getIt()),
  );
  getIt.registerLazySingleton<UpdateTransaction>(
    () => UpdateTransaction(getIt()),
  );
  getIt.registerLazySingleton<DeleteTransaction>(
    () => DeleteTransaction(getIt()),
  );

  // Use Cases - Goals
  getIt.registerLazySingleton<GetAllGoals>(
    () => GetAllGoals(getIt()),
  );
  getIt.registerLazySingleton<GetGoalById>(
    () => GetGoalById(getIt()),
  );
  getIt.registerLazySingleton<GetGoalSubtasks>(
    () => GetGoalSubtasks(getIt()),
  );
  getIt.registerLazySingleton<SaveGoal>(
    () => SaveGoal(getIt()),
  );
  getIt.registerLazySingleton<DeleteGoal>(
    () => DeleteGoal(getIt()),
  );

  // Use Cases - Category Budgets
  getIt.registerLazySingleton<GetAllBudgets>(
    () => GetAllBudgets(getIt()),
  );
  getIt.registerLazySingleton<GetBudgetById>(
    () => GetBudgetById(getIt()),
  );
  getIt.registerLazySingleton<SaveBudget>(
    () => SaveBudget(getIt()),
  );
  getIt.registerLazySingleton<DeleteBudget>(
    () => DeleteBudget(getIt()),
  );

  // Use Cases - Recurring Payments
  getIt.registerLazySingleton<GetAllRecurringPayments>(
    () => GetAllRecurringPayments(getIt()),
  );
  getIt.registerLazySingleton<GetRecurringPaymentById>(
    () => GetRecurringPaymentById(getIt()),
  );
  getIt.registerLazySingleton<SaveRecurringPayment>(
    () => SaveRecurringPayment(getIt()),
  );
  getIt.registerLazySingleton<DeleteRecurringPayment>(
    () => DeleteRecurringPayment(getIt()),
  );

  // Use Cases - Attachments
  getIt.registerLazySingleton<GetAllAttachments>(
    () => GetAllAttachments(getIt()),
  );
  getIt.registerLazySingleton<GetAttachmentById>(
    () => GetAttachmentById(getIt()),
  );
  getIt.registerLazySingleton<AddAttachment>(
    () => AddAttachment(getIt()),
  );
  getIt.registerLazySingleton<DeleteAttachment>(
    () => DeleteAttachment(getIt()),
  );

  // Use Cases - Statistics
  getIt.registerLazySingleton<GetCategoryStats>(
    () => GetCategoryStats(getIt()),
  );
  getIt.registerLazySingleton<GetBalanceDynamics>(
    () => GetBalanceDynamics(getIt()),
  );
  getIt.registerLazySingleton<GetTotalAmount>(
    () => GetTotalAmount(getIt()),
  );

  // Use Cases - Secure Storage
  getIt.registerLazySingleton<ReadSecureValue>(
    () => ReadSecureValue(getIt()),
  );
  getIt.registerLazySingleton<WriteSecureValue>(
    () => WriteSecureValue(getIt()),
  );
  getIt.registerLazySingleton<DeleteSecureValue>(
    () => DeleteSecureValue(getIt()),
  );

  // Use Cases - Preferences
  getIt.registerLazySingleton<ReadPrefString>(
    () => ReadPrefString(getIt()),
  );
  getIt.registerLazySingleton<WritePrefString>(
    () => WritePrefString(getIt()),
  );
  getIt.registerLazySingleton<DeletePrefKey>(
    () => DeletePrefKey(getIt()),
  );

  // Attachment Gallery Filters Repository (SQLite or Web fallback)
  if (kIsWeb) {
    getIt.registerLazySingleton<AttachmentGalleryFiltersRepository>(
      () => AttachmentGalleryFiltersRepositoryWebImpl(),
    );
  } else {
    getIt.registerLazySingleton<AttachmentGalleryFiltersRepository>(
      () => AttachmentGalleryFiltersRepositoryImpl(),
    );
  }

  // Use Cases - Attachment Gallery Filters
  getIt.registerLazySingleton<GetAttachmentGalleryFilters>(
    () => GetAttachmentGalleryFilters(getIt()),
  );
  getIt.registerLazySingleton<SaveAttachmentGalleryFilters>(
    () => SaveAttachmentGalleryFilters(getIt()),
  );
  getIt.registerLazySingleton<ClearAttachmentGalleryFilters>(
    () => ClearAttachmentGalleryFilters(getIt()),
  );

  // Legacy Services (for backward compatibility with old screens)
  // TODO: Remove these when all screens are migrated to use cases
  getIt.registerLazySingleton<TransactionsService>(
    () => TransactionsService(),
  );
  getIt.registerLazySingleton<GoalsService>(
    () => GoalsService(),
  );
  getIt.registerLazySingleton<CategoryBudgetsService>(
    () => CategoryBudgetsService(),
  );
  getIt.registerLazySingleton<RecurringPaymentsService>(
    () => RecurringPaymentsService(),
  );
  getIt.registerLazySingleton<AttachmentsService>(
    () => AttachmentsService(),
  );
  getIt.registerLazySingleton<StatisticsService>(
    () => StatisticsService(getIt<TransactionsService>()),
  );

  // Initialize with demo data
  final transactionsDataSource = getIt<TransactionsLocalDataSource>();
  await transactionsDataSource.initializeWithDemoData(demoTransactions);
}

