# Подробное описание интеграции SharedPreferences в экран Add Goal

## Контекст проекта

**Проект:** Flutter приложение PR12  
**Архитектура:** Clean Architecture (Domain, Data, UI слои)  
**State Management:** MobX  
**Dependency Injection:** GetIt  
**Навигация:** GoRouter  
**Язык:** Dart 3.9.2

**Структура проекта:**
```
lib/
├── core/
│   └── di/
│       └── injection_container.dart  # DI контейнер GetIt
├── domain/
│   ├── repositories/                 # Интерфейсы репозиториев
│   └── usecases/                     # Use cases (бизнес-логика)
├── data/
│   └── repositories/                # Реализации репозиториев
└── ui/
    └── goals/
        ├── screens/
        │   └── add_goal_screen.dart   # Экран добавления цели
        └── stores/
            └── add_goal_store.dart   # MobX store для экрана
```

## Задача

Интегрировать `shared_preferences` в экран `AddGoalScreen` для сохранения черновика (draft) введенных данных:
- **Что сохранять:** название цели (`name`) и описание (`description`)
- **Когда сохранять:** автоматически при вводе текста (с debounce 400мс)
- **Когда загружать:** при открытии экрана создания новой цели
- **Когда очищать:** после успешного сохранения цели

**Важно:** Черновик работает только в режиме создания, не в режиме редактирования существующей цели.

---

## Реализация по слоям Clean Architecture

### 1. Domain Layer (Бизнес-логика)

#### 1.1. Интерфейс репозитория
**Файл:** `lib/domain/repositories/preferences_repository.dart`

```dart
abstract class PreferencesRepository {
  Future<String?> readString(String key);
  Future<void> writeString(String key, String value);
  Future<void> delete(String key);
}
```

**Назначение:** Абстракция для работы с хранилищем ключ-значение. Следует принципу Dependency Inversion - UI и Domain зависят от абстракции, а не от конкретной реализации.

#### 1.2. Use Cases
Созданы три use case по аналогии с существующими use cases проекта:

**Файл:** `lib/domain/usecases/preferences/read_pref_string.dart`
```dart
class ReadPrefString {
  final PreferencesRepository repository;
  ReadPrefString(this.repository);
  
  Future<String?> call(String key) {
    return repository.readString(key);
  }
}
```

**Файл:** `lib/domain/usecases/preferences/write_pref_string.dart`
```dart
class WritePrefString {
  final PreferencesRepository repository;
  WritePrefString(this.repository);
  
  Future<void> call(String key, String value) {
    return repository.writeString(key, value);
  }
}
```

**Файл:** `lib/domain/usecases/preferences/delete_pref_key.dart`
```dart
class DeletePrefKey {
  final PreferencesRepository repository;
  DeletePrefKey(this.repository);
  
  Future<void> call(String key) {
    return repository.delete(key);
  }
}
```

**Паттерн:** Каждый use case инкапсулирует одну бизнес-операцию. Используется паттерн "callable class" - use case вызывается как функция через `call()`.

---

### 2. Data Layer (Реализация)

#### 2.1. Реализация репозитория
**Файл:** `lib/data/repositories/preferences_repository_impl.dart`

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/preferences_repository.dart';

class PreferencesRepositoryImpl implements PreferencesRepository {
  final SharedPreferences _prefs;

  PreferencesRepositoryImpl(this._prefs);

  @override
  Future<String?> readString(String key) async {
    try {
      return _prefs.getString(key);
    } catch (e) {
      return null;  // Graceful degradation
    }
  }

  @override
  Future<void> writeString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      // Игнорируем ошибки при записи
    }
  }

  @override
  Future<void> delete(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      // Игнорируем ошибки при удалении
    }
  }
}
```

**Особенности:**
- Все методы обернуты в try-catch для graceful degradation
- Использует `SharedPreferences` из пакета `shared_preferences`
- Реализует интерфейс `PreferencesRepository` из domain слоя

---

### 3. Dependency Injection (GetIt)

**Файл:** `lib/core/di/injection_container.dart`

#### 3.1. Регистрация SharedPreferences
```dart
// Shared Preferences
final sharedPreferences = await SharedPreferences.getInstance();
getIt.registerSingleton<SharedPreferences>(sharedPreferences);
```

**Важно:** `SharedPreferences.getInstance()` - асинхронный метод, поэтому вызывается в `setupDI()` который уже был async.

#### 3.2. Регистрация репозитория
```dart
getIt.registerLazySingleton<PreferencesRepository>(
  () => PreferencesRepositoryImpl(
    getIt(),  // Получает SharedPreferences из контейнера
  ),
);
```

#### 3.3. Регистрация Use Cases
```dart
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
```

**Паттерн:** LazySingleton - экземпляры создаются при первом обращении и переиспользуются.

---

### 4. UI Layer - MobX Store

**Файл:** `lib/ui/goals/stores/add_goal_store.dart`

#### 4.1. Добавлены зависимости
```dart
final ReadPrefString _readPrefString;
final WritePrefString _writePrefString;
final DeletePrefKey _deletePrefKey;
```

#### 4.2. Константы для ключей
```dart
static const String _nameKey = 'pr12:add_goal:name';
static const String _descriptionKey = 'pr12:add_goal:description';
```

**Конвенция:** Используется неймспейс `pr12:add_goal:` для избежания конфликтов с другими ключами.

#### 4.3. Таймеры для debounce
```dart
Timer? _nameDebounceTimer;
Timer? _descriptionDebounceTimer;
```

**Назначение:** Отменяют предыдущие таймеры перед созданием новых, чтобы не сохранять на каждый символ.

#### 4.4. Метод инициализации `init()`
```dart
@action
Future<void> init() async {
  // Не загружаем черновик в режиме редактирования
  if (isEditMode) return;

  try {
    final savedName = await _readPrefString(_nameKey);
    final savedDescription = await _readPrefString(_descriptionKey);

    if (savedName != null && savedName.isNotEmpty) {
      name = savedName;
    }

    if (savedDescription != null && savedDescription.isNotEmpty) {
      description = savedDescription;
    }
  } catch (e) {
    // Игнорируем ошибки при чтении из preferences
  }
}
```

**Логика:**
- Загружает черновик только при создании новой цели (не в режиме редактирования)
- Обновляет observable поля `name` и `description`
- MobX автоматически уведомляет UI об изменениях

#### 4.5. Методы с debounce для автосохранения

**Для названия:**
```dart
@action
void setName(String value) {
  name = value;
  // Сохраняем только если не в режиме редактирования
  if (!isEditMode) {
    onNameChanged(value);
  }
}

@action
void onNameChanged(String value) {
  // Debounce сохранения в preferences
  _nameDebounceTimer?.cancel();
  _nameDebounceTimer = Timer(const Duration(milliseconds: 400), () {
    _writePrefString(_nameKey, value).catchError((_) {
      // Игнорируем ошибки при записи в preferences
    });
  });
}
```

**Для описания:**
```dart
@action
void setDescription(String? value) {
  description = value;
  // Сохраняем только если не в режиме редактирования
  if (!isEditMode) {
    onDescriptionChanged(value ?? '');
  }
}

@action
void onDescriptionChanged(String value) {
  // Debounce сохранения в preferences
  _descriptionDebounceTimer?.cancel();
  _descriptionDebounceTimer = Timer(const Duration(milliseconds: 400), () {
    _writePrefString(_descriptionKey, value).catchError((_) {
      // Игнорируем ошибки при записи в preferences
    });
  });
}
```

**Механизм debounce:**
1. При каждом изменении текста отменяется предыдущий таймер
2. Создается новый таймер на 400мс
3. Если в течение 400мс текст не меняется, выполняется сохранение
4. Это предотвращает избыточные записи в хранилище

#### 4.6. Метод очистки черновика `clearDraft()`
```dart
@action
Future<void> clearDraft() async {
  // Отменяем таймеры debounce перед очисткой
  _nameDebounceTimer?.cancel();
  _descriptionDebounceTimer?.cancel();

  try {
    await _deletePrefKey(_nameKey);
    await _deletePrefKey(_descriptionKey);
  } catch (e) {
    // Игнорируем ошибки при удалении из preferences
  }
}
```

**Вызывается:** После успешного сохранения цели в методе `save()`:
```dart
await _goalsService.saveGoal(goal: goal, subtasks: subtasks);
// Очищаем черновик после успешного сохранения
await clearDraft();
return true;
```

#### 4.7. Метод `dispose()`
```dart
void dispose() {
  _nameDebounceTimer?.cancel();
  _descriptionDebounceTimer?.cancel();
}
```

**Назначение:** Отменяет активные таймеры при уничтожении store для предотвращения утечек памяти.

---

### 5. UI Layer - Screen

**Файл:** `lib/ui/goals/screens/add_goal_screen.dart`

#### 5.1. Импорты use cases
```dart
import '../../../../domain/usecases/preferences/read_pref_string.dart';
import '../../../../domain/usecases/preferences/write_pref_string.dart';
import '../../../../domain/usecases/preferences/delete_pref_key.dart';
```

#### 5.2. Создание store с зависимостями
```dart
store = AddGoalStore(
  GetIt.I<GoalsService>(),
  GetIt.I<ReadPrefString>(),        // Новые зависимости
  GetIt.I<WritePrefString>(),       // из DI контейнера
  GetIt.I<DeletePrefKey>(),
  initialGoal: widget.initialGoal,
);
```

#### 5.3. Инициализация preferences в `initState()`
```dart
@override
void initState() {
  super.initState();
  // ... создание store ...
  
  // Создаем контроллеры с начальными значениями
  nameController = TextEditingController(text: store.name);
  descriptionController = TextEditingController(text: store.description ?? '');
  
  // Загружаем черновик из preferences после создания контроллеров
  _initPreferences();
}

Future<void> _initPreferences() async {
  await store.init();  // Загружает черновик из SharedPreferences
  // Обновляем контроллеры после загрузки из preferences
  if (mounted) {
    nameController.text = store.name;
    descriptionController.text = store.description ?? '';
  }
}
```

**Последовательность:**
1. Создается store с зависимостями из DI
2. Создаются TextEditingController с начальными значениями
3. Асинхронно вызывается `store.init()` для загрузки черновика
4. После загрузки обновляются контроллеры

#### 5.4. Очистка ресурсов в `dispose()`
```dart
@override
void dispose() {
  // ... dispose контроллеров ...
  store.dispose();  // Отменяет таймеры debounce
  super.dispose();
}
```

---

## Поток данных

### Сценарий 1: Открытие экрана создания цели

```
1. User открывает AddGoalScreen
   ↓
2. initState() создает store с use cases из DI
   ↓
3. _initPreferences() вызывает store.init()
   ↓
4. store.init() вызывает ReadPrefString для каждого ключа
   ↓
5. ReadPrefString → PreferencesRepository → SharedPreferences
   ↓
6. Загруженные значения устанавливаются в observable поля
   ↓
7. MobX уведомляет UI, контроллеры обновляются
```

### Сценарий 2: Ввод текста в поле

```
1. User вводит символ в TextField
   ↓
2. onChanged вызывает store.setName(value)
   ↓
3. setName обновляет observable name и вызывает onNameChanged
   ↓
4. onNameChanged отменяет предыдущий таймер и создает новый (400мс)
   ↓
5. Если в течение 400мс нет новых изменений:
   ↓
6. Таймер срабатывает → WritePrefString → PreferencesRepository → SharedPreferences
```

### Сценарий 3: Успешное сохранение цели

```
1. User нажимает "Сохранить"
   ↓
2. store.save() сохраняет цель через GoalsService
   ↓
3. После успешного сохранения вызывается store.clearDraft()
   ↓
4. clearDraft() отменяет таймеры и удаляет ключи через DeletePrefKey
   ↓
5. DeletePrefKey → PreferencesRepository → SharedPreferences.remove()
```

---

## Ключевые архитектурные решения

### 1. Разделение ответственности
- **Domain:** Абстракции и бизнес-логика (интерфейсы, use cases)
- **Data:** Конкретные реализации (SharedPreferences)
- **UI:** Только отображение и взаимодействие с пользователем

### 2. Dependency Inversion
- UI и Domain зависят от абстракций (`PreferencesRepository`), а не от конкретной реализации
- Легко заменить SharedPreferences на другое хранилище без изменения Domain и UI

### 3. Single Responsibility
- Каждый use case отвечает за одну операцию
- Store отвечает только за состояние экрана и координацию use cases

### 4. Debounce паттерн
- Предотвращает избыточные записи в хранилище
- Улучшает производительность при быстром вводе текста

### 5. Graceful Degradation
- Все операции обернуты в try-catch
- Ошибки не ломают работу приложения
- При ошибках чтения просто не загружается черновик

### 6. Режим редактирования
- Черновик работает только при создании новой цели
- При редактировании существующей цели черновик не сохраняется и не загружается
- Проверка через `isEditMode` (computed property на основе `_initialGoal != null`)

---

## Файлы проекта

### Созданные файлы:
1. `lib/domain/repositories/preferences_repository.dart`
2. `lib/domain/usecases/preferences/read_pref_string.dart`
3. `lib/domain/usecases/preferences/write_pref_string.dart`
4. `lib/domain/usecases/preferences/delete_pref_key.dart`
5. `lib/data/repositories/preferences_repository_impl.dart`

### Измененные файлы:
1. `pubspec.yaml` - добавлена зависимость `shared_preferences: ^2.3.2`
2. `lib/core/di/injection_container.dart` - регистрация всех зависимостей
3. `lib/ui/goals/stores/add_goal_store.dart` - интеграция preferences с debounce
4. `lib/ui/goals/screens/add_goal_screen.dart` - вызовы init и dispose

---

## Технические детали

### Debounce реализация
- Используется `Timer` из `dart:async`
- Задержка: 400 миллисекунд
- При каждом новом изменении предыдущий таймер отменяется через `cancel()`

### Ключи хранения
- Формат: `pr12:add_goal:{field_name}`
- Примеры:
  - `pr12:add_goal:name`
  - `pr12:add_goal:description`
- Неймспейс предотвращает конфликты с другими ключами

### MobX аннотации
- `@observable` - для полей, изменения которых должны отслеживаться
- `@action` - для методов, изменяющих состояние
- `@computed` - для вычисляемых свойств (например, `isEditMode`)

### Асинхронность
- `init()` - async метод для загрузки черновика
- `clearDraft()` - async метод для очистки
- Все операции с SharedPreferences асинхронные

---

## Результат

После реализации:
1. ✅ При открытии экрана создания цели автоматически загружается черновик
2. ✅ При вводе текста значения сохраняются автоматически с debounce 400мс
3. ✅ После успешного сохранения черновик автоматически очищается
4. ✅ Архитектура не нарушена - все по Clean Architecture
5. ✅ Код легко тестировать благодаря разделению слоев
6. ✅ Легко расширить на другие экраны по аналогии

