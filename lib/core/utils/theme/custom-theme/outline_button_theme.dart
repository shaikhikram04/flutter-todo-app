import 'package:flutter/material.dart';
import 'package:up_todo/core/utils/colors.dart';
import 'package:up_todo/core/utils/theme/custom-theme/text_theme.dart';

class TodoOutlinedButtonTheme {
  const TodoOutlinedButtonTheme._();

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: TodoColors.white,
      side: const BorderSide(color: TodoColors.secondary),
      textStyle: TodoTextTheme.darkTextTheme.titleLarge?.copyWith(
        color: TodoColors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}
