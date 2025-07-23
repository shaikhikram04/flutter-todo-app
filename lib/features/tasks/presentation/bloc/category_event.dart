import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategories extends CategoryEvent {}

class AddCategory extends CategoryEvent {
  final String name;
  final IconData icon;
  final Color color;

  const AddCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  @override
  List<Object?> get props => [name, icon, color];
}

class DeleteCategory extends CategoryEvent {
  final String categoryName;

  const DeleteCategory(this.categoryName);

  @override
  List<Object?> get props => [categoryName];
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

  @override
  List<Object?> get props => [oldName, newName, newIcon, newColor];
}
