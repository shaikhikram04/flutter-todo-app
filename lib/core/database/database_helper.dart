import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;
  static const String tasksTableName = 'tasks';
  static const String categoriesTableName = 'categories';
  static const int _databaseVersion = 2;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _createDatabase,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tasksTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        category TEXT NOT NULL,
        priority INTEGER NOT NULL,
        date TEXT NOT NULL,
        isCompleted INTEGER NOT NULL DEFAULT 0,
        createdAt TEXT NOT NULL
      )
    ''');

    // Create categories table
    await db.execute('''
      CREATE TABLE $categoriesTableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL UNIQUE,
        iconCodePoint INTEGER NOT NULL,
        colorValue INTEGER NOT NULL,
        isCustom INTEGER NOT NULL DEFAULT 1,
        createdAt TEXT NOT NULL,
        updatedAt TEXT NOT NULL
      )
    ''');

    // Insert default categories
    await _insertDefaultCategories(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Create categories table for existing databases
      await db.execute('''
        CREATE TABLE $categoriesTableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL UNIQUE,
          iconCodePoint INTEGER NOT NULL,
          colorValue INTEGER NOT NULL,
          isCustom INTEGER NOT NULL DEFAULT 1,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');

      // Insert default categories
      await _insertDefaultCategories(db);
    }
  }

  Future<void> _insertDefaultCategories(Database db) async {
    final defaultCategories = [
      {
        'name': 'Grocery',
        'iconCodePoint': Icons.shopping_cart.codePoint,
        'colorValue': const Color(0xFF66BB6A).value,
        'isCustom': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Work',
        'iconCodePoint': Icons.work.codePoint,
        'colorValue': const Color(0xFFEF5350).value,
        'isCustom': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Sport',
        'iconCodePoint': Icons.fitness_center.codePoint,
        'colorValue': const Color(0xFF42A5F5).value,
        'isCustom': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Home',
        'iconCodePoint': Icons.home.codePoint,
        'colorValue': const Color(0xFFE57373).value,
        'isCustom': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'University',
        'iconCodePoint': Icons.school.codePoint,
        'colorValue': const Color(0xFF8875FF).value,
        'isCustom': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Social',
        'iconCodePoint': Icons.people.codePoint,
        'colorValue': const Color(0xFFAB47BC).value,
        'isCustom': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Music',
        'iconCodePoint': Icons.music_note.codePoint,
        'colorValue': const Color(0xFFBA68C8).value,
        'isCustom': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Health',
        'iconCodePoint': Icons.favorite.codePoint,
        'colorValue': const Color(0xFF4CAF50).value,
        'isCustom': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
      {
        'name': 'Movie',
        'iconCodePoint': Icons.movie.codePoint,
        'colorValue': const Color(0xFF29B6F6).value,
        'isCustom': 0,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      },
    ];

    for (final category in defaultCategories) {
      await db.insert(
        categoriesTableName,
        category,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }

  // ============ CATEGORY METHODS ============

  /// Get all categories from database
  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query(
      categoriesTableName,
      orderBy: 'isCustom ASC, name ASC', // Default categories first, then alphabetical
    );
  }

  /// Get a specific category by ID
  Future<Map<String, dynamic>?> getCategoryById(int id) async {
    final db = await database;
    final result = await db.query(
      categoriesTableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Get a specific category by name
  Future<Map<String, dynamic>?> getCategoryByName(String name) async {
    final db = await database;
    final result = await db.query(
      categoriesTableName,
      where: 'name = ?',
      whereArgs: [name],
    );
    return result.isNotEmpty ? result.first : null;
  }

  /// Add a new custom category
  Future<int> insertCategory({
    required String name,
    required int iconCodePoint,
    required int colorValue,
    bool isCustom = true,
  }) async {
    final db = await database;

    // Check if category already exists
    final existing = await getCategoryByName(name);
    if (existing != null) {
      throw Exception('Category with name "$name" already exists');
    }

    final now = DateTime.now().toIso8601String();

    return await db.insert(
      categoriesTableName,
      {
        'name': name,
        'iconCodePoint': iconCodePoint,
        'colorValue': colorValue,
        'isCustom': isCustom ? 1 : 0,
        'createdAt': now,
        'updatedAt': now,
      },
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  /// Update an existing category
  Future<int> updateCategory({
    required int id,
    String? name,
    int? iconCodePoint,
    int? colorValue,
  }) async {
    final db = await database;

    // Get current category
    final currentCategory = await getCategoryById(id);
    if (currentCategory == null) {
      throw Exception('Category not found');
    }

    // Don't allow updating default categories' names
    if (currentCategory['isCustom'] == 0 && name != null) {
      throw Exception('Cannot modify default category names');
    }

    // Check for name conflicts if updating name
    if (name != null && name != currentCategory['name']) {
      final existing = await getCategoryByName(name);
      if (existing != null) {
        throw Exception('Category with name "$name" already exists');
      }
    }

    final updateData = <String, dynamic>{
      'updatedAt': DateTime.now().toIso8601String(),
    };

    if (name != null) updateData['name'] = name;
    if (iconCodePoint != null) updateData['iconCodePoint'] = iconCodePoint;
    if (colorValue != null) updateData['colorValue'] = colorValue;

    return await db.update(
      categoriesTableName,
      updateData,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete a category (only custom categories can be deleted)
  Future<int> deleteCategory(String name) async {
    final db = await database;

    // Check if category exists and is custom
    final category = await getCategoryByName(name);
    if (category == null) {
      throw Exception('Category not found');
    }

    if (category['isCustom'] == 0) {
      throw Exception('Cannot delete default categories');
    }

    // Check if category is being used by any tasks
    final tasksUsingCategory = await db.query(
      tasksTableName,
      where: 'category = ?',
      whereArgs: [category['name']],
      limit: 1,
    );

    if (tasksUsingCategory.isNotEmpty) {
      throw Exception('Cannot delete category that is being used by tasks');
    }

    return await db.delete(
      categoriesTableName,
      where: 'name = ? AND isCustom = 1',
      whereArgs: [name],
    );
  }

  /// Get only custom categories
  Future<List<Map<String, dynamic>>> getCustomCategories() async {
    final db = await database;
    return await db.query(
      categoriesTableName,
      where: 'isCustom = 1',
      orderBy: 'name ASC',
    );
  }

  /// Get category usage count (how many tasks use each category)
  Future<List<Map<String, dynamic>>> getCategoryUsage() async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        c.id,
        c.name,
        c.iconCodePoint,
        c.colorValue,
        c.isCustom,
        COUNT(t.id) as taskCount
      FROM $categoriesTableName c
      LEFT JOIN $tasksTableName t ON c.name = t.category
      GROUP BY c.id, c.name, c.iconCodePoint, c.colorValue, c.isCustom
      ORDER BY c.isCustom ASC, c.name ASC
    ''');
  }

  /// Reset categories to default (removes all custom categories)
  Future<void> resetCategoriesToDefault() async {
    final db = await database;

    // Delete all custom categories
    await db.delete(
      categoriesTableName,
      where: 'isCustom = 1',
    );

    // Update any tasks using deleted categories to use default category
    await db.update(
      tasksTableName,
      {'category': 'Grocery'}, // Default fallback category
      where: 'category NOT IN (SELECT name FROM $categoriesTableName)',
    );
  }

  // ============ UTILITY METHODS ============

  /// Check if database has been initialized with categories
  Future<bool> hasCategoriesTable() async {
    final db = await database;
    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table' AND name='$categoriesTableName'",
    );
    return result.isNotEmpty;
  }

  /// Get database statistics
  Future<Map<String, int>> getDatabaseStats() async {
    final db = await database;

    final taskCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $tasksTableName'),
        ) ??
        0;

    final categoryCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $categoriesTableName'),
        ) ??
        0;

    final customCategoryCount = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM $categoriesTableName WHERE isCustom = 1'),
        ) ??
        0;

    return {
      'totalTasks': taskCount,
      'totalCategories': categoryCount,
      'customCategories': customCategoryCount,
    };
  }

  /// Close database connection
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }

  /// Delete entire database (for testing or reset purposes)
  Future<void> deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'tasks.db');
    await databaseFactory.deleteDatabase(path);
    _database = null;
  }
}
