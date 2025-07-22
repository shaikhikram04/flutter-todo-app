import 'package:flutter/material.dart';
import 'package:up_todo/core/utils/colors.dart';
import 'package:up_todo/core/utils/theme/custom-theme/app_bar_theme.dart';
import 'package:up_todo/core/utils/theme/custom-theme/check_box_theme.dart';
import 'package:up_todo/core/utils/theme/custom-theme/chip_theme.dart';
import 'package:up_todo/core/utils/theme/custom-theme/elevated_button_theme.dart';
import 'package:up_todo/core/utils/theme/custom-theme/outline_button_theme.dart';
import 'package:up_todo/core/utils/theme/custom-theme/text_field_theme.dart';
import 'package:up_todo/core/utils/theme/custom-theme/text_theme.dart';

class TodoAppTheme {
  const TodoAppTheme._();



  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: TodoColors.black,
    textTheme: TodoTextTheme.darkTextTheme,
    elevatedButtonTheme: TodoElevatedButtonTheme.darkElevatedButtonTheme,
    chipTheme: TodoChipTheme.darkChipTheme,
    inputDecorationTheme: TodoTextFieldTheme.darkInputDecorationTheme,
    appBarTheme: TodoAppBarTheme.darkAppBarTheme,
    checkboxTheme: TodoCheckboxTheme.darkCheckboxTheme,
    outlinedButtonTheme: TodoOutlinedButtonTheme.darkOutlinedButtonTheme,
  );
}
