import 'package:flutter/material.dart';
import '../models/task.dart'; // Import to use TaskPriority enum

class ThemeService {
  // App colors
  static const Color primaryColor = Color(0xFF6200EE);
  static const Color lightPrim = Color.fromARGB(255, 167, 125, 227);
  static const Color primaryVariantColor = Color(0xFF3700B3);
  static const Color secondaryColor = Color(0xFF03DAC6);
  static const Color secondaryVariantColor = Color(0xFF018786);
  static const Color errorColor = Color(0xFFB00020);

  // Light theme colors
  static const Color lightBackgroundColor = Color(0xFFF5F5F5);
  static const Color lightSurfaceColor = Colors.white;
  static const Color lightOnPrimaryColor = Colors.white;
  static const Color lightOnSecondaryColor = Colors.black;
  static const Color lightOnBackgroundColor = Color(0xFF121212);
  static const Color lightOnSurfaceColor = Color(0xFF121212);

  // Dark theme colors
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkOnPrimaryColor = Colors.white;
  static const Color darkOnSecondaryColor = Colors.black;
  static const Color darkOnBackgroundColor = Colors.white;
  static const Color darkOnSurfaceColor = Colors.white;

  // Task priority colors
  static const Color lowPriorityColor = Color(0xFF4CAF50);
  static const Color mediumPriorityColor = Color(0xFFFFC107);
  static const Color highPriorityColor = Color(0xFFF44336);

  // Task category colors
  static const List<Color> categoryColors = [
    Color(0xFF6200EE), // Purple
    Color(0xFF03DAC6), // Teal
    Color(0xFFF44336), // Red
    Color(0xFF4CAF50), // Green
    Color(0xFF2196F3), // Blue
    Color(0xFFFF9800), // Orange
    Color(0xFF9C27B0), // Deep Purple
    Color(0xFF795548), // Brown
    Color(0xFF607D8B), // Blue Grey
  ];

  // Light theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: primaryColor,
      primaryContainer: primaryVariantColor,
      secondary: secondaryColor,
      secondaryContainer: secondaryVariantColor,
      error: errorColor,
      surface: lightSurfaceColor,
      onPrimary: lightOnPrimaryColor,
      onSecondary: lightOnSecondaryColor,
      onSurface: lightOnSurfaceColor,
    ),
    dividerColor: Colors.grey.shade300,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: lightOnPrimaryColor,
      elevation: 0,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: lightOnSecondaryColor,
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightSurfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: lightOnPrimaryColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: lightSurfaceColor,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: darkSurfaceColor,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Dark theme
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      primaryContainer: primaryVariantColor,
      secondary: secondaryColor,
      secondaryContainer: secondaryVariantColor,
      error: errorColor,
      surface: darkSurfaceColor,
      onPrimary: darkOnPrimaryColor,
      onSecondary: darkOnSecondaryColor,
      onSurface: darkOnSurfaceColor,
    ),
    dividerColor: Colors.grey.shade700,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkSurfaceColor,
      foregroundColor: darkOnSurfaceColor,
      elevation: 0,
      centerTitle: true,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: darkOnSecondaryColor,
    ),
    cardTheme: CardThemeData(
      color: darkSurfaceColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurfaceColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade700),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: darkOnPrimaryColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: const BorderSide(color: primaryColor),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return primaryColor;
        }
        return Colors.transparent;
      }),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: darkSurfaceColor,
      selectedItemColor: secondaryColor,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.grey.shade900,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: darkSurfaceColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
  );

  // Get color for task priority
  static Color getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.low:
        return lowPriorityColor;
      case TaskPriority.medium:
        return mediumPriorityColor;
      case TaskPriority.high:
        return highPriorityColor;
    }
  }

  // Get category color by index
  static Color getCategoryColor(int index) {
    return categoryColors[index % categoryColors.length];
  }
}
