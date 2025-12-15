import '../domain/entities/transaction.dart';

final List<Transaction> demoTransactions = [
  // ================= ТЕКУЩИЙ МЕСЯЦ (0–29 дней назад) =================

  // --- Доходы ---
  Transaction(
    id: '1',
    type: TransactionType.income,
    category: 'Зарплата',
    amount: 52000,
    note: 'Основная работа',
    date: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Transaction(
    id: '2',
    type: TransactionType.income,
    category: 'Фриланс',
    amount: 18000,
    note: 'Проект по дизайну сайта',
    date: DateTime.now().subtract(const Duration(days: 7)),
  ),
  Transaction(
    id: '3',
    type: TransactionType.income,
    category: 'Кэшбэк',
    amount: 1200,
    note: 'Кэшбэк от банка',
    date: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Transaction(
    id: '4',
    type: TransactionType.income,
    category: 'Подарок',
    amount: 5000,
    note: 'День рождения 🎉',
    date: DateTime.now().subtract(const Duration(days: 12)),
  ),

  // --- Расходы ---
  Transaction(
    id: '5',
    type: TransactionType.expense,
    category: 'Еда',
    amount: 3200,
    note: 'Продукты на неделю',
    date: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Transaction(
    id: '6',
    type: TransactionType.expense,
    category: 'Еда',
    amount: 850,
    note: 'Кафе с друзьями',
    date: DateTime.now().subtract(const Duration(days: 4)),
  ),
  Transaction(
    id: '7',
    type: TransactionType.expense,
    category: 'Развлечения',
    amount: 2600,
    note: 'Кино, кофе, настолки',
    date: DateTime.now().subtract(const Duration(days: 6)),
  ),
  Transaction(
    id: '8',
    type: TransactionType.expense,
    category: 'Здоровье',
    amount: 2300,
    note: 'Аптека и витамины',
    date: DateTime.now().subtract(const Duration(days: 8)),
  ),
  Transaction(
    id: '9',
    type: TransactionType.expense,
    category: 'Транспорт',
    amount: 900,
    note: 'Такси и метро',
    date: DateTime.now().subtract(const Duration(days: 9)),
  ),
  Transaction(
    id: '10',
    type: TransactionType.expense,
    category: 'Подписки',
    amount: 799,
    note: 'Музыка и фильмы',
    date: DateTime.now().subtract(const Duration(days: 11)),
  ),

  // ================= МЕСЯЦ -1 (30–59 дней назад) =================

  // --- Доходы ---
  Transaction(
    id: '11',
    type: TransactionType.income,
    category: 'Зарплата',
    amount: 51000,
    note: 'Основная работа',
    date: DateTime.now().subtract(const Duration(days: 33)),
  ),
  Transaction(
    id: '12',
    type: TransactionType.income,
    category: 'Фриланс',
    amount: 15000,
    note: 'Верстка лендинга',
    date: DateTime.now().subtract(const Duration(days: 38)),
  ),
  Transaction(
    id: '13',
    type: TransactionType.income,
    category: 'Кэшбэк',
    amount: 900,
    note: 'Кэшбэк за покупки',
    date: DateTime.now().subtract(const Duration(days: 36)),
  ),

  // --- Расходы ---
  Transaction(
    id: '14',
    type: TransactionType.expense,
    category: 'Еда',
    amount: 3100,
    note: 'Продукты в супермаркете',
    date: DateTime.now().subtract(const Duration(days: 31)),
  ),
  Transaction(
    id: '15',
    type: TransactionType.expense,
    category: 'Коммуналка',
    amount: 4200,
    note: 'Свет, вода, отопление',
    date: DateTime.now().subtract(const Duration(days: 34)),
  ),
  Transaction(
    id: '16',
    type: TransactionType.expense,
    category: 'Интернет',
    amount: 700,
    note: 'Домашний интернет',
    date: DateTime.now().subtract(const Duration(days: 35)),
  ),
  Transaction(
    id: '17',
    type: TransactionType.expense,
    category: 'Развлечения',
    amount: 1900,
    note: 'Бар с друзьями',
    date: DateTime.now().subtract(const Duration(days: 37)),
  ),
  Transaction(
    id: '18',
    type: TransactionType.expense,
    category: 'Транспорт',
    amount: 1200,
    note: 'Пополнение транспортной карты',
    date: DateTime.now().subtract(const Duration(days: 39)),
  ),
  Transaction(
    id: '19',
    type: TransactionType.expense,
    category: 'Одежда',
    amount: 3500,
    note: 'Кеды и футболка',
    date: DateTime.now().subtract(const Duration(days: 42)),
  ),

  // ================= МЕСЯЦ -2 (60–89 дней назад) =================

  // --- Доходы ---
  Transaction(
    id: '20',
    type: TransactionType.income,
    category: 'Зарплата',
    amount: 50500,
    note: 'Основная работа',
    date: DateTime.now().subtract(const Duration(days: 63)),
  ),
  Transaction(
    id: '21',
    type: TransactionType.income,
    category: 'Фриланс',
    amount: 22000,
    note: 'Мобильное приложение (дизайн)',
    date: DateTime.now().subtract(const Duration(days: 68)),
  ),
  Transaction(
    id: '22',
    type: TransactionType.income,
    category: 'Подарок',
    amount: 3000,
    note: 'Подарок от родственников',
    date: DateTime.now().subtract(const Duration(days: 70)),
  ),

  // --- Расходы ---
  Transaction(
    id: '23',
    type: TransactionType.expense,
    category: 'Еда',
    amount: 2950,
    note: 'Продукты на неделю',
    date: DateTime.now().subtract(const Duration(days: 61)),
  ),
  Transaction(
    id: '24',
    type: TransactionType.expense,
    category: 'Образование',
    amount: 4500,
    note: 'Онлайн-курс по дизайну',
    date: DateTime.now().subtract(const Duration(days: 66)),
  ),
  Transaction(
    id: '25',
    type: TransactionType.expense,
    category: 'Развлечения',
    amount: 2100,
    note: 'Кино и ужин',
    date: DateTime.now().subtract(const Duration(days: 69)),
  ),
  Transaction(
    id: '26',
    type: TransactionType.expense,
    category: 'Здоровье',
    amount: 1800,
    note: 'Стоматология',
    date: DateTime.now().subtract(const Duration(days: 72)),
  ),
  Transaction(
    id: '27',
    type: TransactionType.expense,
    category: 'Транспорт',
    amount: 950,
    note: 'Такси до офиса',
    date: DateTime.now().subtract(const Duration(days: 73)),
  ),
  Transaction(
    id: '28',
    type: TransactionType.expense,
    category: 'Подписки',
    amount: 899,
    note: 'Стриминговый сервис',
    date: DateTime.now().subtract(const Duration(days: 75)),
  ),

  // ================= МЕСЯЦ -3 (90–119 дней назад) =================

  // --- Доходы ---
  Transaction(
    id: '29',
    type: TransactionType.income,
    category: 'Зарплата',
    amount: 50000,
    note: 'Основная работа',
    date: DateTime.now().subtract(const Duration(days: 94)),
  ),
  Transaction(
    id: '30',
    type: TransactionType.income,
    category: 'Фриланс',
    amount: 16000,
    note: 'Редизайн интернет-магазина',
    date: DateTime.now().subtract(const Duration(days: 98)),
  ),
  Transaction(
    id: '31',
    type: TransactionType.income,
    category: 'Кэшбэк',
    amount: 1100,
    note: 'Кэшбэк за оплату ЖКУ',
    date: DateTime.now().subtract(const Duration(days: 96)),
  ),

  // --- Расходы ---
  Transaction(
    id: '32',
    type: TransactionType.expense,
    category: 'Еда',
    amount: 3050,
    note: 'Продукты',
    date: DateTime.now().subtract(const Duration(days: 91)),
  ),
  Transaction(
    id: '33',
    type: TransactionType.expense,
    category: 'Коммуналка',
    amount: 4100,
    note: 'Оплата квартплаты',
    date: DateTime.now().subtract(const Duration(days: 93)),
  ),
  Transaction(
    id: '34',
    type: TransactionType.expense,
    category: 'Интернет',
    amount: 700,
    note: 'Домашний интернет',
    date: DateTime.now().subtract(const Duration(days: 95)),
  ),
  Transaction(
    id: '35',
    type: TransactionType.expense,
    category: 'Путешествия',
    amount: 12000,
    note: 'Поездка на выходные',
    date: DateTime.now().subtract(const Duration(days: 99)),
  ),
  Transaction(
    id: '36',
    type: TransactionType.expense,
    category: 'Одежда',
    amount: 3900,
    note: 'Джинсы и рубашка',
    date: DateTime.now().subtract(const Duration(days: 101)),
  ),
  Transaction(
    id: '37',
    type: TransactionType.expense,
    category: 'Развлечения',
    amount: 1700,
    note: 'Настольные игры',
    date: DateTime.now().subtract(const Duration(days: 103)),
  ),

  // ================= МЕСЯЦ -4 (120–149 дней назад) =================

  // --- Доходы ---
  Transaction(
    id: '38',
    type: TransactionType.income,
    category: 'Зарплата',
    amount: 49500,
    note: 'Основная работа',
    date: DateTime.now().subtract(const Duration(days: 123)),
  ),
  Transaction(
    id: '39',
    type: TransactionType.income,
    category: 'Фриланс',
    amount: 19000,
    note: 'Логотип и фирстиль',
    date: DateTime.now().subtract(const Duration(days: 128)),
  ),

  // --- Расходы ---
  Transaction(
    id: '40',
    type: TransactionType.expense,
    category: 'Еда',
    amount: 3000,
    note: 'Продукты',
    date: DateTime.now().subtract(const Duration(days: 121)),
  ),
  Transaction(
    id: '41',
    type: TransactionType.expense,
    category: 'Дом',
    amount: 5200,
    note: 'Мелкий ремонт дома',
    date: DateTime.now().subtract(const Duration(days: 125)),
  ),
  Transaction(
    id: '42',
    type: TransactionType.expense,
    category: 'Здоровье',
    amount: 2600,
    note: 'Массаж',
    date: DateTime.now().subtract(const Duration(days: 127)),
  ),
  Transaction(
    id: '43',
    type: TransactionType.expense,
    category: 'Транспорт',
    amount: 1100,
    note: 'Такси',
    date: DateTime.now().subtract(const Duration(days: 129)),
  ),
  Transaction(
    id: '44',
    type: TransactionType.expense,
    category: 'Подписки',
    amount: 799,
    note: 'Музыка и фильмы',
    date: DateTime.now().subtract(const Duration(days: 130)),
  ),

  // ================= МЕСЯЦ -5 (150–179 дней назад) =================

  // --- Доходы ---
  Transaction(
    id: '45',
    type: TransactionType.income,
    category: 'Зарплата',
    amount: 49000,
    note: 'Основная работа',
    date: DateTime.now().subtract(const Duration(days: 154)),
  ),
  Transaction(
    id: '46',
    type: TransactionType.income,
    category: 'Фриланс',
    amount: 17000,
    note: 'UI для мобильного приложения',
    date: DateTime.now().subtract(const Duration(days: 159)),
  ),

  // --- Расходы ---
  Transaction(
    id: '47',
    type: TransactionType.expense,
    category: 'Еда',
    amount: 2800,
    note: 'Продукты',
    date: DateTime.now().subtract(const Duration(days: 151)),
  ),
  Transaction(
    id: '48',
    type: TransactionType.expense,
    category: 'Образование',
    amount: 6000,
    note: 'Курс по английскому',
    date: DateTime.now().subtract(const Duration(days: 160)),
  ),
  Transaction(
    id: '49',
    type: TransactionType.expense,
    category: 'Развлечения',
    amount: 2000,
    note: 'Концерт',
    date: DateTime.now().subtract(const Duration(days: 162)),
  ),
  Transaction(
    id: '50',
    type: TransactionType.expense,
    category: 'Коммуналка',
    amount: 4050,
    note: 'Квартира',
    date: DateTime.now().subtract(const Duration(days: 156)),
  ),
];
