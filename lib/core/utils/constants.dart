import 'package:flutter/material.dart';
import 'package:up_todo/core/utils/colors.dart';

class CategoryConstants {
  const CategoryConstants._();

  static final List<CategoryItem> categories = [
    CategoryItem(
      name: 'Grocery',
      icon: Icons.shopping_cart,
      color: TodoColors.grocery,
    ),
    CategoryItem(
      name: 'Work',
      icon: Icons.work,
      color: TodoColors.work,
    ),
    CategoryItem(
      name: 'Sport',
      icon: Icons.fitness_center,
      color: TodoColors.sport,
    ),
    CategoryItem(
      name: 'Home',
      icon: Icons.home,
      color: TodoColors.home,
    ),
    CategoryItem(
      name: 'University',
      icon: Icons.school,
      color: TodoColors.university,
    ),
    CategoryItem(
      name: 'Social',
      icon: Icons.people,
      color: TodoColors.social,
    ),
    CategoryItem(
      name: 'Music',
      icon: Icons.music_note,
      color: TodoColors.music,
    ),
    CategoryItem(
      name: 'Health',
      icon: Icons.favorite,
      color: TodoColors.health,
    ),
    CategoryItem(
      name: 'Movie',
      icon: Icons.movie,
      color: TodoColors.movie,
    ),
  ];

  static CategoryItem getCategoryByName(String categoryName) {
    return categories.firstWhere((category) => categoryName == category.name, orElse: () => categories.first);
  }
}

class CategoryItem {
  final String name;
  final IconData icon;
  final Color color;

  CategoryItem({
    required this.name,
    required this.icon,
    required this.color,
  });
}
