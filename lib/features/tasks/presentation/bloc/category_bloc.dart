import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  List<CategoryItem> _categories = [];

  CategoryBloc() : super(CategoryInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<AddCategory>(_onAddCategory);
    on<DeleteCategory>(_onDeleteCategory);
    on<UpdateCategory>(_onUpdateCategory);
  }

  void _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) {
    try {
      emit(CategoryLoading());

      // Load default categories from CategoryConstants
      _categories = List.from(CategoryConstants.categories);

      // Here you could also load custom categories from local storage/database
      // _loadCustomCategoriesFromStorage();

      emit(CategoryLoaded(_categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories: $e'));
    }
  }

  void _onAddCategory(AddCategory event, Emitter<CategoryState> emit) {
    try {
      // Check if category already exists
      final existingCategory = _categories.firstWhere(
            (category) => category.name.toLowerCase() == event.name.toLowerCase(),
        orElse: () => CategoryItem(name: '', icon: Icons.error, color: Colors.transparent),
      );

      if (existingCategory.name.isNotEmpty) {
        emit(const CategoryError('Category already exists'));
        return;
      }

      // Validate category name
      if (event.name.trim().isEmpty) {
        emit(const CategoryError('Category name cannot be empty'));
        return;
      }

      if (event.name.trim().length > 20) {
        emit(const CategoryError('Category name must be 20 characters or less'));
        return;
      }

      // Create new category
      final newCategory = CategoryItem(
        name: event.name.trim(),
        icon: event.icon,
        color: event.color,
      );

      // Add to categories list
      _categories = [..._categories, newCategory];

      // Here you would typically save to local storage/database
      // _saveCategoryToStorage(newCategory);

      emit(CategoryAdded(newCategory));
      emit(CategoryLoaded(_categories));
    } catch (e) {
      emit(CategoryError('Failed to add category: $e'));
    }
  }

  void _onDeleteCategory(DeleteCategory event, Emitter<CategoryState> emit) {
    try {
      // Don't allow deletion of default categories
      final defaultCategoryNames = CategoryConstants.categories.map((c) => c.name).toList();

      if (defaultCategoryNames.contains(event.categoryName)) {
        emit(const CategoryError('Cannot delete default categories'));
        return;
      }

      _categories = _categories.where((category) => category.name != event.categoryName).toList();

      // Here you would typically remove from local storage/database
      // _removeCategoryFromStorage(event.categoryName);

      emit(CategoryLoaded(_categories));
    } catch (e) {
      emit(CategoryError('Failed to delete category: $e'));
    }
  }

  void _onUpdateCategory(UpdateCategory event, Emitter<CategoryState> emit) {
    try {
      final categoryIndex = _categories.indexWhere((category) => category.name == event.oldName);

      if (categoryIndex == -1) {
        emit(const CategoryError('Category not found'));
        return;
      }

      final oldCategory = _categories[categoryIndex];
      final updatedCategory = CategoryItem(
        name: event.newName.trim(),
        icon: event.newIcon ?? oldCategory.icon,
        color: event.newColor ?? oldCategory.color,
      );

      _categories[categoryIndex] = updatedCategory;

      // Here you would typically update in local storage/database
      // _updateCategoryInStorage(updatedCategory);

      emit(CategoryLoaded(_categories));
    } catch (e) {
      emit(CategoryError('Failed to update category: $e'));
    }
  }
  // Helper methods for persistence (implement based on your storage solution)

  // Future<void> _saveCategoryToStorage(CategoryItem category) async {
  //   // Implementation for saving to SharedPreferences, Hive, SQLite, etc.
  // }

  // Future<void> _loadCustomCategoriesFromStorage() async {
  //   // Implementation for loading custom categories from storage
  // }

  // Future<void> _removeCategoryFromStorage(String categoryName) async {
  //   // Implementation for removing category from storage
  // }

  // Future<void> _updateCategoryInStorage(CategoryItem category) async {
  //   // Implementation for updating category in storage
  // }

  // Getter for current categories
  List<CategoryItem> get categories => List.unmodifiable(_categories);
}
