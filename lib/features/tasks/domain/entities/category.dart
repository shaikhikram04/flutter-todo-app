import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final int? id;
  final String name;
  final IconData icon;
  final Color color;
  final bool isCustom;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Category({
    this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.isCustom,
    required this.createdAt,
    required this.updatedAt,
  });

  Category copyWith({
    int? id,
    String? name,
    IconData? icon,
    Color? color,
    bool? isCustom,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      isCustom: isCustom ?? this.isCustom,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, name, icon, color, isCustom, createdAt, updatedAt];
}
