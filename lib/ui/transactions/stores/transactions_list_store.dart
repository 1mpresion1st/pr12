import 'package:mobx/mobx.dart';
import '../../../../domain/entities/transaction.dart';
import '../../../../domain/usecases/transactions/get_all_transactions.dart';

part 'transactions_list_store.g.dart';

class TransactionsListStore = _TransactionsListStore with _$TransactionsListStore;

abstract class _TransactionsListStore with Store {
  _TransactionsListStore(this._getAllTransactions);

  final GetAllTransactions _getAllTransactions;

  @observable
  ObservableList<Transaction> transactions = ObservableList.of([]);

  @observable
  bool isLoading = false;

  @observable
  TransactionType? typeFilter;

  @observable
  String? categoryFilter;

  @observable
  DateTime? fromDate;

  @observable
  DateTime? toDate;

  @computed
  List<Transaction> get filteredTransactions {
    var result = List<Transaction>.from(transactions);

    if (typeFilter != null) {
      result = result.where((t) => t.type == typeFilter).toList();
    }

    if (categoryFilter != null && categoryFilter!.isNotEmpty) {
      result = result.where((t) => t.category == categoryFilter).toList();
    }

    if (fromDate != null) {
      result = result.where((t) => t.date.isAfter(fromDate!) || t.date.isAtSameMomentAs(fromDate!)).toList();
    }

    if (toDate != null) {
      result = result.where((t) => t.date.isBefore(toDate!) || t.date.isAtSameMomentAs(toDate!)).toList();
    }

    return result;
  }

  @action
  Future<void> load() async {
    isLoading = true;
    try {
      final items = await _getAllTransactions();
      transactions
        ..clear()
        ..addAll(items);
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> refresh() async {
    await load();
  }

  @action
  void setTypeFilter(TransactionType? type) {
    typeFilter = type;
  }

  @action
  void setCategoryFilter(String? category) {
    categoryFilter = category;
  }

  @action
  void setDateRange(DateTime? from, DateTime? to) {
    fromDate = from;
    toDate = to;
  }
}

