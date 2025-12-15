# Подробное описание интеграции SQLite в приложение PR12

## Контекст задачи

Была поставлена задача встроить SQLite в Flutter приложение PR12, но **только для одного экрана** (Attachments Gallery), не переписывая существующее хранилище проекта. Приложение использует Clean Architecture + MobX + GetIt + GoRouter. Существующие данные хранятся в памяти через LocalDataSource на основе List.

## Выбранный экран

Выбран экран **Attachments Gallery** (`lib/ui/attachments/screens/attachments_gallery_screen.dart`), который отображает галерею чеков и вложений с возможностью фильтрации по:
- Категории (categoryFilter: String?)
- Типу вложения (typeFilter: AttachmentType?)
- Диапазону дат (fromDate: DateTime?, toDate: DateTime?)

**Что хранится в SQLite:** Состояние фильтров галереи, чтобы при следующем открытии экрана фильтры восстанавливались автоматически.

## Архитектура решения

Реализация следует принципам **Clean Architecture** с разделением на слои:

### 1. Domain Layer (Бизнес-логика)

#### Entity: `lib/domain/entities/attachment_gallery_filters.dart`
```dart
class AttachmentGalleryFilters {
  final String? categoryFilter;
  final AttachmentType? typeFilter;
  final DateTime? fromDate;
  final DateTime? toDate;
  final DateTime updatedAt;
}
```
- Чистая бизнес-сущность без зависимостей от фреймворков
- Использует `AttachmentType` из legacy кода (enum: receipt, productPhoto, other)

#### Repository Interface: `lib/domain/repositories/attachment_gallery_filters_repository.dart`
```dart
abstract class AttachmentGalleryFiltersRepository {
  Future<AttachmentGalleryFilters?> getFilters();
  Future<void> saveFilters(AttachmentGalleryFilters filters);
  Future<void> clearFilters();
}
```
- Абстракция для работы с хранилищем фильтров
- Реализация может быть SQLite или in-memory (для Web)

#### Use Cases (3 файла в `lib/domain/usecases/attachment_gallery_filters/`):

1. **get_attachment_gallery_filters.dart**
   - Получение сохранённых фильтров из хранилища
   - Возвращает `Future<AttachmentGalleryFilters?>`

2. **save_attachment_gallery_filters.dart**
   - Сохранение фильтров в хранилище
   - Принимает `AttachmentGalleryFilters` entity

3. **clear_attachment_gallery_filters.dart**
   - Очистка сохранённых фильтров
   - Используется при нажатии "Сбросить"

### 2. Data Layer (Работа с данными)

#### SQLite Database Helper: `lib/data/datasources/local/sqlite/app_database.dart`

**Ключевые особенности:**
- Singleton паттерн с lazy initialization
- Версия базы: 1 (без миграций)
- Таблица: `attachment_gallery_filters`
- Методы: `getFilters()`, `saveFilters()`, `clearFilters()`

**Структура таблицы:**
```sql
CREATE TABLE attachment_gallery_filters (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  category_filter TEXT,
  type_filter TEXT,
  from_date INTEGER,
  to_date INTEGER,
  updated_at INTEGER NOT NULL
)
```

**Важно:** 
- Хранится только **одна запись** (при сохранении старые удаляются)
- Даты хранятся как INTEGER (millisecondsSinceEpoch)
- AttachmentType сериализуется как строка (enum.name)

**Web fallback:**
- Если `kIsWeb == true`, выбрасывается `UnsupportedError`
- Это обрабатывается на уровне DI, где выбирается Web-реализация

#### DTO: `lib/data/models/attachment_gallery_filters_dto.dart`

**Назначение:** Преобразование между Entity (Domain) и Map (SQLite)

**Методы:**
- `toMap()` - преобразование в Map для SQLite
- `fromMap()` - создание DTO из Map из SQLite
- `toEntity()` - преобразование DTO в Domain Entity
- `fromEntity()` - создание DTO из Domain Entity

**Особенности сериализации:**
- `AttachmentType` → строка через `enum.name`
- `DateTime` → `int` через `millisecondsSinceEpoch`
- При десериализации AttachmentType используется `firstWhere` с fallback на `receipt`

#### Repository Implementations:

**1. SQLite реализация:** `lib/data/repositories/attachment_gallery_filters_repository_impl.dart`
- Использует `AppDatabase` для работы с SQLite
- Преобразует Entity ↔ DTO ↔ Map
- Обрабатывает ошибки (возвращает null при ошибках чтения)

**2. Web fallback:** `lib/data/repositories/attachment_gallery_filters_repository_web_impl.dart`
- In-memory хранилище (просто поле `_cachedFilters`)
- Тот же интерфейс, что и SQLite реализация
- Используется автоматически на Web платформе

### 3. Dependency Injection (GetIt)

**Файл:** `lib/core/di/injection_container.dart`

**Регистрация компонентов:**

```dart
// Репозиторий (выбор реализации в зависимости от платформы)
if (kIsWeb) {
  getIt.registerLazySingleton<AttachmentGalleryFiltersRepository>(
    () => AttachmentGalleryFiltersRepositoryWebImpl(),
  );
} else {
  getIt.registerLazySingleton<AttachmentGalleryFiltersRepository>(
    () => AttachmentGalleryFiltersRepositoryImpl(),
  );
}

// Use Cases
getIt.registerLazySingleton<GetAttachmentGalleryFilters>(
  () => GetAttachmentGalleryFilters(getIt()),
);
getIt.registerLazySingleton<SaveAttachmentGalleryFilters>(
  () => SaveAttachmentGalleryFilters(getIt()),
);
getIt.registerLazySingleton<ClearAttachmentGalleryFilters>(
  () => ClearAttachmentGalleryFilters(getIt()),
);
```

**Важно:** 
- Репозиторий регистрируется как lazy singleton
- Выбор реализации происходит на этапе регистрации (compile-time check через `kIsWeb`)
- Use cases получают репозиторий через GetIt автоматически

### 4. UI Layer (MobX Store + Screen)

#### Store: `lib/ui/attachments/stores/attachments_gallery_store.dart`

**Добавленные зависимости:**
```dart
final GetAttachmentGalleryFilters _getFilters;
final SaveAttachmentGalleryFilters _saveFilters;
final ClearAttachmentGalleryFilters _clearFilters;
Timer? _saveFiltersDebounceTimer;
```

**Новые методы:**

1. **`init()`** - загрузка сохранённых фильтров при инициализации:
   ```dart
   @action
   Future<void> init() async {
     try {
       final savedFilters = await _getFilters();
       if (savedFilters != null) {
         categoryFilter = savedFilters.categoryFilter;
         typeFilter = savedFilters.typeFilter;
         fromDate = savedFilters.fromDate;
         toDate = savedFilters.toDate;
       }
     } catch (e) {
       // Игнорируем ошибки
     }
   }
   ```

2. **`_saveFiltersDebounced()`** - сохранение с задержкой 400ms:
   ```dart
   void _saveFiltersDebounced() {
     _saveFiltersDebounceTimer?.cancel();
     _saveFiltersDebounceTimer = Timer(const Duration(milliseconds: 400), () {
       final filters = AttachmentGalleryFilters(
         categoryFilter: categoryFilter,
         typeFilter: typeFilter,
         fromDate: fromDate,
         toDate: toDate,
         updatedAt: DateTime.now(),
       );
       _saveFilters(filters).catchError((_) {});
     });
   }
   ```

3. **Обновлённые методы фильтрации:**
   - `setCategoryFilter()` - теперь вызывает `_saveFiltersDebounced()`
   - `setTypeFilter()` - теперь вызывает `_saveFiltersDebounced()`
   - `setDateRange()` - теперь вызывает `_saveFiltersDebounced()`

4. **`clearFilters()`** - очистка фильтров и хранилища:
   ```dart
   @action
   Future<void> clearFilters() async {
     categoryFilter = null;
     typeFilter = null;
     fromDate = null;
     toDate = null;
     _saveFiltersDebounceTimer?.cancel();
     try {
       await _clearFilters();
     } catch (e) {
       // Игнорируем ошибки
     }
   }
   ```

#### Screen: `lib/ui/attachments/screens/attachments_gallery_screen.dart`

**Изменения:**

1. **Инициализация Store с use cases:**
   ```dart
   AttachmentsGalleryScreen({super.key})
       : store = AttachmentsGalleryStore(
           GetIt.I<AttachmentsService>(),
           GetIt.I<TransactionsService>(),
           GetIt.I<GetAttachmentGalleryFilters>(),
           GetIt.I<SaveAttachmentGalleryFilters>(),
           GetIt.I<ClearAttachmentGalleryFilters>(),
         );
   ```

2. **Вызов init() при загрузке экрана:**
   ```dart
   @override
   void didChangeDependencies() {
     super.didChangeDependencies();
     if (!_isInitialized) {
       _isInitialized = true;
       widget.store.init().then((_) => widget.store.load());
     }
   }
   ```

3. **Кнопка "Сбросить" вызывает clearFilters():**
   ```dart
   OutlinedButton(
     onPressed: () {
       setModalState(() {
         selectedCategory = null;
         selectedType = null;
         from = null;
         to = null;
       });
       store.clearFilters(); // Новый вызов
     },
     child: const Text('Сбросить'),
   )
   ```

## Зависимости

**Добавлено в `pubspec.yaml`:**
```yaml
dependencies:
  sqflite: ^2.3.3+2
  path: ^1.9.0
```

- `sqflite` - SQLite для Flutter (не работает на Web)
- `path` - утилиты для работы с путями (используется для `join()`)

## Поток данных

### Сохранение фильтров:
1. Пользователь изменяет фильтр (категория/тип/даты)
2. Store вызывает `setCategoryFilter()` / `setTypeFilter()` / `setDateRange()`
3. Эти методы вызывают `_saveFiltersDebounced()`
4. Через 400ms создаётся `AttachmentGalleryFilters` entity
5. Вызывается use case `SaveAttachmentGalleryFilters`
6. Use case вызывает репозиторий `saveFilters()`
7. Репозиторий преобразует Entity → DTO → Map
8. `AppDatabase.saveFilters()` сохраняет в SQLite (удаляет старую запись, вставляет новую)

### Загрузка фильтров:
1. При открытии экрана вызывается `store.init()`
2. Вызывается use case `GetAttachmentGalleryFilters`
3. Use case вызывает репозиторий `getFilters()`
4. Репозиторий получает Map из SQLite через `AppDatabase.getFilters()`
5. Преобразует Map → DTO → Entity
6. Store устанавливает значения в observable поля

### Очистка фильтров:
1. Пользователь нажимает "Сбросить"
2. Вызывается `store.clearFilters()`
3. Observable поля очищаются
4. Вызывается use case `ClearAttachmentGalleryFilters`
5. Репозиторий вызывает `AppDatabase.clearFilters()`
6. Запись удаляется из SQLite

## Особенности реализации

### 1. Debounce для сохранения
- Сохранение происходит с задержкой 400ms после последнего изменения
- Предыдущий таймер отменяется при новом изменении
- Это предотвращает частые записи в БД при быстром изменении фильтров

### 2. Web fallback
- На Web платформе (`kIsWeb == true`) используется in-memory реализация
- Тот же интерфейс, что и SQLite версия
- Выбор происходит в DI на этапе регистрации
- UI код не меняется в зависимости от платформы

### 3. Обработка ошибок
- Все ошибки при работе с SQLite игнорируются (try-catch с пустым блоком)
- При ошибке чтения возвращается `null` (фильтры не загружаются)
- При ошибке записи операция просто не выполняется
- Это обеспечивает graceful degradation

### 4. Singleton для базы данных
- `AppDatabase` использует singleton паттерн
- База открывается лениво при первом обращении
- Метод `database` возвращает существующий экземпляр или создаёт новый

### 5. Одна запись в таблице
- В таблице хранится только одна запись фильтров
- При сохранении старые записи удаляются
- Это упрощает логику (не нужен UPDATE, только DELETE + INSERT)

## Тестирование

### Ручная проверка:

1. **Установка зависимостей:**
   ```bash
   flutter pub get
   ```

2. **Генерация MobX кода:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Запуск приложения:**
   ```bash
   flutter run
   ```

4. **Проверка функционала:**
   - Открыть экран "Галерея чеков и вложений"
   - Установить фильтры (категория, тип, даты)
   - Закрыть приложение полностью
   - Открыть снова - фильтры должны восстановиться
   - Нажать "Сбросить" - фильтры должны очиститься

5. **Проверка на Web:**
   ```bash
   flutter run -d chrome
   ```
   - Должно работать без ошибок SQLite
   - Фильтры сохраняются в памяти (исчезают при перезагрузке страницы)

## Важные моменты

1. **Не изменены существующие LocalDataSource** - они остаются как есть (в памяти на List)
2. **SQLite используется только для одного экрана** - изолированное хранилище
3. **Clean Architecture соблюдена** - Domain не знает о Data, UI не знает о SQLite напрямую
4. **DI через GetIt** - все зависимости регистрируются в `injection_container.dart`
5. **MobX для реактивности** - Store использует `@observable`, `@action`, `@computed`
6. **Web совместимость** - автоматический fallback на in-memory хранилище

## Структура файлов

```
lib/
├── domain/
│   ├── entities/
│   │   └── attachment_gallery_filters.dart
│   ├── repositories/
│   │   └── attachment_gallery_filters_repository.dart
│   └── usecases/
│       └── attachment_gallery_filters/
│           ├── get_attachment_gallery_filters.dart
│           ├── save_attachment_gallery_filters.dart
│           └── clear_attachment_gallery_filters.dart
├── data/
│   ├── datasources/
│   │   └── local/
│   │       └── sqlite/
│   │           └── app_database.dart
│   ├── models/
│   │   └── attachment_gallery_filters_dto.dart
│   └── repositories/
│       ├── attachment_gallery_filters_repository_impl.dart
│       └── attachment_gallery_filters_repository_web_impl.dart
├── ui/
│   └── attachments/
│       ├── screens/
│       │   └── attachments_gallery_screen.dart (изменён)
│       └── stores/
│           └── attachments_gallery_store.dart (изменён)
└── core/
    └── di/
        └── injection_container.dart (изменён)
```

## Заключение

Реализация полностью соответствует требованиям:
- ✅ SQLite встроен только для одного экрана
- ✅ Существующие LocalDataSource не изменены
- ✅ Clean Architecture соблюдена
- ✅ DI через GetIt
- ✅ Web fallback реализован
- ✅ Debounce для оптимизации записи
- ✅ MobX для реактивности

Код готов к использованию и тестированию.

