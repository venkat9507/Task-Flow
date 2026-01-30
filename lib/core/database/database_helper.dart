import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../constants/app_constants.dart';

/// Database helper class - singleton for SQLite operations
class DatabaseHelper {
  static DatabaseHelper? _instance;
  static Database? _database;

  DatabaseHelper._internal();

  /// Get singleton instance
  factory DatabaseHelper() {
    _instance ??= DatabaseHelper._internal();
    return _instance!;
  }

  /// Get database instance
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// Initialize the database
  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);

    return await openDatabase(
      path,
      version: AppConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  /// Create tables
  Future<void> _onCreate(Database db, int version) async {
    // Create categories table
    await db.execute('''
      CREATE TABLE ${AppConstants.categoriesTable} (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        color INTEGER NOT NULL,
        icon TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Create tasks table
    await db.execute('''
      CREATE TABLE ${AppConstants.tasksTable} (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        description TEXT,
        is_completed INTEGER DEFAULT 0,
        priority INTEGER DEFAULT 0,
        category_id TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        due_date TEXT,
        FOREIGN KEY (category_id) REFERENCES ${AppConstants.categoriesTable}(id) ON DELETE SET NULL
      )
    ''');

    // Create indexes for better query performance
    await db.execute('''
      CREATE INDEX idx_tasks_category_id ON ${AppConstants.tasksTable}(category_id)
    ''');

    await db.execute('''
      CREATE INDEX idx_tasks_is_completed ON ${AppConstants.tasksTable}(is_completed)
    ''');

    await db.execute('''
      CREATE INDEX idx_tasks_priority ON ${AppConstants.tasksTable}(priority)
    ''');

    await db.execute('''
      CREATE INDEX idx_tasks_due_date ON ${AppConstants.tasksTable}(due_date)
    ''');

    // Insert default categories
    await insertDefaultCategories(db);
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle migrations here when needed
    // Example:
    // if (oldVersion < 2) {
    //   await db.execute('ALTER TABLE tasks ADD COLUMN new_field TEXT');
    // }
  }

  /// Insert default categories
  Future<void> insertDefaultCategories(Database db) async {
    final now = DateTime.now().toIso8601String();

    final defaultCategories = [
      {
        'id': 'cat_personal',
        'name': 'Personal',
        'color': 0xFF5C6BC0, // Indigo
        'icon': 'user',
        'created_at': now,
      },
      {
        'id': 'cat_work',
        'name': 'Work',
        'color': 0xFFFF7043, // Deep Orange
        'icon': 'briefcase',
        'created_at': now,
      },
      {
        'id': 'cat_shopping',
        'name': 'Shopping',
        'color': 0xFF66BB6A, // Green
        'icon': 'shopping-cart',
        'created_at': now,
      },
      {
        'id': 'cat_health',
        'name': 'Health',
        'color': 0xFFEF5350, // Red
        'icon': 'heart',
        'created_at': now,
      },
    ];

    for (final category in defaultCategories) {
      await db.insert(AppConstants.categoriesTable, category);
    }
  }

  /// Close the database
  Future<void> close() async {
    final db = await database;
    await db.close();
    _database = null;
  }

  /// Delete the database (for testing or reset)
  Future<void> deleteDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.databaseName);
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }

  /// Get task count for a category
  Future<int> getTaskCountForCategory(String categoryId) async {
    final db = await database;
    final result = await db.rawQuery(
      '''
      SELECT COUNT(*) as count 
      FROM ${AppConstants.tasksTable} 
      WHERE category_id = ?
    ''',
      [categoryId],
    );

    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Get statistics
  Future<Map<String, int>> getStatistics() async {
    final db = await database;

    final totalTasks =
        Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM ${AppConstants.tasksTable}'),
        ) ??
        0;

    final completedTasks =
        Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM ${AppConstants.tasksTable} WHERE is_completed = 1',
          ),
        ) ??
        0;

    final pendingTasks = totalTasks - completedTasks;

    final overdueTasks =
        Sqflite.firstIntValue(
          await db.rawQuery(
            '''
      SELECT COUNT(*) FROM ${AppConstants.tasksTable} 
      WHERE is_completed = 0 
      AND due_date IS NOT NULL 
      AND due_date < ?
    ''',
            [DateTime.now().toIso8601String().substring(0, 10)],
          ),
        ) ??
        0;

    return {
      'total': totalTasks,
      'completed': completedTasks,
      'pending': pendingTasks,
      'overdue': overdueTasks,
    };
  }
}
