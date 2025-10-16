// lib/domain/services/coaching_service.dart
import '../models/biological_age_assessment.dart';
import '../models/daily_tracking.dart';

class CoachingService {
  /// Generate daily coaching message
  String generateDailyMessage({
    required BiologicalAgeAssessment? assessment,
    required DailyTracking? todayTracking,
    required int currentStreak,
  }) {
    // Personalized based on progress
    if (currentStreak >= 7) {
      return "Amazing! You're on a $currentStreak day streak. Consistency is the key to longevity! 🔥";
    }

    if (assessment != null && assessment.ageDifference < 0) {
      return "Great work! You're ${assessment.ageDifference.abs().toStringAsFixed(1)} years biologically younger than your chronological age! Keep it up! 🎉";
    }

    if (todayTracking?.exercise != null) {
      return "You exercised today! Physical activity is one of the most powerful longevity interventions. 💪";
    }

    return "Start your day with purpose. Small consistent actions compound into remarkable results. Let's optimize your longevity today! ✨";
  }

  /// Generate weekly insights
  String generateWeeklyInsight(List<DailyTracking> weekTracking) {
    if (weekTracking.length < 3) {
      return "Track more consistently to unlock personalized insights!";
    }

    final exerciseDays = weekTracking.where((t) => t.exercise != null).length;
    final sleepQuality =
        weekTracking
            .where((t) => t.sleep != null)
            .map((t) => t.sleep!.sleepQuality)
            .fold(0, (a, b) => a + b) /
        weekTracking.length;

    if (exerciseDays >= 5) {
      return "Fantastic exercise consistency this week! You worked out $exerciseDays days. This is significantly impacting your biological age. 🏃‍♂️";
    }

    if (sleepQuality >= 8) {
      return "Your sleep quality this week averaged ${sleepQuality.toStringAsFixed(1)}/10. Excellent! Quality sleep is crucial for cellular repair and longevity. 😴";
    }

    return "This week you logged $exerciseDays workout days. Aim for 5+ days of exercise for optimal longevity benefits!";
  }

  /// Generate intervention recommendations
  List<String> generateActionableRecommendations(
    BiologicalAgeAssessment assessment,
  ) {
    final recommendations = <String>[];

    // Based on weakest categories
    for (var weakness in assessment.topWeaknesses) {
      switch (weakness) {
        case 'nutrition':
          recommendations.add(
            "🥗 Start your day with a veggie-packed smoothie or Mediterranean-style breakfast",
          );
          break;
        case 'exercise':
          recommendations.add(
            "💪 Schedule 3 HIIT sessions this week - just 20 minutes can reverse cellular aging",
          );
          break;
        case 'sleep':
          recommendations.add(
            "😴 Set a consistent bedtime tonight and avoid screens 1 hour before sleep",
          );
          break;
        case 'stress':
          recommendations.add(
            "🧘‍♂️ Try 10 minutes of meditation today - reduce cortisol and improve HRV",
          );
          break;
        case 'social':
          recommendations.add(
            "👥 Connect with a friend or family member today - social bonds extend lifespan",
          );
          break;
      }
    }

    return recommendations.take(3).toList();
  }
}
