import 'package:flutter_test/flutter_test.dart';
import 'package:age_less/domain/services/biological_age_calculator.dart';
import 'package:age_less/domain/models/user_profile.dart';
import 'package:age_less/core/services/error_service.dart';

void main() {
  group('BiologicalAgeCalculator', () {
    late BiologicalAgeCalculator calculator;
    late UserProfile testProfile;

    setUp(() {
      calculator = BiologicalAgeCalculator();
      testProfile = UserProfile(
        name: 'Test User',
        email: 'test@example.com',
        birthDate: DateTime(1990, 1, 1),
        height: 170,
        weight: 70,
      );
    });

    group('calculate', () {
      test('should calculate biological age correctly with perfect scores', () {
        final categoryScores = {
          'nutrition': 10.0,
          'exercise': 10.0,
          'sleep': 10.0,
          'stress': 10.0,
          'social': 10.0,
        };

        final assessment = calculator.calculate(
          profile: testProfile,
          categoryScores: categoryScores,
          now: DateTime(2024, 1, 1),
        );

        expect(assessment.biologicalAge, lessThan(assessment.chronologicalAge));
        expect(assessment.chronologicalAge, equals(34.0));
        expect(assessment.ageDifference, lessThan(0));
        expect(assessment.categoryScores.length, equals(5));
      });

      test('should calculate biological age correctly with poor scores', () {
        final categoryScores = {
          'nutrition': 0.0,
          'exercise': 0.0,
          'sleep': 0.0,
          'stress': 0.0,
          'social': 0.0,
        };

        final assessment = calculator.calculate(
          profile: testProfile,
          categoryScores: categoryScores,
          now: DateTime(2024, 1, 1),
        );

        expect(assessment.biologicalAge, greaterThan(assessment.chronologicalAge));
        expect(assessment.ageDifference, greaterThan(0));
      });

      test('should calculate biological age with mixed scores', () {
        final categoryScores = {
          'nutrition': 7.0,
          'exercise': 8.0,
          'sleep': 6.0,
          'stress': 5.0,
          'social': 7.0,
        };

        final assessment = calculator.calculate(
          profile: testProfile,
          categoryScores: categoryScores,
          now: DateTime(2024, 1, 1),
        );

        expect(assessment.biologicalAge, isPositive);
        expect(assessment.chronologicalAge, equals(34.0));
        expect(assessment.categoryScores['nutrition'], equals(7.0));
      });

      test('should identify top weaknesses correctly', () {
        final categoryScores = {
          'nutrition': 9.0,
          'exercise': 8.0,
          'sleep': 3.0, // Weakness
          'stress': 2.0, // Weakness
          'social': 4.0, // Weakness
        };

        final assessment = calculator.calculate(
          profile: testProfile,
          categoryScores: categoryScores,
          now: DateTime(2024, 1, 1),
        );

        expect(assessment.topWeaknesses.length, equals(3));
        expect(assessment.topWeaknesses, contains('stress'));
        expect(assessment.topWeaknesses, contains('sleep'));
      });

      test('should handle missing category scores with defaults', () {
        final categoryScores = {
          'nutrition': 8.0,
          'exercise': 7.0,
          // Missing: sleep, stress, social
        };

        final assessment = calculator.calculate(
          profile: testProfile,
          categoryScores: categoryScores,
          now: DateTime(2024, 1, 1),
        );

        // Should use default value of 5 for missing categories
        expect(assessment.categoryScores['sleep'], equals(5.0));
        expect(assessment.categoryScores['stress'], equals(5.0));
        expect(assessment.categoryScores['social'], equals(5.0));
      });

      test('should throw ValidationException for empty scores', () {
        expect(
          () => calculator.calculate(
            profile: testProfile,
            categoryScores: {},
            now: DateTime(2024, 1, 1),
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('should throw ValidationException for out-of-range scores', () {
        final invalidScores = {
          'nutrition': 15.0, // Invalid: > 10
          'exercise': 8.0,
          'sleep': 7.0,
          'stress': 6.0,
          'social': 5.0,
        };

        expect(
          () => calculator.calculate(
            profile: testProfile,
            categoryScores: invalidScores,
            now: DateTime(2024, 1, 1),
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('should throw ValidationException for negative scores', () {
        final invalidScores = {
          'nutrition': -2.0, // Invalid: < 0
          'exercise': 8.0,
          'sleep': 7.0,
          'stress': 6.0,
          'social': 5.0,
        };

        expect(
          () => calculator.calculate(
            profile: testProfile,
            categoryScores: invalidScores,
            now: DateTime(2024, 1, 1),
          ),
          throwsA(isA<ValidationException>()),
        );
      });

      test('should handle profile without birth date', () {
        final profileWithoutBirthDate = UserProfile(
          name: 'Test User',
          email: 'test@example.com',
          birthDate: null,
          height: 170,
          weight: 70,
        );

        final categoryScores = {
          'nutrition': 7.0,
          'exercise': 8.0,
          'sleep': 6.0,
          'stress': 5.0,
          'social': 7.0,
        };

        final assessment = calculator.calculate(
          profile: profileWithoutBirthDate,
          categoryScores: categoryScores,
          now: DateTime(2024, 1, 1),
        );

        // Should use fallback age of 40
        expect(assessment.chronologicalAge, equals(40.0));
      });

      test('should clamp biological age to valid range', () {
        final veryOldProfile = UserProfile(
          name: 'Old User',
          email: 'old@example.com',
          birthDate: DateTime(1900, 1, 1),
          height: 170,
          weight: 70,
        );

        final categoryScores = {
          'nutrition': 0.0,
          'exercise': 0.0,
          'sleep': 0.0,
          'stress': 0.0,
          'social': 0.0,
        };

        final assessment = calculator.calculate(
          profile: veryOldProfile,
          categoryScores: categoryScores,
          now: DateTime(2024, 1, 1),
        );

        // Biological age should be clamped to maximum of 130
        expect(assessment.biologicalAge, lessThanOrEqualTo(130.0));
      });

      test('should calculate chronological age correctly before birthday', () {
        final profile = UserProfile(
          name: 'Test User',
          email: 'test@example.com',
          birthDate: DateTime(1990, 6, 15),
          height: 170,
          weight: 70,
        );

        final categoryScores = {
          'nutrition': 7.0,
          'exercise': 8.0,
          'sleep': 6.0,
          'stress': 5.0,
          'social': 7.0,
        };

        final assessment = calculator.calculate(
          profile: profile,
          categoryScores: categoryScores,
          now: DateTime(2024, 3, 1), // Before birthday
        );

        // Should be 33, not 34, as birthday hasn't occurred yet
        expect(assessment.chronologicalAge, equals(33.0));
      });

      test('should calculate chronological age correctly after birthday', () {
        final profile = UserProfile(
          name: 'Test User',
          email: 'test@example.com',
          birthDate: DateTime(1990, 6, 15),
          height: 170,
          weight: 70,
        );

        final categoryScores = {
          'nutrition': 7.0,
          'exercise': 8.0,
          'sleep': 6.0,
          'stress': 5.0,
          'social': 7.0,
        };

        final assessment = calculator.calculate(
          profile: profile,
          categoryScores: categoryScores,
          now: DateTime(2024, 9, 1), // After birthday
        );

        // Should be 34, as birthday has occurred
        expect(assessment.chronologicalAge, equals(34.0));
      });
    });
  });
}
