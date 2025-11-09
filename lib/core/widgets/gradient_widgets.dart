import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Gradient button with shimmer effect
class GradientButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final double minWidth;
  final double minHeight;
  final bool isLoading;
  final bool isDisabled;

  const GradientButton({
    super.key,
    required this.child,
    this.onPressed,
    this.gradient,
    this.padding,
    this.borderRadius = 12,
    this.minWidth = 100,
    this.minHeight = 48,
    this.isLoading = false,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ?? AppColors.primaryGradientLinear;
    final isEnabled = !isDisabled && !isLoading && onPressed != null;

    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Container(
        constraints: BoxConstraints(
          minWidth: minWidth,
          minHeight: minHeight,
        ),
        decoration: BoxDecoration(
          gradient: effectiveGradient,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: isEnabled
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isEnabled ? onPressed : null,
            borderRadius: BorderRadius.circular(borderRadius),
            child: Container(
              padding: padding ??
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Center(
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Gradient icon button
class GradientIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Gradient? gradient;
  final double size;
  final double iconSize;

  const GradientIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.gradient,
    this.size = 48,
    this.iconSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ?? AppColors.primaryGradientLinear;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Icon(
            icon,
            size: iconSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

/// Gradient card
class GradientCard extends StatelessWidget {
  final Widget child;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final VoidCallback? onTap;

  const GradientCard({
    super.key,
    required this.child,
    this.gradient,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 16,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ?? AppColors.primaryGradientLinear;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding!,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Gradient text
class GradientText extends StatelessWidget {
  final String text;
  final Gradient gradient;
  final TextStyle? style;

  const GradientText({
    super.key,
    required this.text,
    required this.gradient,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: (style ?? AppTypography.h1).copyWith(
          color: Colors.white,
        ),
      ),
    );
  }
}

/// Gradient progress indicator
class GradientProgress extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final Gradient? gradient;
  final Color? backgroundColor;
  final double height;
  final double borderRadius;
  final bool showPercentage;

  const GradientProgress({
    super.key,
    required this.value,
    this.gradient,
    this.backgroundColor,
    this.height = 8,
    this.borderRadius = 4,
    this.showPercentage = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveGradient = gradient ?? AppColors.primaryGradientLinear;
    final effectiveBackgroundColor =
        backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.lightBorder);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (showPercentage)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              '${(value * 100).toInt()}%',
              style: AppTypography.caption,
            ),
          ),
        ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: SizedBox(
            height: height,
            child: Stack(
              children: [
                Container(
                  color: effectiveBackgroundColor,
                ),
                FractionallySizedBox(
                  widthFactor: value.clamp(0.0, 1.0),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: effectiveGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Gradient circular progress
class GradientCircularProgress extends StatelessWidget {
  final double value; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Widget? child;

  const GradientCircularProgress({
    super.key,
    required this.value,
    this.size = 100,
    this.strokeWidth = 8,
    this.gradient,
    this.backgroundColor,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBackgroundColor =
        backgroundColor ?? (isDark ? AppColors.darkCard : AppColors.lightBorder);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // Background circle
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1.0,
              strokeWidth: strokeWidth,
              valueColor: AlwaysStoppedAnimation(effectiveBackgroundColor),
            ),
          ),
          // Gradient progress
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _GradientCircularProgressPainter(
                progress: value,
                gradient: gradient ?? AppColors.primaryGradientLinear,
                strokeWidth: strokeWidth,
              ),
            ),
          ),
          // Child in center
          if (child != null)
            Center(child: child),
        ],
      ),
    );
  }
}

class _GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final Gradient gradient;
  final double strokeWidth;

  _GradientCircularProgressPainter({
    required this.progress,
    required this.gradient,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final startAngle = -90 * (3.14159 / 180);
    final sweepAngle = 360 * progress * (3.14159 / 180);

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect.deflate(strokeWidth / 2),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_GradientCircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Gradient badge
class GradientBadge extends StatelessWidget {
  final String label;
  final Gradient? gradient;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;

  const GradientBadge({
    super.key,
    required this.label,
    this.gradient,
    this.padding,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveGradient = gradient ?? AppColors.successGradientLinear;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: effectiveGradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: AppTypography.labelSmall.copyWith(color: Colors.white),
      ),
    );
  }
}
