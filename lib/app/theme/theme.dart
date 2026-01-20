import 'package:draw_vault/app/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

// Стилизовал все основные виджеты через тему
final theme = ThemeData(
  brightness: Brightness.dark,
  appBarTheme: AppBarTheme(
    titleTextStyle: _textTheme.headlineSmall,
    backgroundColor: Color.fromRGBO(277, 277, 277, 0.2),
  ),
  colorScheme: ColorScheme.dark(
    primary: Color.fromRGBO(106, 70, 249, 1),
    surface: Color.fromRGBO(19, 19, 19, 1),
    onSurface: Color.fromRGBO(135, 133, 143, 1),
    secondary: Color.fromRGBO(238, 238, 238, 1),
    onPrimary: Color.fromRGBO(238, 238, 238, 1),
    secondaryContainer: Color.fromRGBO(255, 255, 255, 0.2),
    onSecondary: Color.fromRGBO(19, 19, 19, 1),
  ),
  iconTheme: IconThemeData(color: Color.fromRGBO(135, 133, 143, 1)),
  inputDecorationTheme: InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    hintStyle: _textTheme.bodyMedium?.copyWith(
      color: Color.fromRGBO(135, 133, 143, 1),
    ),
    labelStyle: _textTheme.labelSmall?.copyWith(
      color: Color.fromRGBO(135, 133, 143, 1),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(135, 133, 143, 1),
        width: 0.5,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromRGBO(135, 133, 143, 1),
        width: 0.5,
      ),
    ),
  ),
  filledButtonTheme: FilledButtonThemeData(
    style: ButtonStyle(
      padding: WidgetStateProperty.all(
        const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      textStyle: WidgetStatePropertyAll(_textTheme.headlineSmall),
    ),
  ),
  textTheme: _textTheme,
  extensions: const [
    AppGradients(
      primaryButton: [
        Color.fromRGBO(137, 36, 231, 1),
        Color.fromRGBO(106, 70, 249, 1),
      ],
    ),
  ],
);

const _textTheme = TextTheme(
  headlineSmall: TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    height: 24 / 17,
    letterSpacing: 0,
  ),
  bodyMedium: TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 24 / 14,
    letterSpacing: 0,
  ),
  labelSmall: TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 1,
    letterSpacing: 0,
  ),
);
