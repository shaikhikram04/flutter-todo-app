import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:up_todo/core/database/database_helper.dart';

import '../../../../../core/utils/constants.dart';
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

  final _dbHelper = DatabaseHelper();

  IconData _getIconFromCodePoint(int codePoint) {
    // Map common codePoints to const IconData
    const iconMap = <int, IconData>{
      0xe047: Icons.category,
      0xe3c9: Icons.work,
      0xe7fd: Icons.person,
      0xe59c: Icons.shopping_cart,
      0xe53f: Icons.home,
      0xe558: Icons.school,
      0xe1b9: Icons.fitness_center,
      0xe3e8: Icons.restaurant,
      0xe071: Icons.directions_car,
      0xe530: Icons.local_hospital,
      0xe3f4: Icons.music_note,
      0xe02f: Icons.movie,
      0xe1a3: Icons.sports,
      0xe866: Icons.travel_explore,
      0xe8b6: Icons.pets,
      0xe84f: Icons.book,
      0xe90f: Icons.games,
      0xe3af: Icons.business,
      0xe8cc: Icons.family_restroom,
    };

    // Return mapped icon or default category icon
    return iconMap[codePoint] ?? Icons.category;
  }

  Future<void> _onLoadCategories(LoadCategories event, Emitter<CategoryState> emit) async {
    try {
      emit(CategoryLoading());

      // Load all categories from database (both default and custom)
      final categoriesFromDb = await _dbHelper.getCategories();

      _categories = categoriesFromDb.map((categoryMap) => CategoryItem(
        name: categoryMap['name'],
        icon: _getIconFromCodePoint(categoryMap['iconCodePoint']),
        color: Color(categoryMap['colorValue']),
      )).toList();

      emit(CategoryLoaded(_categories));
    } catch (e) {
      emit(CategoryError('Failed to load categories: $e'));
    }
  }

  Future<void> _onAddCategory(AddCategory event, Emitter<CategoryState> emit) async {
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

      // Save to database first
      await _dbHelper.insertCategory(
          name: newCategory.name,
          colorValue: newCategory.color.value,
          iconCodePoint: newCategory.icon.codePoint,
          isCustom: true
      );

      // Add to categories list
      _categories = [..._categories, newCategory];

      // Only emit CategoryLoaded with updated list
      emit(CategoryLoaded(_categories));
    } catch (e) {
      emit(CategoryError('Failed to add category: $e'));
    }
  }

  Future<void> _onDeleteCategory(DeleteCategory event, Emitter<CategoryState> emit) async {
    try {
      // Check if it's a default category by checking the database
      final categoryFromDb = await _dbHelper.getCategoryByName(event.categoryName);

      if (categoryFromDb != null && categoryFromDb['isCustom'] == 0) {
        emit(const CategoryError('Cannot delete default categories'));
        return;
      }

      // Delete from database first
      await _dbHelper.deleteCategory(event.categoryName);

      // Remove from local list
      _categories = _categories.where((category) => category.name != event.categoryName).toList();

      emit(CategoryLoaded(_categories));
    } catch (e) {
      emit(CategoryError('Failed to delete category: $e'));
    }
  }

  Future<void> _onUpdateCategory(UpdateCategory event, Emitter<CategoryState> emit) async {
    try {
      final categoryIndex = _categories.indexWhere((category) => category.name == event.oldName);

      if (categoryIndex == -1) {
        emit(const CategoryError('Category not found'));
        return;
      }

      // Get category from database to check if it's custom
      final categoryFromDb = await _dbHelper.getCategoryByName(event.oldName);
      if (categoryFromDb == null) {
        emit(const CategoryError('Category not found in database'));
        return;
      }

      final oldCategory = _categories[categoryIndex];
      final updatedCategory = CategoryItem(
        name: event.newName.trim(),
        icon: event.newIcon ?? oldCategory.icon,
        color: event.newColor ?? oldCategory.color,
      );

      // Update in database
      await _dbHelper.updateCategory(
        id: categoryFromDb['id'],
        name: event.newName.trim(),
        iconCodePoint: updatedCategory.icon.codePoint,
        colorValue: updatedCategory.color.value,
      );

      // Update local list
      _categories[categoryIndex] = updatedCategory;

      emit(CategoryLoaded(_categories));
    } catch (e) {
      emit(CategoryError('Failed to update category: $e'));
    }
  }


  // Getter for current categories
  List<CategoryItem> get categories => List.unmodifiable(_categories);
}
