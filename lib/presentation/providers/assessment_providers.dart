// lib/presentation/providers/assessment_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/biological_age_calculator.dart';
import '../../data/repositories/assessment_repository.dart';
import '../../data/repositories/user_repository.dart';
import '../../domain/models/biological_age_assessment.dart';
import 'user_provider.dart';

final biologicalAgeCalculatorProvider =
    Provider((ref) => BiologicalAgeCalculator());

/// Holds latest assessment
final latestAssessmentProvider =
    FutureProvider<BiologicalAgeAssessment?>((ref) async {
  final repo = ref.watch(assessmentRepositoryProvider);
  return await repo.getLatestAssessment();
});

/// Compute and persist a new assessment from questionnaire scores
final computeAndSaveAssessmentProvider =
    FutureProvider.family<BiologicalAgeAssessment, Map<String, double>>(
  (ref, scores) async {
    final profile = await ref.watch(userProfileProvider.future);
    if (profile == null) {
      throw StateError('User profile not available');
    }
    final calculator = ref.watch(biologicalAgeCalculatorProvider);
    final now = DateTime.now();
    final assessment = calculator.calculate(
      profile: profile,
      categoryScores: scores,
      now: now,
    );
    await ref.read(assessmentRepositoryProvider).saveAssessment(assessment);
    // Update quick access values
    await ref
        .read(userRepositoryProvider)
        .updateBiologicalAge(assessment.biologicalAge);
    return assessment;
  },
);
