// lib/domain/services/export_service.dart
import 'dart:convert';
import '../models/daily_tracking.dart';
import '../models/biological_age_assessment.dart';
import '../models/user_profile.dart';

class ExportService {
  /// Export all user data to JSON format
  String exportAsJson({
    UserProfile? profile,
    required List<DailyTracking> trackingHistory,
    required List<BiologicalAgeAssessment> assessments,
  }) {
    final data = {
      'exportDate': DateTime.now().toIso8601String(),
      'version': '1.0',
      'profile': profile != null
          ? {
              'name': profile.name,
              'email': profile.email,
              'birthDate': profile.birthDate?.toIso8601String(),
              'heightCm': profile.heightCm,
              'weightKg': profile.weightKg,
              'gender': profile.gender,
            }
          : null,
      'trackingHistory': trackingHistory
          .map(
            (t) => {
              'date': t.date.toIso8601String(),
              'nutrition': t.nutrition != null
                  ? {
                      'caloriesConsumed': t.nutrition!.caloriesConsumed,
                      'proteinGrams': t.nutrition!.proteinGrams,
                      'vegetables': t.nutrition!.vegetables,
                      'fastingCompleted': t.nutrition!.fastingCompleted,
                    }
                  : null,
              'exercise': t.exercise != null
                  ? {
                      'totalMinutes': t.exercise!.totalMinutes,
                      'sessions': t.exercise!.sessions
                          .map((s) => {
                                'type': s.type,
                                'durationMinutes': s.minutes,
                                'intensity': s.intensity,
                              })
                          .toList(),
                    }
                  : null,
              'sleep': t.sleep != null
                  ? {
                      'hoursSlept': t.sleep!.hoursSlept,
                      'sleepQuality': t.sleep!.sleepQuality,
                    }
                  : null,
              'stress': t.stress != null
                  ? {
                      'stressLevel': t.stress!.stressLevel,
                      'meditationMinutes': t.stress!.meditationMinutes,
                    }
                  : null,
              'supplements': t.supplements,
            },
          )
          .toList(),
      'assessments': assessments
          .map(
            (a) => {
              'date': a.assessmentDate.toIso8601String(),
              'biologicalAge': a.biologicalAge,
              'chronologicalAge': a.chronologicalAge,
              'ageDifference': a.ageDifference,
              'topWeaknesses': a.topWeaknesses,
              'categoryScores': a.categoryScores,
            },
          )
          .toList(),
    };

    return JsonEncoder.withIndent('  ').convert(data);
  }

  /// Export tracking data as CSV
  String exportAsCSV(List<DailyTracking> trackingHistory) {
    final buffer = StringBuffer();

    // Headers
    buffer.writeln(
      'Date,Calories,Protein (g),Vegetables,Fasting,Exercise (min),Sleep (hrs),Sleep Quality,Stress Level,Meditation (min)',
    );

    // Data rows
    for (var tracking in trackingHistory) {
      buffer.writeln(
        [
          tracking.date.toIso8601String().split('T')[0],
          tracking.nutrition?.caloriesConsumed ?? '',
          tracking.nutrition?.proteinGrams ?? '',
          tracking.nutrition?.vegetables ?? '',
          tracking.nutrition?.fastingCompleted ?? '',
          tracking.exercise?.totalMinutes ?? '',
          tracking.sleep?.hoursSlept ?? '',
          tracking.sleep?.sleepQuality ?? '',
          tracking.stress?.stressLevel ?? '',
          tracking.stress?.meditationMinutes ?? '',
        ].join(','),
      );
    }

    return buffer.toString();
  }

  /// Export assessment history to CSV format
  String exportAssessmentsAsCSV(List<BiologicalAgeAssessment> assessments) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln(
        'Date,Biological Age,Chronological Age,Age Difference,Nutrition Score,Exercise Score,Sleep Score,Stress Score,Social Score,Top Weaknesses');

    // Data rows
    for (var assessment in assessments) {
      final date = assessment.assessmentDate.toIso8601String().split('T')[0];
      final bioAge = assessment.biologicalAge.toStringAsFixed(1);
      final chronAge = assessment.chronologicalAge.toStringAsFixed(1);
      final diff = assessment.ageDifference.toStringAsFixed(1);
      final nutrition =
          (assessment.categoryScores['nutrition'] ?? 0).toStringAsFixed(1);
      final exercise =
          (assessment.categoryScores['exercise'] ?? 0).toStringAsFixed(1);
      final sleep =
          (assessment.categoryScores['sleep'] ?? 0).toStringAsFixed(1);
      final stress =
          (assessment.categoryScores['stress'] ?? 0).toStringAsFixed(1);
      final social =
          (assessment.categoryScores['social'] ?? 0).toStringAsFixed(1);
      final weaknesses = assessment.topWeaknesses.join(';');

      buffer.writeln(
          '$date,$bioAge,$chronAge,$diff,$nutrition,$exercise,$sleep,$stress,$social,"$weaknesses"');
    }

    return buffer.toString();
  }
}
