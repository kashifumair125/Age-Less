// lib/domain/services/recommendation_engine.dart
import '../models/biological_age_assessment.dart';

class RecommendationEngine {
  /// Rule-based recommendations with simple evidence weights.
  /// Returns sorted list of recommendation strings, most impactful first.
  List<String> generate({
    required BiologicalAgeAssessment assessment,
  }) {
    final rules = <_Rule>[
      _Rule('nutrition', 0.30,
          'Increase whole foods and fiber; follow a Mediterranean pattern'),
      _Rule('exercise', 0.30,
          'Do 3x/week HIIT (20 min) and 2x/week resistance training'),
      _Rule('sleep', 0.20,
          'Maintain 7-9h sleep; consistent schedule; dark, cool room'),
      _Rule('stress', 0.15,
          'Daily 10min mindfulness; breathing; track HRV/cortisol inputs'),
      _Rule('social', 0.05, 'Schedule meaningful social connection 2x/week'),
    ];

    // Score rules by whether category is a weakness
    final weaknessSet = assessment.topWeaknesses.toSet();
    final ranked = rules
        .map((r) => MapEntry(
            r, weaknessSet.contains(r.category) ? r.weight : r.weight * 0.3))
        .toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return ranked.map((e) => e.key.recommendation).toList();
  }
}

class _Rule {
  final String category;
  final double weight;
  final String recommendation;
  const _Rule(this.category, this.weight, this.recommendation);
}
