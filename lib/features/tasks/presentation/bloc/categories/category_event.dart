import 'package:flutter/material.dart';

abstract class CategoryEvent {
  const CategoryEvent();
}

class LoadCategories extends CategoryEvent {}

class LoadCustomCategories extends CategoryEvent {}

class LoadCategoryUsage extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String name;
  final IconData icon;
  final Color color;

  const AddCategory({
    required this.name,
    required this.icon,
    required this.color,
  });
}

class UpdateCategory extends CategoryEvent {
  final String oldName;
  final String newName;
  final IconData? newIcon;
  final Color? newColor;

  const UpdateCategory({
    required this.oldName,
    required this.newName,
    this.newIcon,
    this.newColor,
  });
}

class DeleteCategory extends CategoryEvent {
  final String categoryName;

  const DeleteCategory(this.categoryName);
}

class ResetCategories extends CategoryEvent {}
