import 'package:flutter/material.dart';
import 'package:up_todo/core/utils/colors.dart';
import 'package:up_todo/core/utils/theme/custom-theme/text_theme.dart';

class TodoElevatedButtonTheme {
  const TodoElevatedButtonTheme._();

  static ElevatedButtonThemeData darkElevatedButtonTheme =
      ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: TodoColors.primary,
      foregroundColor: TodoColors.white,
      disabledBackgroundColor: TodoColors.grey,
      disabledForegroundColor: TodoColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      side: const BorderSide(color: TodoColors.primary),
      padding: const EdgeInsets.symmetric(vertical: 18),
      textStyle: TodoTextTheme.darkTextTheme.titleMedium?.copyWith(
        color: TodoColors.white,
      ),
    ),
  );
}
