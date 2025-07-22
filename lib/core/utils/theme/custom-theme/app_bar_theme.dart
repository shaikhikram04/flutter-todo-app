import 'package:flutter/material.dart';
import 'package:up_todo/core/utils/colors.dart';
import 'package:up_todo/core/utils/theme/custom-theme/text_theme.dart';

class TodoAppBarTheme {
  const TodoAppBarTheme._();

  static AppBarTheme darkAppBarTheme = AppBarTheme(
    toolbarHeight: 60,
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: TodoColors.white,
    iconTheme: const IconThemeData(
      color: TodoColors.white,
      size: 24,
    ),
    titleTextStyle: TodoTextTheme.darkTextTheme.headlineMedium?.copyWith(
      color: TodoColors.white,
    ),
    actionsIconTheme: const IconThemeData(
      color: TodoColors.white,
      size: 24,
    ),
  );
}