import 'package:flutter_test/flutter_test.dart';
import 'package:age_less/domain/services/progress_service.dart';
import 'package:age_less/domain/models/daily_tracking.dart';
import 'package:age_less/core/services/error_service.dart';

void main() {
  group('ProgressService', () {
    late ProgressService service;

    setUp(() {
      service = ProgressService();
    });

    group('calculateProgress', () {
      test('should calculate progress with empty tracking history', () {
        final metrics = service.calculateProgress(
          trackingHistory: [],
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        expect(metrics.currentStreak, equals(0));
        expect(metrics.longestStreak, equals(0));
        expect(metrics.ageReduction, equals(2.0));
        expect(metrics.initialBiologicalAge, equals(35.0));
        expect(metrics.currentBiologicalAge, equals(33.0));
      });

      test('should calculate progress with single day tracking', () {
        final tracking = [
          DailyTracking(
            date: DateTime(2024, 1, 1),
            nutrition: NutritionLog(
              caloriesConsumed: 2000,
              proteinGrams: 150,
              vegetables: 5,
              fastingCompleted: true,
            ),
          ),
        ];

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        expect(metrics.categoryTrends['nutrition'], isNotEmpty);
        expect(metrics.currentStreak, greaterThanOrEqualTo(0));
      });

      test('should calculate consecutive streak correctly', () {
        final tracking = [
          DailyTracking(date: DateTime(2024, 1, 1)),
          DailyTracking(date: DateTime(2024, 1, 2)),
          DailyTracking(date: DateTime(2024, 1, 3)),
          DailyTracking(date: DateTime.now().subtract(const Duration(days: 1))),
          DailyTracking(date: DateTime.now()),
        ];

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        // Should have a current streak since we have today's data
        expect(metrics.currentStreak, greaterThanOrEqualTo(1));
      });

      test('should calculate longest streak with gaps', () {
        final tracking = [
          // First streak: 3 days
          DailyTracking(date: DateTime(2024, 1, 1)),
          DailyTracking(date: DateTime(2024, 1, 2)),
          DailyTracking(date: DateTime(2024, 1, 3)),
          // Gap
          // Second streak: 5 days (longest)
          DailyTracking(date: DateTime(2024, 1, 10)),
          DailyTracking(date: DateTime(2024, 1, 11)),
          DailyTracking(date: DateTime(2024, 1, 12)),
          DailyTracking(date: DateTime(2024, 1, 13)),
          DailyTracking(date: DateTime(2024, 1, 14)),
          // Gap
          // Third streak: 2 days
          DailyTracking(date: DateTime(2024, 1, 20)),
          DailyTracking(date: DateTime(2024, 1, 21)),
        ];

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        expect(metrics.longestStreak, equals(5));
      });

      test('should calculate nutrition score correctly', () {
        final tracking = [
          DailyTracking(
            date: DateTime(2024, 1, 1),
            nutrition: NutritionLog(
              caloriesConsumed: 2000,
              proteinGrams: 150,
              vegetables: 7,
              fastingCompleted: true,
            ),
          ),
        ];

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        final nutritionTrend = metrics.categoryTrends['nutrition']!;
        expect(nutritionTrend.length, equals(1));
        expect(nutritionTrend.first.value, greaterThan(7.0)); // Should be high score
      });

      test('should calculate exercise score correctly', () {
        final tracking = [
          DailyTracking(
            date: DateTime(2024, 1, 1),
            exercise: ExerciseLog(
              totalMinutes: 60,
              sessions: [
                WorkoutSession(
                  type: 'cardio',
                  durationMinutes: 30,
                  intensity: 8,
                ),
                WorkoutSession(
                  type: 'strength',
                  durationMinutes: 30,
                  intensity: 7,
                ),
              ],
            ),
          ),
        ];

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        final exerciseTrend = metrics.categoryTrends['exercise']!;
        expect(exerciseTrend.length, equals(1));
        expect(exerciseTrend.first.value, greaterThan(5.0));
      });

      test('should calculate sleep score correctly', () {
        final tracking = [
          DailyTracking(
            date: DateTime(2024, 1, 1),
            sleep: SleepLog(
              hoursSlept: 8.0,
              sleepQuality: 9,
              bedTime: DateTime(2024, 1, 1, 22, 0),
              wakeTime: DateTime(2024, 1, 2, 6, 0),
            ),
          ),
        ];

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        final sleepTrend = metrics.categoryTrends['sleep']!;
        expect(sleepTrend.length, equals(1));
        expect(sleepTrend.first.value, greaterThan(7.0)); // Good sleep score
      });

      test('should calculate stress score correctly (inverted)', () {
        final tracking = [
          DailyTracking(
            date: DateTime(2024, 1, 1),
            stress: StressLog(
              stressLevel: 3, // Low stress (good)
              meditationMinutes: 20,
              notes: 'Feeling good',
            ),
          ),
        ];

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        final stressTrend = metrics.categoryTrends['stress']!;
        expect(stressTrend.length, equals(1));
        expect(stressTrend.first.value, equals(7.0)); // 10 - 3 = 7
      });

      test('should generate 7-day streak achievement', () {
        final tracking = List.generate(
          7,
          (i) => DailyTracking(
            date: DateTime.now().subtract(Duration(days: 6 - i)),
          ),
        );

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        final streak7Achievement = metrics.achievements.any(
          (a) => a.id == 'streak_7',
        );
        expect(streak7Achievement, isTrue);
      });

      test('should generate 30-day streak achievement', () {
        final tracking = List.generate(
          30,
          (i) => DailyTracking(
            date: DateTime.now().subtract(Duration(days: 29 - i)),
          ),
        );

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        final streak30Achievement = metrics.achievements.any(
          (a) => a.id == 'streak_30',
        );
        expect(streak30Achievement, isTrue);
      });

      test('should generate workout achievement', () {
        final tracking = List.generate(
          50,
          (i) => DailyTracking(
            date: DateTime(2024, 1, i + 1),
            exercise: ExerciseLog(
              totalMinutes: 30,
              sessions: [
                WorkoutSession(
                  type: 'cardio',
                  durationMinutes: 30,
                  intensity: 7,
                ),
              ],
            ),
          ),
        );

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        final workoutAchievement = metrics.achievements.any(
          (a) => a.id == 'workout_50',
        );
        expect(workoutAchievement, isTrue);
      });

      test('should throw ValidationException for negative biological age', () {
        expect(
          () => service.calculateProgress(
            trackingHistory: [],
            initialBiologicalAge: -5.0,
            currentBiologicalAge: 33.0,
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('should handle tracking history with missing data gracefully', () {
        final tracking = [
          DailyTracking(date: DateTime(2024, 1, 1)),
          DailyTracking(
            date: DateTime(2024, 1, 2),
            nutrition: NutritionLog(
              caloriesConsumed: 2000,
              proteinGrams: 100,
              vegetables: 3,
              fastingCompleted: false,
            ),
          ),
          DailyTracking(date: DateTime(2024, 1, 3)),
        ];

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        // Should only have data point for day 2
        expect(metrics.categoryTrends['nutrition']!.length, equals(1));
      });

      test('should calculate age reduction correctly', () {
        final metrics = service.calculateProgress(
          trackingHistory: [],
          initialBiologicalAge: 40.0,
          currentBiologicalAge: 36.0,
        );

        expect(metrics.ageReduction, equals(4.0));
      });

      test('should handle negative age reduction (aging)', () {
        final metrics = service.calculateProgress(
          trackingHistory: [],
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 38.0,
        );

        expect(metrics.ageReduction, equals(-3.0));
      });

      test('should sort tracking history by date correctly', () {
        final tracking = [
          DailyTracking(date: DateTime(2024, 1, 5)),
          DailyTracking(date: DateTime(2024, 1, 1)),
          DailyTracking(date: DateTime(2024, 1, 3)),
          DailyTracking(date: DateTime(2024, 1, 2)),
          DailyTracking(date: DateTime(2024, 1, 4)),
        ];

        final metrics = service.calculateProgress(
          trackingHistory: tracking,
          initialBiologicalAge: 35.0,
          currentBiologicalAge: 33.0,
        );

        expect(metrics.startDate.day, equals(1));
      });
    });
  });
}
