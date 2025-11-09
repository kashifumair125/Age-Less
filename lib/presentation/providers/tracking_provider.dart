// lib/presentation/providers/tracking_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/daily_tracking.dart';
import '../../data/repositories/tracking_repository.dart';
import '../../core/services/error_service.dart';

final currentTrackingProvider = FutureProvider<DailyTracking?>((ref) async {
  try {
    final repository = ref.watch(trackingRepositoryProvider);
    final tracking = await repository.getTrackingForDate(DateTime.now());

    return tracking;
  } catch (error, stackTrace) {
    ErrorService.logError(error, stackTrace, context: 'currentTrackingProvider');
    rethrow;
  }
});

class SelectedDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    return DateTime.now();
  }

  void updateDate(DateTime newDate) {
    state = newDate;
  }
}

final selectedDateProvider = NotifierProvider<SelectedDateNotifier, DateTime>(
  () => SelectedDateNotifier(),
);
