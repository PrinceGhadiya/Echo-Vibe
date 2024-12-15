import 'package:flutter/material.dart';

class KAppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    /**
     * App colors for light theme
     */
    colorScheme: ColorScheme.light(
      surface: Colors.grey[300]!,
      primary: Colors.grey[500]!,
      onPrimary: Colors.grey[100]!,
      secondary: Colors.blueGrey[700]!,
      surfaceContainer: Colors.white,
    ),

    /**
     * Text theme for light theme
     */
    textTheme: TextTheme(
      labelLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.grey[600]!,
      ),
      labelMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.grey[600]!,
      ),
      labelSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w300,
        color: Colors.grey[600]!,
      ),
    ),
  );
}
