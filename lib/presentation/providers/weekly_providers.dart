// lib/presentation/providers/weekly_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../data/repositories/tracking_repository.dart';
import '../../domain/models/daily_tracking.dart';
import '../../core/services/error_service.dart';

class WeeklySummary {
  final DateTime start;
  final DateTime end;
  final double averageCalories;
  final double averageExerciseMinutes;
  final double averageSleepHours;
  final double adherencePercent; // percent of days meeting goals

  const WeeklySummary({
    required this.start,
    required this.end,
    required this.averageCalories,
    required this.averageExerciseMinutes,
    required this.averageSleepHours,
    required this.adherencePercent,
  });
}

class AdherencePoint {
  final String dayLabel; // e.g. Mon, Tue
  final double value; // 0..1 adherence for that day
  const AdherencePoint(this.dayLabel, this.value);
}

final weeklySummaryProvider = FutureProvider<WeeklySummary>((ref) async {
  try {
    final repo = ref.watch(trackingRepositoryProvider);
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6));
    final data = await repo.getTrackingRange(
      DateTime(start.year, start.month, start.day, 0, 0, 0),
      DateTime(now.year, now.month, now.day, 23, 59, 59),
    );

    if (data.isEmpty) {
      return WeeklySummary(
        start: start,
        end: now,
        averageCalories: 0,
        averageExerciseMinutes: 0,
        averageSleepHours: 0,
        adherencePercent: 0,
      );
    }

    double calories = 0;
    double exercise = 0;
    double sleep = 0;
    int adherentDays = 0;

    for (final d in data) {
      final cals = d.nutrition?.caloriesConsumed ?? 0;
      final exMin = d.exercise?.totalMinutes ?? 0;
      final slp = d.sleep?.hoursSlept ?? 0;

      calories += cals;
      exercise += exMin;
      sleep += slp;

      final metCalories = cals <= 2200 && cals >= 1500; // simple bounds
      final metExercise = exMin >= 30;
      final metSleep = slp >= 7.0;
      if (metCalories && metExercise && metSleep) adherentDays += 1;
    }

    final days = data.length;
    return WeeklySummary(
      start: start,
      end: now,
      averageCalories: calories / days,
      averageExerciseMinutes: exercise / days,
      averageSleepHours: sleep / days,
      adherencePercent: (adherentDays / days) * 100,
    );
  } catch (error, stackTrace) {
    ErrorService.logError(error, stackTrace, context: 'weeklySummaryProvider');
    // Return empty summary on error
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6));
    return WeeklySummary(
      start: start,
      end: now,
      averageCalories: 0,
      averageExerciseMinutes: 0,
      averageSleepHours: 0,
      adherencePercent: 0,
    );
  }
});

final adherenceSeriesProvider =
    FutureProvider<List<AdherencePoint>>((ref) async {
  try {
    final repo = ref.watch(trackingRepositoryProvider);
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6));
    final data = await repo.getTrackingRange(
      DateTime(start.year, start.month, start.day, 0, 0, 0),
      DateTime(now.year, now.month, now.day, 23, 59, 59),
    );

    final byDay = <String, DailyTracking?>{};
    for (int i = 0; i < 7; i++) {
      final d = start.add(Duration(days: i));
      byDay[DateFormat('EEE').format(d)] = null;
    }
    for (final t in data) {
      final label = DateFormat('EEE').format(t.date);
      byDay[label] = t;
    }

    return byDay.entries.map((e) {
      final t = e.value;
      if (t == null) return AdherencePoint(e.key, 0);
      final metCalories = (t.nutrition?.caloriesConsumed ?? 0) <= 2200 &&
          (t.nutrition?.caloriesConsumed ?? 0) >= 1500;
      final metExercise = (t.exercise?.totalMinutes ?? 0) >= 30;
      final metSleep = (t.sleep?.hoursSlept ?? 0) >= 7.0;
      final score =
          [metCalories, metExercise, metSleep].where((x) => x).length / 3.0;
      return AdherencePoint(e.key, score);
    }).toList();
  } catch (error, stackTrace) {
    ErrorService.logError(error, stackTrace, context: 'adherenceSeriesProvider');
    // Return empty series on error
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 6));
    return List.generate(7, (i) {
      final d = start.add(Duration(days: i));
      return AdherencePoint(DateFormat('EEE').format(d), 0);
    });
  }
});
