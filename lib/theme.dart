import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 90, 200, 250),
      onPrimary: Color.fromARGB(255, 10, 10, 10),
      secondary: Color.fromARGB(255, 0, 170, 248),
      onSecondary: Color.fromARGB(255, 10, 10, 10),
      surface: Color.fromARGB(255, 255, 255, 255),
      onSurface: Color.fromARGB(255, 59, 59, 59),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 30,
        color: Color.fromARGB(255, 90, 200, 250),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: const ColorScheme.dark(
      primary: Color.fromARGB(255, 59, 59, 59),
      onPrimary: Color.fromARGB(255, 225, 225, 225),
      surface: Color.fromARGB(255, 59, 59, 59),
      onSurface: Color.fromARGB(255, 225, 225, 225),
      secondary: Color.fromARGB(255, 225, 225, 225),
      onSecondary: Color.fromARGB(255, 225, 225, 225),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 72,
        fontWeight: FontWeight.bold,
      ),
      // ···
      titleLarge: TextStyle(
        fontSize: 30,
      ),
    ),
  );
}
