import 'package:flutter/material.dart';

class AppTheme {
  // Colors (Light Theme)
  static const Color primaryColor = Color(0xFF3D5AFE); // Indigo A200
  static const Color secondaryColor = Color(0xFF00C853); // Green A700
  static const Color accentColor = Color(0xFFFF7043); // Deep Orange 300
  static const Color successColor = Color(0xFF2E7D32);
  static const Color warningColor = Color(0xFFF9A825);
  static const Color errorColor = Color(0xFFD32F2F);

  // Dark Theme Colors
  static const Color darkPrimaryColor = Color(0xFF5C7CFA); // Lighter indigo for dark mode
  static const Color darkSecondaryColor = Color(0xFF00E676); // Lighter green for dark mode
  static const Color darkAccentColor = Color(0xFFFF8A65); // Lighter deep orange
  static const Color darkBackgroundColor = Color(0xFF121212);
  static const Color darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color darkCardColor = Color(0xFF2C2C2C);

  static ThemeData light() {
    final base = ThemeData.light();
    return base.copyWith(
      primaryColor: primaryColor,
      colorScheme: base.colorScheme.copyWith(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        background: Colors.white,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: Colors.black,
        onSurface: Colors.black,
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      scaffoldBackgroundColor: Colors.white,
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.large,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.medium,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.medium,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.small,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.small,
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.small,
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1,
        displayMedium: AppTextStyles.h2,
        titleLarge: AppTextStyles.h3,
        bodyLarge: AppTextStyles.body1.copyWith(color: Colors.black87),
        bodyMedium: AppTextStyles.body2.copyWith(color: Colors.black87),
        bodySmall: AppTextStyles.caption,
      ),
    );
  }

  static ThemeData dark() {
    final base = ThemeData.dark();
    return base.copyWith(
      primaryColor: darkPrimaryColor,
      colorScheme: base.colorScheme.copyWith(
        primary: darkPrimaryColor,
        secondary: darkSecondaryColor,
        error: errorColor,
        background: darkBackgroundColor,
        surface: darkSurfaceColor,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onBackground: Colors.white,
        onSurface: Colors.white,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: darkSurfaceColor,
        foregroundColor: Colors.white,
      ),
      scaffoldBackgroundColor: darkBackgroundColor,
      cardTheme: CardThemeData(
        color: darkCardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.large,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.medium,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkPrimaryColor,
          side: const BorderSide(color: darkPrimaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.medium,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCardColor,
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.small,
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.small,
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.small,
          borderSide: const BorderSide(color: darkPrimaryColor, width: 2),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.h1.copyWith(color: Colors.white),
        displayMedium: AppTextStyles.h2.copyWith(color: Colors.white),
        titleLarge: AppTextStyles.h3.copyWith(color: Colors.white),
        bodyLarge: AppTextStyles.body1.copyWith(color: Colors.white70),
        bodyMedium: AppTextStyles.body2.copyWith(color: Colors.white70),
        bodySmall: AppTextStyles.caption.copyWith(color: Colors.white54),
      ),
      dividerColor: Colors.grey.shade800,
    );
  }
}

extension AppThemeVariants on AppTheme {
  static ThemeData get lightTheme => AppTheme.light();
  static ThemeData get darkTheme => AppTheme.dark();
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.45,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    color: Colors.grey,
  );
}

class AppBorderRadius {
  static BorderRadius get small => BorderRadius.circular(8);
  static BorderRadius get medium => BorderRadius.circular(12);
  static BorderRadius get large => BorderRadius.circular(16);
}
