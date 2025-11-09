import 'package:flutter/material.dart';

/// Enhanced Typography System with Clear Hierarchy
class AppTypography {
  // ============================================================================
  // FONT FAMILY
  // ============================================================================
  static const String fontFamily = 'Inter'; // Will use system default if not added

  // ============================================================================
  // DISPLAY STYLES - Hero Text
  // ============================================================================

  /// Display Extra Large - Hero headlines (48px)
  static const TextStyle displayXL = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    height: 1.1,
    letterSpacing: -0.5,
  );

  /// Display Large - Major headings (40px)
  static const TextStyle displayLarge = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w800,
    height: 1.15,
    letterSpacing: -0.5,
  );

  /// Display Medium - Section headings (32px)
  static const TextStyle displayMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.25,
  );

  /// Display Small - Card headings (28px)
  static const TextStyle displaySmall = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: -0.25,
  );

  // ============================================================================
  // HEADING STYLES - Standard Headings
  // ============================================================================

  /// Heading 1 - Main page title (24px)
  static const TextStyle h1 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
    letterSpacing: -0.25,
  );

  /// Heading 2 - Section headers (20px)
  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// Heading 3 - Subsection headers (18px)
  static const TextStyle h3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  /// Heading 4 - Card titles (16px)
  static const TextStyle h4 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Heading 5 - Small headers (14px)
  static const TextStyle h5 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ============================================================================
  // BODY STYLES - Content Text
  // ============================================================================

  /// Body Large - Primary content (16px)
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body Medium - Standard content (14px)
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body Small - Secondary content (12px)
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  // ============================================================================
  // LABEL STYLES - UI Elements
  // ============================================================================

  /// Label Large - Button text, form labels (16px)
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.1,
  );

  /// Label Medium - Small buttons, tabs (14px)
  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.1,
  );

  /// Label Small - Tiny labels, tags (12px)
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.5,
  );

  // ============================================================================
  // CAPTION & OVERLINE - Supporting Text
  // ============================================================================

  /// Caption - Helper text, timestamps (12px)
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Overline - Labels, categories (10px uppercase)
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 1.5,
  );

  // ============================================================================
  // SPECIALIZED STYLES
  // ============================================================================

  /// Number Large - Big statistics (56px)
  static const TextStyle numberLarge = TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w800,
    height: 1.0,
    letterSpacing: -1,
  );

  /// Number Medium - Stats (32px)
  static const TextStyle numberMedium = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.1,
    letterSpacing: -0.5,
  );

  /// Number Small - Small stats (24px)
  static const TextStyle numberSmall = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// Quote - Quotes and testimonials
  static const TextStyle quote = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.6,
    fontStyle: FontStyle.italic,
  );

  /// Link - Clickable text links
  static const TextStyle link = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    decoration: TextDecoration.underline,
  );

  // ============================================================================
  // CTA (Call to Action) STYLES
  // ============================================================================

  /// Primary CTA - Main action buttons
  static const TextStyle ctaPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0.5,
  );

  /// Secondary CTA - Secondary action buttons
  static const TextStyle ctaSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0.25,
  );

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Get emphasized version of text style
  static TextStyle emphasized(TextStyle style) {
    return style.copyWith(
      fontWeight: FontWeight.w700,
    );
  }

  /// Get dimmed version of text style
  static TextStyle dimmed(TextStyle style, {double opacity = 0.6}) {
    return style.copyWith(
      color: style.color?.withOpacity(opacity),
    );
  }

  /// Get text style for different semantic meanings
  static TextStyle semantic(
    TextStyle style, {
    required String type,
    required bool isDark,
  }) {
    Color color;
    switch (type) {
      case 'success':
        color = const Color(0xFF10B981);
        break;
      case 'error':
        color = const Color(0xFFEF4444);
        break;
      case 'warning':
        color = const Color(0xFFF59E0B);
        break;
      case 'info':
        color = const Color(0xFF3B82F6);
        break;
      default:
        color = isDark ? Colors.white : Colors.black;
    }
    return style.copyWith(color: color);
  }
}

/// Line height presets
class LineHeights {
  static const double tight = 1.25;
  static const double normal = 1.5;
  static const double relaxed = 1.75;
  static const double loose = 2.0;
}

/// Letter spacing presets
class LetterSpacing {
  static const double tight = -0.5;
  static const double normal = 0.0;
  static const double wide = 0.5;
  static const double wider = 1.0;
  static const double widest = 1.5;
}
