// lib/presentation/providers/coaching_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/services/coaching_service.dart';
import '../../domain/services/recommendation_engine.dart';
import '../../domain/services/progress_service.dart';
import '../../data/repositories/assessment_repository.dart';
import '../../data/repositories/tracking_repository.dart';
import '../../core/services/error_service.dart';

final coachingServiceProvider = Provider<CoachingService>((ref) {
  return CoachingService();
});

final progressServiceProvider = Provider<ProgressService>((ref) {
  return ProgressService();
});

// Calculate current streak from tracking history
final currentStreakProvider = FutureProvider<int>((ref) async {
  try {
    // Cache the streak calculation
    ref.keepAlive();

    final trackingRepo = ref.watch(trackingRepositoryProvider);
    final allTracking = await trackingRepo.getAllTracking();

    if (allTracking.isEmpty) return 0;

    final progressService = ref.read(progressServiceProvider);
    final streaks = progressService.calculateProgress(
      trackingHistory: allTracking,
      initialBiologicalAge: 0, // Not needed for streak calculation
      currentBiologicalAge: 0,
    );

    return streaks.currentStreak;
  } catch (error, stackTrace) {
    ErrorService.logError(error, stackTrace, context: 'currentStreakProvider');
    return 0; // Return default on error
  }
});

// Daily coaching message with real data
final dailyMessageProvider = FutureProvider<String>((ref) async {
  try {
    final service = ref.watch(coachingServiceProvider);
    final assessmentRepo = ref.watch(assessmentRepositoryProvider);
    final trackingRepo = ref.watch(trackingRepositoryProvider);

    final latestAssessment = await assessmentRepo.getLatestAssessment();
    final todayTracking = await trackingRepo.getTodayTracking();
    final streakAsync = await ref.watch(currentStreakProvider.future);

    return service.generateDailyMessage(
      assessment: latestAssessment,
      todayTracking: todayTracking,
      currentStreak: streakAsync,
    );
  } catch (error, stackTrace) {
    ErrorService.logError(error, stackTrace, context: 'dailyMessageProvider');
    return 'Welcome back! Track your progress today.'; // Fallback message
  }
});

final recommendationEngineProvider = Provider((ref) => RecommendationEngine());

final dashboardRecommendationsProvider =
    FutureProvider<List<String>>((ref) async {
  try {
    // Cache recommendations
    ref.keepAlive();

    final latest =
        await ref.watch(assessmentRepositoryProvider).getLatestAssessment();
    if (latest == null) return const [];

    final engine = ref.watch(recommendationEngineProvider);
    return engine.generate(assessment: latest).take(5).toList();
  } catch (error, stackTrace) {
    ErrorService.logError(error, stackTrace, context: 'dashboardRecommendationsProvider');
    return const []; // Return empty list on error
  }
});
