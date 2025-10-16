// lib/presentation/providers/coaching_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/coaching_service.dart';
import '../../domain/services/recommendation_engine.dart';
import '../../data/repositories/assessment_repository.dart';

final coachingServiceProvider = Provider<CoachingService>((ref) {
  return CoachingService();
});

final dailyMessageProvider = Provider<String>((ref) {
  final service = ref.watch(coachingServiceProvider);
  return service.generateDailyMessage(
    assessment: null, // TODO: wire latest assessment if needed
    todayTracking: null,
    currentStreak: 0,
  );
});

final recommendationEngineProvider = Provider((ref) => RecommendationEngine());

final dashboardRecommendationsProvider =
    FutureProvider<List<String>>((ref) async {
  final latest =
      await ref.watch(assessmentRepositoryProvider).getLatestAssessment();
  if (latest == null) return const [];
  final engine = ref.watch(recommendationEngineProvider);
  return engine.generate(assessment: latest).take(5).toList();
});
