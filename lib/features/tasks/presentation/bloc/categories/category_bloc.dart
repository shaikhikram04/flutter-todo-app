import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:up_todo/features/tasks/data/repositories/category_repository_impl.dart';

import '../../../../../core/utils/constants.dart';
import '../../../domain/entities/category.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;
  List<Category> _categories = [];

  CategoryBloc(this._categoryRepository) : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<UpdateCategory>(_onUpdateCategory);
    on<ResetCategories>(_onResetCategories);
    on<LoadCustomCategories>(_onLoadCustomCategories);
    on<LoadCategoryUsage>(_onLoadCategoryUsage);
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());

      // Load all categories from repository
      _categories = await _categoryRepository.getCategories();

      // Convert to CategoryItem for backwards compatibility with UI
      final categoryItems = _categories
          .map((category) => CategoryItem(
                name: category.name,
                icon: category.icon,
                color: category.color,
              ))
          .toList();

      emit(CategoryLoaded(categoryItems));
    } catch (e) {
      emit(CategoryError('Failed to load categories: $e'));
    }
  }

  Future<void> _onAddCategory(AddCategory event, Emitter<CategoryState> emit) async {
    try {
      // Validate category name
      if (event.name.trim().isEmpty) {
        emit(const CategoryError('Category name cannot be empty'));
        return;
      }

      if (event.name.trim().length > 20) {
        emit(const CategoryError('Category name must be 20 characters or less'));
        return;
      }

      // Create new category entity
      final now = DateTime.now();
      final newCategory = Category(
        name: event.name.trim(),
        icon: event.icon,
        color: event.color,
        isCustom: true,
        createdAt: now,
        updatedAt: now,
      );

      // Add to repository
      await _categoryRepository.addCategory(newCategory);

      // Reload categories to get the updated list with IDs
      _categories = await _categoryRepository.getCategories();

      // Convert to CategoryItem for UI
      final categoryItems = _categories
          .map((category) => CategoryItem(
                name: category.name,
                icon: category.icon,
                color: category.color,
              ))
          .toList();

      emit(CategoryLoaded(categoryItems));
    } catch (e) {
      emit(CategoryError('Failed to add category: $e'));
    }
  }

  Future<void> _onDeleteCategory(DeleteCategory event, Emitter<CategoryState> emit) async {
    try {
      // Delete from repository
      await _categoryRepository.deleteCategory(event.categoryName);

      // Update local list
      _categories = _categories.where((category) => category.name != event.categoryName).toList();

      // Convert to CategoryItem for UI
      final categoryItems = _categories
          .map((category) => CategoryItem(
                name: category.name,
                icon: category.icon,
                color: category.color,
              ))
          .toList();

      emit(CategoryLoaded(categoryItems));
    } catch (e) {
      emit(CategoryError('Failed to delete category: $e'));
    }
  }

  Future<void> _onUpdateCategory(UpdateCategory event, Emitter<CategoryState> emit) async {
    try {
      // Find the category to update
      final categoryToUpdate = _categories.firstWhere(
        (category) => category.name == event.oldName,
        orElse: () => throw Exception('Category not found'),
      );

      // Create updated category
      final updatedCategory = categoryToUpdate.copyWith(
        name: event.newName.trim(),
        icon: event.newIcon,
        color: event.newColor,
        updatedAt: DateTime.now(),
      );

      // Update in repository
      await _categoryRepository.updateCategory(updatedCategory);

      // Update local list
      final categoryIndex = _categories.indexWhere((category) => category.name == event.oldName);
      if (categoryIndex != -1) {
        _categories[categoryIndex] = updatedCategory;
      }

      // Convert to CategoryItem for UI
      final categoryItems = _categories
          .map((category) => CategoryItem(
                name: category.name,
                icon: category.icon,
                color: category.color,
              ))
          .toList();

      emit(CategoryLoaded(categoryItems));
    } catch (e) {
      emit(CategoryError('Failed to update category: $e'));
    }
  }

  Future<void> _onResetCategories(ResetCategories event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());

      // Reset categories in repository
      await _categoryRepository.resetCategoriesToDefault();

      // Reload categories
      _categories = await _categoryRepository.getCategories();

      // Convert to CategoryItem for UI
      final categoryItems = _categories
          .map((category) => CategoryItem(
                name: category.name,
                icon: category.icon,
                color: category.color,
              ))
          .toList();

      emit(CategoryLoaded(categoryItems));
    } catch (e) {
      emit(CategoryError('Failed to reset categories: $e'));
    }
  }

  Future<void> _onLoadCustomCategories(LoadCustomCategories event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());

      // Load only custom categories
      final customCategories = await _categoryRepository.getCustomCategories();

      // Convert to CategoryItem for UI
      final categoryItems = customCategories
          .map((category) => CategoryItem(
                name: category.name,
                icon: category.icon,
                color: category.color,
              ))
          .toList();

      emit(CategoryLoaded(categoryItems));
    } catch (e) {
      emit(CategoryError('Failed to load custom categories: $e'));
    }
  }

  Future<void> _onLoadCategoryUsage(LoadCategoryUsage event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());

      // Load category usage statistics
      final categoryUsage = await _categoryRepository.getCategoryUsage();

      // You might want to create a specific state for category usage
      // For now, we'll emit as loaded state
      emit(CategoryUsageLoaded(categoryUsage));
    } catch (e) {
      emit(CategoryError('Failed to load category usage: $e'));
    }
  }

  // Getter for current categories (maintain backwards compatibility)
  List<CategoryItem> get categories => _categories
      .map((category) => CategoryItem(
            name: category.name,
            icon: category.icon,
            color: category.color,
          ))
      .toList();

  // Getter for domain entities
  List<Category> get categoryEntities => List.unmodifiable(_categories);
}
