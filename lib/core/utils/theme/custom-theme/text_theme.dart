import 'package:flutter/material.dart';
import 'package:up_todo/core/utils/colors.dart';

class TodoTextTheme {
  const TodoTextTheme._();

  static const String _fontFamily = 'Inter';

  static TextTheme darkTextTheme = const TextTheme().copyWith(
    headlineLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 32,
      color: TodoColors.textPrimary,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 24,
      color: TodoColors.textPrimary,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 18,
      color: TodoColors.textPrimary,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      color: TodoColors.textPrimary,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      color: TodoColors.textPrimary,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 16,
      color: TodoColors.textPrimary,
      fontWeight: FontWeight.w400,
    ),
    bodyLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      color: TodoColors.textPrimary,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      color: TodoColors.textPrimary,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 14,
      color: Colors.white54,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      color: TodoColors.textPrimary,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: TextStyle(
      fontFamily: _fontFamily,
      fontSize: 12,
      color: TodoColors.textPrimary,
      fontWeight: FontWeight.normal,
    ),
  );
}
