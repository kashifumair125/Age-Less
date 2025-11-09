import 'package:flutter/material.dart';

/// Age-Less Color System
/// Based on color psychology principles for health and wellness
class AppColors {
  // ============================================================================
  // PRIMARY - Purple (Trust, Wisdom, Premium)
  // ============================================================================
  static const Color primary = Color(0xFF7C3AED); // Vibrant Purple
  static const Color primaryLight = Color(0xFF9F7AEA); // Light Purple
  static const Color primaryDark = Color(0xFF5B21B6); // Deep Purple
  static const Color primarySoft = Color(0xFFEDE9FE); // Very light purple background

  // Primary shades for gradients
  static const List<Color> primaryGradient = [
    Color(0xFF7C3AED), // Violet
    Color(0xFF8B5CF6), // Purple
  ];

  // ============================================================================
  // SECONDARY - Green (Health, Growth, Success)
  // ============================================================================
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color successLight = Color(0xFF34D399); // Light Green
  static const Color successDark = Color(0xFF059669); // Deep Green
  static const Color successSoft = Color(0xFFD1FAE5); // Very light green background

  // Success shades for gradients
  static const List<Color> successGradient = [
    Color(0xFF10B981), // Emerald
    Color(0xFF14B8A6), // Teal
  ];

  // ============================================================================
  // ACCENT - Orange (Energy, Enthusiasm, Action)
  // ============================================================================
  static const Color accent = Color(0xFFF59E0B); // Amber
  static const Color accentLight = Color(0xFFFBBF24); // Light Amber
  static const Color accentDark = Color(0xFFD97706); // Deep Amber
  static const Color accentSoft = Color(0xFFFEF3C7); // Very light amber background

  // Accent shades for gradients
  static const List<Color> accentGradient = [
    Color(0xFFF59E0B), // Amber
    Color(0xFFF97316), // Orange
  ];

  // ============================================================================
  // ERROR - Red (Attention, Alerts)
  // ============================================================================
  static const Color error = Color(0xFFEF4444); // Red
  static const Color errorLight = Color(0xFFF87171); // Light Red
  static const Color errorDark = Color(0xFFDC2626); // Deep Red
  static const Color errorSoft = Color(0xFFFEE2E2); // Very light red background

  // ============================================================================
  // WARNING - Yellow (Caution)
  // ============================================================================
  static const Color warning = Color(0xFFFBBF24); // Yellow
  static const Color warningSoft = Color(0xFFFEF3C7); // Very light yellow background

  // ============================================================================
  // INFO - Blue (Information, Calm)
  // ============================================================================
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color infoSoft = Color(0xFFDCEAFC); // Very light blue background

  // ============================================================================
  // NEUTRAL COLORS - Light Theme
  // ============================================================================
  static const Color lightBackground = Color(0xFFF9FAFB); // Off-white
  static const Color lightSurface = Color(0xFFFFFFFF); // Pure white
  static const Color lightCard = Color(0xFFFFFFFF); // Pure white

  static const Color lightText = Color(0xFF111827); // Almost black
  static const Color lightTextSecondary = Color(0xFF6B7280); // Gray
  static const Color lightTextTertiary = Color(0xFF9CA3AF); // Light gray

  static const Color lightBorder = Color(0xFFE5E7EB); // Border gray
  static const Color lightDivider = Color(0xFFF3F4F6); // Divider gray

  // Neumorphism shadows - Light theme
  static const Color lightShadowDark = Color(0xFFD1D5DB); // Darker shadow
  static const Color lightShadowLight = Color(0xFFFFFFFF); // Light highlight

  // ============================================================================
  // NEUTRAL COLORS - Dark Theme
  // ============================================================================
  static const Color darkBackground = Color(0xFF0F172A); // Slate 900
  static const Color darkSurface = Color(0xFF1E293B); // Slate 800
  static const Color darkCard = Color(0xFF334155); // Slate 700

  static const Color darkText = Color(0xFFF1F5F9); // Almost white
  static const Color darkTextSecondary = Color(0xFFCBD5E1); // Light gray
  static const Color darkTextTertiary = Color(0xFF94A3B8); // Gray

  static const Color darkBorder = Color(0xFF475569); // Border gray
  static const Color darkDivider = Color(0xFF334155); // Divider gray

  // Neumorphism shadows - Dark theme
  static const Color darkShadowDark = Color(0xFF000000); // Pure black shadow
  static const Color darkShadowLight = Color(0xFF475569); // Light highlight

  // ============================================================================
  // GLASSMORPHISM OVERLAYS
  // ============================================================================
  static const Color glassLight = Color(0x1AFFFFFF); // 10% white
  static const Color glassMedium = Color(0x33FFFFFF); // 20% white
  static const Color glassStrong = Color(0x4DFFFFFF); // 30% white

  static const Color glassDarkLight = Color(0x1A000000); // 10% black
  static const Color glassDarkMedium = Color(0x33000000); // 20% black
  static const Color glassDarkStrong = Color(0x4D000000); // 30% black

  // ============================================================================
  // GRADIENTS
  // ============================================================================

  /// Premium purple gradient
  static const LinearGradient primaryGradientLinear = LinearGradient(
    colors: primaryGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Success green gradient
  static const LinearGradient successGradientLinear = LinearGradient(
    colors: successGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Energetic orange gradient
  static const LinearGradient accentGradientLinear = LinearGradient(
    colors: accentGradient,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Premium background gradient
  static const LinearGradient backgroundGradient = LinearGradient(
    colors: [Color(0xFFF9FAFB), Color(0xFFFFFFFF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Dark background gradient
  static const LinearGradient darkBackgroundGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // ============================================================================
  // CATEGORY COLORS
  // ============================================================================
  static const Color categoryNutrition = Color(0xFF10B981); // Green
  static const Color categoryExercise = Color(0xFFEF4444); // Red
  static const Color categorySleep = Color(0xFF8B5CF6); // Purple
  static const Color categoryStress = Color(0xFFF59E0B); // Amber
  static const Color categorySocial = Color(0xFF3B82F6); // Blue

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get semantic color based on value (0-100)
  static Color getScoreColor(double score) {
    if (score >= 80) return success;
    if (score >= 60) return accent;
    if (score >= 40) return warning;
    return error;
  }

  /// Get category color by name
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'nutrition':
        return categoryNutrition;
      case 'exercise':
        return categoryExercise;
      case 'sleep':
        return categorySleep;
      case 'stress':
        return categoryStress;
      case 'social':
        return categorySocial;
      default:
        return primary;
    }
  }

  /// Get gradient for category
  static LinearGradient getCategoryGradient(String category) {
    final color = getCategoryColor(category);
    final lightColor = Color.lerp(color, Colors.white, 0.2)!;
    return LinearGradient(
      colors: [color, lightColor],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
