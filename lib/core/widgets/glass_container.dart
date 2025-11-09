import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Glassmorphism container with frosted glass effect
/// Creates a translucent, blurred background effect
class GlassContainer extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? color;
  final double blur;
  final double opacity;
  final Border? border;
  final GlassIntensity intensity;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.color,
    this.blur = 10,
    this.opacity = 0.1,
    this.border,
    this.intensity = GlassIntensity.medium,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get blur and opacity based on intensity
    final effectiveBlur = _getBlur(intensity);
    final effectiveOpacity = _getOpacity(intensity);

    // Get default color based on theme
    final defaultColor = isDark ? AppColors.glassLight : AppColors.glassLight;
    final effectiveColor = color ?? defaultColor;

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur > 0 ? effectiveBlur : 0,
            sigmaY: blur > 0 ? effectiveBlur : 0,
          ),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: effectiveColor.withOpacity(opacity > 0 ? effectiveOpacity : 0),
              borderRadius: BorderRadius.circular(borderRadius),
              border: border ??
                  Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1.5,
                  ),
            ),
            child: onTap != null
                ? InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: child,
                  )
                : child,
          ),
        ),
      ),
    );
  }

  double _getBlur(GlassIntensity intensity) {
    switch (intensity) {
      case GlassIntensity.light:
        return 5;
      case GlassIntensity.medium:
        return 10;
      case GlassIntensity.strong:
        return 20;
    }
  }

  double _getOpacity(GlassIntensity intensity) {
    switch (intensity) {
      case GlassIntensity.light:
        return 0.05;
      case GlassIntensity.medium:
        return 0.1;
      case GlassIntensity.strong:
        return 0.2;
    }
  }
}

/// Glass card with consistent styling
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final GlassIntensity intensity;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.intensity = GlassIntensity.medium,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      intensity: intensity,
      onTap: onTap,
      child: child,
    );
  }
}

/// Glass button with gradient overlay
class GlassButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Gradient? gradient;
  final Color? color;

  const GlassButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.borderRadius = 12,
    this.gradient,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: borderRadius,
      intensity: GlassIntensity.medium,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient ?? AppColors.primaryGradientLinear,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Center(child: child),
            ),
          ),
        ),
      ),
    );
  }
}

/// Glass app bar with blur effect
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? leading;
  final Widget? title;
  final List<Widget>? actions;
  final double height;
  final GlassIntensity intensity;

  const GlassAppBar({
    super.key,
    this.leading,
    this.title,
    this.actions,
    this.height = 56,
    this.intensity = GlassIntensity.strong,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: height + MediaQuery.of(context).padding.top,
      borderRadius: 0,
      intensity: intensity,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              if (leading != null) leading!,
              if (leading != null) const SizedBox(width: 12),
              if (title != null) Expanded(child: title!),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }
}

/// Glass bottom navigation bar
class GlassBottomNav extends StatelessWidget {
  final List<Widget> items;
  final EdgeInsetsGeometry? padding;
  final double height;

  const GlassBottomNav({
    super.key,
    required this.items,
    this.padding,
    this.height = 72,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: height + MediaQuery.of(context).padding.bottom,
      borderRadius: 0,
      intensity: GlassIntensity.strong,
      border: Border(
        top: BorderSide(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items,
          ),
        ),
      ),
    );
  }
}

/// Glass modal bottom sheet
class GlassBottomSheet extends StatelessWidget {
  final Widget child;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const GlassBottomSheet({
    super.key,
    required this.child,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      height: height ?? MediaQuery.of(context).size.height * 0.6,
      borderRadius: 24,
      intensity: GlassIntensity.strong,
      padding: padding ?? const EdgeInsets.all(24),
      border: Border.all(
        color: Colors.white.withOpacity(0.2),
        width: 1.5,
      ),
      child: child,
    );
  }

  /// Show glass bottom sheet
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    double? height,
    EdgeInsetsGeometry? padding,
    bool isDismissible = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      isScrollControlled: true,
      builder: (context) => GlassBottomSheet(
        height: height,
        padding: padding,
        child: child,
      ),
    );
  }
}

/// Glass intensity levels
enum GlassIntensity {
  /// Light blur and opacity
  light,

  /// Medium blur and opacity
  medium,

  /// Strong blur and opacity
  strong,
}
