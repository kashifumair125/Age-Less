// lib/data/repositories/tracking_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/daily_tracking.dart';
import '../../core/services/error_service.dart';
import '../local/hive_config.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepository();
});

class TrackingRepository {
  /// Get tracking data for a specific date
  Future<DailyTracking?> getTrackingForDate(DateTime date) async {
    try {
      final box = HiveConfig.dailyTrackingBox;
      final dateKey = _getDateKey(date);

      // Direct lookup by key is O(1) - much faster than iteration
      final tracking = box.get(dateKey);
      return tracking;
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'TrackingRepository.getTrackingForDate',
        metadata: {'date': date.toIso8601String()},
      );
      return null;
    }
  }

  /// Save tracking data
  Future<void> saveTracking(DailyTracking tracking) async {
    try {
      final box = HiveConfig.dailyTrackingBox;
      // Use date key as identifier since DailyTracking has no id field
      await box.put(_getDateKey(tracking.date), tracking);
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'TrackingRepository.saveTracking',
      );
      throw DataException(
        'Failed to save tracking data',
        code: 'SAVE_FAILED',
        details: error,
      );
    }
  }

  /// Get tracking data for a date range (inclusive)
  Future<List<DailyTracking>> getTrackingRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final box = HiveConfig.dailyTrackingBox;

      // Optimize: Filter dates efficiently
      final results = <DailyTracking>[];
      for (final tracking in box.values) {
        // Use normalized date comparison for better accuracy
        final trackingDate = _normalizeDate(tracking.date);
        final normalizedStart = _normalizeDate(start);
        final normalizedEnd = _normalizeDate(end);

        if ((trackingDate.isAfter(normalizedStart) ||
                trackingDate.isAtSameMomentAs(normalizedStart)) &&
            (trackingDate.isBefore(normalizedEnd) ||
                trackingDate.isAtSameMomentAs(normalizedEnd))) {
          results.add(tracking);
        }
      }

      // Sort by date for consistency
      results.sort((a, b) => a.date.compareTo(b.date));
      return results;
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'TrackingRepository.getTrackingRange',
        metadata: {
          'start': start.toIso8601String(),
          'end': end.toIso8601String(),
        },
      );
      return [];
    }
  }

  /// Get all tracking data
  Future<List<DailyTracking>> getAllTracking() async {
    try {
      final box = HiveConfig.dailyTrackingBox;
      final allTracking = box.values.toList();

      // Sort by date
      allTracking.sort((a, b) => a.date.compareTo(b.date));
      return allTracking;
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'TrackingRepository.getAllTracking',
      );
      return [];
    }
  }

  /// Get today's tracking data
  Future<DailyTracking?> getTodayTracking() async {
    return await getTrackingForDate(DateTime.now());
  }

  /// Delete tracking data for a specific date
  Future<void> deleteTracking(DateTime date) async {
    try {
      final box = HiveConfig.dailyTrackingBox;
      await box.delete(_getDateKey(date));
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'TrackingRepository.deleteTracking',
      );
      throw DataException(
        'Failed to delete tracking data',
        code: 'DELETE_FAILED',
        details: error,
      );
    }
  }

  /// Get count of tracking entries
  Future<int> getTrackingCount() async {
    try {
      final box = HiveConfig.dailyTrackingBox;
      return box.length;
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'TrackingRepository.getTrackingCount',
      );
      return 0;
    }
  }

  /// Normalize date to start of day for accurate comparisons
  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Generate consistent date key
  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
