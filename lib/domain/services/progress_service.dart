// lib/domain/services/progress_service.dart
import '../../core/services/error_service.dart';
import '../models/daily_tracking.dart';
import '../models/progress_metrics.dart';

class ProgressService {
  /// Calculate progress metrics from tracking history
  ProgressMetrics calculateProgress({
    required List<DailyTracking> trackingHistory,
    required double initialBiologicalAge,
    required double currentBiologicalAge,
  }) {
    try {
      // Validate inputs
      if (initialBiologicalAge < 0 || currentBiologicalAge < 0) {
        throw const ValidationException(
          'Biological ages must be non-negative',
          code: 'INVALID_AGE',
        );
      }

      final now = DateTime.now();
      final startDate =
          trackingHistory.isEmpty ? now : trackingHistory.first.date;

    // Calculate category trends
    final categoryTrends = _calculateCategoryTrends(trackingHistory);

    // Calculate streaks
    final streaks = _calculateStreaks(trackingHistory);

    // Generate achievements
    final achievements = _generateAchievements(trackingHistory, streaks);

      return ProgressMetrics(
        startDate: startDate,
        currentDate: now,
        initialBiologicalAge: initialBiologicalAge,
        currentBiologicalAge: currentBiologicalAge,
        ageReduction: initialBiologicalAge - currentBiologicalAge,
        categoryTrends: categoryTrends,
        achievements: achievements,
        currentStreak: streaks['current']!,
        longestStreak: streaks['longest']!,
      );
    } catch (error, stackTrace) {
      ErrorService.logError(
        error,
        stackTrace,
        context: 'ProgressService.calculateProgress',
      );
      rethrow;
    }
  }

  Map<String, List<DataPoint>> _calculateCategoryTrends(
    List<DailyTracking> history,
  ) {
    final trends = <String, List<DataPoint>>{
      'nutrition': [],
      'exercise': [],
      'sleep': [],
      'stress': [],
    };

    for (var tracking in history) {
      // Nutrition score
      if (tracking.nutrition != null) {
        final score = _calculateNutritionScore(tracking.nutrition!);
        trends['nutrition']!.add(DataPoint(
          date: tracking.date,
          value: score,
        ));
      }

      // Exercise score
      if (tracking.exercise != null) {
        final score = _calculateExerciseScore(tracking.exercise!);
        trends['exercise']!.add(DataPoint(
          date: tracking.date,
          value: score,
        ));
      }

      // Sleep score
      if (tracking.sleep != null) {
        final score = _calculateSleepScore(tracking.sleep!);
        trends['sleep']!.add(DataPoint(
          date: tracking.date,
          value: score,
        ));
      }

      // Stress score (inverted - lower is better)
      if (tracking.stress != null) {
        final score = 10 - tracking.stress!.stressLevel.toDouble();
        trends['stress']!.add(DataPoint(
          date: tracking.date,
          value: score,
        ));
      }
    }

    return trends;
  }

  double _calculateNutritionScore(NutritionLog nutrition) {
    try {
      double score = 0.0;

      // Calorie adherence (0-3 points)
      final calorieTarget = 2000;
      final calorieAdherence =
          1 - (nutrition.caloriesConsumed - calorieTarget).abs() / calorieTarget;
      score += (calorieAdherence * 3).clamp(0, 3);

      // Vegetable intake (0-3 points)
      score += ((nutrition.vegetables / 7) * 3).clamp(0, 3);

      // Fasting (0-2 points)
      score += nutrition.fastingCompleted ? 2 : 0;

      // Protein adequacy (0-2 points)
      score += ((nutrition.proteinGrams / 150) * 2).clamp(0, 2);

      return score.clamp(0, 10);
    } catch (error) {
      // Return neutral score on calculation error
      return 5.0;
    }
  }

  double _calculateExerciseScore(ExerciseLog exercise) {
    try {
      double score = 0.0;

      // Total minutes (0-5 points)
      score += ((exercise.totalMinutes / 60) * 5).clamp(0, 5);

      // Variety bonus (0-3 points)
      final uniqueTypes = exercise.sessions.map((s) => s.type).toSet().length;
      score += (uniqueTypes * 1.0).clamp(0, 3);

      // Intensity (0-2 points)
      final avgIntensity = exercise.sessions.isEmpty
          ? 0.0
          : exercise.sessions.map((s) => s.intensity).reduce((a, b) => a + b) /
              exercise.sessions.length;
      score += ((avgIntensity / 10) * 2).clamp(0, 2);

      return score.clamp(0, 10);
    } catch (error) {
      // Return neutral score on calculation error
      return 5.0;
    }
  }

  double _calculateSleepScore(SleepLog sleep) {
    try {
      double score = 0.0;

      // Duration (0-5 points) - optimal 7-9 hours
      if (sleep.hoursSlept >= 7 && sleep.hoursSlept <= 9) {
        score += 5;
      } else {
        score += 3;
      }

      // Quality (0-5 points)
      score += ((sleep.sleepQuality / 10) * 5).clamp(0, 5);

      return score.clamp(0, 10);
    } catch (error) {
      // Return neutral score on calculation error
      return 5.0;
    }
  }

  Map<String, int> _calculateStreaks(List<DailyTracking> history) {
    if (history.isEmpty) {
      return {'current': 0, 'longest': 0};
    }

    int currentStreak = 0;
    int longestStreak = 0;
    int tempStreak = 0;

    // Sort by date
    final sorted = List<DailyTracking>.from(history)
      ..sort((a, b) => a.date.compareTo(b.date));

    DateTime? lastDate;
    final now = DateTime.now();

    for (var tracking in sorted) {
      if (lastDate == null) {
        tempStreak = 1;
      } else {
        final daysDiff = tracking.date.difference(lastDate).inDays;
        if (daysDiff == 1) {
          tempStreak++;
        } else if (daysDiff > 1) {
          // Break in streak
          if (tempStreak > longestStreak) {
            longestStreak = tempStreak;
          }
          tempStreak = 1;
        }
      }
      lastDate = tracking.date;
    }

    // finalize
    if (tempStreak > longestStreak) {
      longestStreak = tempStreak;
    }

    if (lastDate != null && now.difference(lastDate).inDays <= 1) {
      currentStreak = tempStreak;
    }

    return {'current': currentStreak, 'longest': longestStreak};
  }

  List<Achievement> _generateAchievements(
    List<DailyTracking> history,
    Map<String, int> streaks,
  ) {
    final achievements = <Achievement>[];

    // Streak achievements
    if (streaks['current']! >= 7) {
      achievements.add(Achievement(
        id: 'streak_7',
        title: '7 Day Streak',
        description: 'Logged consistently for 7 days',
        icon: '🔥',
        unlockedAt: DateTime.now(),
        points: 50,
      ));
    }

    if (streaks['longest']! >= 30) {
      achievements.add(Achievement(
        id: 'streak_30',
        title: '30 Day Streak',
        description: 'Logged consistently for 30 days',
        icon: '🏆',
        unlockedAt: DateTime.now(),
        points: 200,
      ));
    }

    // Exercise achievements
    final totalWorkouts = history
        .where((t) => t.exercise != null)
        .map((t) => t.exercise!.sessions.length)
        .fold(0, (a, b) => a + b);

    if (totalWorkouts >= 50) {
      achievements.add(Achievement(
        id: 'workout_50',
        title: 'Workout Warrior',
        description: 'Completed 50 workouts',
        icon: '💪',
        unlockedAt: DateTime.now(),
        points: 150,
      ));
    }

    return achievements;
  }
}
