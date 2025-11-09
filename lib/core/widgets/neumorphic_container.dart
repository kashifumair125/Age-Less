import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Neumorphic container with soft shadows and highlights
/// Creates a soft, extruded effect that appears to rise from or sink into the background
class NeumorphicContainer extends StatelessWidget {
  final Widget? child;
  final double width;
  final double height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? backgroundColor;
  final NeumorphicStyle style;
  final double intensity;
  final VoidCallback? onTap;

  const NeumorphicContainer({
    super.key,
    this.child,
    this.width = double.infinity,
    this.height = double.infinity,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.backgroundColor,
    this.style = NeumorphicStyle.flat,
    this.intensity = 1.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = backgroundColor ??
        (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Container(
            padding: padding,
            decoration: _buildDecoration(isDark, bgColor),
            child: child,
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration(bool isDark, Color bgColor) {
    final shadowColor =
        isDark ? AppColors.darkShadowDark : AppColors.lightShadowDark;
    final highlightColor =
        isDark ? AppColors.darkShadowLight : AppColors.lightShadowLight;

    List<BoxShadow> shadows;

    switch (style) {
      case NeumorphicStyle.flat:
        shadows = [];
        break;

      case NeumorphicStyle.convex:
        shadows = [
          BoxShadow(
            color: shadowColor.withOpacity(0.2 * intensity),
            offset: Offset(6 * intensity, 6 * intensity),
            blurRadius: 12 * intensity,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: highlightColor.withOpacity(0.7 * intensity),
            offset: Offset(-6 * intensity, -6 * intensity),
            blurRadius: 12 * intensity,
            spreadRadius: 0,
          ),
        ];
        break;

      case NeumorphicStyle.concave:
        shadows = [
          BoxShadow(
            color: highlightColor.withOpacity(0.7 * intensity),
            offset: Offset(6 * intensity, 6 * intensity),
            blurRadius: 12 * intensity,
            spreadRadius: 0,
          ),
          BoxShadow(
            color: shadowColor.withOpacity(0.2 * intensity),
            offset: Offset(-6 * intensity, -6 * intensity),
            blurRadius: 12 * intensity,
            spreadRadius: 0,
          ),
        ];
        break;

      case NeumorphicStyle.pressed:
        shadows = [
          BoxShadow(
            color: shadowColor.withOpacity(0.2 * intensity),
            offset: Offset(4 * intensity, 4 * intensity),
            blurRadius: 8 * intensity,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: highlightColor.withOpacity(0.5 * intensity),
            offset: Offset(-2 * intensity, -2 * intensity),
            blurRadius: 6 * intensity,
            spreadRadius: -1,
          ),
        ];
        break;
    }

    return BoxDecoration(
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: shadows,
    );
  }
}

/// Neumorphic button with interaction states
class NeumorphicButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final double minWidth;
  final double minHeight;

  const NeumorphicButton({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.borderRadius = 12,
    this.backgroundColor,
    this.minWidth = 100,
    this.minHeight = 48,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.onPressed != null
          ? (_) => setState(() => _isPressed = true)
          : null,
      onTapUp: widget.onPressed != null
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel:
          widget.onPressed != null ? () => setState(() => _isPressed = false) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        constraints: BoxConstraints(
          minWidth: widget.minWidth,
          minHeight: widget.minHeight,
        ),
        child: NeumorphicContainer(
          padding: widget.padding ??
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          borderRadius: widget.borderRadius,
          backgroundColor: widget.backgroundColor,
          style: _isPressed ? NeumorphicStyle.pressed : NeumorphicStyle.convex,
          intensity: widget.onPressed != null ? 1.0 : 0.5,
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}

/// Neumorphic card with consistent styling
class NeumorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  const NeumorphicCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      style: NeumorphicStyle.flat,
      onTap: onTap,
      child: child,
    );
  }
}

/// Neumorphic progress indicator
class NeumorphicProgress extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double height;
  final double borderRadius;
  final Color? progressColor;
  final Color? backgroundColor;

  const NeumorphicProgress({
    super.key,
    required this.value,
    this.height = 12,
    this.borderRadius = 6,
    this.progressColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return NeumorphicContainer(
      height: height,
      borderRadius: borderRadius,
      style: NeumorphicStyle.concave,
      intensity: 0.5,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.all(2),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - 2),
        child: Stack(
          children: [
            Container(color: Colors.transparent),
            FractionallySizedBox(
              widthFactor: value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: progressColor != null
                        ? [progressColor!, progressColor!]
                        : AppColors.primaryGradient,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius - 2),
                  boxShadow: [
                    BoxShadow(
                      color: (progressColor ?? AppColors.primary)
                          .withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Neumorphic style enum
enum NeumorphicStyle {
  /// Flat with no shadow (subtle)
  flat,

  /// Raised from surface (convex)
  convex,

  /// Sunken into surface (concave)
  concave,

  /// Pressed state
  pressed,
}
