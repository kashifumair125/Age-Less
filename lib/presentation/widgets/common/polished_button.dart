import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/haptic_feedback_service.dart';
import '../../../core/utils/animations.dart';

/// Elevated button with haptic feedback and animations
class PolishedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const PolishedButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.backgroundColor,
    this.foregroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = icon != null
        ? ElevatedButton.icon(
            onPressed: isLoading ? null : _handlePress,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Icon(icon),
            label: Text(label),
            style: _getButtonStyle(context),
          )
        : ElevatedButton(
            onPressed: isLoading ? null : _handlePress,
            style: _getButtonStyle(context),
            child: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(label),
          );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  ButtonStyle _getButtonStyle(BuildContext context) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppTheme.primaryColor,
      foregroundColor: foregroundColor ?? Colors.white,
      elevation: AppElevation.small,
      shadowColor: (backgroundColor ?? AppTheme.primaryColor).withOpacity(0.3),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppBorderRadius.medium,
      ),
    );
  }

  void _handlePress() {
    HapticFeedbackService.lightImpact();
    onPressed?.call();
  }
}

/// Outlined button with haptic feedback
class PolishedOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool fullWidth;

  const PolishedOutlinedButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.icon,
    this.fullWidth = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = icon != null
        ? OutlinedButton.icon(
            onPressed: _handlePress,
            icon: Icon(icon),
            label: Text(label),
          )
        : OutlinedButton(
            onPressed: _handlePress,
            child: Text(label),
          );

    if (fullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  void _handlePress() {
    HapticFeedbackService.selectionClick();
    onPressed?.call();
  }
}

/// Icon button with haptic feedback and scale animation
class PolishedIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final double size;
  final String? tooltip;

  const PolishedIconButton({
    Key? key,
    required this.icon,
    this.onPressed,
    this.color,
    this.size = 24,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      icon: Icon(icon, size: size),
      onPressed: _handlePress,
      color: color ?? AppTheme.primaryColor,
      tooltip: tooltip,
    );

    return ScaleButton(
      onPressed: _handlePress,
      child: button,
    );
  }

  void _handlePress() {
    HapticFeedbackService.selectionClick();
    onPressed?.call();
  }
}

/// Floating action button with haptic feedback
class PolishedFAB extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final String? label;
  final bool isExtended;

  const PolishedFAB({
    Key? key,
    required this.icon,
    this.onPressed,
    this.label,
    this.isExtended = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isExtended && label != null) {
      return FloatingActionButton.extended(
        onPressed: _handlePress,
        icon: Icon(icon),
        label: Text(label!),
        elevation: AppElevation.medium,
      );
    }

    return FloatingActionButton(
      onPressed: _handlePress,
      child: Icon(icon),
      elevation: AppElevation.medium,
    );
  }

  void _handlePress() {
    HapticFeedbackService.mediumImpact();
    onPressed?.call();
  }
}

/// Chip button with selection animation
class PolishedChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;
  final IconData? icon;

  const PolishedChip({
    Key? key,
    required this.label,
    this.isSelected = false,
    this.onTap,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onPressed: _handlePress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor
              : AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: AppBorderRadius.full,
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.white : AppTheme.primaryColor,
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            Text(
              label,
              style: AppTextStyles.body2.copyWith(
                color: isSelected ? Colors.white : AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePress() {
    HapticFeedbackService.selectionClick();
    onTap?.call();
  }
}

/// Card button with subtle animation
class PolishedCardButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;

  const PolishedCardButton({
    Key? key,
    required this.child,
    this.onTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleButton(
      onPressed: _handlePress,
      scaleValue: 0.98,
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: AppBorderRadius.large,
          boxShadow: AppShadows.small,
        ),
        child: child,
      ),
    );
  }

  void _handlePress() {
    HapticFeedbackService.lightImpact();
    onTap?.call();
  }
}
