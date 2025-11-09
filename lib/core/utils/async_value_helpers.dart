import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      loading: loading ?? () => const Center(child: CircularProgressIndicator()),
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
      loading: () => onLoading?.call() ?? const Center(child: CircularProgressIndicator()),
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

/// Reusable error display widget
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

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
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

/// Loading state widget with optional message
class LoadingDisplay extends StatelessWidget {
  final String? message;

  const LoadingDisplay({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Empty state widget
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
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
