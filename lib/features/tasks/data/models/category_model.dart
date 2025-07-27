import 'package:flutter/material.dart';

import '../../domain/entities/category.dart';

class CategoryModel extends Category {
  const CategoryModel({
    super.id,
    required super.name,
    required super.icon,
    required super.color,
    required super.isCustom,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      icon: _getIconFromCodePoint(map['iconCodePoint']),
      color: Color(map['colorValue']),
      isCustom: map['isCustom'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'iconCodePoint': icon.codePoint,
      'colorValue': color.value,
      'isCustom': isCustom ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CategoryModel.fromEntity(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      icon: category.icon,
      color: category.color,
      isCustom: category.isCustom,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  static IconData _getIconFromCodePoint(int codePoint) {
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
      0xe7f4: Icons.people,
    };

    return iconMap[codePoint] ?? Icons.category;
  }
}
