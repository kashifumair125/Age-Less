import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/animated_widgets.dart';

/// Extension methods for AsyncValue to simplify error/loading state handling
extension AsyncValueUI<T> on AsyncValue<T> {
  /// Show data with loading indicator when refreshing
  Widget when({
    required Widget Function(T data) data,
    Widget Function()? loading,
    Widget Function(Object error, StackTrace stackTrace)? error,
    bool skipLoadingOnRefresh = true,
    bool skipLoadingOnReload = false,
    bool skipError = false,
  }) {
    return this.when(
      data: data,
      loading: loading ?? () => const LoadingDisplay(),
      error: error ?? (err, stack) => ErrorDisplay(error: err, stackTrace: stack),
      skipLoadingOnRefresh: skipLoadingOnRefresh,
      skipLoadingOnReload: skipLoadingOnReload,
      skipError: skipError,
    );
  }

  /// Simplified pattern matching for AsyncValue
  Widget buildWidget({
    required Widget Function(T data) onData,
    Widget Function()? onLoading,
    Widget Function(Object error)? onError,
  }) {
    return when(
      data: onData,
      loading: () => onLoading?.call() ?? const LoadingDisplay(),
      error: (err, _) => onError?.call(err) ?? ErrorDisplay(error: err),
    );
  }

  /// Get data or null without throwing
  T? get valueOrNull {
    return when(
      data: (value) => value,
      loading: () => null,
      error: (_, __) => null,
    );
  }

  /// Check if has data (regardless of loading state)
  bool get hasData => hasValue;

  /// Get error or null
  Object? get errorOrNull {
    return when(
      data: (_) => null,
      loading: () => null,
      error: (err, _) => err,
    );
  }
}

/// Reusable error display widget with modern design
class ErrorDisplay extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;
  final VoidCallback? onRetry;

  const ErrorDisplay({
    super.key,
    required this.error,
    this.stackTrace,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final errorMessage = _getErrorMessage(error);

    return FadeInAnimation(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.errorSoft,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 48,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Something went wrong',
                style: AppTypography.h2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                errorMessage,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.lightTextSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradientLinear,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onRetry,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 14,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.refresh, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              'Try Again',
                              style: AppTypography.labelLarge
                                  .copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _getErrorMessage(Object error) {
    if (error is StateError) {
      return error.message;
    } else if (error is FormatException) {
      return 'Invalid data format';
    } else if (error is Exception) {
      final message = error.toString();
      if (message.contains('Exception:')) {
        return message.replaceFirst('Exception:', '').trim();
      }
      return message;
    }
    return 'An unexpected error occurred. Please try again.';
  }
}

/// Loading state widget with modern animated loader
class LoadingDisplay extends StatelessWidget {
  final String? message;

  const LoadingDisplay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const PulseLoader(size: 80),
          if (message != null) ...[
            const SizedBox(height: 24),
            Text(
              message!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.lightTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state widget with modern design
class EmptyDisplay extends StatelessWidget {
  final String title;
  final String? message;
  final IconData icon;
  final Widget? action;

  const EmptyDisplay({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FadeInAnimation(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.primaryLight.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 64,
                  color: AppColors.primary.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: AppTypography.h2,
                textAlign: TextAlign.center,
              ),
              if (message != null) ...[
                const SizedBox(height: 12),
                Text(
                  message!,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              if (action != null) ...[
                const SizedBox(height: 32),
                action!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
