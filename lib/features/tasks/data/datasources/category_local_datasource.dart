import '../../../../core/database/database_helper.dart';
import '../models/category_model.dart';

abstract class CategoryLocalDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel?> getCategoryById(int id);
  Future<CategoryModel?> getCategoryByName(String name);
  Future<int> addCategory(CategoryModel category);
  Future<int> updateCategory(CategoryModel category);
  Future<int> deleteCategory(String name);
  Future<List<CategoryModel>> getCustomCategories();
  Future<List<Map<String, dynamic>>> getCategoryUsage();
  Future<void> resetCategoriesToDefault();
}

class CategoryLocalDataSourceImpl implements CategoryLocalDataSource {
  final DatabaseHelper databaseHelper;

  CategoryLocalDataSourceImpl(this.databaseHelper);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.categoriesTableName,
      orderBy: 'isCustom ASC, name ASC',
    );

    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  @override
  Future<CategoryModel?> getCategoryById(int id) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DatabaseHelper.categoriesTableName,
      where: 'id = ?',
      whereArgs: [id],
    );

    return result.isNotEmpty ? CategoryModel.fromMap(result.first) : null;
  }

  @override
  Future<CategoryModel?> getCategoryByName(String name) async {
    final db = await databaseHelper.database;
    final result = await db.query(
      DatabaseHelper.categoriesTableName,
      where: 'name = ?',
      whereArgs: [name],
    );

    return result.isNotEmpty ? CategoryModel.fromMap(result.first) : null;
  }

  @override
  Future<int> addCategory(CategoryModel category) async {
    final db = await databaseHelper.database;

    // Check if category already exists
    final existing = await getCategoryByName(category.name);
    if (existing != null) {
      throw Exception('Category with name "${category.name}" already exists');
    }

    return await db.insert(
      DatabaseHelper.categoriesTableName,
      category.toMap(),
    );
  }

  @override
  Future<int> updateCategory(CategoryModel category) async {
    final db = await databaseHelper.database;

    if (category.id == null) {
      throw Exception('Category ID is required for update');
    }

    // Get current category
    final currentCategory = await getCategoryById(category.id!);
    if (currentCategory == null) {
      throw Exception('Category not found');
    }

    // Don't allow updating default categories' names
    if (!currentCategory.isCustom && category.name != currentCategory.name) {
      throw Exception('Cannot modify default category names');
    }

    // Check for name conflicts if updating name
    if (category.name != currentCategory.name) {
      final existing = await getCategoryByName(category.name);
      if (existing != null) {
        throw Exception('Category with name "${category.name}" already exists');
      }
    }

    final updateData = category.toMap();
    updateData['updatedAt'] = DateTime.now().toIso8601String();

    return await db.update(
      DatabaseHelper.categoriesTableName,
      updateData,
      where: 'id = ?',
      whereArgs: [category.id],
    );
  }

  @override
  Future<int> deleteCategory(String name) async {
    final db = await databaseHelper.database;

    // Check if category exists and is custom
    final category = await getCategoryByName(name);
    if (category == null) {
      throw Exception('Category not found');
    }

    if (!category.isCustom) {
      throw Exception('Cannot delete default categories');
    }

    // Check if category is being used by any tasks
    final tasksUsingCategory = await db.query(
      DatabaseHelper.tasksTableName,
      where: 'category = ?',
      whereArgs: [category.name],
      limit: 1,
    );

    if (tasksUsingCategory.isNotEmpty) {
      throw Exception('Cannot delete category that is being used by tasks');
    }

    return await db.delete(
      DatabaseHelper.categoriesTableName,
      where: 'name = ? AND isCustom = 1',
      whereArgs: [name],
    );
  }

  @override
  Future<List<CategoryModel>> getCustomCategories() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      DatabaseHelper.categoriesTableName,
      where: 'isCustom = 1',
      orderBy: 'name ASC',
    );

    return List.generate(maps.length, (i) => CategoryModel.fromMap(maps[i]));
  }

  @override
  Future<List<Map<String, dynamic>>> getCategoryUsage() async {
    final db = await databaseHelper.database;
    return await db.rawQuery('''
      SELECT
        c.id,
        c.name,
        c.iconCodePoint,
        c.colorValue,
        c.isCustom,
        COUNT(t.id) as taskCount
      FROM ${DatabaseHelper.categoriesTableName} c
      LEFT JOIN ${DatabaseHelper.tasksTableName} t ON c.name = t.category
      GROUP BY c.id, c.name, c.iconCodePoint, c.colorValue, c.isCustom
      ORDER BY c.isCustom ASC, c.name ASC
    ''');
  }

  @override
  Future<void> resetCategoriesToDefault() async {
    final db = await databaseHelper.database;

    // Delete all custom categories
    await db.delete(
      DatabaseHelper.categoriesTableName,
      where: 'isCustom = 1',
    );

    // Update any tasks using deleted categories to use default category
    await db.update(
      DatabaseHelper.tasksTableName,
      {'category': 'Grocery'}, // Default fallback category
      where: 'category NOT IN (SELECT name FROM ${DatabaseHelper.categoriesTableName})',
    );
  }
}
