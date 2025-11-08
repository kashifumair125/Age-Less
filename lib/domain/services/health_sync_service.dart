// lib/domain/services/health_sync_service.dart
import 'package:health/health.dart';
import '../models/daily_tracking.dart';

class HealthSyncService {
  final Health _health = Health();

  /// Request permissions for health data access
  Future<bool> requestPermissions() async {
    final types = [
      HealthDataType.STEPS,
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.SLEEP_ASLEEP,
      HealthDataType.WEIGHT,
      HealthDataType.HEIGHT,
      HealthDataType.HEART_RATE,
      HealthDataType.WORKOUT,
    ];

    final permissions = types.map((type) => HealthDataAccess.READ).toList();

    try {
      final requested = await _health.requestAuthorization(types, permissions: permissions);
      return requested;
    } catch (e) {
      print('Error requesting health permissions: $e');
      return false;
    }
  }

  /// Check if health data access is authorized
  Future<bool> isAuthorized() async {
    try {
      final hasPermissions = await _health.hasPermissions([
        HealthDataType.STEPS,
        HealthDataType.ACTIVE_ENERGY_BURNED,
      ]);
      return hasPermissions ?? false;
    } catch (e) {
      print('Error checking health permissions: $e');
      return false;
    }
  }

  /// Fetch health data for a specific date
  Future<HealthDataSummary?> fetchHealthData(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      // Fetch steps
      final stepsData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.STEPS],
        startTime: startOfDay,
        endTime: endOfDay,
      );
      final totalSteps = stepsData
          .where((data) => data.type == HealthDataType.STEPS)
          .fold<int>(0, (sum, data) => sum + (data.value as NumericHealthValue).numericValue.toInt());

      // Fetch active calories
      final caloriesData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
        startTime: startOfDay,
        endTime: endOfDay,
      );
      final totalCalories = caloriesData
          .where((data) => data.type == HealthDataType.ACTIVE_ENERGY_BURNED)
          .fold<double>(0, (sum, data) => sum + (data.value as NumericHealthValue).numericValue);

      // Fetch sleep
      final sleepData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.SLEEP_ASLEEP, HealthDataType.SLEEP_IN_BED],
        startTime: startOfDay,
        endTime: endOfDay,
      );

      double sleepHours = 0;
      if (sleepData.isNotEmpty) {
        for (var data in sleepData) {
          if (data.type == HealthDataType.SLEEP_ASLEEP) {
            final value = data.value as NumericHealthValue;
            sleepHours += value.numericValue / 60; // Convert minutes to hours
          }
        }
      }

      // Fetch workouts
      final workoutsData = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WORKOUT],
        startTime: startOfDay,
        endTime: endOfDay,
      );
      final totalWorkoutMinutes = workoutsData
          .where((data) => data.type == HealthDataType.WORKOUT)
          .fold<double>(0, (sum, data) {
            final workout = data.value as WorkoutHealthValue;
            return sum + (workout.totalEnergyBurned ?? 0) / 5; // Rough estimate
          });

      return HealthDataSummary(
        steps: totalSteps,
        activeCalories: totalCalories.toInt(),
        sleepHours: sleepHours,
        workoutMinutes: totalWorkoutMinutes.toInt(),
        date: date,
      );
    } catch (e) {
      print('Error fetching health data: $e');
      return null;
    }
  }

  /// Sync health data for the last N days
  Future<List<HealthDataSummary>> syncLastDays(int days) async {
    final summaries = <HealthDataSummary>[];

    for (var i = 0; i < days; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final summary = await fetchHealthData(date);
      if (summary != null) {
        summaries.add(summary);
      }
    }

    return summaries;
  }

  /// Convert health data summary to DailyTracking update
  Map<String, dynamic> healthDataToTrackingUpdate(HealthDataSummary summary) {
    return {
      'exercise': {
        'totalMinutes': summary.workoutMinutes,
        'sessions': [], // Could be enhanced with actual workout sessions
      },
      'sleep': {
        'hoursSlept': summary.sleepHours,
        'sleepQuality': summary.sleepHours >= 7 ? 8.0 : 6.0, // Rough estimate
      },
      'steps': summary.steps,
      'activeCalories': summary.activeCalories,
    };
  }
}

class HealthDataSummary {
  final int steps;
  final int activeCalories;
  final double sleepHours;
  final int workoutMinutes;
  final DateTime date;

  HealthDataSummary({
    required this.steps,
    required this.activeCalories,
    required this.sleepHours,
    required this.workoutMinutes,
    required this.date,
  });
}
