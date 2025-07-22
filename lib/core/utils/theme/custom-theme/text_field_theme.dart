import 'package:flutter/material.dart';
import 'package:up_todo/core/utils/colors.dart';
import 'package:up_todo/core/utils/theme/custom-theme/text_theme.dart';

class TodoTextFieldTheme {
  const TodoTextFieldTheme._();

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: TodoColors.grey,
    suffixIconColor: TodoColors.grey,
    labelStyle: TodoTextTheme.darkTextTheme.bodyMedium!.copyWith(
      color: TodoColors.textPrimary,
    ),
    hintStyle: TodoTextTheme.darkTextTheme.bodyMedium!.copyWith(
      color: TodoColors.textSecondary,
    ),
    errorStyle: TodoTextTheme.darkTextTheme.bodySmall!.copyWith(
      fontWeight: FontWeight.normal,
      color: TodoColors.error,
    ),
    floatingLabelStyle: TodoTextTheme.darkTextTheme.bodyMedium!.copyWith(
      color: TodoColors.textPrimary.withOpacity(0.8),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: TodoColors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: TodoColors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: TodoColors.white),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 1, color: TodoColors.error),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(width: 2, color: TodoColors.warning),
    ),
  );
}
