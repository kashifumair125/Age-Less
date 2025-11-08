// lib/domain/services/biological_age_calculator.dart
import '../models/biological_age_assessment.dart';
import '../models/user_profile.dart';

class BiologicalAgeCalculator {
  /// Compute a biological age assessment based on questionnaire category scores
  /// and user profile basics. Category scores are expected on a 0-10 scale
  /// where 10 is best. Keys: nutrition, exercise, sleep, stress, social.
  BiologicalAgeAssessment calculate({
    required UserProfile profile,
    required Map<String, double> categoryScores,
    required DateTime now,
  }) {
    final chronologicalAge = _calculateChronologicalAge(profile.birthDate, now);

    // Evidence-weighted composite (simple MVP weights)
    // Sums to 1.0
    const weights = <String, double>{
      'nutrition': 0.30,
      'exercise': 0.30,
      'sleep': 0.20,
      'stress': 0.15,
      'social': 0.05,
    };

    // Normalize unknown categories to 5 (neutral)
    double scoreFor(String key) => (categoryScores[key] ?? 5).clamp(0, 10);

    // Composite score on 0-10
    final composite = weights.entries
        .map((e) => e.value * scoreFor(e.key))
        .fold(0.0, (a, b) => a + b);

    // Map composite (0-10) to age delta in years. Higher score → younger.
    // Linear MVP: delta in [-8, +8] years.
    final deltaYears = _mapScoreToAgeDelta(composite);

    final biologicalAge = (chronologicalAge + deltaYears).clamp(0, 130);

    // Top weaknesses are the lowest categories
    final entries = weights.keys.map((k) => MapEntry(k, scoreFor(k))).toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final topWeaknesses = entries.take(3).map((e) => e.key).toList();

    return BiologicalAgeAssessment(
      assessmentDate: now,
      biologicalAge: biologicalAge.toDouble(),
      chronologicalAge: chronologicalAge.toDouble(),
      ageDifference: biologicalAge - chronologicalAge,
      topWeaknesses: topWeaknesses,
      categoryScores: {
        'nutrition': scoreFor('nutrition'),
        'exercise': scoreFor('exercise'),
        'sleep': scoreFor('sleep'),
        'stress': scoreFor('stress'),
        'social': scoreFor('social'),
      },
    );
  }

  double _calculateChronologicalAge(DateTime? birthDate, DateTime now) {
    if (birthDate == null) return 40; // fallback if unknown
    int years = now.year - birthDate.year;
    final hadBirthdayThisYear = (now.month > birthDate.month) ||
        (now.month == birthDate.month && now.day >= birthDate.day);
    if (!hadBirthdayThisYear) years -= 1;
    return years.toDouble();
  }

  double _mapScoreToAgeDelta(double composite0to10) {
    // 10 → -8 years (younger), 0 → +8 years (older)
    // Linear: y = m x + b, where m = -16/10, b = +8
    return (-1.6 * composite0to10) + 8.0;
  }
}
