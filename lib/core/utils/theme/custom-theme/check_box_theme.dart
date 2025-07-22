import 'package:flutter/material.dart';
import 'package:up_todo/core/utils/colors.dart';

class TodoCheckboxTheme {
  const TodoCheckboxTheme._();

  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return TodoColors.white;
      }
      return TodoColors.white;
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return TodoColors.primary;
      }
      return Colors.transparent;
    }),
    overlayColor: WidgetStateProperty.all(TodoColors.primary.withOpacity(0.1)),
    side: const BorderSide(color: TodoColors.grey),
  );
}
