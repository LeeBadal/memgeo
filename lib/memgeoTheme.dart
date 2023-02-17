import 'package:flutter/material.dart';

MaterialColor mgSwatch = MaterialColor(
  0xFF37474F, // You can replace this value with the hex value of your desired shade of dark grey
  <int, Color>{
    50: Color(0xFFECEFF1),
    100: Color(0xFFCFD8DC),
    200: Color(0xFFB0BEC5),
    300: Color(0xFF90A4AE),
    400: Color(0xFF78919C),
    500: Color(0xFF607D8B),
    600: Color(0xFF546E7A),
    700: Color(0xFF455A64),
    800: Color(0xFF37474F),
    900: Color(0xFF263238),
  },
);

// secondary swatch is yellow
MaterialColor mgSwatch2 = MaterialColor(
  0xFFFBC02D, // You can replace this value with the hex value of your desired shade of dark grey
  <int, Color>{
    50: Color(0xFFFFFDE7),
    100: Color(0xFFFFF9C4),
    200: Color(0xFFFFF59D),
    300: Color(0xFFFFF176),
    400: Color(0xFFFFEE58),
    500: Color(0xFFFFEB3B),
    600: Color(0xFFFDD835),
    700: Color(0xFFFBC02D),
    800: Color(0xFFF9A825),
    900: Color(0xFFF57F17),
  },
);

class mgTheme {
  static final ThemeData themeData = ThemeData(
      textTheme: const TextTheme(
        headline1: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.white,
        ),
        bodyText2: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
        button: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
      splashColor: mgSwatch,
      colorScheme: ColorScheme.fromSwatch(primarySwatch: mgSwatch)
          .copyWith(secondary: mgSwatch2),
      backgroundColor: mgSwatch);
}
