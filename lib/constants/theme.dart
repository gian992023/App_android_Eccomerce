import 'package:flutter/material.dart';

ThemeData themeData = ThemeData(
  scaffoldBackgroundColor: Color(0xFFE6E6E6), // Gris más claro que #DFDFDF
  primaryColor: Color(0xFF826343),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Color(0xFF826343),
      textStyle: const TextStyle(color: Color(0xFF826343)),
      side: const BorderSide(color: Color(0xFF826343), width: 1.7),
      disabledForegroundColor: Color(0xFF826343).withOpacity(0.38),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: outlineInputBorder,
    errorBorder: outlineInputBorder,
    enabledBorder: outlineInputBorder,
    prefixIconColor: Color(0xFFB3A28F),
    suffixIconColor: Color(0xFFB3A28F),
    focusedBorder: outlineInputBorder,
    disabledBorder: outlineInputBorder,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Color(0xFF826343),
      textStyle: const TextStyle(fontSize: 18.0),
      disabledBackgroundColor: Color(0xFFB3A28F),
    ),
  ),
  primarySwatch: MaterialColor(0xFF826343, {
    50: Color(0xFFF5E8E1),
    100: Color(0xFFD8C5B2),
    200: Color(0xFFBFA289),
    300: Color(0xFFA47E5E),
    400: Color(0xFF8F6645),
    500: Color(0xFF826343),
    600: Color(0xFF755938),
    700: Color(0xFF664D30),
    800: Color(0xFF564027),
    900: Color(0xFF452E1B),
  }),
  canvasColor: Color(0xFF826343),
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFE6E6E6), // También ajustado para mayor claridad
    elevation: 0.0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  cardTheme: CardTheme(
    color: Colors.transparent,
    elevation: 5,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    shadowColor: Color(0xFFB3A28F).withOpacity(0.5),
  ),
);

OutlineInputBorder outlineInputBorder = const OutlineInputBorder(
  borderSide: BorderSide(
    color: Color(0xFFB3A28F),
  ),
);
