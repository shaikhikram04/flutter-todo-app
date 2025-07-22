import 'package:flutter/material.dart';

class CategoryConstants {
  const CategoryConstants._();

  static final List<CategoryItem> categories = [
    CategoryItem(
      name: 'Grocery',
      icon: Icons.shopping_cart,
      color: const Color(0xFF66BB6A), // Green
    ),
    CategoryItem(
      name: 'Work',
      icon: Icons.work,
      color: const Color(0xFFEF5350), // Red
    ),
    CategoryItem(
      name: 'Sport',
      icon: Icons.fitness_center,
      color: const Color(0xFF42A5F5), // Blue
    ),
    CategoryItem(
      name: 'Home',
      icon: Icons.home,
      color: const Color(0xFFE57373), // Light Red
    ),
    CategoryItem(
      name: 'University',
      icon: Icons.school,
      color: const Color(0xFF8875FF), // Purple
    ),
    CategoryItem(
      name: 'Social',
      icon: Icons.people,
      color: const Color(0xFFAB47BC), // Pink/Purple
    ),
    CategoryItem(
      name: 'Music',
      icon: Icons.music_note,
      color: const Color(0xFFBA68C8), // Light Purple
    ),
    CategoryItem(
      name: 'Health',
      icon: Icons.favorite,
      color: const Color(0xFF4CAF50), // Green
    ),
    CategoryItem(
      name: 'Movie',
      icon: Icons.movie,
      color: const Color(0xFF29B6F6), // Light Blue
    ),
  ];
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
