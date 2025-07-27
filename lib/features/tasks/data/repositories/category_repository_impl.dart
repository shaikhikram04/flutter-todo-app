import '../../domain/entities/category.dart';
import '../datasources/category_local_datasource.dart';
import '../models/category_model.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<Category?> getCategoryById(int id);
  Future<Category?> getCategoryByName(String name);
  Future<int> addCategory(Category category);
  Future<int> updateCategory(Category category);
  Future<int> deleteCategory(String name);
  Future<List<Category>> getCustomCategories();
  Future<List<Map<String, dynamic>>> getCategoryUsage();
  Future<void> resetCategoriesToDefault();
}

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryLocalDataSource localDataSource;

  CategoryRepositoryImpl(this.localDataSource);

  @override
  Future<List<Category>> getCategories() async {
    return await localDataSource.getCategories();
  }

  @override
  Future<Category?> getCategoryById(int id) async {
    return await localDataSource.getCategoryById(id);
  }

  @override
  Future<Category?> getCategoryByName(String name) async {
    return await localDataSource.getCategoryByName(name);
  }

  @override
  Future<int> addCategory(Category category) async {
    final categoryModel = CategoryModel.fromEntity(category);
    return await localDataSource.addCategory(categoryModel);
  }

  @override
  Future<int> updateCategory(Category category) async {
    final categoryModel = CategoryModel.fromEntity(category);
    return await localDataSource.updateCategory(categoryModel);
  }

  @override
  Future<int> deleteCategory(String name) async {
    return await localDataSource.deleteCategory(name);
  }

  @override
  Future<List<Category>> getCustomCategories() async {
    return await localDataSource.getCustomCategories();
  }

  @override
  Future<List<Map<String, dynamic>>> getCategoryUsage() async {
    return await localDataSource.getCategoryUsage();
  }

  @override
  Future<void> resetCategoriesToDefault() async {
    return await localDataSource.resetCategoriesToDefault();
  }
}
