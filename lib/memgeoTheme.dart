import 'package:flutter/material.dart';

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
    splashColor: Colors.blue[50],
    colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
        .copyWith(secondary: Colors.pink),
  );
}
