// lib/presentation/providers/tracking_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/daily_tracking.dart';
import '../../data/repositories/tracking_repository.dart';

final currentTrackingProvider = FutureProvider<DailyTracking?>((ref) async {
  final repository = ref.watch(trackingRepositoryProvider);
  return await repository.getTrackingForDate(DateTime.now());
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
