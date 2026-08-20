import 'package:flutter/material.dart';

class AppTheme {
  // Dark theme colors
  static const Color darkBg = Color(0xFF121212);      // Black background
  static const Color darkSurface = Color(0xFF1E1E1E); // Slightly lighter black
  static const Color darkCard = Color(0xFF2C2C2C);    // Card background
  static const Color darkText = Color(0xFFFFFFFF);    // White text
  static const Color darkSecondaryText = Color(0xFFB0B0B0); // Gray text
  static const Color accentBlue = Color(0xFF2196F3); // Blue accent
  static const Color accentGreen = Color(0xFF4CAF50); // Green for positive

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    appBarTheme: AppBarTheme(
      backgroundColor: darkSurface,
      elevation: 0,
      iconTheme: const IconThemeData(color: darkText),
      titleTextStyle: const TextStyle(
        color: darkText,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: darkText, fontSize: 16),
      bodyMedium: TextStyle(color: darkSecondaryText, fontSize: 14),
      headlineLarge: TextStyle(
        color: darkText,
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        color: darkText,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkCard,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF404040)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF404040)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accentBlue, width: 2),
      ),
      hintStyle: const TextStyle(color: darkSecondaryText),
      labelStyle: const TextStyle(color: darkText),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accentBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: accentBlue,
      ),
    ),
  );
}