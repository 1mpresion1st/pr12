import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AppDatabase {
  static const String _databaseName = 'pr12.db';
  static const int _databaseVersion = 1;
  static const String _filtersTable = 'attachment_gallery_filters';

  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    // On Web, sqflite doesn't work, so we'll use fallback
    if (kIsWeb) {
      throw UnsupportedError('SQLite is not supported on Web. Use fallback repository.');
    }

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_filtersTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_filter TEXT,
        type_filter TEXT,
        from_date INTEGER,
        to_date INTEGER,
        updated_at INTEGER NOT NULL
      )
    ''');
  }

  // Filters methods
  static Future<Map<String, dynamic>?> getFilters() async {
    final db = await database;
    final result = await db.query(
      _filtersTable,
      orderBy: 'updated_at DESC',
      limit: 1,
    );
    if (result.isEmpty) return null;
    return result.first;
  }

  static Future<void> saveFilters(Map<String, dynamic> filters) async {
    final db = await database;
    // Delete existing filters (we only keep one record)
    await db.delete(_filtersTable);
    // Insert new filters
    await db.insert(_filtersTable, filters);
  }

  static Future<void> clearFilters() async {
    final db = await database;
    await db.delete(_filtersTable);
  }

  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

