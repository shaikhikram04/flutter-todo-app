import 'package:flutter/material.dart';
import 'package:up_todo/core/utils/colors.dart';
import 'package:up_todo/core/utils/theme/custom-theme/text_theme.dart';

class TodoChipTheme {
  const TodoChipTheme._();

  static ChipThemeData darkChipTheme = ChipThemeData(
    backgroundColor: TodoColors.secondary.withOpacity(0.2),
    disabledColor: TodoColors.grey.withOpacity(0.4),
    selectedColor: TodoColors.primary,
    secondarySelectedColor: TodoColors.primary,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    labelStyle: TodoTextTheme.darkTextTheme.labelLarge!.copyWith(
      color: TodoColors.white,
    ),
    secondaryLabelStyle: TodoTextTheme.darkTextTheme.labelLarge!.copyWith(
      color: TodoColors.white,
    ),
    checkmarkColor: TodoColors.white,
    brightness: Brightness.dark,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  );
}
