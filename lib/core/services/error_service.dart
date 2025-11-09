import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Centralized error handling and reporting service
class ErrorService {
  /// Log an error with context
  static void logError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
    Map<String, dynamic>? metadata,
  }) {
    // Log to console in debug mode
    if (kDebugMode) {
      developer.log(
        'Error${context != null ? ' in $context' : ''}',
        error: error,
        stackTrace: stackTrace,
        name: 'ErrorService',
      );
      if (metadata != null) {
        developer.log('Metadata: $metadata', name: 'ErrorService');
      }
    }

    // TODO: In production, send to error reporting service (e.g., Sentry, Crashlytics)
    // Example:
    // if (kReleaseMode) {
    //   Sentry.captureException(error, stackTrace: stackTrace);
    // }
  }

  /// Get user-friendly error message from exception
  static String getUserFriendlyMessage(Object error) {
    if (error is AppException) {
      return error.message;
    }

    if (error is StateError) {
      return error.message;
    }

    if (error is FormatException) {
      return 'Invalid data format. Please check your input.';
    }

    if (error is TypeError) {
      return 'Data type mismatch. Please contact support.';
    }

    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('socket')) {
      return 'Network connection error. Please check your internet connection.';
    }

    if (errorString.contains('permission')) {
      return 'Permission denied. Please grant the necessary permissions.';
    }

    if (errorString.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }

    if (errorString.contains('not found')) {
      return 'Requested data not found.';
    }

    if (errorString.contains('invalid')) {
      return 'Invalid operation. Please check your input.';
    }

    // Default fallback message
    return 'An unexpected error occurred. Please try again.';
  }

  /// Handle error and return user-friendly message
  static String handleError(
    Object error,
    StackTrace? stackTrace, {
    String? context,
  }) {
    logError(error, stackTrace, context: context);
    return getUserFriendlyMessage(error);
  }
}

/// Base class for custom app exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => message;
}

/// Data-related exceptions
class DataException extends AppException {
  const DataException(super.message, {super.code, super.details});
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(
    super.message, {
    super.code,
    this.fieldErrors,
  });
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code, super.details});
}

/// Permission-related exceptions
class PermissionException extends AppException {
  const PermissionException(super.message, {super.code, super.details});
}

/// Business logic exceptions
class BusinessLogicException extends AppException {
  const BusinessLogicException(super.message, {super.code, super.details});
}

/// Not found exceptions
class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.details});
}

/// Timeout exceptions
class TimeoutException extends AppException {
  const TimeoutException(super.message, {super.code, super.details});
}

/// Extension to add error handling to Future
extension FutureErrorHandling<T> on Future<T> {
  /// Wrap future with error handling
  Future<T> handleError({String? context}) {
    return catchError((error, stackTrace) {
      ErrorService.logError(error, stackTrace, context: context);
      throw error;
    });
  }

  /// Wrap future with error handling and return default value on error
  Future<T> handleErrorWithDefault(T defaultValue, {String? context}) {
    return catchError((error, stackTrace) {
      ErrorService.logError(error, stackTrace, context: context);
      return defaultValue;
    });
  }
}
