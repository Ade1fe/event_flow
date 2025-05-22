// // lib/theme/theme.dart

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// /// Define your color palette here
// class AppColors {
//   static const Color primary = Color(0xFFFFF1E0);
//   static const Color secondary = Color(0xFF7B8CDE);
//   static const Color background = Colors.white;
//   static const Color surface = Colors.white;
//   static const Color error = Color(0xFFB00020);
//   static const Color onPrimary = Colors.white;
//   static const Color onSecondary = Colors.black;
//   static const Color onBackground = Colors.black87;
//   static const Color onSurface = Colors.black;
//   static const Color onError = Colors.white;
//   static const Color appGrey = Colors.grey;
// }

// /// Reusable text styles with customization options
// class AppTextStyles {
//   static final TextStyle _baseStyle = GoogleFonts.roboto();

//   static TextStyle getStyle({
//     double? fontSize,
//     FontWeight? fontWeight,
//     Color? color,
//     FontStyle? fontStyle,
//     double? letterSpacing,
//     double? wordSpacing,
//     TextDecoration? decoration,
//     TextDecorationStyle? decorationStyle,
//     double? decorationThickness,
//   }) {
//     return _baseStyle.copyWith(
//       fontSize: fontSize,
//       fontWeight: fontWeight,
//       color: color,
//       fontStyle: fontStyle,
//       letterSpacing: letterSpacing,
//       wordSpacing: wordSpacing,
//       decoration: decoration,
//       decorationStyle: decorationStyle,
//       decorationThickness: decorationThickness,
//     );
//   }

//   static final TextStyle headline1 = getStyle(
//     fontSize: 32,
//     fontWeight: FontWeight.bold,
//     color: AppColors.onBackground,
//   );
//   static final TextStyle bodyText1 = getStyle(
//     fontSize: 16,
//     fontWeight: FontWeight.normal,
//     color: AppColors.onBackground,
//   );
//   static final TextStyle button = getStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     color: AppColors.onPrimary,
//   );
// }

// /// The global theme configuration
// class AppTheme {
//   static ThemeData get lightTheme {
//     return ThemeData(
//       brightness: Brightness.light,
//       primaryColor: AppColors.primary,
//       scaffoldBackgroundColor: AppColors.background,
//       colorScheme: const ColorScheme(
//         brightness: Brightness.light,
//         primary: AppColors.primary,
//         onPrimary: AppColors.onPrimary,
//         secondary: AppColors.secondary,
//         onSecondary: AppColors.onSecondary,
//         surface: AppColors.surface,
//         onSurface: AppColors.onSurface,
//         error: AppColors.error,
//         onError: AppColors.onError,
//       ),
//       textTheme: ThemeData.light().textTheme.copyWith(
//         headlineLarge: AppTextStyles.headline1,
//         bodyLarge: AppTextStyles.bodyText1,
//         labelLarge: AppTextStyles.button,
//       ),

//       appBarTheme: AppBarTheme(
//         backgroundColor: AppColors.primary,
//         foregroundColor: AppColors.onPrimary,
//         elevation: 0,
//         titleTextStyle: AppTextStyles.getStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//           color: AppColors.onPrimary,
//         ),
//       ),
//       elevatedButtonTheme: ElevatedButtonThemeData(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: AppColors.primary,
//           foregroundColor: AppColors.onPrimary,
//           textStyle: AppTextStyles.button,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Define your color palette here
class AppColors {
  // Primary brand colors - bright and vibrant
  static const Color primary = Color(0xFF5E17EB); // Vibrant purple
  static const Color secondary = Color(0xFF00D9F5); // Bright cyan
  static const Color tertiary = Color(0xFFFF3366); // Vibrant pink
  static const Color quaternary = Color(0xFFFFCC00); // Bright yellow

  // Background and surface colors
  static const Color background = Colors.white;
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFF5F7FA);

  // Status colors - bright variants
  static const Color success = Color(0xFF00C853); // Bright green
  static const Color warning = Color(0xFFFFAB00); // Bright amber
  static const Color error = Color(0xFFFF3D00); // Bright red
  static const Color info = Color(0xFF2979FF); // Bright blue

  // Text colors
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Color(0xFF1A1A1A); // Near black
  static const Color onBackground = Color(0xFF1A1A1A); // Near black
  static const Color onSurface = Color(0xFF1A1A1A); // Near black
  static const Color onError = Colors.white;

  // Neutral colors
  static const Color appGrey = Color(0xFF9E9E9E); // Medium grey
  static const Color lightGrey = Color(0xFFE0E0E0); // Light grey
  static const Color darkGrey = Color(0xFF616161); // Dark grey

  // Gradient colors
  static const List<Color> primaryGradient = [
    Color(0xFF5E17EB), // Vibrant purple
    Color(0xFF7B3FF2), // Lighter purple
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF00D9F5), // Bright cyan
    Color(0xFF00F2C3), // Teal accent
  ];

  // Extension method to adjust color opacity
  static Color withValues({
    required Color color,
    double? alpha,
    double? red,
    double? green,
    double? blue,
  }) {
    return Color.fromARGB(
      (alpha != null ? alpha * 255 : color.alpha).round(),
      (red != null ? red * 255 : color.red).round(),
      (green != null ? green * 255 : color.green).round(),
      (blue != null ? blue * 255 : color.blue).round(),
    );
  }

  // Tab indicator colors
  static const Color tabIndicator = Color(0xFFFF3366); // Vibrant pink

  // Card colors
  static const Color cardBorder = Color(0xFFEEEEEE);

  // Button colors
  static const Color approveButton = Color(0xFF00C853); // Bright green
  static const Color rejectButton = Color(0xFFFF3D00); // Bright red
}

/// Reusable text styles with customization options
class AppTextStyles {
  static final TextStyle _baseStyle = GoogleFonts.roboto();

  static TextStyle getStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? wordSpacing,
    TextDecoration? decoration,
    TextDecorationStyle? decorationStyle,
    double? decorationThickness,
  }) {
    return _baseStyle.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      decoration: decoration,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
    );
  }

  static final TextStyle headline1 = getStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );

  static final TextStyle headline2 = getStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.onBackground,
  );

  static final TextStyle headline3 = getStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.onBackground,
  );

  static final TextStyle subtitle1 = getStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.onBackground,
  );

  static final TextStyle bodyText1 = getStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
  );

  static final TextStyle bodyText2 = getStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.onBackground,
  );

  static final TextStyle button = getStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.onPrimary,
  );

  static final TextStyle caption = getStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.appGrey,
  );
}

/// The global theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onPrimary,
        error: AppColors.error,
        onError: AppColors.onError,
        background: AppColors.background,
        onBackground: AppColors.onBackground,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
      ),
      textTheme: ThemeData.light().textTheme.copyWith(
        headlineLarge: AppTextStyles.headline1,
        headlineMedium: AppTextStyles.headline2,
        headlineSmall: AppTextStyles.headline3,
        titleLarge: AppTextStyles.subtitle1,
        bodyLarge: AppTextStyles.bodyText1,
        bodyMedium: AppTextStyles.bodyText2,
        labelLarge: AppTextStyles.button,
        bodySmall: AppTextStyles.caption,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        elevation: 0,
        titleTextStyle: AppTextStyles.getStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.onPrimary,
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          textStyle: AppTextStyles.button,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button,
        ),
      ),

      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: AppColors.surface,
      ),

      tabBarTheme: const TabBarTheme(
        labelColor: AppColors.onPrimary,
        unselectedLabelColor: Color(0xAAFFFFFF),
        indicatorColor: AppColors.tabIndicator,
        labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.tertiary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.lightGrey,
        thickness: 1,
        space: 1,
      ),

      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.lightGrey;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.lightGrey;
        }),
      ),

      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary;
          }
          return AppColors.lightGrey;
        }),
        trackColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.primary.withOpacity(0.5);
          }
          return AppColors.lightGrey.withOpacity(0.5);
        }),
      ),
    );
  }

  // You can add a dark theme here if needed
  static ThemeData get darkTheme {
    // Implement dark theme
    return ThemeData.dark();
  }
}
