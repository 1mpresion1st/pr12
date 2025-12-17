# Подробное описание проекта PR12 - Планировщик бюджета

## Общая информация

**Название проекта:** PR12 (Budget Planner / Планировщик бюджета)  
**Тип приложения:** Flutter мобильное приложение  
**Язык программирования:** Dart  
**Версия SDK:** Dart 3.9.2  
**Платформы:** Android, iOS, Web, Windows, Linux, macOS

**Описание:** Мобильное приложение для управления личным бюджетом с функциями учета доходов и расходов, планирования финансовых целей, контроля бюджетов по категориям, управления регулярными платежами и ведения статистики.

---

## Архитектура проекта

Проект использует **Clean Architecture** с четким разделением на три основных слоя:

### 1. Domain Layer (Доменный слой) - `lib/domain/`

**Назначение:** Содержит бизнес-логику и сущности, не зависящие от внешних библиотек.

**Структура:**

- **`entities/`** - Бизнес-сущности приложения:

  - `transaction.dart` - Транзакции (доходы/расходы)
  - `goal.dart` - Финансовые цели с подзадачами
  - `category_budget.dart` - Бюджеты по категориям
  - `recurring_payment.dart` - Регулярные платежи
  - `attachment.dart` - Вложения (чеки, фото)
  - `statistics.dart` - Статистика
  - `recurring_payment_extensions.dart` - Расширения для регулярных платежей

- **`repositories/`** - Абстрактные интерфейсы репозиториев:

  - `transactions_repository.dart`
  - `goals_repository.dart`
  - `category_budgets_repository.dart`
  - `recurring_payments_repository.dart`
  - `attachments_repository.dart`

- **`usecases/`** - Бизнес-сценарии использования (26 use cases):
  - **Transactions:** `get_all_transactions.dart`, `get_transactions.dart`, `get_transaction_by_id.dart`, `add_transaction.dart`, `update_transaction.dart`, `delete_transaction.dart`
  - **Goals:** `get_all_goals.dart`, `get_goal_by_id.dart`, `get_goal_subtasks.dart`, `save_goal.dart`, `delete_goal.dart`
  - **Category Budgets:** `get_all_budgets.dart`, `get_budget_by_id.dart`, `save_budget.dart`, `delete_budget.dart`
  - **Recurring Payments:** `get_all_recurring_payments.dart`, `get_recurring_payment_by_id.dart`, `save_recurring_payment.dart`, `delete_recurring_payment.dart`
  - **Attachments:** `get_all_attachments.dart`, `get_attachment_by_id.dart`, `add_attachment.dart`, `delete_attachment.dart`
  - **Statistics:** `get_category_stats.dart`, `get_balance_dynamics.dart`, `get_total_amount.dart`

### 2. Data Layer (Слой данных) - `lib/data/`

**Назначение:** Реализация работы с данными, преобразование между DTO и Entity.

**Структура:**

- **`datasources/local/`** - Локальные источники данных (хранение в памяти):

  - `transactions_local_data_source.dart` - Хранение транзакций в List<TransactionDto>
  - `goals_local_data_source.dart` - Хранение целей
  - `category_budgets_local_data_source.dart` - Хранение бюджетов
  - `recurring_payments_local_data_source.dart` - Хранение регулярных платежей
  - `attachments_local_data_source.dart` - Хранение вложений

- **`models/`** - DTO (Data Transfer Objects) для преобразования:

  - `transaction_dto.dart`
  - `goal_dto.dart`
  - `category_budget_dto.dart`
  - `recurring_payment_dto.dart`
  - `attachment_dto.dart`

- **`repositories/`** - Реализации репозиториев:

  - `transactions_repository_impl.dart`
  - `goals_repository_impl.dart`
  - `category_budgets_repository_impl.dart`
  - `recurring_payments_repository_impl.dart`
  - `attachments_repository_impl.dart`

- **`legacy/`** - Старые сервисы для обратной совместимости (помечены как временные):

  - `transactions_service.dart`
  - `goals_service.dart`
  - `category_budgets_service.dart`
  - `recurring_payments_service.dart`
  - `attachments_service.dart`
  - `statistics_service.dart`
  - `services.dart`

- **`demo_data.dart`** - Демонстрационные данные для инициализации (50 транзакций за последние 5 месяцев)

### 3. UI Layer (Слой представления) - `lib/ui/`

**Назначение:** Пользовательский интерфейс и управление состоянием.

**Структура:**

- **`home/`** - Главный экран приложения

  - `home_screen.dart` - Экран с балансом и навигацией

- **`transactions/`** - Модуль транзакций

  - **`screens/`:** `transactions_list_screen.dart`, `add_transaction_screen.dart`, `transaction_details_screen.dart`
  - **`stores/`:** MobX stores для управления состоянием
  - **`routes.dart`** - Определение маршрутов

- **`goals/`** - Модуль финансовых целей

  - **`screens/`:** `goals_list_screen.dart`, `goal_details_screen.dart`, `add_goal_screen.dart`
  - **`stores/`:** MobX stores

- **`category_budgets/`** - Модуль бюджетов по категориям

  - **`screens/`:** `category_budgets_screen.dart`, `edit_category_budget_screen.dart`, `budget_progress_bar.dart`, `category_budget_item.dart`
  - **`stores/`:** MobX stores

- **`recurring_payments/`** - Модуль регулярных платежей

  - **`screens/`:** `recurring_payments_list_screen.dart`, `add_recurring_payment_screen.dart`
  - **`stores/`:** MobX stores

- **`attachments/`** - Модуль вложений (чеки, фото)

  - **`screens/`:** `attachments_gallery_screen.dart`, `attachment_full_screen.dart`
  - **`stores/`:** MobX stores

- **`statistics/`** - Модуль статистики

  - **`screens/`:** Экраны для отображения статистики (6 файлов)
  - **`stores/`:** `statistics_store.dart`

- **`models/`** - UI-специфичные модели:
  - `attachment_with_meta.dart`
  - `category_budget_with_progress.dart`
  - `goal_with_progress.dart`

### 4. Core Layer (Ядро приложения) - `lib/core/`

**Назначение:** Общие компоненты и конфигурация.

- **`di/`** - Dependency Injection:

  - `injection_container.dart` - Настройка GetIt с регистрацией всех зависимостей (data sources, repositories, use cases, legacy services)

- **`constants/`** - Константы приложения:

  - `app_constants.dart`

- **`errors/`** - Обработка ошибок:
  - `failures.dart`

---

## Основные технологии и библиотеки

### State Management

- **MobX** (`mobx: ^2.5.0`) - Реактивное управление состоянием
- **flutter_mobx** (`flutter_mobx: ^2.3.0`) - Интеграция MobX с Flutter
- **build_runner** (`build_runner: 2.7.1`) + **mobx_codegen** (`mobx_codegen: ^2.7.4`) - Генерация кода для MobX

### Dependency Injection

- **get_it** (`get_it: ^7.7.0`) - Service locator для DI

### Navigation

- **go_router** (`go_router: ^14.2.7`) - Декларативная маршрутизация

### UI Components

- **fl_chart** (`fl_chart: ^0.66.0`) - Графики и диаграммы для статистики
- **cached_network_image** (`cached_network_image: ^3.4.1`) - Кэширование изображений
- **image_picker** (`image_picker: ^1.0.0`) - Выбор изображений из галереи

### Development Tools

- **flutter_lints** (`flutter_lints: ^5.0.0`) - Линтинг кода

---

## Основные сущности и их структура

### Transaction (Транзакция)

```dart
enum TransactionType { income, expense }

class Transaction {
  String id;
  double amount;
  DateTime date;
  TransactionType type;  // доход или расход
  String category;       // категория (Еда, Транспорт, и т.д.)
  String? note;          // заметка
  String? goalId;        // связь с целью
  String? budgetId;      // связь с бюджетом
  String? attachmentId;  // связь с вложением
}
```

### Goal (Финансовая цель)

```dart
enum GoalStatus { inProgress, completed }

class Goal {
  String id;
  String name;
  double targetAmount;    // целевая сумма
  DateTime? targetDate;   // целевая дата
  String? icon;
  String? description;
  DateTime createdAt;
}

class GoalSubtask {
  String id;
  String goalId;
  String name;
  double targetAmount;
  int order;
}
```

### CategoryBudget (Бюджет по категории)

```dart
enum BudgetPeriod { monthly }

class CategoryBudget {
  String id;
  String category;        // категория расходов
  double limitAmount;     // лимит на период
  BudgetPeriod period;    // период (месячный)
}
```

### RecurringPayment (Регулярный платеж)

```dart
enum RecurringPaymentFrequency { weekly, monthly, yearly }

class RecurringPayment {
  String id;
  String name;
  double amount;
  RecurringPaymentFrequency frequency;
  DateTime nextChargeDate;
  String category;
  bool autoCreateTransaction;  // автоматически создавать транзакцию
  bool isActive;
  DateTime createdAt;
}
```

### Attachment (Вложение)

```dart
enum AttachmentType { receipt, productPhoto, other }

class Attachment {
  String id;
  String transactionId;   // связь с транзакцией
  String path;           // путь к файлу
  AttachmentType type;
  DateTime createdAt;
}
```

---

## Маршрутизация (Navigation)

Приложение использует **GoRouter** для навигации. Основные маршруты:

- `/` - Главный экран (HomeScreen)
- `/transactions` - Список транзакций
- `/transactions/add` - Добавление транзакции
- `/transactions/:id` - Детали транзакции
- `/statistics` - Статистика расходов
- `/category-budgets` - Бюджеты по категориям
- `/category-budgets/edit` - Редактирование бюджета
- `/goals` - Список целей
- `/goals/add` - Добавление/редактирование цели
- `/goals/:id` - Детали цели
- `/recurring-payments` - Список регулярных платежей
- `/recurring-payments/add` - Добавление/редактирование регулярного платежа
- `/attachments` - Галерея вложений
- `/attachments/:id` - Просмотр вложения

---

## Хранение данных

**Текущая реализация:** Данные хранятся **в памяти** (в List структурах внутри LocalDataSource классов). При перезапуске приложения данные теряются, но при инициализации загружаются демонстрационные данные из `demo_data.dart`.

**Особенности:**

- Все DataSource классы используют `List<T>` для хранения данных
- При старте приложения вызывается `initializeWithDemoData()` для транзакций
- Данные не сохраняются между сессиями (нет персистентного хранилища)

**Потенциальные улучшения:**

- Интеграция с SQLite через `sqflite` или `drift`
- Использование `shared_preferences` для простых данных
- Интеграция с Firebase или другой облачной БД

---

## Dependency Injection (DI)

DI настроен в `lib/core/di/injection_container.dart` с использованием **GetIt**.

**Регистрация зависимостей:**

1. **Data Sources** - как LazySingleton
2. **Repositories** - как LazySingleton, получают data sources через DI
3. **Use Cases** - как LazySingleton, получают repositories через DI
4. **Legacy Services** - как LazySingleton (для обратной совместимости)

**Инициализация:** Вызывается в `main()` перед запуском приложения:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDI();
  runApp(BudgetPlannerApp());
}
```

---

## Управление состоянием (State Management)

Приложение использует **MobX** для реактивного управления состоянием.

**Паттерн:**

- Каждый экран имеет соответствующий **Store** класс
- Store классы помечены аннотацией `@Store` и используют `@observable`, `@computed`, `@action`
- Код генерируется через `build_runner` (файлы `.g.dart`)
- UI виджеты используют `Observer` для реактивного обновления

**Пример структуры Store:**

```dart
@Store()
class TransactionsListStore = _TransactionsListStore with _$TransactionsListStore;

abstract class _TransactionsListStore with Store {
  @observable
  List<Transaction> transactions = [];

  @observable
  bool isLoading = false;

  @action
  Future<void> loadTransactions() async { ... }
}
```

---

## Основной функционал приложения

### 1. Управление транзакциями

- Добавление доходов и расходов
- Редактирование транзакций
- Удаление транзакций
- Просмотр списка транзакций с фильтрацией
- Просмотр деталей транзакции
- Связывание транзакций с целями, бюджетами и вложениями

### 2. Финансовые цели

- Создание финансовых целей с целевой суммой и датой
- Подзадачи для целей (GoalSubtask)
- Отслеживание прогресса достижения целей
- Связывание транзакций с целями

### 3. Бюджеты по категориям

- Установка месячных лимитов по категориям расходов
- Отслеживание прогресса использования бюджета
- Визуализация прогресса через прогресс-бары

### 4. Регулярные платежи

- Создание регулярных платежей (еженедельные, ежемесячные, ежегодные)
- Автоматическое создание транзакций (опционально)
- Управление активностью платежей

### 5. Вложения (Attachments)

- Прикрепление чеков и фотографий к транзакциям
- Галерея всех вложений
- Просмотр вложений в полноэкранном режиме

### 6. Статистика

- Статистика по категориям расходов
- Динамика баланса
- Общая сумма доходов/расходов
- Визуализация через графики (fl_chart)

---

## Демонстрационные данные

Приложение инициализируется с **50 демонстрационными транзакциями**, распределенными по последним 5 месяцам:

- **Текущий месяц:** 10 транзакций (4 дохода, 6 расходов)
- **Месяц -1:** 9 транзакций (3 дохода, 6 расходов)
- **Месяц -2:** 9 транзакций (3 дохода, 6 расходов)
- **Месяц -3:** 10 транзакций (3 дохода, 7 расходов)
- **Месяц -4:** 7 транзакций (2 дохода, 5 расходов)
- **Месяц -5:** 5 транзакций (2 дохода, 3 расхода)

**Категории доходов:** Зарплата, Фриланс, Кэшбэк, Подарок  
**Категории расходов:** Еда, Транспорт, Развлечения, Здоровье, Коммуналка, Интернет, Подписки, Одежда, Образование, Путешествия, Дом

---

## Структура файлов проекта

```
lib/
├── core/                    # Ядро приложения
│   ├── constants/          # Константы
│   ├── di/                 # Dependency Injection
│   └── errors/             # Обработка ошибок
├── data/                   # Слой данных
│   ├── datasources/        # Источники данных
│   ├── models/             # DTO модели
│   ├── repositories/       # Реализации репозиториев
│   ├── legacy/             # Старые сервисы (временные)
│   └── demo_data.dart      # Демо данные
├── domain/                 # Доменный слой
│   ├── entities/           # Бизнес-сущности
│   ├── repositories/       # Интерфейсы репозиториев
│   └── usecases/           # Use cases (26 файлов)
├── ui/                     # Слой представления
│   ├── home/               # Главный экран
│   ├── transactions/       # Модуль транзакций
│   ├── goals/              # Модуль целей
│   ├── category_budgets/   # Модуль бюджетов
│   ├── recurring_payments/ # Модуль регулярных платежей
│   ├── attachments/        # Модуль вложений
│   ├── statistics/         # Модуль статистики
│   └── models/             # UI модели
└── main.dart               # Точка входа
```

---

## Особенности реализации

### 1. Clean Architecture

- Четкое разделение слоев (Domain, Data, UI)
- Domain слой не зависит от внешних библиотек
- Использование интерфейсов (repositories) для абстракции

### 2. Use Cases Pattern

- Каждая бизнес-операция инкапсулирована в отдельный use case
- Use cases получают репозитории через конструктор
- Простота тестирования и поддержки

### 3. Legacy Code

- В проекте присутствуют старые сервисы в папке `legacy/`
- Они используются для обратной совместимости со старыми экранами
- Помечены как временные

### 4. MobX Code Generation

- Все Store классы генерируются через `build_runner`
- Файлы `.g.dart` содержат сгенерированный код
- Необходимо запускать `flutter pub run build_runner build` после изменений

### 5. Локализация

- Приложение использует русский язык в UI
- Название приложения: "Планировщик бюджета"
- Главный экран: "Ало бизнес? Да-да, деньги!"

---

## Запуск и сборка проекта

### Требования

- Flutter SDK 3.9.2 или выше
- Dart SDK 3.9.2 или выше

### Установка зависимостей

```bash
flutter pub get
```

### Генерация кода MobX

```bash
flutter pub run build_runner build
# или для автоматической регенерации:
flutter pub run build_runner watch
```

### Запуск приложения

```bash
flutter run
```

### Сборка для платформ

```bash
# Android
flutter build apk

# iOS
flutter build ios

# Web
flutter build web

# Windows
flutter build windows
```

---


## Заключение

PR12 - это полнофункциональное Flutter приложение для управления личным бюджетом, построенное на принципах Clean Architecture. Приложение демонстрирует современные практики разработки Flutter приложений с использованием MobX для управления состоянием, GetIt для dependency injection и GoRouter для навигации. Проект имеет четкую структуру и готов к дальнейшему развитию и улучшению.



