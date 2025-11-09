import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/animations.dart';

class ErrorState extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final bool isOffline;

  const ErrorState({
    Key? key,
    required this.title,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.isOffline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedEntrance(
              delay: const Duration(milliseconds: 100),
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isOffline ? Icons.wifi_off : icon,
                  size: 60,
                  color: AppTheme.errorColor.withOpacity(0.7),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 200),
              child: Text(
                title,
                style: AppTextStyles.h3.copyWith(
                  color: AppTheme.grey800,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AnimatedEntrance(
              delay: const Duration(milliseconds: 300),
              child: Text(
                message,
                style: AppTextStyles.body2.copyWith(
                  color: AppTheme.grey600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AnimatedEntrance(
                delay: const Duration(milliseconds: 400),
                child: ElevatedButton.icon(
                  onPressed: onRetry,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Preset error states
class ErrorStates {
  static Widget networkError({VoidCallback? onRetry}) {
    return ErrorState(
      title: 'No Internet Connection',
      message: 'Please check your connection and try again',
      onRetry: onRetry,
      isOffline: true,
    );
  }

  static Widget serverError({VoidCallback? onRetry}) {
    return ErrorState(
      title: 'Something Went Wrong',
      message: 'We encountered an error. Please try again later',
      onRetry: onRetry,
      icon: Icons.cloud_off_outlined,
    );
  }

  static Widget notFound() {
    return const ErrorState(
      title: 'Not Found',
      message: 'The requested resource could not be found',
      icon: Icons.search_off,
    );
  }

  static Widget custom({
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    return ErrorState(
      title: title,
      message: message,
      onRetry: onRetry,
    );
  }
}

/// Inline error banner
class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final VoidCallback? onRetry;

  const ErrorBanner({
    Key? key,
    required this.message,
    this.onDismiss,
    this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.errorColor.withOpacity(0.1),
        borderRadius: AppBorderRadius.medium,
        border: Border.all(
          color: AppTheme.errorColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: AppTheme.errorColor,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body2.copyWith(
                color: AppTheme.errorColor,
              ),
            ),
          ),
          if (onRetry != null)
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: 20,
              onPressed: onDismiss,
              color: AppTheme.errorColor,
            ),
        ],
      ),
    );
  }
}

/// Success banner
class SuccessBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;

  const SuccessBanner({
    Key? key,
    required this.message,
    this.onDismiss,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withOpacity(0.1),
        borderRadius: AppBorderRadius.medium,
        border: Border.all(
          color: AppTheme.successColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppTheme.successColor,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body2.copyWith(
                color: AppTheme.successColor,
              ),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: 20,
              onPressed: onDismiss,
              color: AppTheme.successColor,
            ),
        ],
      ),
    );
  }
}

/// Warning banner
class WarningBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onDismiss;
  final VoidCallback? onAction;
  final String? actionLabel;

  const WarningBanner({
    Key? key,
    required this.message,
    this.onDismiss,
    this.onAction,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withOpacity(0.1),
        borderRadius: AppBorderRadius.medium,
        border: Border.all(
          color: AppTheme.warningColor.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppTheme.warningColor,
            size: 24,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.body2.copyWith(
                color: AppTheme.warningColor.withOpacity(0.9),
              ),
            ),
          ),
          if (onAction != null && actionLabel != null)
            TextButton(
              onPressed: onAction,
              child: Text(actionLabel!),
            ),
          if (onDismiss != null)
            IconButton(
              icon: const Icon(Icons.close),
              iconSize: 20,
              onPressed: onDismiss,
              color: AppTheme.warningColor,
            ),
        ],
      ),
    );
  }
}
