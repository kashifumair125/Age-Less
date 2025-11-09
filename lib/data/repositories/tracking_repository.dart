// lib/data/repositories/tracking_repository.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/daily_tracking.dart';
import '../local/hive_config.dart';

final trackingRepositoryProvider = Provider<TrackingRepository>((ref) {
  return TrackingRepository();
});

class TrackingRepository {
  Future<DailyTracking?> getTrackingForDate(DateTime date) async {
    final box = HiveConfig.dailyTrackingBox;
    final dateKey = _getDateKey(date);

    for (final tracking in box.values) {
      if (_getDateKey(tracking.date) == dateKey) {
        return tracking;
      }
    }
    return null;
  }

  Future<void> saveTracking(DailyTracking tracking) async {
    final box = HiveConfig.dailyTrackingBox;
    // Use date key as identifier since DailyTracking has no id field
    await box.put(_getDateKey(tracking.date), tracking);
  }

  Future<List<DailyTracking>> getTrackingRange(
    DateTime start,
    DateTime end,
  ) async {
    final box = HiveConfig.dailyTrackingBox;
    return box.values.where((tracking) {
      return tracking.date.isAfter(start) && tracking.date.isBefore(end);
    }).toList();
  }

  Future<List<DailyTracking>> getAllTracking() async {
    final box = HiveConfig.dailyTrackingBox;
    return box.values.toList();
  }

  Future<DailyTracking?> getTodayTracking() async {
    return await getTrackingForDate(DateTime.now());
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}
